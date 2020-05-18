//
//  ESCGroupTableCellView.h
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/4/24.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ESCGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ESCGroupTableGroupCellView;

@protocol ESCGroupTableGroupCellViewDelegate <NSObject>

- (void)ESCGroupTableGroupCellViewDidClickShowButton:(ESCGroupTableGroupCellView *)cellView;

@end

static NSString *ESCGroupTableGroupCellViewId = @"ESCGroupTableGroupCellViewId";

@interface ESCGroupTableGroupCellView : NSTableCellView

@property(nonatomic,weak)ESCGroupModel* groupModel;

@property(nonatomic,weak)id<ESCGroupTableGroupCellViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
