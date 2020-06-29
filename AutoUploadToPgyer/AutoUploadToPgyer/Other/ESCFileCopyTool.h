//
//  FFArchiveFIleCopyTool.h
//  FFArchive
//
//  Created by xiang on 2020/4/21.
//  Copyright © 2020 xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ScanFileCallBackBlock)(NSString *filePath);


NS_ASSUME_NONNULL_BEGIN

@interface ESCFileCopyTool : NSObject

+ (void)removeDirFileWithDirPath:(NSString *)dirPath;

+ (void)scanDirAllFileWithDirPath:(NSString *)dirPath
                        callBack:(ScanFileCallBackBlock)callBackBlock;

+ (void)scanDirWithDirPath:(NSString *)directoryPath resultFileArray:(NSMutableArray *)resultFileArray;

+ (void)replaceFileContentOfStringWithFilePath:(NSString *)filePath
                                     oldString:(NSString *)oldString
                                     newString:(NSString *)newString;

@end

NS_ASSUME_NONNULL_END
