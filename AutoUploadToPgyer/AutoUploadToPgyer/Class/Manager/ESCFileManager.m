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
#import "ESCConfigurationModel.h"
#import "NSDate+ESCDateString.h"

@interface ESCFileManager ()

@property(nonatomic,strong)NSDateFormatter* dateFormatter;

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
- (NSString *)getLatestIPAFilePathFromWithConfigurationModel:(ESCConfigurationModel *)model {
    NSString *path = model.ipaPath;
    NSArray *ipaArray = [self getAllIPAinDirectoryPath:path];
    NSString *filePath = [self getLatestIPAFilePath:ipaArray];
    return filePath;
}

- (void)getLatestIPAFileInfoWithConfigurationModel:(ESCConfigurationModel *)model {
    model.ipaName = [[NSFileManager defaultManager] displayNameAtPath:[self getLatestIPAFilePathFromWithConfigurationModel:model]];
    NSDictionary *infoDicture = [[ESCFileManager sharedFileManager] getLatestIPAFileInfoFromDirectoryWithConfigurationModel:model];
    NSDate *date = [infoDicture objectForKey:NSFileCreationDate];
    model.createDateString = [self.dateFormatter stringFromDate:date];
    model.offTime = [date getOffTime];
    float firstSize = [[infoDicture objectForKey:NSFileSize] floatValue] / 1024 / 1024;
    model.sizeString = [NSString stringWithFormat:@"%.2lfM",firstSize];
}

- (NSDictionary *)getLatestIPAFileInfoFromDirectoryWithConfigurationModel:(ESCConfigurationModel *)model {
    NSString *filePath = [self getLatestIPAFilePathFromWithConfigurationModel:model];
    NSError *error;
    NSDictionary *attributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"get ipa attributes error === %@ ===\n==%@",error,filePath);
        return nil;
    }else {
        return attributesDict;
    }
}

- (void)wirteLogToFileWith:(NSString *)logString withName:(NSString *)name withPath:(NSString *)path{
    NSError *error;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt",path,name];
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

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }
    return _dateFormatter;
}
@end
