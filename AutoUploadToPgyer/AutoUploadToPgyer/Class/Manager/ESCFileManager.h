//
//  ESCFileManager.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 02/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESCConfigurationModel;

@interface ESCFileManager : NSObject

+ (instancetype)sharedFileManager;

/**
 获取文件夹里最新api路径
 */
- (NSString *)getLatestIPAFilePathFromWithConfigurationModel:(ESCConfigurationModel *)model;

/**
 获取第一个文件夹里最新ipa文件属性
 */
- (void)getLatestIPAFileInfoWithConfigurationModel:(ESCConfigurationModel *)model;

/**
 写入日志
 */
- (void)wirteLogToFileWith:(NSString *)logString withName:(NSString *)name;

@end
