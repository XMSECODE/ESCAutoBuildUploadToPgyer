//
//  ESCAndroidTaskConfigViewController.m
//  iOSAutoBuildAndUpload
//
//  Created by apple on 2024/4/13.
//  Copyright © 2024 XMSECODE. All rights reserved.
//

#import "ESCAndroidTaskConfigViewController.h"
#import "ESCConfigurationModel.h"
#import "ESCConfigManager.h"
#import "ESCAppBundleIdAndProfileConfigViewController.h"


@interface ESCAndroidTaskConfigViewController ()

@property (weak) IBOutlet NSTextField *appNameTextField;

@property (weak) IBOutlet NSTextField *buildTypeTextField;

@property (weak) IBOutlet NSTextField *projectPathTextField;

@property (weak) IBOutlet NSTextField *ipaPathTextField;

@property (weak) IBOutlet NSPopUpButton *groupPopUpButton;

@property (assign) BOOL isCreatNew;

@property(nonatomic,strong)NSArray* temGroupModelArray;

@end

@implementation ESCAndroidTaskConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.configurationModel == nil) {
        self.isCreatNew = YES;
        self.configurationModel = [[ESCConfigurationModel alloc]init];
    }

    [self setupUI];

    
}

- (void)setupUI {
    ESCConfigurationModel *configurationModel = self.configurationModel;

    if (configurationModel.projectPath) {
        self.projectPathTextField.stringValue = configurationModel.projectPath;
    }
    
    if (configurationModel.ipaPath) {
        self.ipaPathTextField.stringValue = configurationModel.ipaPath;
    }
    
    
    if (configurationModel.appName) {
        self.appNameTextField.stringValue = configurationModel.appName;
    }
    
    if (configurationModel.android_buildType) {
        self.buildTypeTextField.stringValue = configurationModel.android_buildType;
    }
    
    [self.groupPopUpButton removeAllItems];
    
    NSArray <ESCGroupModel *>*groupArray = [[[ESCConfigManager sharedConfigManager] groupModel] allGroupModelArray];
    NSMutableArray *temArray = [NSMutableArray array];
    [self.groupPopUpButton addItemWithTitle:@"无分组"];
    for (int i = 0; i < groupArray.count; i++) {
        ESCGroupModel *groupModel = [groupArray objectAtIndex:i];
        [temArray addObject:groupModel];
        [self.groupPopUpButton addItemWithTitle:groupModel.name];
    }
    self.temGroupModelArray = [temArray copy];
    
    //查找当前所在的分组
    ESCGroupModel *groupModel = [[[ESCConfigManager sharedConfigManager] groupModel] getAppInGroupWithAPP:self.configurationModel];
    if (groupModel == nil) {
        [self.groupPopUpButton selectItemAtIndex:0];
    }else {
        [self.groupPopUpButton selectItemAtIndex:[groupArray indexOfObject:groupModel] + 1];
    }
    

}

- (IBAction)didClickCancelButton:(id)sender {
    [self dismissController:nil];
}

- (IBAction)didClickCheckProject:(id)sender {
    ESCConfigurationModel *configurationModel = self.configurationModel;
    
    NSString *projectPath = self.projectPathTextField.stringValue;
    configurationModel.projectPath = projectPath;
    
    NSString *ipaPath = self.ipaPathTextField.stringValue;
    configurationModel.ipaPath = ipaPath;
    
    
    configurationModel.tastType = ESCTaskType_android;

    configurationModel.appName = self.appNameTextField.stringValue;
    
    configurationModel.android_buildType = self.buildTypeTextField.stringValue;
    
    if (configurationModel.android_buildType.length <= 0) {
        configurationModel.android_buildType = @"release";
    }
    
    if (self.isCreatNew) {
        
    }else {
        
        
        ESCGroupModel *groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
        for (ESCConfigurationModel *configurationModelt in groupModel.configurationModelArray) {
            if ([configurationModelt isEqual:configurationModel]) {
                NSMutableArray *temArray = [groupModel.configurationModelArray mutableCopy];
                [temArray removeObject:configurationModel];
                groupModel.configurationModelArray = [temArray copy];
                [[ESCConfigManager sharedConfigManager] saveUserData];
            }
        }
        
        NSArray *temArray = [[[ESCConfigManager sharedConfigManager] groupModel] getAllGroupModelAndAppModelToArray];
           for (id temModel in temArray) {
               if ([temModel isKindOfClass:[ESCGroupModel class]]) {
                   ESCGroupModel *groupModel = temModel;
                   for (ESCConfigurationModel *model2 in groupModel.configurationModelArray) {
                       if ([model2 isEqual:configurationModel]) {
                           NSMutableArray *temArray = [groupModel.configurationModelArray mutableCopy];
                           [temArray removeObject:configurationModel];
                           groupModel.configurationModelArray = [temArray copy];
                           [[ESCConfigManager sharedConfigManager] saveUserData];
                       }
                   }
               }
           }
        
    }
    
    //保存分组
    NSInteger index = self.groupPopUpButton.indexOfSelectedItem;
    ESCGroupModel *groupModel;
    if (index == 0) {
        groupModel = [[ESCConfigManager sharedConfigManager] groupModel];
    }else {
        groupModel = [self.temGroupModelArray objectAtIndex:index - 1];
    }

    NSMutableArray *temConfigurationModelArray = [groupModel.configurationModelArray mutableCopy];
    if (temConfigurationModelArray == nil) {
        temConfigurationModelArray = [NSMutableArray array];
    }
    [temConfigurationModelArray addObject:configurationModel];
    groupModel.configurationModelArray = temConfigurationModelArray;
    
    [[ESCConfigManager sharedConfigManager] saveUserData];
    
    if (self.configCompleteBlock) {
        self.configCompleteBlock();
    }
    
    [self dismissController:nil];
}


@end
