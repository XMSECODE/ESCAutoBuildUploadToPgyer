//
//  ESCAppTableViewAppBuildUpdateDescriptionCellView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/4/20.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCAppTableViewAppBuildUpdateDescriptionCellView.h"

@interface ESCAppTableViewAppBuildUpdateDescriptionCellView ()

@property (weak) IBOutlet NSTextView *contentTextView;

@property (weak) IBOutlet NSButton *save_button;

@end

@implementation ESCAppTableViewAppBuildUpdateDescriptionCellView

- (void)setModel:(ESCConfigurationModel *)model {
    _model = model;
    if (model.buildUpdateDescription != nil) {
        self.contentTextView.string = model.buildUpdateDescription;
    }
    self.save_button.state = model.save_buildUpdateDescription;
}


- (IBAction)didClickSaveButton:(NSButton *)sender {
    if (sender.state == 0) {
        self.model.save_buildUpdateDescription = NO;
    }else {
        self.model.save_buildUpdateDescription = YES;
    }
}
- (IBAction)contentDidChanged:(id)sender {
    self.model.buildUpdateDescription = self.contentTextView.string;
}

@end
