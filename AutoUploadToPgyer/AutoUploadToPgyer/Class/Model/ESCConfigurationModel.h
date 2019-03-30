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

@property (nonatomic, readonly,copy) NSString *historyLogPath;

@property(nonatomic,copy)NSString* schemes;

@property(nonatomic,assign)ESCXCodeProjectType projectType;

@property(nonatomic,assign)ESCXcodeBuildConfiguration configuration;

@property(nonatomic,copy)NSString* appName;
    
@property (nonatomic, copy) NSString *projectName;

@property(nonatomic,assign)BOOL isCreateIPA;

@property(nonatomic,assign)BOOL isUploadIPA;

@property(nonatomic,copy)NSString* escprojectName;

@property(nonatomic,copy)NSString* ipaName;

@property(nonatomic,copy)NSString* createDateString;

@property(nonatomic,copy)NSString* offTime;

@property(nonatomic,copy)NSString* sizeString;

@property(nonatomic,assign)CGFloat uploadProgress;

@property(nonatomic,copy)NSString* uploadState;

@property(nonatomic,copy)NSString* signingCertificate;

@end
