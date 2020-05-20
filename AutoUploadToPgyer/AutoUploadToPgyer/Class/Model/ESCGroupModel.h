//
//  ESCGroupModel.h
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/4/22.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCConfigurationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESCGroupModel : NSObject

@property(nonatomic,copy)NSString* name;

@property(nonatomic,assign)int index;

@property(nonatomic,assign)BOOL isShow;

@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,strong)NSArray<ESCConfigurationModel *>* configurationModelArray;

@property(nonatomic,strong)NSArray <ESCGroupModel *>* groupModelArray;

- (int)allShowCount;

- (int)allGroupShowCount;

- (NSArray <ESCGroupModel *>*)allShowGroupModelArray;

- (NSArray <ESCGroupModel *>*)allGroupModelArray;

/// 获取作为主页展示的model数组，按分组排序
- (NSArray *)getAllGroupModelAndAppModelToShowArray;

- (NSArray *)getAllGroupModelAndAppModelToArray;

- (NSArray <ESCConfigurationModel *>*)getAllAPPModelInGroup;

- (void)addGroupModel:(ESCGroupModel *)model;

- (int)getLevelWithGroupMdel:(ESCGroupModel *)groupModel;

- (ESCGroupModel *)getAppInGroupWithAPP:(ESCConfigurationModel *)configurationModel;

- (ESCGroupModel *)getGroupInWhatGroupWithGroup:(ESCGroupModel *)groupModel;

- (BOOL)isAllCreateIPAFile;

- (BOOL)isAllUploadIPAFile;

- (void)setAllCreateIPAFile:(BOOL)isCreateIPAFile;

- (void)setAllUploadIPAFile:(BOOL)isUploadIPAFile;

@end

NS_ASSUME_NONNULL_END
