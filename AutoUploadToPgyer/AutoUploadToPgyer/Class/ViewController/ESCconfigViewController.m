//
//  ESCconfigViewController.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCconfigViewController.h"
#import "ESCConfigurationModel.h"
#import "ESCConfigManager.h"

@interface ESCconfigViewController ()

@property (weak) IBOutlet NSButton *xcodeprojButton;

@property (weak) IBOutlet NSButton *xcworkspaceButton;

@property (weak) IBOutlet NSTextField *schemesTextField;

@property (weak) IBOutlet NSTextField *appNameTextField;

@property (weak) IBOutlet NSTextField *projectPathTextField;

@property (weak) IBOutlet NSTextField *ipaPathTextField;

@property (weak) IBOutlet NSTextField *signingCertificateTextField;

@property (weak) IBOutlet NSTextField *bundleIdTextField;

@property (weak) IBOutlet NSTextField *provisioningProfileNameTextField;

@property (weak) IBOutlet NSPopUpButton *groupPopUpButton;

@property (assign) BOOL isCreatNew;

@property(nonatomic,strong)NSArray* temGroupModelArray;

@end

@implementation ESCconfigViewController

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
    
    self.xcodeprojButton.state = !configurationModel.projectType;
    self.xcworkspaceButton.state = configurationModel.projectType;
    if (configurationModel.schemes) {
        self.schemesTextField.stringValue = configurationModel.schemes;
    }
    if (configurationModel.appName) {
        self.appNameTextField.stringValue = configurationModel.appName;
    }
    if (configurationModel.signingCertificate) {
        self.signingCertificateTextField.stringValue = configurationModel.signingCertificate;
    }
    if (configurationModel.bundleID) {
        self.bundleIdTextField.stringValue = configurationModel.bundleID;
    }
    if (configurationModel.provisioningProfileName) {
        self.provisioningProfileNameTextField.stringValue = configurationModel.provisioningProfileName;
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
    
    configurationModel.signingCertificate = self.signingCertificateTextField.stringValue;
    
    configurationModel.bundleID = self.bundleIdTextField.stringValue;
    
    configurationModel.provisioningProfileName = self.provisioningProfileNameTextField.stringValue;
    
    if (self.xcodeprojButton.state) {
        configurationModel.projectType = ESCXCodeProjectTypeProj;
    }else {
        configurationModel.projectType = ESCXCodeProjectTypeWorkspace;
    }
    
    NSString *schemes = self.schemesTextField.stringValue;
    configurationModel.schemes = schemes;
    configurationModel.appName = self.appNameTextField.stringValue;
    
    NSMutableArray *temArray = [[ESCConfigManager sharedConfigManager].modelArray mutableCopy];
    if (self.isCreatNew) {
        [temArray addObject:configurationModel];
        [ESCConfigManager sharedConfigManager].modelArray = [temArray copy];
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
- (IBAction)didClickxcodeprojButton:(id)sender {
    self.xcworkspaceButton.state = !self.xcodeprojButton.state;
}
- (IBAction)didClickxcworkspaceButton:(id)sender {
    self.xcodeprojButton.state = !self.xcworkspaceButton.state;
}

@end
