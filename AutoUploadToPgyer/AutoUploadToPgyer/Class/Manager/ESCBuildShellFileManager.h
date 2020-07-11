//
//  ESCBuildShellFileManager.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCBuildModel.h"

@class ESCConfigurationModel;

@interface ESCBuildShellFileManager : NSObject

+ (ESCBuildModel *)writeShellFileWithConfigurationModel:(ESCConfigurationModel *)configurationModel;

@end
