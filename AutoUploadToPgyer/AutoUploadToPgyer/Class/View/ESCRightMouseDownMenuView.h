//
//  ESCRightMouseDownMenuView.h
//  AutoUploadToPgyer
//
//  Created by xiang on 2019/5/9.
//  Copyright © 2019 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class ESCRightMouseDownMenuView;

@protocol ESCRightMouseDownMenuViewDelegate <NSObject>

- (void)ESCRightMouseDownMenuViewdidClickBuildButton:(ESCRightMouseDownMenuView *)view ;

- (void)ESCRightMouseDownMenuViewdidClickUploadButton:(ESCRightMouseDownMenuView *)view ;

- (void)ESCRightMouseDownMenuViewdidClickBuildAndUploadButton:(ESCRightMouseDownMenuView *)view ;

@end

@interface ESCRightMouseDownMenuView : NSView

@property(nonatomic,weak)id<ESCRightMouseDownMenuViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
