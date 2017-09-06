//
//  ESCMainTableCellView.h
//  AutoUploadToPgyer
//
//  Created by xiang on 05/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ESCMainTableCellView,ESCConfigurationModel;

static NSString *ESCMainTableCellViewID = @"ESCMainTableCellViewID";

@protocol ESCMainTableCellViewDelegate <NSObject>

- (void)mainTableCellViewdidClickConfigButton:(ESCMainTableCellView *)cellView configurationModel:(ESCConfigurationModel *)model;

- (void)mainTableCellViewdidClickDeleteButton:(ESCMainTableCellView *)cellView configurationModel:(ESCConfigurationModel *)model;

@end

@interface ESCMainTableCellView : NSTableCellView

@property(nonatomic,weak)id<ESCMainTableCellViewDelegate> delegate;

@property(nonatomic,strong)ESCConfigurationModel* configurationModel;

@end
