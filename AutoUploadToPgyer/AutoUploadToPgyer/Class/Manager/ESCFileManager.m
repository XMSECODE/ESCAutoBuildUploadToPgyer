//
//  ESCFileManager.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 02/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCFileManager.h"
#import "ESCHeader.h"
#import "MJExtension.h"

@interface ESCFileManager ()

@end

static ESCFileManager *staticESCFileManager;

@implementation ESCFileManager

+ (instancetype)sharedFileManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticESCFileManager = [[ESCFileManager alloc] init];
    });
    return staticESCFileManager;
}


#pragma mark - public
- (NSData *)getFirstDirectoryNewVersionIPA {
    NSString *filePath = [self getLatestIPAFilePathFromFirstDirectory];
    NSData *firstIPAData = [[NSData alloc] initWithContentsOfFile:filePath];
    return firstIPAData;
}

- (NSDictionary *)getLatestIPAFileInfoFromFirstDirectory {
    NSString *filePath = [self getLatestIPAFilePathFromFirstDirectory];
    NSError *error;
    NSDictionary *attributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"get first ipa attributes error %@",error);
        return nil;
    }else {
        return attributesDict;
    }
}

- (NSString *)getLatestIPAFilePathFromFirstDirectory {
    NSArray *ipaArray = [self getAllIPAinDirectoryPath:ESCfirstFileDirectoryPath];
    NSString *filePath = [self getLatestIPAFilePath:ipaArray];
    return filePath;
}

- (NSString *)getFirstIPADisplayName {
    return [[NSFileManager defaultManager] displayNameAtPath:[self getLatestIPAFilePathFromFirstDirectory]];
}

- (NSDictionary *)getLatestIPAFileInfoFromSecondDirectory {
    NSString *filePath = [self getLatestIPAFilePathFromSecondDirectory];
    NSError *error;
    NSDictionary *attributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"get first ipa attributes error %@",error);
        return nil;
    }else {
        return attributesDict;
    }
}

- (NSData *)getSecondDirectoryNewVersionIPA {
    NSString *filePath = [self getLatestIPAFilePathFromSecondDirectory];
    NSData *firstIPAData = [[NSData alloc] initWithContentsOfFile:filePath];
    return firstIPAData;
}

- (NSString *)getLatestIPAFilePathFromSecondDirectory {
    NSArray *ipaArray = [self getAllIPAinDirectoryPath:ESCsecondFileDirectoryPath];
    NSString *filePath = [self getLatestIPAFilePath:ipaArray];
    return filePath;
}

- (NSString *)getSecondIPADisplayName {
    return [[NSFileManager defaultManager] displayNameAtPath:[self getLatestIPAFilePathFromSecondDirectory]];
}

- (void)wirteLogToFileWith:(NSString *)logString withName:(NSString *)name{
    NSError *error;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt",ESCHistoryFileDirectoryPath,name];
    [logString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

#pragma mark - private
- (NSString *)getLatestIPAFilePath:(NSArray <NSString *>*)ipaPathArray {
    NSString *temFilePath = ipaPathArray.firstObject;
    for (NSString *filePath in ipaPathArray) {
        NSError *error;
        NSDictionary *attributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"get attributes error %@",error);
        }else {
            NSDictionary *temAttributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:temFilePath error:&error];
            if (error) {
                NSLog(@"get attributes error %@",error);
            }else {
                NSDate *fileDate = [attributesDict objectForKey:NSFileCreationDate];
                NSDate *temFileDate = [temAttributesDict objectForKey:NSFileCreationDate];
                NSComparisonResult result = [fileDate compare:temFileDate];
                if (result == NSOrderedDescending) {
                    temFilePath = filePath;
                }else {
                    
                }
            }
        }
        
    }
    return temFilePath;
}

- (NSArray <NSString *>*)getAllIPAinDirectoryPath:(NSString *)directoryPath {
    NSMutableArray *ipaArray = [NSMutableArray array];
    [self scanAllIPAFilePathWithDirectory:directoryPath resultArray:ipaArray];
    return ipaArray;
}

- (void)scanAllIPAFilePathWithDirectory:(NSString *)directoryPath resultArray:(NSMutableArray *)resultArray{
    NSError *error;
    NSArray *temArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    if (temArray.count == 0) {
        return;
    }
    for (NSString *fileString in temArray) {
        BOOL isDirectory = NO;
        NSString *temfile = [NSString stringWithFormat:@"%@/%@",directoryPath,fileString];
        if ([[NSFileManager defaultManager] fileExistsAtPath:temfile isDirectory:&isDirectory]) {
            if (isDirectory == YES) {
                [self scanAllIPAFilePathWithDirectory:temfile resultArray:resultArray];
            }else {
                if ([fileString containsString:@".ipa"]) {
                    [resultArray addObject:temfile];
                }
            }
        }
    }
    
    
}

@end
