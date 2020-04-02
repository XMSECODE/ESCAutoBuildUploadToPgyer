//
//  ESCNetWorkManager.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 02/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCNetWorkManager.h"
#import "AFHTTPSessionManager.h"
#import "MJExtension.h"

NSString *ESCPgyerUploadIPAURLPath = @"https://qiniu-storage.pgyer.com/apiv1/app/upload";

@interface ESCNetWorkManager ()

@property(nonatomic,strong)AFHTTPSessionManager* httpSessionManager;

@end

static ESCNetWorkManager *staticNetWorkManager;

@implementation ESCNetWorkManager

+ (instancetype)sharedNetWorkManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticNetWorkManager = [[ESCNetWorkManager alloc] init];
    });
    return staticNetWorkManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.httpSessionManager = [[AFHTTPSessionManager alloc] init];
        self.httpSessionManager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
        [self.httpSessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    }
    return self;
}

+ (void)uploadToPgyerWithFilePath:(NSString *)filePath
                             uKey:(NSString *)uKey
                          api_key:(NSString *)api_key
                         password:(NSString *)password
                         progress:(void (^)(NSProgress * progress))cuploadProgress
                          success:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure{
    NSDictionary *pare = nil;
    if (password == nil || password.length <= 0) {
        pare = @{@"uKey":uKey,
                 @"_api_key":api_key,
                 @"installType":@"1",
                 @"updateDescription":@""
        };
    }else {
        pare = @{@"uKey":uKey,
                 @"_api_key":api_key,
                 @"installType":@"2",
                 @"password":password,
                 @"updateDescription":@""
        };
    }
    [[ESCNetWorkManager sharedNetWorkManager].httpSessionManager POST:ESCPgyerUploadIPAURLPath parameters:pare constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *url=[NSURL fileURLWithPath:filePath];
        NSError *error;
        BOOL result = [formData appendPartWithFileURL:url name:@"file" fileName:[filePath lastPathComponent] mimeType:@"ipa" error:&error];
        if (result) {
            NSLog(@"success");
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%@",uploadProgress);
        dispatch_async(dispatch_get_main_queue(), ^{
            cuploadProgress(uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                if (code == 0) {
                    success(responseObject);
                }else {
                    NSString *errorString = [responseObject mj_JSONString];
                    if (errorString == nil) {
                        errorString = @"上传失败";
                    }
                    NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorString}];
                    failure(error);
                }
            });
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

@end
