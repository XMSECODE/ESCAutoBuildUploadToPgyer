//
//  ViewController.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 02/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ViewController.h"
#import "ESCFileManager.h"
#import "NSDate+ESCDateString.h"
#import "ESCNetWorkManager.h"
#import "MJExtension.h"
#import "ESCHeader.h"
#import <AVFoundation/AVFoundation.h>
#import "ESCconfigViewController.h"
#import "ESCBuildShellFileManager.h"
#import "ESCConfigurationModel.h"
#import "ESCConfigManager.h"
#import "ESCMainViewController.h"

@interface ViewController ()

@property (weak) IBOutlet NSTextField *firstName;
@property (weak) IBOutlet NSTextField *firstCreateDate;
@property (weak) IBOutlet NSTextField *firstPacketSzie;
@property (weak) IBOutlet NSTextField *firstOffTime;
@property (weak) IBOutlet NSTextField *firstProgress;
@property (weak) IBOutlet NSProgressIndicator *firstProgressDicator;
@property (weak) IBOutlet NSTextField *firstUploadResult;

@property (weak) IBOutlet NSTextField *secondName;
@property (weak) IBOutlet NSTextField *secondCreateDate;
@property (weak) IBOutlet NSTextField *secondPacketSize;
@property (weak) IBOutlet NSTextField *secondOffTime;
@property (weak) IBOutlet NSTextField *secondProgress;
@property (weak) IBOutlet NSProgressIndicator *secondProgressDicator;
@property (weak) IBOutlet NSTextField *secondUploadResult;

@property (weak) IBOutlet NSTextView *logTextView;

@property(nonatomic,strong)NSDateFormatter* dateFormatter;

@property(nonatomic,strong)AVAudioPlayer* firstPlayer;
@property(nonatomic,strong)AVAudioPlayer* secondPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didClickCommitButton:(id)sender {
    [self uploadFirstIPA];
    [self uploadSecondIPA];
}

- (IBAction)didClickTest:(id)sender {
    NSViewController *vc = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"ESCMainViewController"];
    [self presentViewControllerAsSheet:vc];
}

- (IBAction)uploadFirstIPA:(id)sender {
    [self uploadFirstIPA];
}
- (IBAction)uploadSecondIPA:(id)sender {
    [self uploadSecondIPA];
}


- (IBAction)didCliclFirstIPAButton:(id)sender {
    NSString *filePath = [ESCBuildShellFileManager writeShellFileWithConfigurationModel:[ESCConfigManager sharedConfigManager].firstConfigurationModel];
    system(filePath.UTF8String);
    [self addLog:@"生成第一个ipa包"];
}
- (IBAction)didClickSecondIPAButton:(id)sender {
    NSString *filePath = [ESCBuildShellFileManager writeShellFileWithConfigurationModel:[ESCConfigManager sharedConfigManager].secondConfigurationModel];
    system(filePath.UTF8String);
    [self addLog:@"生成第二个ipa包"];
}

- (IBAction)didClickAllIPAButton:(id)sender {
    [self didCliclFirstIPAButton:nil];
    [self didClickSecondIPAButton:nil];
}

- (IBAction)didClickBuildAndUploadFirstipaButton:(id)sender {
    [self didCliclFirstIPAButton:nil];
    [NSThread sleepForTimeInterval:2];
    [self uploadFirstIPA];
}
- (IBAction)didClickBuildAndUploadSecondipaButton:(id)sender {
    [self didClickSecondIPAButton:nil];
    [NSThread sleepForTimeInterval:2];
    [self uploadSecondIPA];
}
- (IBAction)didClickBuildAndUploadAllipaButton:(id)sender {
    [self didCliclFirstIPAButton:nil];
    [NSThread sleepForTimeInterval:2];
    [self didClickSecondIPAButton:nil];
    [self uploadFirstIPA];
    [self uploadSecondIPA];
}

- (IBAction)didClickScanDirectory:(id)sender {
    self.firstName.stringValue = [[ESCFileManager sharedFileManager] getFirstIPADisplayName];
    NSDictionary *firstDicture = [[ESCFileManager sharedFileManager] getLatestIPAFileInfoFromFirstDirectory];
    NSDate *firstDate = [firstDicture objectForKey:NSFileCreationDate];
    self.firstCreateDate.stringValue = [self.dateFormatter stringFromDate:firstDate];
    self.firstOffTime.stringValue = [firstDate getOffTime];
    float firstSize = [[firstDicture objectForKey:NSFileSize] floatValue] / 1024 / 1024;
    self.firstPacketSzie.stringValue = [NSString stringWithFormat:@"%.2lfM",firstSize];
    
    self.secondName.stringValue = [[ESCFileManager sharedFileManager] getSecondIPADisplayName];
    NSDictionary *secondDict = [[ESCFileManager sharedFileManager] getLatestIPAFileInfoFromSecondDirectory];
    NSDate *secondDate = [secondDict objectForKey:NSFileModificationDate];
    self.secondCreateDate.stringValue = [self.dateFormatter stringFromDate:secondDate];
    self.secondOffTime.stringValue = [secondDate getOffTime];
    float secondSize = [[secondDict objectForKey:NSFileSize] floatValue] / 1024 / 1024;
    self.secondPacketSize.stringValue = [NSString stringWithFormat:@"%.2lfM",secondSize];
}
- (IBAction)didClickConfigFirstProjectButton:(id)sender {
    ESCconfigViewController *viewController = [[NSStoryboard storyboardWithName:@"ESCconfigViewController" bundle:nil] instantiateInitialController];
    viewController.projectNum = 1;
    [self presentViewControllerAsSheet:viewController];
}
- (IBAction)didClickConfigSecondProjectButton:(id)sender {
    ESCconfigViewController *viewController = [[NSStoryboard storyboardWithName:@"ESCconfigViewController" bundle:nil] instantiateInitialController];
    viewController.projectNum = 2;
    [self presentViewControllerAsSheet:viewController];
}

- (void)uploadFirstIPA {
    [self didClickScanDirectory:nil];
    __weak __typeof(self)weakSelf = self;
    [ESCNetWorkManager uploadToPgyerWithFilePath:[[ESCFileManager sharedFileManager] getLatestIPAFilePathFromFirstDirectory] progress:^(NSProgress *progress) {
        double currentProgress = progress.fractionCompleted;
        weakSelf.firstProgress.stringValue = [NSString stringWithFormat:@"%.2lf",currentProgress * 100];
        weakSelf.firstProgressDicator.doubleValue =currentProgress;
    } success:^(NSDictionary *result){
        weakSelf.firstUploadResult.stringValue = @"success";
        NSString *resultString = [result mj_JSONString];
        [weakSelf writeLog:resultString];
        [weakSelf uploadFirstSuccess];
    } failure:^(NSError *error) {
        weakSelf.firstUploadResult.stringValue = @"failure";
        [weakSelf writeLog:error.localizedDescription];
    }];
}


- (void)uploadSecondIPA {
    [self didClickScanDirectory:nil];
    __weak __typeof(self)weakSelf = self;
    [ESCNetWorkManager uploadToPgyerWithFilePath:[[ESCFileManager sharedFileManager] getLatestIPAFilePathFromSecondDirectory] progress:^(NSProgress *progress) {
        double currentProgress = progress.fractionCompleted;
        weakSelf.secondProgress.stringValue = [NSString stringWithFormat:@"%.2lf",currentProgress * 100];
        weakSelf.secondProgressDicator.doubleValue =currentProgress;
    } success:^(NSDictionary *result){
        weakSelf.secondUploadResult.stringValue = @"success";
        NSString *resultString = [result mj_JSONString];
        [weakSelf writeLog:resultString];
        [weakSelf uploadSecondSuccess];
    } failure:^(NSError *error) {
        weakSelf.secondUploadResult.stringValue = @"failure";
        [weakSelf writeLog:error.localizedDescription];
    }];
}

- (void)uploadFirstSuccess {
    NSString *string = [[NSBundle mainBundle] pathForSoundResource:@"G.E.M.邓紫棋 - 喜欢你.mp3"];
    NSData *data = [NSData dataWithContentsOfFile:string];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.firstPlayer = player;
    [self.firstPlayer prepareToPlay];
    [self.firstPlayer play];
    [self.secondPlayer stop];
    [self addLog:@"上传第一个ipa包"];
}

- (void)uploadSecondSuccess {
    NSString *string = [[NSBundle mainBundle] pathForSoundResource:@"G.E.M.邓紫棋 - A.I.N.Y. 爱你.mp3"];
    NSData *data = [NSData dataWithContentsOfFile:string];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.secondPlayer = player;
    [self.secondPlayer prepareToPlay];
    [self.secondPlayer play];
    [self.firstPlayer stop];
    [self addLog:@"上传第二个ipa包"];
}

- (void)writeLog:(NSString *)string {
    NSString *logString = [[self.dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:[NSString stringWithFormat:@"==========%@",string]];
    [[ESCFileManager sharedFileManager] wirteLogToFileWith:logString withName:[self.dateFormatter stringFromDate:[NSDate date]]];
}

- (IBAction)didClickOpenHistoryDirectory:(id)sender {
    NSString* str = ESCHistoryFileDirectoryPath;
    str = [NSString stringWithFormat:@"open %@",str];
    system(str.UTF8String);
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }
    return _dateFormatter;
}

- (void)addLog:(NSString *)string {
    NSString *temStrin = self.logTextView.string;
    temStrin = [temStrin stringByAppendingFormat:@"           %@",string];
    self.logTextView.string = temStrin;
}

@end
