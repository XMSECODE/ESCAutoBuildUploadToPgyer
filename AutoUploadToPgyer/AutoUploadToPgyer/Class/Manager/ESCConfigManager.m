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

static NSString *ESCPgyerUKey = @"ESCPgyerUKey";
static NSString *ESCPgyerapi_key = @"ESCPgyerapi_key";
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
    
    self.api_k = [[NSUserDefaults standardUserDefaults] objectForKey:ESCPgyerapi_key];
    self.uKey = [[NSUserDefaults standardUserDefaults] objectForKey:ESCPgyerUKey];
}

- (void)sortWithLRUTypeWithModel:(ESCConfigurationModel *)model {
    NSInteger index = [self.modelArray indexOfObject:model];
    if (index != 0) {
        NSMutableArray *temArray = [NSMutableArray array];
        for (int i = 0; i < self.modelArray.count; i++) {
            if (i != index - 1 && i != index) {
                [temArray addObject:self.modelArray[i]];
            }else {
                [temArray addObject:model];
                [temArray addObject:self.modelArray[i]];
                i++;
            }
        }
        self.modelArray = temArray;
        [self saveUserData];
    }
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

- (void)setUKey:(NSString *)uKey {
    _uKey = [uKey copy];
    [[NSUserDefaults standardUserDefaults] setObject:_uKey forKey:ESCPgyerUKey];
}

- (void)setApi_k:(NSString *)api_k {
    _api_k = [api_k copy];
    [[NSUserDefaults standardUserDefaults] setObject:_api_k forKey:ESCPgyerapi_key];
}

@end
