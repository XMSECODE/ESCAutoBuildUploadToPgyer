//
//  ESCBuildShellFileManager.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESCConfigurationModel;

@interface ESCBuildShellFileManager : NSObject

+ (NSString *)writeShellFileWithConfigurationModel:(ESCConfigurationModel *)configurationModel;

@end
