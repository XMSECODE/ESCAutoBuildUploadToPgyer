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

static NSString *ESCUserDataKey = @"ESCUserDataKey";

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
    NSArray *temArray = [[NSUserDefaults standardUserDefaults] objectForKey:ESCUserDataKey];
    self.modelArray = [ESCConfigurationModel mj_objectArrayWithKeyValuesArray:temArray];
}

- (void)saveUserData {
    NSMutableArray *temArray = [NSMutableArray array];
    for (ESCConfigurationModel *model in self.modelArray) {
        NSDictionary *dict = [[model mj_keyValues] copy];
        [temArray addObject:dict];
    }
    [[NSUserDefaults standardUserDefaults] setObject:temArray forKey:ESCUserDataKey];
}

- (void)setModelArray:(NSArray<ESCConfigurationModel *> *)modelArray {
    _modelArray = modelArray;
    [self saveUserData];
}

@end
