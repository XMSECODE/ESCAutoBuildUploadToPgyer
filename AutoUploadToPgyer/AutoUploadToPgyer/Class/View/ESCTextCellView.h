//
//  ESCTextCellView.h
//  iOSAutoBuildAndUpload
//
//  Created by xiangmingsheng on 2021/3/20.
//  Copyright © 2021 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ESCBundleIdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESCTextCellView : NSTableCellView

@property (nonatomic, strong)ESCBundleIdModel *model;

@property (nonatomic, assign)int type;

@end

NS_ASSUME_NONNULL_END
