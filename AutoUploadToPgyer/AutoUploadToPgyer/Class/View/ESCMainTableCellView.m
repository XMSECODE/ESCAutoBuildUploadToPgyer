//
//  ESCMainTableCellView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 05/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCMainTableCellView.h"
#import "ESCConfigurationModel.h"
#import "ESCRightMouseDownMenuView.h"

@interface ESCMainTableCellView () <ESCRightMouseDownMenuViewDelegate>

@property (weak) IBOutlet NSTextField *projectName;
@property (weak) IBOutlet NSTextField *ipaNameTextField;
@property (weak) IBOutlet NSTextField *createDateTextField;
@property (weak) IBOutlet NSTextField *offTimeTextField;
@property (weak) IBOutlet NSTextField *sizeTextField;
@property (weak) IBOutlet NSTextField *uploadProgressTextField;
@property (weak) IBOutlet NSTextField *uploadStateTextField;
//@property (weak) IBOutlet NSButton *createIPAButton;
//@property (weak) IBOutlet NSButton *uploadIPAButton;
@property (weak) IBOutlet NSTextField *timeTextField;
//@property (weak) IBOutlet NSButton *bothButton;

@property(nonatomic,weak)ESCRightMouseDownMenuView* menuView;

@end

@implementation ESCMainTableCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMouseDownNotification:) name:@"mouseDownNotificationName" object:nil];
}

- (void)receiveMouseDownNotification:(NSNotification *)notification {
    if (self.menuView) {
        [self.menuView removeFromSuperview];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
}

- (void)mouseDown:(NSEvent *)event {
    if (self.menuView) {
        [self.menuView removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mouseDownNotificationName" object:nil];
}

- (void)rightMouseDown:(NSEvent *)event {
    NSPoint windowPoint= event.locationInWindow;
    NSPoint local_point = [self convertPoint:windowPoint fromView:nil];
    if (self.menuView) {
        [self.menuView removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mouseDownNotificationName" object:nil];
    //弹框
    ESCRightMouseDownMenuView *menuView = [[ESCRightMouseDownMenuView alloc] initWithFrame:NSMakeRect(local_point.x, 2, 100, 66)];
    [self addSubview:menuView];
    self.menuView = menuView;
    self.menuView.delegate = self;
    
}

//- (IBAction)didClickDeleteButton:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickDeleteButton:configurationModel:)]) {
//        [self.delegate mainTableCellViewdidClickDeleteButton:self configurationModel:self.configurationModel];
//    }
//}

- (IBAction)didClickConfigButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickConfigButton:configurationModel:)]) {
        [self.delegate mainTableCellViewdidClickConfigButton:self configurationModel:self.configurationModel];
    }
}

//- (IBAction)didClickCreateIPAButton:(id)sender {
//    self.configurationModel.isCreateIPA = self.createIPAButton.state;
//    if (self.configurationModel.isCreateIPA == YES && self.configurationModel.isUploadIPA == YES) {
//        self.bothButton.state = 1;
//    }else {
//        self.bothButton.state = 0;
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickSelectBuildButton:configurationModel:)]) {
//        [self.delegate mainTableCellViewdidClickSelectBuildButton:self configurationModel:self.configurationModel];
//    }
//}

//- (IBAction)didClickUploadIPAButton:(id)sender {
//    self.configurationModel.isUploadIPA = self.uploadIPAButton.state;
//    if (self.configurationModel.isCreateIPA == YES && self.configurationModel.isUploadIPA == YES) {
//        self.bothButton.state = 1;
//    }else {
//        self.bothButton.state = 0;
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickUploadButton:configurationModel:)]) {
//        [self.delegate mainTableCellViewdidClickUploadButton:self configurationModel:self.configurationModel];
//    }
//}
//- (IBAction)didClickBothButton:(id)sender {
//    self.configurationModel.isUploadIPA = self.bothButton.state;
//    self.configurationModel.isCreateIPA = self.bothButton.state;
//    self.createIPAButton.state = self.bothButton.state;
//    self.uploadIPAButton.state = self.bothButton.state;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickBothButton:configurationModel:)]) {
//        [self.delegate mainTableCellViewdidClickBothButton:self configurationModel:self.configurationModel];
//    }
//}

- (void)setConfigurationModel:(ESCConfigurationModel *)configurationModel {
    _configurationModel = configurationModel;
    
    self.projectName.stringValue = [NSString stringWithFormat:@"%@\n(%@)",configurationModel.appName,configurationModel.projectName];
    self.ipaNameTextField.stringValue = [self checkString:configurationModel.ipaName];
    self.createDateTextField.stringValue = [self checkString:configurationModel.createDateString];
    self.offTimeTextField.stringValue = [self checkString:configurationModel.offTime];
    self.sizeTextField.stringValue = [self checkString:configurationModel.sizeString];
    self.uploadProgressTextField.stringValue = [NSString stringWithFormat:@"%.2lf%@",configurationModel.uploadProgress * 100,@"%"];
    self.uploadStateTextField.stringValue = [self checkString:configurationModel.uploadState];
//    self.createIPAButton.state = configurationModel.isCreateIPA;
//    self.uploadIPAButton.state = configurationModel.isUploadIPA;
//    if (configurationModel.isCreateIPA == YES && configurationModel.isUploadIPA == YES) {
//        self.bothButton.state = 1;
//    }else {
//        self.bothButton.state = 0;
//    }
    self.timeTextField.stringValue = [self checkString:configurationModel.needRemainTimeString];
}

- (NSString *)checkString:(NSString *)string {
    if (string == nil) {
        return @"";
    }
    return string;
}

#pragma mark - ESCRightMouseDownMenuViewDelegate
- (void)ESCRightMouseDownMenuViewdidClickBuildButton:(ESCRightMouseDownMenuView *)view  {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickRightMenuBuildButton:configurationModel:)]) {
        [self.delegate mainTableCellViewdidClickRightMenuBuildButton:self configurationModel:self.configurationModel];
    }
}

- (void)ESCRightMouseDownMenuViewdidClickUploadButton:(ESCRightMouseDownMenuView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickRightMenuUploadButton:configurationModel:)]) {
        [self.delegate mainTableCellViewdidClickRightMenuUploadButton:self configurationModel:self.configurationModel];
    }
}

- (void)ESCRightMouseDownMenuViewdidClickBuildAndUploadButton:(ESCRightMouseDownMenuView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableCellViewdidClickRightMenuBuildAndUploadButton:configurationModel:)]) {
        [self.delegate mainTableCellViewdidClickRightMenuBuildAndUploadButton:self configurationModel:self.configurationModel];
    }
}

@end
