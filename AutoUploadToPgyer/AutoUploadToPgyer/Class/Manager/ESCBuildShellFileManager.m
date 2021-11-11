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

+ (ESCBuildModel *)writeShellFileWithConfigurationModel:(ESCConfigurationModel *)configurationModel {
    return [self writeProjectShellFileWithConfigurationModel:configurationModel];
}

+ (ESCBuildModel *)writeProjectShellFileWithConfigurationModel:(ESCConfigurationModel *)configurationModel {
    
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
    
    NSString *plistPath = [self createBuildinfoWithConfigurationModel:configurationModel];
    
    NSString *archiveShellString = [NSString stringWithFormat:@"\"$(xcodebuild archive -%@ %@ -scheme %@ -archivePath %@)\"",projectTypeString,projectPath,configurationModel.schemes,archiveFilePath];
    
    NSString *exportArchiveShellString = [NSString stringWithFormat:@"\"$(xcodebuild -exportArchive -archivePath %@ -exportPath %@ -exportOptionsPlist %@ -allowProvisioningUpdates)\"",archiveFilePath,ipaFilePath,plistPath];
    
    
    NSString *shellString = [NSString stringWithFormat:@"#!/bin/sh\n\n%@\n\n%@\n",archiveShellString,exportArchiveShellString];
    
    NSError *error;
    NSString *temShellPath = [NSString stringWithFormat:@"%@/tem.sh",ipaPath];
    [shellString writeToFile:temShellPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSString *getauto = [NSString stringWithFormat:@"chmod a+x %@",temShellPath];
    system(getauto.UTF8String);
    if (error) {
        return nil;
    }else {
        ESCBuildModel *model = [[ESCBuildModel alloc] init];
        model.shellFilePath = temShellPath;
        model.archiveFilePath = archiveFilePath;
        model.ipaDirPath = ipaFilePath;
        return model;
    }
}

+ (NSString *)createBuildinfoWithConfigurationModel:(ESCConfigurationModel *)configurationModel {
    //provisioningProfiles
    NSMutableDictionary *dict = [@{@"method":@"ad-hoc",
                                  @"compileBitcode":@(NO)
    } mutableCopy];
    
    if (configurationModel.method == ESCXcodeMethod_adhoc) {
        [dict setObject:@"ad-hoc" forKey:@"method"];
    }else if (configurationModel.method == ESCXcodeMethod_appstore) {
        [dict setObject:@"app-store" forKey:@"method"];
    }else {
        [dict setObject:@"development" forKey:@"method"];
    }
    
    
    if (configurationModel.signingCertificate != nil && configurationModel.signingCertificate.length > 0) {
        [dict setObject:@"signingCertificate" forKey:configurationModel.signingCertificate];
    }
    NSMutableDictionary *provisionDic = [NSMutableDictionary dictionary];
    if (configurationModel.bundleID != nil && configurationModel.bundleID.length > 0 &&
        configurationModel.provisioningProfileName != nil && configurationModel.provisioningProfileName.length > 0) {
//        NSDictionary *provisionDic = @{configurationModel.bundleID:configurationModel.provisioningProfileName};
        [provisionDic setValue:configurationModel.provisioningProfileName forKey:configurationModel.bundleID];
        
    }
    if (configurationModel.bundleIdModelArray) {
        for (ESCBundleIdModel *model in configurationModel.bundleIdModelArray) {
            [provisionDic setValue:model.profileName forKey:model.bundleId];
        }
    }
    [dict setObject:provisionDic forKey:@"provisioningProfiles"];
    NSString *temPlistPath = [NSString stringWithFormat:@"%@/buildinfo.plist",configurationModel.ipaPath];
    [dict writeToFile:temPlistPath atomically:YES];
    return temPlistPath;
}

@end
