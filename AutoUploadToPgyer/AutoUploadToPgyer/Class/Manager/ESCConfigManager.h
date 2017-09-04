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

@property(nonatomic,strong)ESCConfigurationModel* firstConfigurationModel;

@property(nonatomic,strong)ESCConfigurationModel* secondConfigurationModel;

+ (instancetype)sharedConfigManager;

@end
