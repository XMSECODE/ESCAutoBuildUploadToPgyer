//
//  ESCConfigurationModel.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ESCXCodeProjectType) {
    ESCXCodeProjectTypeProj,
    ESCXCodeProjectTypeWorkspace,
};

typedef NS_ENUM(NSUInteger, ESCXcodeBuildConfiguration) {
    ESCXcodeBuildConfigurationDebug,
    ESCXcodeBuildConfigurationRelease,
};

@interface ESCConfigurationModel : NSObject

@property(nonatomic,copy)NSString* projectPath;

@property(nonatomic,copy)NSString* temPath;

@property(nonatomic,copy)NSString* ipaPath;

@property(nonatomic,copy)NSString* schemes;

@property(nonatomic,assign)ESCXCodeProjectType projectType;

@property(nonatomic,assign)ESCXcodeBuildConfiguration configuration;

@property(nonatomic,copy)NSString* appName;


@end
