//
//  ESCSelectButtonTableCellView.h
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/5/18.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ESCGroupModel.h"
#import "ESCConfigurationModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ESCSelectButtonTableCellView;

@protocol ESCSelectButtonTableCellViewDelegate <NSObject>

- (void)ESCSelectButtonTableCellViewDidClickSelectedButton:(ESCSelectButtonTableCellView *)view;

@end

typedef enum : NSUInteger {
    ESCSelectButtonTableCellViewTypeBuild,
    ESCSelectButtonTableCellViewTypeUpload,
    ESCSelectButtonTableCellViewTypeBuildAndUploa,
} ESCSelectButtonTableCellViewType;

static NSString *ESCSelectButtonTableCellViewId = @"ESCSelectButtonTableCellViewId";

@interface ESCSelectButtonTableCellView : NSTableCellView

@property(nonatomic,weak)id<ESCSelectButtonTableCellViewDelegate> delegate;

- (void)setModel:(id)model type:(ESCSelectButtonTableCellViewType)type;

@property(nonatomic,assign)int row;

@end

NS_ASSUME_NONNULL_END
