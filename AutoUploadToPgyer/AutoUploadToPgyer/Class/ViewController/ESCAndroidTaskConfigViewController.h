//
//  ESCAndroidTaskConfigViewController.h
//  iOSAutoBuildAndUpload
//
//  Created by apple on 2024/4/13.
//  Copyright © 2024 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ESCConfigurationModel;


@interface ESCAndroidTaskConfigViewController : NSViewController

@property(nonatomic,strong)ESCConfigurationModel* configurationModel;

@property(nonatomic,copy)void(^configCompleteBlock)(void);

@end

