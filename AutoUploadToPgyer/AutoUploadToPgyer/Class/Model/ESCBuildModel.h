//
//  ESCBuildModel.h
//  iOSAutoBuildAndUpload
//
//  Created by xiangmingsheng on 2020/7/11.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ESCBuildResultSuccess,  //编译成功
    ESCBuildResultBuildFailure, //编译失败
    ESCBuildResultExportIpafailure, //导出ipa文件失败
} ESCBuildResult;

@interface ESCBuildModel : NSObject

@property(nonatomic,copy)NSString* shellFilePath;

@property(nonatomic,copy)NSString* archiveFilePath;

@property(nonatomic,copy)NSString* ipaDirPath;

@property(nonatomic,assign)ESCBuildResult buildResult;

@end

NS_ASSUME_NONNULL_END
