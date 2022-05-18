//
//  ESCConfigManager.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCGroupModel.h"

@class ESCConfigurationModel;

@interface ESCConfigManager : NSObject

@property(nonatomic,strong)ESCGroupModel* groupModel;



@property (nonatomic, copy) NSString *api_k;

@property (nonatomic, copy) NSString *uKey;

@property(nonatomic,copy)NSString* firim_api_token;

//0:蒲公英 1:fir.im
@property(nonatomic,assign)int uploadType;
//0:串行编译，1并行编译
@property(nonatomic,assign)int buildType;

@property(nonatomic,copy)NSString* password;

@property(nonatomic,copy)NSString* custom_shell_content;

- (void)sortWithLRUTypeWithModel:(ESCConfigurationModel *)model;

+ (instancetype)sharedConfigManager;

- (NSDictionary *)getUserData;

- (void)saveUserData;

- (int)getGroupLevelWithGroupModel:(ESCGroupModel *)groupModel;

- (void)addGroupModel:(ESCGroupModel *)groupModel;

- (void)removeAllBuildHistoryFile;

/// 获取所有编译文件大小
- (int)getAllBuildFileTotalSize;

@end
