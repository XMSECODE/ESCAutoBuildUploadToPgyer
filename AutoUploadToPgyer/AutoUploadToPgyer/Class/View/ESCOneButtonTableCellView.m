//
//  ESCDeleteTableCellView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/5/18.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCOneButtonTableCellView.h"

@interface ESCOneButtonTableCellView ()

@property (weak, nonatomic) IBOutlet NSButton *deleteButton;

@end

@implementation ESCOneButtonTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}

- (void)setType:(ESCOneButtonTableCellViewType)type {
    _type = type;
    if (type == ESCOneButtonTableCellViewConfigType) {
        [self.deleteButton setTitle:@"配置"];
    }else if (type == ESCOneButtonTableCellViewDeleteType) {
        [self.deleteButton setTitle:@"删除"];

    }
}

- (IBAction)didClickDeleteButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ESCDeleteTableCellViewDidClickButton:)]) {
        [self.delegate ESCDeleteTableCellViewDidClickButton:self];
    }
}

@end
