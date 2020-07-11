//
//  ESCBuildModel.h
//  iOSAutoBuildAndUpload
//
//  Created by xiangmingsheng on 2020/7/11.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESCBuildModel : NSObject

@property(nonatomic,copy)NSString* shellFilePath;

@property(nonatomic,copy)NSString* archiveFilePath;

@property(nonatomic,copy)NSString* ipaDirPath;

@end

NS_ASSUME_NONNULL_END
