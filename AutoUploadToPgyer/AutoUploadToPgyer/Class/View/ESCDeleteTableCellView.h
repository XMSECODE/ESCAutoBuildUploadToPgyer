//
//  ESCDeleteTableCellView.h
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/5/18.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ESCConfigurationModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *ESCDeleteTableCellViewId = @"ESCDeleteTableCellViewId";

@class ESCDeleteTableCellView;

@protocol ESCDeleteTableCellViewDelegate <NSObject>

- (void)ESCDeleteTableCellViewDidClickDeleteButton:(ESCDeleteTableCellView *)view;

@end

@interface ESCDeleteTableCellView : NSTableCellView

@property(nonatomic,weak)id<ESCDeleteTableCellViewDelegate> delegate;

@property(nonatomic,strong)ESCConfigurationModel* model;

@end

NS_ASSUME_NONNULL_END
