//
//  ESCConfigManager.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESCConfigurationModel;

@interface ESCConfigManager : NSObject

@property(nonatomic,strong)NSArray <ESCConfigurationModel *>* modelArray;

@property (nonatomic, copy) NSString *api_k;

@property (nonatomic, copy) NSString *uKey;

@property(nonatomic,copy)NSString* password;

@property(nonatomic,copy)NSString* custom_shell_content;


- (void)sortWithLRUTypeWithModel:(ESCConfigurationModel *)model;

+ (instancetype)sharedConfigManager;

- (void)saveUserData;

@end
