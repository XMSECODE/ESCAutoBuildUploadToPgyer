//
//  ESCTextCellView.m
//  iOSAutoBuildAndUpload
//
//  Created by xiangmingsheng on 2021/3/20.
//  Copyright © 2021 XMSECODE. All rights reserved.
//

#import "ESCTextCellView.h"

@interface ESCTextCellView  () <NSTextFieldDelegate>

@end

@implementation ESCTextCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    self.textField.delegate = self;
}

- (void)setModel:(ESCBundleIdModel *)model {
    _model = model;
    [self setUI];
}

- (void)setType:(int)type {
    _type = type;
    [self setUI];
}

- (void)setUI {
    if (self.type == 0) {
        self.textField.stringValue = self.model.bundleId;
    }else {
        self.textField.stringValue = self.model.profileName;
    }
}

#pragma mark - NSTextFieldDelegate
- (void)controlTextDidBeginEditing:(NSNotification *)obj {
    
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if (self.textField.stringValue.length <= 0) {
        [self setUI];
        return;
    }
    if (self.type == 0) {
        self.model.bundleId = self.textField.stringValue;
    }else {
        self.model.profileName = self.textField.stringValue;
    }
    
    [self setUI];
}
@end
