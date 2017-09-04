//
//  ESCFileManager.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 02/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCFileManager : NSObject

+ (instancetype)sharedFileManager;

/**
 获取第一个文件夹里最新api路径
 */
- (NSString *)getLatestIPAFilePathFromFirstDirectory;

/**
 获取第一个文件夹里最新ipa文件属性
 */
- (NSDictionary *)getLatestIPAFileInfoFromFirstDirectory;

/**
 获取第一个文件夹里最新ipa二进制文件
 */
- (NSData *)getFirstDirectoryNewVersionIPA;

/**
 获取第一个文件夹里最新ipa文件名
 */
- (NSString *)getFirstIPADisplayName;

/**
 获取第二个文件夹里最新api路径
 */
- (NSString *)getLatestIPAFilePathFromSecondDirectory;

/**
 获取第二个文件夹里最新ipa文件属性
 */
- (NSDictionary *)getLatestIPAFileInfoFromSecondDirectory;

/**
 获取第二个文件夹里最新ipa二进制文件
 */
- (NSData *)getSecondDirectoryNewVersionIPA;

/**
 获取第二个文件夹里最新ipa文件名
 */
- (NSString *)getSecondIPADisplayName;

/**
 写入日志
 */
- (void)wirteLogToFileWith:(NSString *)logString withName:(NSString *)name;

@end
