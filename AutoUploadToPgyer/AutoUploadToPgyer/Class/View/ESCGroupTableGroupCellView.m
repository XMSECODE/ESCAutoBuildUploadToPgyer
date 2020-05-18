//
//  ESCGroupTableCellView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/4/24.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCGroupTableGroupCellView.h"
#import "ESCConfigManager.h"

@interface  ESCGroupTableGroupCellView() <NSTextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSTextField *nameTextField;

@property (weak, nonatomic) IBOutlet NSButton *showButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayoutConstraint;

@end

@implementation ESCGroupTableGroupCellView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.nameTextField setEditable:YES];
    
//    self.nameTextField.target = self;
//    self.nameTextField.action = @selector(nameTextFieldDidChange:);
    self.nameTextField.delegate = self;
    
    self.showButton.target = self;
    self.showButton.action = @selector(didClickShowButton:);
}

#pragma mark - NSTextFieldDelegate
- (void)controlTextDidBeginEditing:(NSNotification *)obj {
    
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if (self.nameTextField.stringValue.length <= 0) {
        self.nameTextField.stringValue = self.groupModel.name;
        return;
    }
    self.groupModel.name = self.nameTextField.stringValue;
    [self setGroupModel:self.groupModel];
}



- (void)didClickShowButton:(NSButton *)showButton {
    self.groupModel.isShow = !self.groupModel.isShow;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ESCGroupTableGroupCellViewDidClickShowButton:)]) {
        [self.delegate ESCGroupTableGroupCellViewDidClickShowButton:self];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}

- (void)setGroupModel:(ESCGroupModel *)groupModel {
    _groupModel = groupModel;
    self.nameTextField.stringValue = groupModel.name;
    if (self.groupModel.isShow == YES) {
        [self.showButton setImage:[NSImage imageNamed:@"NSTouchBarGoDownTemplate"]];
    }else {
        [self.showButton setImage:[NSImage imageNamed:@"NSTouchBarGoForwardTemplate"]];
    }
    int level = [[ESCConfigManager sharedConfigManager] getGroupLevelWithGroupModel:groupModel];
    self.leftLayoutConstraint.constant = level * 20;
    
    if (groupModel.isEdit == YES) {
        
    }
    [self.nameTextField sizeToFit];
}

@end
