//
//  ESCAppBundleIdAndProfileConfigViewController.h
//  iOSAutoBuildAndUpload
//
//  Created by xiangmingsheng on 2021/3/20.
//  Copyright © 2021 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ESCConfigurationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESCAppBundleIdAndProfileConfigViewController : NSViewController

@property(nonatomic,strong)ESCConfigurationModel* configurationModel;

@end

NS_ASSUME_NONNULL_END
