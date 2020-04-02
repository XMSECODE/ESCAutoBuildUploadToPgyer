//
//  ESCPgyerConfigViewController.m
//  AutoUploadToPgyer
//
//  Created by xiang on 06/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCPgyerConfigViewController.h"
#import "ESCConfigManager.h"

@interface ESCPgyerConfigViewController ()

@property (weak) IBOutlet NSTextField *uKeyTextField;

@property (weak) IBOutlet NSTextField *_api_kTextField;

@property (weak) IBOutlet NSTextField *passwordTextField;

@end

@implementation ESCPgyerConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([ESCConfigManager sharedConfigManager].uKey) {
        self.uKeyTextField.stringValue = [ESCConfigManager sharedConfigManager].uKey;
    }
    
    if ([ESCConfigManager sharedConfigManager].api_k) {
        self._api_kTextField.stringValue = [ESCConfigManager sharedConfigManager].api_k;
    }
    
    if ([ESCConfigManager sharedConfigManager].password) {
        self.passwordTextField.stringValue = [ESCConfigManager sharedConfigManager].password;
    }
    
}

- (IBAction)didClickMakeConfigButton:(id)sender {
    
    [ESCConfigManager sharedConfigManager].uKey = self.uKeyTextField.stringValue;
    [ESCConfigManager sharedConfigManager].api_k = self._api_kTextField.stringValue;
    [ESCConfigManager sharedConfigManager].password = self.passwordTextField.stringValue;

    [self dismissController:nil];
}

@end
