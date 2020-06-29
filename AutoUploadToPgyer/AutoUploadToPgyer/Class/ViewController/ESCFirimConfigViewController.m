//
//  ESCFirimConfigViewController.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/6/23.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCFirimConfigViewController.h"
#import "ESCConfigManager.h"

@interface ESCFirimConfigViewController ()

@property (weak) IBOutlet NSTextField *api_tokenTextField;

@end

@implementation ESCFirimConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([ESCConfigManager sharedConfigManager].firim_api_token) {
          self.api_tokenTextField.stringValue = [ESCConfigManager sharedConfigManager].firim_api_token;
      }
}

- (IBAction)didClickMakeConfigButton:(id)sender {
    
    [ESCConfigManager sharedConfigManager].firim_api_token = self.api_tokenTextField.stringValue;

    [self dismissController:nil];
}
@end
