//
//  ESCPgyerConfigViewController.m
//  AutoUploadToPgyer
//
//  Created by xiang on 06/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCCustemShellConfigViewController.h"
#import "ESCConfigManager.h"

@interface ESCCustemShellConfigViewController ()

@property (weak) IBOutlet NSTextView *contentTextView;

@end

@implementation ESCCustemShellConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([ESCConfigManager sharedConfigManager].custom_shell_content) {
        self.contentTextView.string = [ESCConfigManager sharedConfigManager].custom_shell_content;
    }
    
}

- (IBAction)didClickMakeConfigButton:(id)sender {
    
    [ESCConfigManager sharedConfigManager].custom_shell_content = self.contentTextView.string;

    [self dismissController:nil];
}

@end
