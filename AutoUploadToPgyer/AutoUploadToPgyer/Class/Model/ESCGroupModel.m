//
//  ESCGroupModel.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/4/22.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCGroupModel.h"
#import "MJExtension.h"

@interface ESCGroupModel () <MJKeyValue>

@end

@implementation ESCGroupModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"configurationModelArray":@"ESCConfigurationModel",
             @"groupModelArray":@"ESCGroupModel"
    };
}

- (int)allShowCount {
    int count = [self getShowCountWithLevel:0];
    return count;
}

- (int)getShowCountWithLevel:(int)level {
    int count = 1;
    if (self.isShow == YES || level == 0) {
        count += self.configurationModelArray.count;
        for (ESCGroupModel *groupModel in self.groupModelArray) {
            count += [groupModel getShowCountWithLevel:level + 1];
        }
    }
    return count;
}

- (int)allGroupShowCount {
    return [self getAllGroupShowCountWithLevel:0];
}

- (int)getAllGroupShowCountWithLevel:(int)level {
    int count = 1;
    if (self.isShow == YES || level == 0) {
        for (ESCGroupModel *groupModel in self.groupModelArray) {
            count += [groupModel getShowCountWithLevel:level + 1];
        }
    }
    return count;
}

- (NSArray <ESCGroupModel *>*)allShowGroupModelArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    [self getAllShowGroupModelArrayWithLevel:0 resultArray:resultArray];
    return resultArray;
}

- (void)getAllShowGroupModelArrayWithLevel:(int)level resultArray:(NSMutableArray *)array {
    if (array == nil) {
        return;
    }
    if (self.isShow == YES || level == 0) {
        if (self.groupModelArray != nil) {
            for (ESCGroupModel *groupModel in self.groupModelArray) {
                [array addObject:groupModel];
                [groupModel getAllShowGroupModelArrayWithLevel:level + 1 resultArray:array];
            }
        }
    }
    return;
}

- (NSArray <ESCGroupModel *>*)allGroupModelArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    [self getAllGroupModelArrayWithLevel:0 resultArray:resultArray];
    return resultArray;
}

- (void)getAllGroupModelArrayWithLevel:(int)level resultArray:(NSMutableArray *)array {
    if (array == nil) {
        return;
    }
    if (self.groupModelArray != nil) {
        for (ESCGroupModel *groupModel in self.groupModelArray) {
            [array addObject:groupModel];
            [groupModel getAllGroupModelArrayWithLevel:level + 1 resultArray:array];
        }
    }
}

/// 获取作为主页展示的model数组，按分组排序
- (NSArray *)getAllGroupModelAndAppModelToShowArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    [self getAllGroupModelAndAppModelToShowArrayWithArray:resultArray level:0];
    return [resultArray copy];
}

- (void)getAllGroupModelAndAppModelToShowArrayWithArray:(NSMutableArray *)array level:(int)level {
    if (self.groupModelArray && self.groupModelArray.count > 0 && ((self.isShow == NO && level ==0) || self.isShow == YES)) {
        for (int i = 0; i < self.groupModelArray.count; i++) {
            ESCGroupModel *groupModel = [self.groupModelArray objectAtIndex:i];
            [array addObject:groupModel];
            [groupModel getAllGroupModelAndAppModelToShowArrayWithArray:array level:level + 1];
        }
    }
    if (self.isShow == YES || level == 0) {
        if (self.configurationModelArray.count > 0) {
            [array addObjectsFromArray:self.configurationModelArray];
        }
    }
}

- (void)addGroupModel:(ESCGroupModel *)model {
    NSMutableArray *temArray = [self.groupModelArray mutableCopy];
    if (temArray == nil) {
        temArray = [NSMutableArray array];
    }
    [temArray addObject:model];
    self.groupModelArray = temArray;
}

- (int)getLevelWithGroupMdel:(ESCGroupModel *)groupModel {
    return [self chekGroupModelLevel:groupModel currentLevel:0];
}

- (ESCGroupModel *)getAppInGroupWithAPP:(ESCConfigurationModel *)configurationModel {
    NSArray *modelArray = [self allGroupModelArray];
    for (ESCGroupModel *model in modelArray) {
        if (model.configurationModelArray != nil) {
            for (ESCConfigurationModel *appModel in model.configurationModelArray) {
                if ([appModel.appUdid isEqualToString:configurationModel.appUdid]) {
                    return model;
                }
            }
        }
    }
    return nil;
}

- (ESCGroupModel *)getGroupInWhatGroupWithGroup:(ESCGroupModel *)groupModel {
    NSArray *modelArray = [self allGroupModelArray];
    for (ESCGroupModel *model in modelArray) {
        if (model.groupModelArray != nil) {
            for (ESCGroupModel *groupModel1 in model.groupModelArray) {
                if ([groupModel isEqual:groupModel1]) {
                    return model;
                }
            }
        }
    }
    return nil;
}

- (int)chekGroupModelLevel:(ESCGroupModel *)groupModel currentLevel:(int)currentLevel {
    if (self.groupModelArray != nil) {
        for (ESCGroupModel *model in self.groupModelArray) {
            if ([model isEqual:groupModel]) {
                return currentLevel + 1;
            }else {
                int level = [model chekGroupModelLevel:groupModel currentLevel:currentLevel + 1];
                if (level == -1) {
                    continue;
                }else {
                    return level;
                }
            }
        }
    }
    return -1;
}

- (BOOL)isAllCreateIPAFile {
    NSArray *modelArray = [self getAllGroupModelAndAppModelToArray];
    for (id model in modelArray) {
        if ([model isKindOfClass:[ESCConfigurationModel class]]) {
            ESCConfigurationModel *configurationModel = model;
            if (configurationModel.isCreateIPA == NO) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)isAllUploadIPAFile {
    NSArray *modelArray = [self getAllGroupModelAndAppModelToArray];
    for (id model in modelArray) {
        if ([model isKindOfClass:[ESCConfigurationModel class]]) {
            ESCConfigurationModel *configurationModel = model;
            if (configurationModel.isUploadIPA == NO) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)setAllCreateIPAFile:(BOOL)isCreateIPAFile {
    NSArray *modelArray = [self getAllGroupModelAndAppModelToArray];
    for (id model in modelArray) {
        if ([model isKindOfClass:[ESCConfigurationModel class]]) {
            ESCConfigurationModel *configurationModel = model;
            configurationModel.isCreateIPA = isCreateIPAFile;
        }
    }
}

- (void)setAllUploadIPAFile:(BOOL)isUploadIPAFile {
    NSArray *modelArray = [self getAllGroupModelAndAppModelToArray];
    for (id model in modelArray) {
        if ([model isKindOfClass:[ESCConfigurationModel class]]) {
            ESCConfigurationModel *configurationModel = model;
            configurationModel.isUploadIPA = isUploadIPAFile;
        }
    }
}


- (NSArray *)getAllGroupModelAndAppModelToArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    [self getAllGroupModelAndAppModelToArrayWithArray:resultArray level:0];
    return [resultArray copy];
}

- (void)getAllGroupModelAndAppModelToArrayWithArray:(NSMutableArray *)array level:(int)level {
    if (self.groupModelArray && self.groupModelArray.count > 0) {
        for (int i = 0; i < self.groupModelArray.count; i++) {
            ESCGroupModel *groupModel = [self.groupModelArray objectAtIndex:i];
            [array addObject:groupModel];
            [groupModel getAllGroupModelAndAppModelToArrayWithArray:array level:level + 1];
        }
    }
    
    if (self.configurationModelArray.count > 0) {
        [array addObjectsFromArray:self.configurationModelArray];
    }
}

- (NSArray <ESCConfigurationModel *>*)getAllAPPModelInGroup {
    NSMutableArray *temArray = [NSMutableArray array];
    [self getAllAPPModelInGroupWithArray:temArray];
    return [temArray copy];
}

- (void)getAllAPPModelInGroupWithArray:(NSMutableArray *)array {
    if (self.groupModelArray && self.groupModelArray.count > 0) {
        for (int i = 0; i < self.groupModelArray.count; i++) {
            ESCGroupModel *groupModel = [self.groupModelArray objectAtIndex:i];
            [groupModel getAllAPPModelInGroupWithArray:array];
        }
    }
    
    if (self.configurationModelArray.count > 0) {
        [array addObjectsFromArray:self.configurationModelArray];
    }
}

@end
