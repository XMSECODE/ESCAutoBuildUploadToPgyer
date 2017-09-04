//
//  ESCConfigManager.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCConfigManager.h"
#import "MJExtension.h"
#import "ESCConfigurationModel.h"

static NSString *firstConfiguration = @"firstConfiguration";
static NSString *secondConfiguration = @"secondConfiguration";

@interface ESCConfigManager ()

@end

static ESCConfigManager *staticESCConfigManager;

@implementation ESCConfigManager

+ (instancetype)sharedConfigManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticESCConfigManager = [[ESCConfigManager alloc] init];
        [staticESCConfigManager readConfigData];
    });
    return staticESCConfigManager;
}

- (void)readConfigData {
    NSDictionary *firstDict = [[NSUserDefaults standardUserDefaults] objectForKey:firstConfiguration];
    self.firstConfigurationModel = [ESCConfigurationModel mj_objectWithKeyValues:firstDict];
    
    NSDictionary *secondDict = [[NSUserDefaults standardUserDefaults] objectForKey:secondConfiguration];
    self.secondConfigurationModel = [ESCConfigurationModel mj_objectWithKeyValues:secondDict];
}

- (void)setFirstConfigurationModel:(ESCConfigurationModel *)firstConfigurationModel {
    _firstConfigurationModel = firstConfigurationModel;
    NSDictionary *dict = [[firstConfigurationModel mj_keyValues] copy];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:firstConfiguration];
}

- (void)setSecondConfigurationModel:(ESCConfigurationModel *)secondConfigurationModel {
    _secondConfigurationModel = secondConfigurationModel;
    NSDictionary *dict = [[secondConfigurationModel mj_keyValues] copy];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:secondConfiguration];
}

@end
