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
#import "ESCFileCopyTool.h"

static NSString *ESCPgyerUKey = @"ESCPgyerUKey";
static NSString *ESCPgyerapi_key = @"ESCPgyerapi_key";
static NSString *ESCPgyerPassword_key = @"ESCPgyerPassword_key";
static NSString *ESCFirim_api_token_key = @"ESCFirim_api_token_key";
static NSString *ESC_upload_type_key = @"ESC_upload_type_key";
static NSString *ESCCustemShellContent_key = @"ESCCustemShellContent_key";
static NSString *ESCUserDataKey = @"ESCUserDataKey";
static NSString *ESCUserGroupDataKey = @"ESCUserGroupDataKey";

@interface ESCConfigManager ()

@property(nonatomic,strong)NSArray <ESCConfigurationModel *>* modelArray;
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
    
    NSDictionary *groupModelDic = [[NSUserDefaults standardUserDefaults] objectForKey:ESCUserGroupDataKey];
    self.groupModel = [ESCGroupModel mj_objectWithKeyValues:groupModelDic];
    if (self.groupModel == nil) {
        self.groupModel = [[ESCGroupModel alloc] init];
        self.groupModel.name = @"level_0_group";
        self.groupModel.configurationModelArray = self.modelArray;
        [self saveUserData];
    }
    
    self.api_k = [[NSUserDefaults standardUserDefaults] objectForKey:ESCPgyerapi_key];
    self.uKey = [[NSUserDefaults standardUserDefaults] objectForKey:ESCPgyerUKey];
    self.password = [[NSUserDefaults standardUserDefaults] objectForKey:ESCPgyerPassword_key];
    self.firim_api_token = [[NSUserDefaults standardUserDefaults] objectForKey:ESCFirim_api_token_key];
    self.custom_shell_content = [[NSUserDefaults standardUserDefaults] objectForKey:ESCCustemShellContent_key];
    self.uploadType = [[[NSUserDefaults standardUserDefaults] objectForKey:ESC_upload_type_key] intValue];

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
        model.cellView = nil;
        NSDictionary *dict = [[model mj_keyValues] copy];
        [temArray addObject:dict];
    }
    [[NSUserDefaults standardUserDefaults] setObject:temArray forKey:ESCUserDataKey];
    
    NSDictionary *dict = [self groupModelToDictionary:self.groupModel];
    if (dict != nil && dict.allKeys.count != 0) {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:ESCUserGroupDataKey];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ESCUserGroupDataKey];
    }
}

- (NSDictionary *)groupModelToDictionary:(ESCGroupModel *)model{
    if (model == nil) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (model.groupModelArray != nil) {
        NSMutableArray *groupModelArray = [NSMutableArray array];
        for (ESCGroupModel *groupModel in model.groupModelArray) {
            NSDictionary *groupDict = [self groupModelToDictionary:groupModel];
            [groupModelArray addObject:groupDict];
        }
        [dict setObject:groupModelArray forKey:@"groupModelArray"];
    }
    
    if (model.configurationModelArray != nil) {
        NSMutableArray *temArray = [NSMutableArray array];
        for (ESCConfigurationModel *configurationModel in model.configurationModelArray) {
            configurationModel.cellView = nil;
            NSDictionary *dict = [[configurationModel mj_keyValues] copy];
            [temArray addObject:dict];
        }
        [dict setObject:temArray forKey:@"configurationModelArray"];
    }
    if (model.name != nil) {
        [dict setObject:model.name forKey:@"name"];   
    }
    [dict setObject:@(model.index) forKey:@"index"];
    [dict setObject:@(model.isShow) forKey:@"isShow"];
    return dict;
}

- (void)removeAllBuildHistoryFile {
    NSArray *appModelArray = [self.groupModel getAllAPPModelInGroup];
    for (ESCConfigurationModel *model in appModelArray) {
        [self removeBuildHistoryFileWithWithConfigurationModel:model];
    }
}

- (void)removeBuildHistoryFileWithWithConfigurationModel:(ESCConfigurationModel *)configurationModel {
    NSString *ipaPath = [configurationModel ipaPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:ipaPath]) {
        //遍历删除
        [ESCFileCopyTool removeDirFileWithDirPath:ipaPath];
    }else {
        NSLog(@"文件夹不存在");
    }
}

- (void)setModelArray:(NSArray<ESCConfigurationModel *> *)modelArray {
    _modelArray = modelArray;
//    [self saveUserData];
}

- (void)setGroupModel:(ESCGroupModel *)groupModel {
    _groupModel = groupModel;
//    [self saveUserData];
}

- (void)setUKey:(NSString *)uKey {
    _uKey = [uKey copy];
    [[NSUserDefaults standardUserDefaults] setObject:_uKey forKey:ESCPgyerUKey];
}

- (void)setApi_k:(NSString *)api_k {
    _api_k = [api_k copy];
    [[NSUserDefaults standardUserDefaults] setObject:_api_k forKey:ESCPgyerapi_key];
}

- (void)setFirim_api_token:(NSString *)firim_api_token {
    _firim_api_token = [firim_api_token copy];
    [[NSUserDefaults standardUserDefaults] setObject:_firim_api_token forKey:ESCFirim_api_token_key];
}

- (void)setUploadType:(int)uploadType {
    _uploadType = uploadType;
    [[NSUserDefaults standardUserDefaults] setObject:@(_uploadType) forKey:ESC_upload_type_key];
}

- (void)setPassword:(NSString *)password {
    _password = [password copy];
    [[NSUserDefaults standardUserDefaults] setObject:_password forKey:ESCPgyerPassword_key];
}

- (void)setCustom_shell_content:(NSString *)custom_shell_content {
    _custom_shell_content = custom_shell_content;
    [[NSUserDefaults standardUserDefaults] setObject:_custom_shell_content forKey:ESCCustemShellContent_key];
}

- (int)getGroupLevelWithGroupModel:(ESCGroupModel *)groupModel {
    return [self.groupModel getLevelWithGroupMdel:groupModel];
}

@end
