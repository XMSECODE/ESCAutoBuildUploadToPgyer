//
//  ESCMainTableCellView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 05/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCMainTableCellView.h"
#import "ESCConfigurationModel.h"

@interface ESCMainTableCellView ()

@property (weak) IBOutlet NSTextField *projectName;
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
    
}
- (IBAction)didClickDeleteButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickDeleteButton:configurationModel:)]) {
        [self.delegate mainTableCellViewdidClickDeleteButton:self configurationModel:self.configurationModel];
    }
}

- (IBAction)didClickConfigButton:(id)sender {
    if (self.delegate) {
        [self.delegate mainTableCellViewdidClickConfigButton:self configurationModel:self.configurationModel];
    }
}
- (IBAction)didClickCreateIPAButton:(id)sender {
    self.configurationModel.isCreateIPA = self.createIPAButton.state;
}
- (IBAction)didClickUploadIPAButton:(id)sender {
    self.configurationModel.isUploadIPA = self.uploadIPAButton.state;
}

- (void)setConfigurationModel:(ESCConfigurationModel *)configurationModel {
    _configurationModel = configurationModel;
    
    self.projectName.stringValue = [self checkString:configurationModel.projectName];
    self.ipaNameTextField.stringValue = [self checkString:configurationModel.ipaName];
    self.createDateTextField.stringValue = [self checkString:configurationModel.createDateString];
    self.offTimeTextField.stringValue = [self checkString:configurationModel.offTime];
    self.sizeTextField.stringValue = [self checkString:configurationModel.sizeString];
    self.uploadProgressTextField.stringValue = [NSString stringWithFormat:@"%.2lf%@",configurationModel.uploadProgress * 100,@"%"];
    self.uploadProgressIndicator.doubleValue = configurationModel.uploadProgress;
    self.uploadStateTextField.stringValue = [self checkString:configurationModel.uploadState];
    self.createIPAButton.state = configurationModel.isCreateIPA;
    self.uploadIPAButton.state = configurationModel.isUploadIPA;
    
}

- (NSString *)checkString:(NSString *)string {
    if (string == nil) {
        return @"";
    }
    return string;
}

@end