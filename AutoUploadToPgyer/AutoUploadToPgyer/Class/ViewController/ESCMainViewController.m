//
//  ESCMainViewController.m
//  AutoUploadToPgyer
//
//  Created by xiang on 05/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCMainViewController.h"
#import "ESCMainTableCellView.h"
#import "ESCconfigViewController.h"
#import "ESCConfigManager.h"
#import "ESCConfigurationModel.h"
#import "ESCBuildShellFileManager.h"
#import "ESCFileManager.h"
#import "MJExtension.h"
#import <AVFoundation/AVFoundation.h>
#import "ESCNetWorkManager.h"
#import "ESCAppTableViewAppBuildUpdateDescriptionCellView.h"
#import "ESCGroupViewController.h"
#import "ESCGroupTableGroupCellView.h"
#import "ESCSelectButtonTableCellView.h"
#import "ESCOneButtonTableCellView.h"
#import "ESCNotificationManager.h"
#import "ESCFirimConfigViewController.h"

typedef enum : NSUInteger {
    ESCSortAlgorithmTypeLRU
} ESCSortAlgorithmType;


@interface ESCMainViewController () <NSTableViewDataSource, NSTabViewDelegate,ESCMainTableCellViewDelegate
,
ESCGroupTableGroupCellViewDelegate
,
ESCSelectButtonTableCellViewDelegate
,
ESCOneButtonTableCellViewDelegate
>

@property (weak) IBOutlet NSTableView *tableView;

@property (unsafe_unretained) IBOutlet NSTextView *logTextView;

@property(nonatomic,strong)NSDateFormatter* dateFormatter;

@property (weak) IBOutlet NSButton *selectAllBuildButton;

@property (weak) IBOutlet NSButton *selectAllUploadButton;

@property (weak) IBOutlet NSButton *selectAllBothButton;

@property (nonatomic, assign) BOOL isCompiling;

@property (nonatomic, assign) BOOL isUploading;

@property (nonatomic, assign) NSInteger allUploadIPACount;

@property (nonatomic, assign) NSInteger completeUploadIPACount;

@property(nonatomic,strong)dispatch_queue_t build_queue;

@property(nonatomic,strong)dispatch_queue_t upload_queue;

@property(nonatomic,strong)dispatch_queue_t other_queue;

@property (weak) IBOutlet NSButton *notificationButton;

@property(nonatomic,assign)BOOL isStartSort;

@property(nonatomic,assign)ESCSortAlgorithmType sortType;

@property(nonatomic,strong)NSArray* showModelArray;

@property (weak, nonatomic) IBOutlet NSPopUpButton *uploadTypeButton;

@end

@implementation ESCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.build_queue = dispatch_queue_create("build queue", NULL);
    self.upload_queue = dispatch_queue_create("upload queue", NULL);
    self.other_queue = dispatch_queue_create("other queue", NULL);
    
    self.tableView.rowHeight = 70;
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"ESCGroupTableGroupCellView" bundle:nil] forIdentifier:ESCGroupTableGroupCellViewId];
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"ESCSelectButtonTableCellView" bundle:nil]  forIdentifier:ESCSelectButtonTableCellViewId];
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"ESCOneButtonTableCellView" bundle:nil]  forIdentifier:ESCOneButtonTableCellViewId];
    
    
    [self reloadData];
    
    [self uploadData];
    
    [self checkIsAllSelected];
    
    [self setupUI];
    
}

- (void)setupUI {
    
    int selectSortType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SortType"] intValue];
    if (selectSortType == 1) {
        self.sortType = ESCSortAlgorithmTypeLRU;
        self.isStartSort = YES;
    }
    
    BOOL notificationSwitchIsOpen = [ESCNotificationManager sharedManager].notificationSwitchIsOpen;
    if (notificationSwitchIsOpen == YES) {
        self.notificationButton.state = 1;
    }
    
    int index = [ESCConfigManager sharedConfigManager].uploadType;
    [self.uploadTypeButton selectItemAtIndex:index];
    
    CGFloat width = 0;
    CGFloat height = 0;
    NSString *widthString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ESCViewFrameWidth_key"];
    if (widthString) {
        width = [widthString floatValue];
    }else {
        width = self.view.frame.size.width;
    }
    NSString *heightString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ESCViewFrameHeight_key"];
    if (heightString) {
        height = [heightString floatValue];
    }else {
        height = self.view.frame.size.height;
    }
    self.view.frame = CGRectMake(0, 0, width, height);
}

- (void)viewWillDisappear {
    [super viewWillDisappear];

    [[ESCConfigManager sharedConfigManager] saveUserData];
    
    CGRect frame = self.view.frame;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",frame.size.width] forKey:@"ESCViewFrameWidth_key"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",frame.size.height] forKey:@"ESCViewFrameHeight_key"];

}

- (void)dismissViewController:(NSViewController *)viewController API_AVAILABLE(macos(10.10)) {
    [super dismissViewController:viewController];
    [self reloadData];
    
}

- (void)reloadData {
//#warning 2020.5.18
    ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
    NSArray *showModelArray = [groupModel getAllGroupModelAndAppModelToShowArray];
    self.showModelArray = showModelArray;
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.showModelArray.count;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row NS_AVAILABLE_MAC(10_7) {
    id model = [self.showModelArray objectAtIndex:row];
    if ([model isKindOfClass:[ESCGroupModel class]]) {
        ESCGroupModel *groupModel = model;
        if([tableColumn.identifier isEqualToString:@"buildCell"]){
            ESCSelectButtonTableCellView *cell = [tableView makeViewWithIdentifier:ESCSelectButtonTableCellViewId owner:self];
            [cell setModel:groupModel type:ESCSelectButtonTableCellViewTypeBuild];
            cell.delegate = self;
            return cell;
        }else if([tableColumn.identifier isEqualToString:@"uploadCell"]){
            ESCSelectButtonTableCellView *cell = [tableView makeViewWithIdentifier:ESCSelectButtonTableCellViewId owner:self];
            [cell setModel:groupModel type:ESCSelectButtonTableCellViewTypeUpload];
            cell.delegate = self;
            return cell;
        }else if([tableColumn.identifier isEqualToString:@"buildAndUploadCell"]){
            ESCSelectButtonTableCellView *cell = [tableView makeViewWithIdentifier:ESCSelectButtonTableCellViewId owner:self];
            [cell setModel:groupModel type:ESCSelectButtonTableCellViewTypeBuildAndUploa];
            cell.delegate = self;
            return cell;
        }else if ([tableColumn.identifier isEqualToString:@"ESCAppBasisInfo"]) {
            ESCGroupTableGroupCellView *cell = [tableView makeViewWithIdentifier:ESCGroupTableGroupCellViewId owner:nil];
            cell.groupModel = groupModel;
            cell.delegate = self;
            return cell;
        }else if ([tableColumn.identifier isEqualToString:@"ESDConfigCell"]) {
            
        }
        
    }else if ([model isKindOfClass:[ESCConfigurationModel class]]) {
        ESCConfigurationModel *configurationModel = model;
        if ([tableColumn.identifier isEqualToString:@"ESCAppBasisInfo"]) {
            ESCMainTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
            cell.delegate = self;
            cell.configurationModel = configurationModel;
            return cell;
        }else if([tableColumn.identifier isEqualToString:@"buildCell"]){
            ESCSelectButtonTableCellView *cell = [tableView makeViewWithIdentifier:ESCSelectButtonTableCellViewId owner:self];
            cell.delegate = self;
            [cell setModel:configurationModel type:ESCSelectButtonTableCellViewTypeBuild];
            return cell;
        }else if([tableColumn.identifier isEqualToString:@"uploadCell"]){
            ESCSelectButtonTableCellView *cell = [tableView makeViewWithIdentifier:ESCSelectButtonTableCellViewId owner:self];
            cell.delegate = self;
            [cell setModel:configurationModel type:ESCSelectButtonTableCellViewTypeUpload];
            return cell;
        }else if([tableColumn.identifier isEqualToString:@"buildAndUploadCell"]){
            ESCSelectButtonTableCellView *cell = [tableView makeViewWithIdentifier:ESCSelectButtonTableCellViewId owner:self];
            cell.delegate = self;
            [cell setModel:configurationModel type:ESCSelectButtonTableCellViewTypeBuildAndUploa];
            return cell;
        }else if([tableColumn.identifier isEqualToString:@"deleteCell"]){
            ESCOneButtonTableCellView *cell = [tableView makeViewWithIdentifier:ESCOneButtonTableCellViewId owner:self];
            cell.model = configurationModel;
            cell.type = ESCOneButtonTableCellViewDeleteType;
            cell.delegate = self;
            return cell;
        }else if ([tableColumn.identifier isEqualToString:@"ESDConfigCell"]) {
            ESCOneButtonTableCellView *cell = [tableView makeViewWithIdentifier:ESCOneButtonTableCellViewId owner:self];
            cell.model = configurationModel;
            cell.type = ESCOneButtonTableCellViewConfigType;
            cell.delegate = self;
            return cell;
        }else{
            ESCAppTableViewAppBuildUpdateDescriptionCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
            cell.model = configurationModel;
            return cell;
        }
    }

    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    id model = [self.showModelArray objectAtIndex:row];
    if ([model isKindOfClass:[ESCGroupModel class]]) {
        return 20;
    }else if ([model isKindOfClass:[ESCConfigurationModel class]]) {
        return 70;
    }
    return 0;
}

- (IBAction)didClickCreateIPAAndUploadPgyerButton:(id)sender {
    __weak typeof(self)weakSelf = self;
    [self createIPAFileComplete:^(ESCConfigurationModel *model, ESCBuildModel *buildModel) {
        if (buildModel.buildResult == ESCBuildResultSuccess && model.isUploadIPA == YES) {
            [weakSelf uploadIpaWithModel:model];
        }
    }];
}

- (IBAction)didClickAddNewTarget:(id)sender {
    ESCconfigViewController *viewController = [[NSStoryboard storyboardWithName:@"ESCconfigViewController" bundle:nil] instantiateInitialController];
    __weak typeof(self)weakSelf = self;
    [viewController setConfigCompleteBlock:^{
        [weakSelf.tableView reloadData];
    }];
    [self presentViewControllerAsSheet:viewController];
}

- (IBAction)didClickCreateIPAButton:(id)sender {
    [self createIPAFileComplete:^(ESCConfigurationModel *model, ESCBuildModel *buildModel) {
        
    }];
}

- (IBAction)didClickUploadPgyerButton:(id)sender {
    [self uploadToPgyer];
}

- (IBAction)didClickScanButton:(id)sender {
    [self uploadData];
}
- (IBAction)didClickManualSelectIpaFileAndUploadButton:(id)sender {
    NSOpenPanel * openPanel = [NSOpenPanel openPanel];
    //是否可以创建文件夹
    openPanel.canCreateDirectories = NO;
    //是否可以选择文件夹
    openPanel.canChooseDirectories = NO;
    //是否可以选择文件
    openPanel.canChooseFiles = YES;
    //是否可以多选
    [openPanel setAllowsMultipleSelection:NO];
    __weak __typeof(self)weakSelf = self;
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        //是否点击open 按钮
        if (result == NSModalResponseOK) {
            if ([ESCConfigManager sharedConfigManager].uploadType == 0) {
                NSString *pathString = [openPanel.URLs.firstObject path];
                NSString *ukey = [ESCConfigManager sharedConfigManager].uKey;
                NSString *api_k = [ESCConfigManager sharedConfigManager].api_k;
                NSString *password = [ESCConfigManager sharedConfigManager].password;
                
                NSString *logStr = [NSString stringWithFormat:@"开始上传%@项目ipa包",pathString];
                [weakSelf addLog:logStr];
                
                [ESCNetWorkManager uploadToPgyerWithFilePath:pathString
                                                        uKey:ukey
                                                     api_key:api_k
                                                    password:password
                                      buildUpdateDescription:@""
                                                    progress:^(NSProgress *progress) {
                    double currentProgress = progress.fractionCompleted * 100;
                    NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包进度%.2lf%@",[pathString lastPathComponent],currentProgress,@"%"];
                    [weakSelf addLog:logStr];
                } success:^(NSDictionary *result) {
                    NSString *logStr = [NSString stringWithFormat:@"%@项目ipa包上传完成",pathString];
                    NSString *resultString = [self parePgyerResult:result];
                    [weakSelf addLog:[logStr stringByAppendingString:resultString]];
                } failure:^(NSError *error) {
                    NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包失败",pathString];
                    [weakSelf addLog:logStr];
                }];
            }else if ([ESCConfigManager sharedConfigManager].uploadType == 1) {
                __weak __typeof(self)weakSelf = self;
               NSString *pathString = [openPanel.URLs.firstObject path];

                NSString *logStr = [NSString stringWithFormat:@"开始上传%@项目ipa包",pathString];
                [self addLog:logStr];
                
                NSString *api_token = [ESCConfigManager sharedConfigManager].firim_api_token;
                [ESCNetWorkManager uploadToFirimWithFilePath:pathString api_token:api_token buildUpdateDescription:@"" progress:^(NSProgress *progress) {
                    double currentProgress = progress.fractionCompleted * 100;
                    NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包进度%.2lf%@",[pathString lastPathComponent],currentProgress,@"%"];
                    [weakSelf addLog:logStr];
                } success:^(NSDictionary *result) {
                    NSString *logStr = [NSString stringWithFormat:@"%@项目ipa包上传完成",pathString];
                    NSString *resultString = [result mj_JSONString];
                    [weakSelf addLog:[NSString stringWithFormat:@"%@:\n%@",logStr,resultString]];
                } failure:^(NSError *error) {
                    NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包失败",pathString];
                    [weakSelf addLog:logStr];
                }];
            }
           
        }
    }];
}

- (IBAction)didClickSelectAllBuildButton:(NSButton *)sender {
    ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
    [groupModel setAllCreateIPAFile:sender.state];
    [self checkIsAllSelected];
    [self.tableView reloadData];
}

- (IBAction)didClickSelectAllUploadButton:(NSButton *)sender {
    ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
    [groupModel setAllUploadIPAFile:sender.state];
    [self checkIsAllSelected];
    [self.tableView reloadData];
}

- (IBAction)didClickSelectAllBothButton:(NSButton *)sender {
    self.selectAllUploadButton.state = sender.state;
    self.selectAllBuildButton.state = sender.state;
    ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
    [groupModel setAllCreateIPAFile:sender.state];
    [groupModel setAllUploadIPAFile:sender.state];
    [self checkIsAllSelected];
    [self.tableView reloadData];
}

- (IBAction)didClickClearLogButton:(NSButton *)sender {
    self.logTextView.string = @"";
}

- (IBAction)didClickNotificationButton:(id)sender {
    if (self.notificationButton.state == YES) {
        [ESCNotificationManager sharedManager].notificationSwitchIsOpen = YES;
    }else {
        [ESCNotificationManager sharedManager].notificationSwitchIsOpen = NO;
    }
}

- (IBAction)didClickRunCustemShellButton:(id)sender {
    //执行自定义脚本
    [self addLog:@"开始执行自定义脚本"];
    dispatch_async(self.build_queue, ^{
        system([ESCConfigManager sharedConfigManager].custom_shell_content.UTF8String);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addLog:@"自定义脚本执行完毕"];
        });
    });
}

- (IBAction)didClickGroupSetButton:(id)sender {
    ESCGroupViewController *viewController = [[NSStoryboard storyboardWithName:@"ESCGroupViewController" bundle:nil] instantiateInitialController];
    [self presentViewControllerAsSheet:viewController];
}

- (IBAction)didClickFirimConfigButton:(id)sender {
    ESCFirimConfigViewController *firimConfigViewController = [[NSStoryboard storyboardWithName:@"ESCFirimConfigViewController" bundle:nil] instantiateInitialController];
    [self presentViewControllerAsSheet:firimConfigViewController];
}

- (IBAction)didClickUploadTypeButton:(id)sender {
    int index = (int)self.uploadTypeButton.indexOfSelectedItem;
//    NSLog(@"%d",index);
    [ESCConfigManager sharedConfigManager].uploadType = index;
}

- (IBAction)didClickRemoveBuildHistoryFile:(id)sender {
    [[ESCConfigManager sharedConfigManager] removeAllBuildHistoryFile];
    [self uploadData];
}

- (void)uploadData {
    dispatch_async(self.other_queue, ^{
        //修改为子线程
        ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
        NSArray *appModelArray = [groupModel getAllAPPModelInGroup];
        
        for (ESCConfigurationModel *model in appModelArray) {
            [[ESCFileManager sharedFileManager] getLatestIPAFileInfoWithConfigurationModel:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)createIPAFileComplete:(void(^)(ESCConfigurationModel *model,ESCBuildModel *buildModel))complete {
    if (self.isCompiling == YES) {
        NSString *str = @"正在打包";
        [self addLog:str];
        return;
    }
    self.isCompiling = YES;
    dispatch_async(self.build_queue, ^{
        ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
        NSArray *modelArray = [groupModel getAllGroupModelAndAppModelToArray];
        for (id model in modelArray) {
            if ([model isKindOfClass:[ESCConfigurationModel class]]) {
                ESCConfigurationModel *configurationModel = model;
                if (configurationModel.isCreateIPA) {
                    ESCBuildModel *buildModel = [self buildTargetWithModel:model];
                    complete(model,buildModel);
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isCompiling = NO;
        });
    });
    
}

- (ESCBuildModel *)buildTargetWithModel:(ESCConfigurationModel *)model {
    if(self.isStartSort == YES) {
        [[ESCConfigManager sharedConfigManager] sortWithLRUTypeWithModel:model];
    }
    NSString *logStr = [NSString stringWithFormat:@"开始编译%@项目",model.appName];
    [self addLog:logStr];
    ESCBuildModel *buildModel = [ESCBuildShellFileManager writeShellFileWithConfigurationModel:model];
    system(buildModel.shellFilePath.UTF8String);
    //检测是否生成ipa文件
    BOOL ipaIsBuild = [[ESCFileManager sharedFileManager] isContainIPAFileWithDirPath:buildModel.ipaDirPath];
    if (ipaIsBuild == NO) {
        //导出ipa文件失败
        BOOL archiveResult = [[NSFileManager defaultManager] fileExistsAtPath:buildModel.archiveFilePath];
        if (archiveResult == YES) {
            buildModel.buildResult = ESCBuildResultExportIpafailure;
            //打包成功
            logStr = [NSString stringWithFormat:@"%@项目编译成功，导出ipa文件时发生错误",model.appName];
            [[ESCNotificationManager sharedManager] pushNotificationMessage:logStr];
            [self addLog:logStr];
        }else {
            //打包失败
            buildModel.buildResult = ESCBuildResultBuildFailure;
            logStr = [NSString stringWithFormat:@"%@项目编译发生错误",model.appName];
            [[ESCNotificationManager sharedManager] pushNotificationMessage:logStr];
            [self addLog:logStr];
        }
    }else {
        buildModel.buildResult = ESCBuildResultSuccess;
        logStr = [NSString stringWithFormat:@"完成%@项目编译生成ipa包",model.appName];
        [[ESCNotificationManager sharedManager] pushNotificationMessage:logStr];
        [self addLog:logStr];
        [self uploadData];
    }
    return buildModel;
}

- (void)uploadToPgyer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isUploading) {
            NSString *str = @"正在上传";
            [self addLog:str];
            return;
        }
        self.isUploading = YES;
        self.allUploadIPACount = 0;
        self.completeUploadIPACount = 0;
        
        ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
        NSArray *modelArray = [groupModel getAllGroupModelAndAppModelToArray];
        for (id model in modelArray) {
            if ([model isKindOfClass:[ESCConfigurationModel class]]) {
                ESCConfigurationModel *configurationModel = model;
                if (configurationModel.isUploadIPA) {
                    self.allUploadIPACount++;
                    dispatch_async(self.upload_queue, ^{
                        [self uploadIpaWithModel:model];
                    });
                }
            }
        }
    });
}

- (void)uploadIpaWithModel:(ESCConfigurationModel *)model {
    if ([ESCConfigManager sharedConfigManager].uploadType == 0) {
        [self uploadToPgyerWithModel:model];
    }else if ([ESCConfigManager sharedConfigManager].uploadType == 1) {
        [self uploadIpaToFirimWithModel:model];
    }
}

- (void)uploadToPgyerWithModel:(ESCConfigurationModel *)model {
    __weak __typeof(self)weakSelf = self;
       [model resetNetworkRate];
       if(self.isStartSort == YES) {
           [[ESCConfigManager sharedConfigManager] sortWithLRUTypeWithModel:model];
       }
       NSString *logStr = [NSString stringWithFormat:@"开始上传%@项目ipa包",model.appName];
       [self addLog:logStr];
       
       NSString *ukey = [ESCConfigManager sharedConfigManager].uKey;
       NSString *api_k = [ESCConfigManager sharedConfigManager].api_k;
       NSString *password = [ESCConfigManager sharedConfigManager].password;
       NSString *filePath = [[ESCFileManager sharedFileManager] getLatestIPAFilePathFromWithConfigurationModel:model];
       [ESCNetWorkManager uploadToPgyerWithFilePath:filePath
                                               uKey:ukey
                                            api_key:api_k
                                           password:password
                             buildUpdateDescription:model.buildUpdateDescription
                                           progress:^(NSProgress *progress) {
           double currentProgress = progress.fractionCompleted;
           int total = (int)progress.totalUnitCount;
           int complete = (int)progress.completedUnitCount;
           model.totalSize = total;
           model.sendSize = complete;
           model.uploadProgress = currentProgress;
           [model calculateNetWorkRate];
           [weakSelf.tableView reloadData];
       } success:^(NSDictionary *result){
           weakSelf.completeUploadIPACount++;
           if (weakSelf.completeUploadIPACount == weakSelf.allUploadIPACount) {
               weakSelf.isUploading = NO;
           }
           if (model.save_buildUpdateDescription == NO) {
               model.buildUpdateDescription = @"";
           }
           model.uploadState = @"上传成功";
           NSString *logStr = [NSString stringWithFormat:@"%@项目ipa包上传完成",model.appName];
           [[ESCNotificationManager sharedManager] pushNotificationMessage:logStr];
           NSString *resultString = [self parePgyerResult:result];
           [weakSelf addLog:[logStr stringByAppendingString:resultString]];
           [weakSelf writeLog:resultString withPath:model.historyLogPath];
           [weakSelf.tableView reloadData];
       } failure:^(NSError *error) {
           weakSelf.completeUploadIPACount++;
           if (weakSelf.completeUploadIPACount == weakSelf.allUploadIPACount) {
               weakSelf.isUploading = NO;
           }
           model.uploadState = @"上传失败";
           NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包失败",model.appName];
           [[ESCNotificationManager sharedManager] pushNotificationMessage:logStr];
           [weakSelf addLog:logStr];
           [weakSelf writeLog:error.localizedDescription withPath:model.historyLogPath];
       }];
}

- (void)uploadIpaToFirimWithModel:(ESCConfigurationModel *)model {
    __weak __typeof(self)weakSelf = self;
    [model resetNetworkRate];
    if(self.isStartSort == YES) {
        [[ESCConfigManager sharedConfigManager] sortWithLRUTypeWithModel:model];
    }
    NSString *logStr = [NSString stringWithFormat:@"开始上传%@项目ipa包",model.appName];
    [self addLog:logStr];
    
    NSString *filePath = [[ESCFileManager sharedFileManager] getLatestIPAFilePathFromWithConfigurationModel:model];
    if (filePath == nil) {
        self.completeUploadIPACount++;
        NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包失败，ipa文件不存在",model.appName];
        [self addLog:logStr];
        if (weakSelf.completeUploadIPACount == weakSelf.allUploadIPACount) {
            weakSelf.isUploading = NO;
        }
        return;
    }
    NSString *api_token = [ESCConfigManager sharedConfigManager].firim_api_token;
    [ESCNetWorkManager uploadToFirimWithFilePath:filePath api_token:api_token buildUpdateDescription:model.buildUpdateDescription progress:^(NSProgress *progress) {
        double currentProgress = progress.fractionCompleted;
        int total = (int)progress.totalUnitCount;
        int complete = (int)progress.completedUnitCount;
        model.totalSize = total;
        model.sendSize = complete;
        model.uploadProgress = currentProgress;
        [model calculateNetWorkRate];
        [weakSelf.tableView reloadData];
    } success:^(NSDictionary *result) {
        weakSelf.completeUploadIPACount++;
        if (weakSelf.completeUploadIPACount == weakSelf.allUploadIPACount) {
            weakSelf.isUploading = NO;
        }
        if (model.save_buildUpdateDescription == NO) {
            model.buildUpdateDescription = @"";
        }
        model.uploadState = @"上传成功";
        NSString *logStr = [NSString stringWithFormat:@"%@项目ipa包上传完成",model.appName];
        [[ESCNotificationManager sharedManager] pushNotificationMessage:logStr];
        NSString *resultString = [result mj_JSONString];
        [weakSelf addLog:[NSString stringWithFormat:@"%@:\n%@",logStr,resultString]];
        [weakSelf writeLog:resultString withPath:model.historyLogPath];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        weakSelf.completeUploadIPACount++;
        if (weakSelf.completeUploadIPACount == weakSelf.allUploadIPACount) {
            weakSelf.isUploading = NO;
        }
        model.uploadState = @"上传失败";
        NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包失败",model.appName];
        [[ESCNotificationManager sharedManager] pushNotificationMessage:logStr];
        [weakSelf addLog:logStr];
        [weakSelf writeLog:error.localizedDescription withPath:model.historyLogPath];
    }];
}

- (void)writeLog:(NSString *)string withPath:(NSString *)path{
    NSString *logString = [[self.dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:[NSString stringWithFormat:@":\n%@",string]];
    [[ESCFileManager sharedFileManager] wirteLogToFileWith:logString withName:[self.dateFormatter stringFromDate:[NSDate date]] withPath:path];
}

- (NSString *)parePgyerResult:(NSDictionary *)result {
    NSString *resultString = @"";
    if ([result isKindOfClass:[NSDictionary class]] == YES) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        int buildBuildVersion = [[dataDict objectForKey:@"buildBuildVersion"] intValue];
        NSString *buildShortcutUrl = [dataDict objectForKey:@"buildShortcutUrl"];
        NSString *buildVersion = [dataDict objectForKey:@"buildVersion"];
        NSString *buildKey = [dataDict objectForKey:@"buildKey"];
        resultString = [NSString stringWithFormat:@"\n下载地址1:\nhttps://www.pgyer.com/%@\n下载地址2：\nhttps://www.pgyer.com/%@\nbuildVersion:%@\nbuildBuildVersion:%d",buildKey,buildShortcutUrl,buildVersion,buildBuildVersion];
    }else {
        resultString = [result mj_JSONString];
    }
    return resultString;
}

- (void)addLog:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *temStrin = self.logTextView.string;
        NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
        NSString *logString = [NSString stringWithFormat:@"%@:%@",dateString,string];
        temStrin = [temStrin stringByAppendingFormat:@"%@\n",logString];
        self.logTextView.string = temStrin;
    });
}

#pragma mark - ESCMainTableCellViewDelegate
- (void)mainTableCellViewdidClickRightMenuUploadButton:(ESCMainTableCellView *)cellView configurationModel:(ESCConfigurationModel *)model {
    dispatch_async(self.upload_queue, ^{
        [self uploadIpaWithModel:model];
    });
}

- (void)mainTableCellViewdidClickRightMenuBuildButton:(ESCMainTableCellView *)cellView configurationModel:(ESCConfigurationModel *)model {
    dispatch_async(self.build_queue, ^{    
        [self buildTargetWithModel:model];
    });
}

- (void)mainTableCellViewdidClickRightMenuBuildAndUploadButton:(ESCMainTableCellView *)cellView configurationModel:(ESCConfigurationModel *)model {
    dispatch_async(self.build_queue, ^{
        ESCBuildModel *buildModel = [self buildTargetWithModel:model];
        if (buildModel.buildResult == ESCBuildResultSuccess) {
            dispatch_async(self.upload_queue, ^{
                [self uploadIpaWithModel:model];
            });
        }
    });
}

#pragma mark - ESCGroupTableGroupCellViewDelegate
- (void)ESCGroupTableGroupCellViewDidClickShowButton:(ESCGroupTableGroupCellView *)cellView {
    [self reloadData];
}

#pragma mark - ESCSelectButtonTableCellViewDelegate
- (void)ESCSelectButtonTableCellViewDidClickSelectedButton:(ESCSelectButtonTableCellView *)view {
    [self reloadData];
    [self checkIsAllSelected];
}

#pragma mark - ESCOneButtonTableCellViewDelegate
- (void)ESCDeleteTableCellViewDidClickButton:(ESCOneButtonTableCellView *)view {
    if (view.type == ESCOneButtonTableCellViewDeleteType) {
        ESCConfigurationModel *model = view.model;
        NSArray *temArray = [[[ESCConfigManager sharedConfigManager] groupModel] getAllGroupModelAndAppModelToArray];
        for (id temModel in temArray) {
            if ([temModel isKindOfClass:[ESCGroupModel class]]) {
                ESCGroupModel *groupModel = temModel;
                for (ESCConfigurationModel *model2 in groupModel.configurationModelArray) {
                    if ([model2 isEqual:model]) {
                        NSMutableArray *temArray = [groupModel.configurationModelArray mutableCopy];
                        [temArray removeObject:model];
                        groupModel.configurationModelArray = [temArray copy];
                        [[ESCConfigManager sharedConfigManager] saveUserData];
                        [self reloadData];
                        return;
                    }
                }
            }
        }
        
        ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
        for (ESCConfigurationModel *configurationModel in groupModel.configurationModelArray) {
            if ([configurationModel isEqual:model]) {
                NSMutableArray *temArray = [groupModel.configurationModelArray mutableCopy];
                [temArray removeObject:model];
                groupModel.configurationModelArray = [temArray copy];
                [[ESCConfigManager sharedConfigManager] saveUserData];
                [self reloadData];
                return;
            }
        }
    }else if(view.type == ESCOneButtonTableCellViewConfigType){
        ESCConfigurationModel *model = view.model;
        ESCconfigViewController *viewController = [[NSStoryboard storyboardWithName:@"ESCconfigViewController" bundle:nil] instantiateInitialController];
        viewController.configurationModel = model;
        [self presentViewControllerAsSheet:viewController];
    }
}

- (void)checkIsAllSelected {
    [[ESCConfigManager sharedConfigManager] saveUserData];
    BOOL buildIsAllSelected = YES;
    BOOL uploadIsAllSelected = YES;
    ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
    if (groupModel.isAllCreateIPAFile == YES && groupModel.isAllUploadIPAFile == YES) {
        
    }else if(groupModel.isAllUploadIPAFile == YES){
        buildIsAllSelected = NO;
    }else if (groupModel.isAllCreateIPAFile == YES) {
        uploadIsAllSelected = NO;
    }else {
        buildIsAllSelected = NO;
        uploadIsAllSelected = NO;
    }
    self.selectAllBuildButton.state = buildIsAllSelected;
    self.selectAllUploadButton.state = uploadIsAllSelected;
    if (self.selectAllBuildButton.state == 1 && self.selectAllUploadButton.state == 1) {
        self.selectAllBothButton.state = 1;
    }else {
        self.selectAllBothButton.state = 0;
    }
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }
    return _dateFormatter;
}

@end
