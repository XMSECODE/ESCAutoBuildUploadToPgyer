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

typedef enum : NSUInteger {
    ESCOneButtonTableCellViewDeleteType,
    ESCOneButtonTableCellViewConfigType
} ESCOneButtonTableCellViewType;

static NSString *ESCOneButtonTableCellViewId = @"ESCOneButtonTableCellViewId";

@class ESCOneButtonTableCellView;

@protocol ESCOneButtonTableCellViewDelegate <NSObject>

- (void)ESCDeleteTableCellViewDidClickButton:(ESCOneButtonTableCellView *)view;

@end

@interface ESCOneButtonTableCellView : NSTableCellView

@property(nonatomic,weak)id<ESCOneButtonTableCellViewDelegate> delegate;

@property(nonatomic,strong)ESCConfigurationModel* model;

@property(nonatomic,assign)ESCOneButtonTableCellViewType type;

@end

NS_ASSUME_NONNULL_END
