//
//  ESCNetWorkManager.h
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 02/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCNetWorkManager : NSObject

+ (void)uploadToPgyerWithFilePath:(NSString *)filePath
                         progress:(void (^)(NSProgress * progress))cuploadProgress
                          success:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure;

@end
