//
//  ESCMainTableCellView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 05/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCMainTableCellView.h"

@interface ESCMainTableCellView ()
    
@property (weak) IBOutlet NSTextField *ipaNameTextField;
@property (weak) IBOutlet NSTextField *createDateTextField;
@property (weak) IBOutlet NSTextField *offTimeTextField;
@property (weak) IBOutlet NSTextField *sizeTextField;
@property (weak) IBOutlet NSTextField *uploadProgressTextField;
@property (weak) IBOutlet NSProgressIndicator *uploadProgressIndicator;
@property (weak) IBOutlet NSTextField *uploadStateTextField;
@property (weak) IBOutlet NSButton *createIPAButton;
@property (weak) IBOutlet NSButton *uploadIPAButton;

@end

@implementation ESCMainTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
- (IBAction)didClickConfigButton:(id)sender {
}

@end
