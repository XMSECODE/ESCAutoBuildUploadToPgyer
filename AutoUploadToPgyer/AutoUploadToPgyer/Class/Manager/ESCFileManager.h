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

/// 文件夹中是否包含ipa文件
- (BOOL)isContainIPAFileWithDirPath:(NSString *)dirPath;

/**
 获取第一个文件夹里最新ipa文件属性
 */
- (void)getLatestIPAFileInfoWithConfigurationModel:(ESCConfigurationModel *)model;

- (NSDictionary *)getAppInfoWithIPAFilePath:(NSString *)ipaFilePath;

/**
 写入日志
 */
- (void)wirteLogToFileWith:(NSString *)logString withName:(NSString *)name withPath:(NSString *)path;

/// 获取文件夹下所有文件大小
+ (int64_t)getDirectorySize:(NSString *)dirPath;

@end
