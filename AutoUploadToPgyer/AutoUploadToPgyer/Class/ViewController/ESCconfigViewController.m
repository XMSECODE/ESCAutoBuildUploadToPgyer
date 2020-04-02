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

@property (assign) BOOL isCreatNew;

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
