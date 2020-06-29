//
//  FFArchiveFIleCopyTool.m
//  FFArchive
//
//  Created by xiang on 2020/4/21.
//  Copyright © 2020 xiang. All rights reserved.
//

#import "ESCFileCopyTool.h"

@implementation ESCFileCopyTool

+ (void)removeDirFileWithDirPath:(NSString *)dirPath {
    [ESCFileCopyTool scanDirAllFileWithDirPath:dirPath callBack:^(NSString *filePath) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"%@=%@",filePath,error);
        }
    }];
}

+ (void)scanDirAllFileWithDirPath:(NSString *)dirPath
                         callBack:(ScanFileCallBackBlock)callBackBlock {
    NSMutableArray *fileArray = [NSMutableArray array];
    [self scanDirWithDirPath:dirPath resultFileArray:fileArray];
    //    NSLog(@"%@",fileArray);
    //    NSLog(@"%ld",fileArray.count);
    for (int i = 0; i < fileArray.count; i++) {
        NSString *filePath = fileArray[i];
        callBackBlock(filePath);
    }
}

+ (void)scanDirWithDirPath:(NSString *)directoryPath resultFileArray:(NSMutableArray *)resultFileArray {
    
    NSError *error;
    NSArray *temArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    if (temArray.count == 0) {
        [resultFileArray addObject:directoryPath];
        return;
    }
    for (NSString *fileString in temArray) {
        BOOL isDirectory = NO;
        NSString *temfile = [NSString stringWithFormat:@"%@/%@",directoryPath,fileString];
        if ([[NSFileManager defaultManager] fileExistsAtPath:temfile isDirectory:&isDirectory]) {
            if (isDirectory == YES) {
                [self scanDirWithDirPath:temfile resultFileArray:resultFileArray];
            }else {
                [resultFileArray addObject:temfile];
            }
        }
    }
    [resultFileArray addObject:directoryPath];
}

+ (void)replaceFileContentOfStringWithFilePath:(NSString *)filePath
                                     oldString:(NSString *)oldString
                                     newString:(NSString *)newString {
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *content_copy = [content mutableCopy];
    
    int count = (int)[content_copy replaceOccurrencesOfString:oldString withString:newString options:0 range:NSMakeRange(0, content.length)];
    NSLog(@"字符串替换==文件路径：%@===旧字符串：%@====新字符串：%@====替换次数：%d",filePath,oldString,newString,count);
    
    [content_copy writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
