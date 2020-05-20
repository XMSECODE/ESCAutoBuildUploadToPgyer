//
//  ESCSelectButtonTableCellView.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/5/18.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCSelectButtonTableCellView.h"

@interface ESCSelectButtonTableCellView ()

@property (weak, nonatomic) IBOutlet NSButton *selectButton;

@property(nonatomic,strong)id model;

@property(nonatomic,assign)ESCSelectButtonTableCellViewType type;

@end

@implementation ESCSelectButtonTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setModel:(id)model type:(ESCSelectButtonTableCellViewType)type {
    self.model = model;
    self.type = type;
    
    if ([self.model isKindOfClass:[ESCGroupModel class]]) {
        ESCGroupModel *groupModel = self.model;
        if (self.type == ESCSelectButtonTableCellViewTypeBuild) {
            self.selectButton.state = [groupModel isAllCreateIPAFile];
        }else if (self.type == ESCSelectButtonTableCellViewTypeUpload) {
            self.selectButton.state = [groupModel isAllUploadIPAFile];
        }else if (self.type == ESCSelectButtonTableCellViewTypeBuildAndUploa) {
            self.selectButton.state = [groupModel isAllUploadIPAFile] && [groupModel isAllCreateIPAFile];
        }
    }else if ([self.model isKindOfClass:[ESCConfigurationModel class]]) {
        ESCConfigurationModel *configurationModel = model;
        if (self.type == ESCSelectButtonTableCellViewTypeBuild) {
            self.selectButton.state = configurationModel.isCreateIPA;
        }else if (self.type == ESCSelectButtonTableCellViewTypeUpload) {
            self.selectButton.state = configurationModel.isUploadIPA;
        }else if (self.type == ESCSelectButtonTableCellViewTypeBuildAndUploa) {
            self.selectButton.state = configurationModel.isCreateIPA && configurationModel.isUploadIPA;
        }
    }
}

- (IBAction)didClickSelectButton:(id)sender {
    if ([self.model isKindOfClass:[ESCGroupModel class]]) {
         ESCGroupModel *groupModel = self.model;
         if (self.type == ESCSelectButtonTableCellViewTypeBuild) {
             [groupModel setAllCreateIPAFile:self.selectButton.state];
         }else if (self.type == ESCSelectButtonTableCellViewTypeUpload) {
             [groupModel setAllUploadIPAFile:self.selectButton.state];
         }else if (self.type == ESCSelectButtonTableCellViewTypeBuildAndUploa) {
             [groupModel setAllUploadIPAFile:self.selectButton.state];
             [groupModel setAllCreateIPAFile:self.selectButton.state];
         }
     }else if ([self.model isKindOfClass:[ESCConfigurationModel class]]) {
         ESCConfigurationModel *configurationModel = self.model;
         if (self.type == ESCSelectButtonTableCellViewTypeBuild) {
             configurationModel.isCreateIPA = self.selectButton.state;
         }else if (self.type == ESCSelectButtonTableCellViewTypeUpload) {
              configurationModel.isUploadIPA = self.selectButton.state;
         }else if (self.type == ESCSelectButtonTableCellViewTypeBuildAndUploa) {
             configurationModel.isUploadIPA = self.selectButton.state;
             configurationModel.isCreateIPA = self.selectButton.state;
         }
     }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ESCSelectButtonTableCellViewDidClickSelectedButton:)]) {
        [self.delegate ESCSelectButtonTableCellViewDidClickSelectedButton:self];
    }
}

@end
