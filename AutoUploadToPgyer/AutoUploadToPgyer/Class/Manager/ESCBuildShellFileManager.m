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
    if (configurationModel.projectType == ESCXCodeProjectTypeProj) {
        return [self writeProjectShellFileWithConfigurationModel:configurationModel];
    }else {
        return [self writeWorkSpaceShellFileWithConfigurationModel:configurationModel];
    }
}

+ (NSString *)writeProjectShellFileWithConfigurationModel:(ESCConfigurationModel *)configurationModel {
    
    NSURL *filePathURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/temBuild.sh",configurationModel.temPath]];
    
    
    NSURL *projectPathURL = [NSURL URLWithString:configurationModel.projectPath];
    NSString *projectPath = projectPathURL.path;
    
    NSString *shellPath = filePathURL.path.stringByDeletingLastPathComponent;
    
    NSURL *ipaPathURL = [NSURL URLWithString:configurationModel.ipaPath];
    NSString *ipaPath = ipaPathURL.path;
    
    NSString *shellString = [NSString stringWithFormat:@"#!/bin/sh\n\
                             echo \"==============start=========\"\n\
                             \n\
                             todayTime=$(%@)\n\
                             echo $todayTime\n\
                             \n\
                             appName=\"%@\"\n\
                             projectPath=\"%@\"\n\
                             shellPath=\"%@\"\n\
                             resultipaPath=\"%@\"\n\
                             \n\
                             \n\
                             rmobuild=\"rm -fr ${shellPath}/build\"\n\
                             echo \"$($rmobuild)\"\n\
                             \n\
                             echo \"$(cd %@;clear;pwd;xcodebuild)\"\n\
                             \n\
                             copyPath=\"${projectPath}/build\"\n\
                             copyd=\"cp -R ${copyPath} %@\"\n\
                             echo \"$($copyd)\"\n\
                             \n\
                             ipad=\"xcrun -sdk iphoneos PackageApplication -v ${shellPath}/build/Release-iphoneos/${appName}.app -o ${resultipaPath}/${todayTime}-${appName}.ipa\"\n\
                             echo $ipad\n\
                             echo \"$($ipad)\"\n\
                             \n\
                             rmprojectbuild=\"rm -rf ${projectPath}/build\"\n\
                             echo \"$($rmprojectbuild)\"\n\
                             \n\
                             \n\
                             echo \"=============end================\"\n",@"date -v -0d +%Y-%m-%d-%H-%M-%S",configurationModel.appName,projectPath,shellPath,ipaPath,projectPath,shellPath];
    


    NSError *error;
    [shellString writeToURL:filePathURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSString *getauto = [NSString stringWithFormat:@"chmod a+x %@",filePathURL.path];
    system(getauto.UTF8String);
    if (error) {
        return nil;
    }else {
        return filePathURL.path;
    }
}

+ (NSString *)writeWorkSpaceShellFileWithConfigurationModel:(ESCConfigurationModel *)configurationModel {
    NSURL *filePathURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/temBuild.sh",configurationModel.temPath]];
    
    NSURL *projectPathURL = [NSURL URLWithString:configurationModel.projectPath];
    NSString *projectPath = projectPathURL.path;
    
    NSString *shellPath = filePathURL.path.stringByDeletingLastPathComponent;
    
    NSURL *ipaPathURL = [NSURL URLWithString:configurationModel.ipaPath];
    NSString *ipaPath = ipaPathURL.path;
    
    NSString *appName = configurationModel.appName;
    NSString *scheme = configurationModel.schemes;
    NSString *projectName = configurationModel.projectName;
    
    NSString *shellString = [NSString stringWithFormat:@"#!/bin/sh\n\
                             echo \"==========\"\n\
                             \n\
                             \n\
                             todayTime=$(%@)\n\
                             echo $todayTime\n\
                             \n\
                             appName=\"%@\"\n\
                             projectName=\"%@.xcworkspace\"\n\
                             scheme=\"%@\"\n\
                             projectPath=\"%@\"\n\
                             shellPath=\"%@\"\n\
                             resultipaPath=\"%@\"\n\
                             \n\
                             rmobuild=\"rm -fr ${shellPath}/build\"\n\
                             echo \"$($rmobuild)\"\n\
                             \n\
                             workspacepath=\"xcodebuild -workspace ${projectPath}/${projectName} -scheme ${scheme} -configuration Release -derivedDataPath ${shellPath}\"\n\
                             echo $workspacepath\n\
                             echo \"$($workspacepath)\"\n\
                             \n\
                             copyPath=\"${projectPath}/build\"\n\
                             copyd=\"cp -R ${copyPath} ${shellPath}/build\"\n\
                             echo \"$($copyd)\"\n\
                             \n\
                             ipad=\"xcrun -sdk iphoneos PackageApplication -v ${shellPath}/Build/Products/Release-iphoneos/${appName}.app -o ${resultipaPath}/${todayTime}-${appName}.ipa\"\n\
                             echo $ipad\n\
                             echo \"$($ipad)\"\n\
                             \n\
                             rmprojectbuild=\"rm -rf ${projectPath}/build\"\n\
                             echo \"$($rmprojectbuild)\"",@"date -v -0d +%Y-%m-%d-%H-%M-%S",appName,projectName,scheme,projectPath,shellPath,ipaPath];
    
    NSError *error;
    [shellString writeToURL:filePathURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSString *getauto = [NSString stringWithFormat:@"chmod a+x %@",filePathURL.path];
    system(getauto.UTF8String);
    return @"/Users/xiang/个人资料/tem_IPA/xlb_test.sh";
    if (error) {
        return nil;
    }else {
        return filePathURL.path;
    }

    return nil;
}

@end
