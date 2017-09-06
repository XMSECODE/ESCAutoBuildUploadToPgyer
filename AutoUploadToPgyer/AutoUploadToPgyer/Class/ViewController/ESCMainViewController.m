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
    for (ESCConfigurationModel *model in [ESCConfigManager sharedConfigManager].modelArray) {
        if (model.isCreateIPA) {
            NSString *filePath = [ESCBuildShellFileManager writeShellFileWithConfigurationModel:model];
            system(filePath.UTF8String);
            NSString *logStr = [NSString stringWithFormat:@"生成%@项目ipa包",model.projectName];
            [self addLog:logStr];
            [self uploadData];
        }
    }
}

- (IBAction)didClickUploadPgyerButton:(id)sender {
    NSString *ukey = [ESCConfigManager sharedConfigManager].uKey;
    NSString *api_k = [ESCConfigManager sharedConfigManager].api_k;
    for (ESCConfigurationModel *model in [ESCConfigManager sharedConfigManager].modelArray) {
        __weak __typeof(self)weakSelf = self;
        if (model.isUploadIPA) {
            [ESCNetWorkManager uploadToPgyerWithFilePath:[[ESCFileManager sharedFileManager] getLatestIPAFilePathFromWithConfigurationModel:model] uKey:ukey api_key:api_k progress:^(NSProgress *progress) {
                double currentProgress = progress.fractionCompleted;
                model.uploadProgress = currentProgress;
                [weakSelf.tableView reloadData];
            } success:^(NSDictionary *result){
                model.uploadState = @"上传成功";
                NSString *resultString = [result mj_JSONString];
                [weakSelf writeLog:resultString withPath:model.historyLogPath];
                [weakSelf.tableView reloadData];
            } failure:^(NSError *error) {
                model.uploadState = @"上传失败";
                [weakSelf writeLog:error.localizedDescription withPath:model.historyLogPath];
            }];
        }
    }
}

- (IBAction)didClickScanButton:(id)sender {
    [self uploadData];
}

- (void)uploadData {
    for (ESCConfigurationModel *model in [ESCConfigManager sharedConfigManager].modelArray) {
        [[ESCFileManager sharedFileManager] getLatestIPAFileInfoWithConfigurationModel:model];
    }
    [self.tableView reloadData];
}

- (void)writeLog:(NSString *)string withPath:(NSString *)path{
    NSString *logString = [[self.dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:[NSString stringWithFormat:@"==========%@",string]];
    [[ESCFileManager sharedFileManager] wirteLogToFileWith:logString withName:[self.dateFormatter stringFromDate:[NSDate date]] withPath:path];
}

- (void)addLog:(NSString *)string {
    NSString *temStrin = self.logTextView.string;
    temStrin = [temStrin stringByAppendingFormat:@"%@\n",string];
    self.logTextView.string = temStrin;
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
