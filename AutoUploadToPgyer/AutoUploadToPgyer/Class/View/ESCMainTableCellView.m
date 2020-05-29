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
@property (weak) IBOutlet NSTextField *timeTextField;

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

- (void)setConfigurationModel:(ESCConfigurationModel *)configurationModel {
    _configurationModel = configurationModel;
    
    self.projectName.stringValue = [NSString stringWithFormat:@"%@\n(%@)",configurationModel.appName,configurationModel.projectName];
    self.ipaNameTextField.stringValue = [self checkString:configurationModel.ipaName];
    self.createDateTextField.stringValue = [self checkString:configurationModel.createDateString];
    self.offTimeTextField.stringValue = [self checkString:configurationModel.offTime];
    self.sizeTextField.stringValue = [self checkString:configurationModel.sizeString];
    self.uploadProgressTextField.stringValue = [NSString stringWithFormat:@"%.2lf%@",configurationModel.uploadProgress * 100,@"%"];
    self.uploadStateTextField.stringValue = [self checkString:configurationModel.uploadState];

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
