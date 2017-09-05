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

@property (weak) IBOutlet NSPathControl *projectPathControl;
@property (weak) IBOutlet NSPathControl *temPathControl;
@property (weak) IBOutlet NSPathControl *ipaPathControl;
@property (weak) IBOutlet NSButton *xcodeprojButton;
@property (weak) IBOutlet NSButton *xcworkspaceButton;
@property (weak) IBOutlet NSButton *debugButton;
@property (weak) IBOutlet NSButton *releaseButton;
@property (weak) IBOutlet NSTextField *schemesTextField;
@property (weak) IBOutlet NSTextField *appNameTextField;
    @property (weak) IBOutlet NSTextField *projectNameTextField;

@end

@implementation ESCconfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    ESCConfigurationModel *configurationModel;
    if (self.projectNum == 1) {
        configurationModel = [ESCConfigManager sharedConfigManager].firstConfigurationModel;
    }else {
        configurationModel = [ESCConfigManager sharedConfigManager].secondConfigurationModel;
    }
    if (configurationModel == nil) {
        return;
    }
    if (configurationModel.projectPath) {
        NSURL *url = [NSURL URLWithString:configurationModel.projectPath];
        self.projectPathControl.URL = url;
    }
    
    if (configurationModel.temPath) {
        NSURL *url = [NSURL URLWithString:configurationModel.temPath];
        self.temPathControl.URL = url;
    }
    
    if (configurationModel.ipaPath) {
        NSURL *url = [NSURL URLWithString:configurationModel.ipaPath];
        self.ipaPathControl.URL = url;
    }
    
    self.xcodeprojButton.state = configurationModel.projectType;
    self.xcworkspaceButton.state = !configurationModel.projectType;
    self.debugButton.state = configurationModel.configuration;
    self.releaseButton.state = !configurationModel.configuration;
    if (configurationModel.schemes) {
        self.schemesTextField.stringValue = configurationModel.schemes;
    }
    if (configurationModel.appName) {
        self.appNameTextField.stringValue = configurationModel.appName;
    }
    
    if (configurationModel.projectName) {
        self.projectNameTextField.stringValue = configurationModel.projectName;
    }
    
}

- (IBAction)didClickCheckProject:(id)sender {
    ESCConfigurationModel *configurationModel = [[ESCConfigurationModel alloc] init];
    
    NSString *projectPath = self.projectPathControl.stringValue;
    configurationModel.projectPath = projectPath;
    
    NSString *temPath = self.temPathControl.stringValue;
    configurationModel.temPath = temPath;
    
    NSString *ipaPath = self.ipaPathControl.stringValue;
    configurationModel.ipaPath = ipaPath;
    
    if (self.xcodeprojButton.state) {
        configurationModel.projectType = ESCXCodeProjectTypeProj;
    }else {
        configurationModel.projectType = ESCXCodeProjectTypeWorkspace;
    }
    
    if (self.debugButton.state) {
        configurationModel.configuration = ESCXcodeBuildConfigurationDebug;
    }else {
        configurationModel.configuration = ESCXcodeBuildConfigurationRelease;
    }
    
    NSString *schemes = self.schemesTextField.stringValue;
    configurationModel.schemes = schemes;
    configurationModel.appName = self.appNameTextField.stringValue;
    configurationModel.projectName = self.projectNameTextField.stringValue;
    if (self.projectNum == 1) {
        [ESCConfigManager sharedConfigManager].firstConfigurationModel = configurationModel;
    }else {
        [ESCConfigManager sharedConfigManager].secondConfigurationModel = configurationModel;
    }
    
    [self dismissController:nil];
}
- (IBAction)didClickxcodeprojButton:(id)sender {
    self.xcworkspaceButton.state = !self.xcodeprojButton.state;
}
- (IBAction)didClickxcworkspaceButton:(id)sender {
    self.xcodeprojButton.state = !self.xcworkspaceButton.state;
}
- (IBAction)didClickDebugButton:(id)sender {
    self.releaseButton.state = !self.debugButton.state;
}
- (IBAction)didClickReleaseButton:(id)sender {
    self.debugButton.state = !self.releaseButton.state;
}

@end
