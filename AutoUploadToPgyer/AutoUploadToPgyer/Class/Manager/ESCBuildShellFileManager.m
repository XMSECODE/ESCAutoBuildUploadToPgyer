//
//  ESCBuildShellFileManager.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCBuildShellFileManager.h"
#import "ESCConfigurationModel.h"

@implementation ESCBuildShellFileManager

+ (NSString *)writeShellFileWithConfigurationModel:(ESCConfigurationModel *)configurationModel {
    return [self writeProjectShellFileWithConfigurationModel:configurationModel];
}

+ (NSString *)writeProjectShellFileWithConfigurationModel:(ESCConfigurationModel *)configurationModel {
    
    NSString *projectPath = configurationModel.projectPath;
    
    NSString *ipaPath = configurationModel.ipaPath;

    NSString *projectTypeString;
    if (configurationModel.projectType == ESCXCodeProjectTypeProj) {
        projectTypeString = @"project";
    }else {
        projectTypeString = @"workspace";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *projectName = [configurationModel projectName];
    
    NSString *archiveFilePath = [NSString stringWithFormat:@"%@/%@/%@.xcarchive",ipaPath,dateString,projectName];
    
    NSString *ipaFilePath = [NSString stringWithFormat:@"%@/%@",ipaPath,dateString];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"buildinfo.plist" ofType:nil];
    
    NSString *archiveShellString = [NSString stringWithFormat:@"\"$(xcodebuild archive -%@ %@ -scheme %@ -archivePath %@)\"",projectTypeString,projectPath,configurationModel.schemes,archiveFilePath];
    
    NSString *exportArchiveShellString = [NSString stringWithFormat:@"\"$(xcodebuild -exportArchive -archivePath %@ -exportPath %@ -exportOptionsPlist %@)\"",archiveFilePath,ipaFilePath,plistPath];

    
    NSString *shellString = [NSString stringWithFormat:@"#!/bin/sh\n\n%@\n\n%@\n",archiveShellString,exportArchiveShellString];

    NSError *error;
    NSString *temShellPath = [NSString stringWithFormat:@"%@/tem.sh",ipaPath];
    [shellString writeToFile:temShellPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSString *getauto = [NSString stringWithFormat:@"chmod a+x %@",temShellPath];
    system(getauto.UTF8String);
    if (error) {
        return nil;
    }else {
        return temShellPath;
    }
}

@end
