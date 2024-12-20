//
//  ESCRightMouseDownMenuView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2019/5/9.
//  Copyright © 2019 XMSECODE. All rights reserved.
//

#import "ESCRightMouseDownMenuView.h"

@interface ESCRightMouseDownMenuView ()

@property(nonatomic,weak)NSButton* buildButton;

@property(nonatomic,weak)NSButton* uploadButton;

@property(nonatomic,weak)NSButton* buildAnduploadButton;

@property(nonatomic,weak)NSButton* showInFindButton;

@end

@implementation ESCRightMouseDownMenuView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor clearColor] setFill];

    
    NSRectFill(dirtyRect);
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        NSButton *buildButton = [[NSButton alloc] initWithFrame:CGRectMake(0, frameRect.size.height / 4 * 3, frameRect.size.width, frameRect.size.height / 3)];
        [self addSubview:buildButton];
        self.buildButton = buildButton;
        [self.buildButton setTitle:@"编译"];
        self.buildButton.action = @selector(didClickBuildButton);
        self.buildButton.target = self;

        NSButton *uploadButton = [[NSButton alloc] initWithFrame:CGRectMake(0, frameRect.size.height / 4 * 2, frameRect.size.width, frameRect.size.height / 3)];
        [self addSubview:uploadButton];
        self.uploadButton = uploadButton;
        [self.uploadButton setTitle:@"上传打包文件"];
        self.uploadButton.action = @selector(didClickUploadButton);
        self.uploadButton.target = self;

        NSButton *buildAnduploadButton = [[NSButton alloc] initWithFrame:CGRectMake(0, frameRect.size.height / 4 * 1, frameRect.size.width, frameRect.size.height / 3)];
        [self addSubview:buildAnduploadButton];
        self.buildAnduploadButton = buildAnduploadButton;
        [self.buildAnduploadButton setTitle:@"编译和上传"];
        self.buildAnduploadButton.action = @selector(didClickBuildAndUploadButton);
        self.buildAnduploadButton.target = self;
        
        NSButton *showInFindButton = [[NSButton alloc] initWithFrame:CGRectMake(0, frameRect.size.height / 4 * 0, frameRect.size.width, frameRect.size.height / 3)];
        [self addSubview:showInFindButton];
        self.showInFindButton = showInFindButton;
        [self.showInFindButton setTitle:@"在Find中打开包文件存储路径"];
        self.showInFindButton.action = @selector(didClickOpenFindButton);
        self.showInFindButton.target = self;
        
    }
    return self;
}

- (void)didClickBuildButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ESCRightMouseDownMenuViewdidClickBuildButton:)]) {
        [self.delegate ESCRightMouseDownMenuViewdidClickBuildButton:self];
    }
    [self removeFromSuperview];
}

- (void)didClickUploadButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ESCRightMouseDownMenuViewdidClickUploadButton:)]) {
        [self.delegate ESCRightMouseDownMenuViewdidClickUploadButton:self];
    }
    [self removeFromSuperview];
}

- (void)didClickBuildAndUploadButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ESCRightMouseDownMenuViewdidClickBuildAndUploadButton:)]) {
        [self.delegate ESCRightMouseDownMenuViewdidClickBuildAndUploadButton:self];
    }
    [self removeFromSuperview];
}
    
- (void)didClickOpenFindButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ESCRightMouseDownMenuViewdidClickOpenFindButton:)]) {
        [self.delegate ESCRightMouseDownMenuViewdidClickOpenFindButton:self];
    }
    [self removeFromSuperview];
}

@end
