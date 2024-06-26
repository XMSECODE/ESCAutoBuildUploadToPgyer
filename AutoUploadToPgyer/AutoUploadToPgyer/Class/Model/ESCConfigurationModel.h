//
//  ESCConfigurationModel.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ESCBundleIdModel.h"

typedef NS_ENUM(NSUInteger, ESCXCodeProjectType) {
    ESCXCodeProjectTypeProj,
    ESCXCodeProjectTypeWorkspace,
};

typedef NS_ENUM(NSUInteger, ESCXcodeBuildConfiguration) {
    ESCXcodeBuildConfigurationDebug,
    ESCXcodeBuildConfigurationRelease,
};

typedef NS_ENUM(NSUInteger, ESCXcodeMethod) {
    ESCXcodeMethod_adhoc,
    ESCXcodeMethod_appstore,
    ESCXcodeMethod_development
};

typedef NS_ENUM(NSUInteger, ESCTaskType) {
    ESCTaskType_iOS,
    ESCTaskType_android
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

@property(nonatomic,copy)NSString* bundleID;

@property(nonatomic,copy)NSString* appUdid;

@property (nonatomic, strong)NSArray <ESCBundleIdModel *>*bundleIdModelArray;

@property(nonatomic,weak)NSTableCellView* cellView;

@property(nonatomic,copy)NSString* provisioningProfileName;

//更新描述
@property(nonatomic,copy)NSString* buildUpdateDescription;

//是否保存更新描述字段
@property(nonatomic,assign)BOOL save_buildUpdateDescription;

@property(nonatomic,assign)int totalSize;

@property(nonatomic,assign)int sendSize;

@property (nonatomic, strong)NSMutableArray <NSDictionary *>*networkRecordArray;

@property(nonatomic,copy)NSString* networkRate;

//剩余时间
@property(nonatomic,assign)int needRemainTime;

//剩余时间
@property(nonatomic,copy)NSString *needRemainTimeString;

@property(nonatomic,assign)ESCXcodeMethod method;

@property(nonatomic,assign)ESCTaskType tastType;

///安卓的buildType（release、debug...）
@property(nonatomic,copy)NSString *android_buildType;

- (void)calculateNetWorkRate;

- (void)resetNetworkRate;

- (int64_t)getAllFileSize;


@end
