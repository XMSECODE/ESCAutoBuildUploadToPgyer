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
@property (weak) IBOutlet NSPathControl *ipaPathControl;
@property (weak) IBOutlet NSButton *xcodeprojButton;
@property (weak) IBOutlet NSButton *xcworkspaceButton;
@property (weak) IBOutlet NSButton *debugButton;
@property (weak) IBOutlet NSButton *releaseButton;
@property (weak) IBOutlet NSTextField *schemesTextField;
@property (weak) IBOutlet NSTextField *appNameTextField;

@end

@implementation ESCconfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    ESCConfigurationModel *configurationModel = self.configurationModel;

    if (configurationModel.projectPath) {
        NSURL *url = [NSURL URLWithString:configurationModel.projectPath];
        self.projectPathControl.URL = url;
    }
    
    if (configurationModel.ipaPath) {
        NSURL *url = [NSURL URLWithString:configurationModel.ipaPath];
        self.ipaPathControl.URL = url;
    }
    
    self.xcodeprojButton.state = !configurationModel.projectType;
    self.xcworkspaceButton.state = configurationModel.projectType;
    self.debugButton.state = configurationModel.configuration;
    self.releaseButton.state = !configurationModel.configuration;
    if (configurationModel.schemes) {
        self.schemesTextField.stringValue = configurationModel.schemes;
    }
    if (configurationModel.appName) {
        self.appNameTextField.stringValue = configurationModel.appName;
    }
    
}
- (IBAction)didClickCancelButton:(id)sender {
    [self dismissController:nil];
}

- (IBAction)didClickCheckProject:(id)sender {
    ESCConfigurationModel *configurationModel = self.configurationModel;
    
    NSString *projectPath = self.projectPathControl.URL.path;
    configurationModel.projectPath = projectPath;
    
    NSString *ipaPath = self.ipaPathControl.URL.path;
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
- (IBAction)didClickDebugButton:(id)sender {
    self.releaseButton.state = !self.debugButton.state;
}
- (IBAction)didClickReleaseButton:(id)sender {
    self.debugButton.state = !self.releaseButton.state;
}

@end
