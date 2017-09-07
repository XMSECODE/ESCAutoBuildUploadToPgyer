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

@interface ESCMainViewController () <NSTableViewDataSource, NSTabViewDelegate,ESCMainTableCellViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property(nonatomic,strong)NSDateFormatter* dateFormatter;

@property (nonatomic, assign) BOOL isCompiling;
@property (nonatomic, assign) BOOL isUploading;

@property (nonatomic, assign) NSInteger allUploadIPACount;
@property (nonatomic, assign) NSInteger completeUploadIPACount;

@end

@implementation ESCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 70;
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    
    [self uploadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [ESCConfigManager sharedConfigManager].modelArray.count;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row NS_AVAILABLE_MAC(10_7) {
    ESCMainTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    cell.delegate = self;
    cell.configurationModel = [[ESCConfigManager sharedConfigManager].modelArray objectAtIndex:row];
    return cell;
}

- (IBAction)didClickCreateIPAAndUploadPgyerButton:(id)sender {
    __weak typeof(self)weakSelf = self;
    [self createIPAFileComplete:^{
        [weakSelf uploadToPgyer];
    }];
}

- (IBAction)didClickAddNewTarget:(id)sender {
    ESCconfigViewController *viewController = [[NSStoryboard storyboardWithName:@"ESCconfigViewController" bundle:nil] instantiateInitialController];
    ESCConfigurationModel *newModel = [[ESCConfigurationModel alloc] init];
    NSMutableArray *newArray = [[ESCConfigManager sharedConfigManager].modelArray mutableCopy];
    [newArray addObject:newModel];
    [ESCConfigManager sharedConfigManager].modelArray = [newArray copy];
    viewController.configurationModel = newModel;
    [viewController setConfigCompleteBlock:^{
        [self.tableView reloadData];
    }];
    [self presentViewControllerAsSheet:viewController];
}

- (IBAction)didClickCreateIPAButton:(id)sender {
    [self createIPAFileComplete:^{
        
    }];
}

- (IBAction)didClickUploadPgyerButton:(id)sender {
    [self uploadToPgyer];
}

- (IBAction)didClickScanButton:(id)sender {
    [self uploadData];
}

- (void)uploadData {
    for (ESCConfigurationModel *model in [ESCConfigManager sharedConfigManager].modelArray) {
        [[ESCFileManager sharedFileManager] getLatestIPAFileInfoWithConfigurationModel:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)createIPAFileComplete:(void(^)())complete {
    if (self.isCompiling == YES) {
        NSString *str = @"正在打包";
        [self addLog:str];
        return;
    }
    self.isCompiling = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        for (ESCConfigurationModel *model in [ESCConfigManager sharedConfigManager].modelArray) {
            if (model.isCreateIPA) {
                
                NSDate *date = [NSDate date];
                NSString *dateString = [dateFormatter stringFromDate:date];
                NSString *logStr = [NSString stringWithFormat:@"%@:正在编译%@项目ipa包",dateString,model.projectName];
                [self addLog:logStr];
                NSString *filePath = [ESCBuildShellFileManager writeShellFileWithConfigurationModel:model];
                system(filePath.UTF8String);
                date = [NSDate date];
                dateString = [dateFormatter stringFromDate:date];
                logStr = [NSString stringWithFormat:@"%@:生成%@项目ipa包",dateString,model.projectName];
                [self addLog:logStr];
                [self uploadData];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isCompiling = NO;
        });
        complete();
    });
    
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
        NSString *ukey = [ESCConfigManager sharedConfigManager].uKey;
        NSString *api_k = [ESCConfigManager sharedConfigManager].api_k;
        for (ESCConfigurationModel *model in [ESCConfigManager sharedConfigManager].modelArray) {
            __weak __typeof(self)weakSelf = self;
            if (model.isUploadIPA) {
                self.allUploadIPACount++;
                [ESCNetWorkManager uploadToPgyerWithFilePath:[[ESCFileManager sharedFileManager] getLatestIPAFilePathFromWithConfigurationModel:model] uKey:ukey api_key:api_k progress:^(NSProgress *progress) {
                    double currentProgress = progress.fractionCompleted;
                    model.uploadProgress = currentProgress;
                    [weakSelf.tableView reloadData];
                } success:^(NSDictionary *result){
                    self.completeUploadIPACount++;
                    if (self.completeUploadIPACount == self.allUploadIPACount) {
                        self.isUploading = NO;
                    }
                    model.uploadState = @"上传成功";
                    NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包",model.projectName];
                    [weakSelf addLog:logStr];
                    NSString *resultString = [result mj_JSONString];
                    [weakSelf writeLog:resultString withPath:model.historyLogPath];
                    [weakSelf.tableView reloadData];
                } failure:^(NSError *error) {
                    self.completeUploadIPACount++;
                    if (self.completeUploadIPACount == self.allUploadIPACount) {
                        self.isUploading = NO;
                    }
                    model.uploadState = @"上传失败";
                    NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包失败",model.projectName];
                    [weakSelf addLog:logStr];
                    [weakSelf writeLog:error.localizedDescription withPath:model.historyLogPath];
                }];
            }
        }
    });
}

- (void)writeLog:(NSString *)string withPath:(NSString *)path{
    NSString *logString = [[self.dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:[NSString stringWithFormat:@"==========%@",string]];
    [[ESCFileManager sharedFileManager] wirteLogToFileWith:logString withName:[self.dateFormatter stringFromDate:[NSDate date]] withPath:path];
}

- (void)addLog:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *temStrin = self.logTextView.string;
        temStrin = [temStrin stringByAppendingFormat:@"%@\n",string];
        self.logTextView.string = temStrin;
    });
}

#pragma mark - ESCMainTableCellViewDelegate
- (void)mainTableCellViewdidClickConfigButton:(ESCMainTableCellView *)cellView configurationModel:(ESCConfigurationModel *)model {
    ESCconfigViewController *viewController = [[NSStoryboard storyboardWithName:@"ESCconfigViewController" bundle:nil] instantiateInitialController];
    viewController.configurationModel = model;
    [self presentViewControllerAsSheet:viewController];
}

- (void)mainTableCellViewdidClickDeleteButton:(ESCMainTableCellView *)cellView configurationModel:(ESCConfigurationModel *)model {
    NSMutableArray *temArray = [[ESCConfigManager sharedConfigManager].modelArray mutableCopy];
    [temArray removeObject:model];
    [ESCConfigManager sharedConfigManager].modelArray = [temArray copy];
    [self.tableView reloadData];
}

- (void)uploadFirstSuccess {
//    NSString *string = [[NSBundle mainBundle] pathForSoundResource:@"G.E.M.邓紫棋 - 喜欢你.mp3"];
//    NSData *data = [NSData dataWithContentsOfFile:string];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
//    self.firstPlayer = player;
//    [self.firstPlayer prepareToPlay];
//    [self.firstPlayer play];
//    [self.secondPlayer stop];
}

- (void)uploadSecondSuccess {
//    NSString *string = [[NSBundle mainBundle] pathForSoundResource:@"G.E.M.邓紫棋 - A.I.N.Y. 爱你.mp3"];
//    NSData *data = [NSData dataWithContentsOfFile:string];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
//    self.secondPlayer = player;
//    [self.secondPlayer prepareToPlay];
//    [self.secondPlayer play];
//    [self.firstPlayer stop];
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }
    return _dateFormatter;
}
@end
