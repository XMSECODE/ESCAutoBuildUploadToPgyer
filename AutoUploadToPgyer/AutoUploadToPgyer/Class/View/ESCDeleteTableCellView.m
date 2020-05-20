//
//  ESCDeleteTableCellView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/5/18.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCDeleteTableCellView.h"

@interface ESCDeleteTableCellView ()

@property (weak, nonatomic) IBOutlet NSButton *deleteButton;

@end

@implementation ESCDeleteTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}

- (IBAction)didClickDeleteButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ESCDeleteTableCellViewDidClickDeleteButton:)]) {
        [self.delegate ESCDeleteTableCellViewDidClickDeleteButton:self];
    }
}

@end
