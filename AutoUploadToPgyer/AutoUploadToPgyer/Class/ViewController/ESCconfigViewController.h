//
//  ESCconfigViewController.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ESCConfigurationModel;

@interface ESCconfigViewController : NSViewController

@property(nonatomic,strong)ESCConfigurationModel* configurationModel;

@property(nonatomic,copy)void(^configCompleteBlock)(void);

@end
