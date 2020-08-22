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
#import "ESCFileManager.h"

NSString *ESCPgyerUploadIPAURLPath = @"https://www.pgyer.com/apiv2/app/upload";

NSString *ESCFireGetCertURLPath = @"http://api.bq04.com/apps";



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
           buildUpdateDescription:(NSString *)buildUpdateDescription
                         progress:(void (^)(NSProgress * progress))cuploadProgress
                          success:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure{
    NSDictionary *pare = nil;
    if (buildUpdateDescription == nil) {
        buildUpdateDescription = @"";
    }
    if (password == nil || password.length <= 0) {
        pare = @{@"_api_key":api_key,
                 @"buildInstallType":@"1",
                 @"buildUpdateDescription":buildUpdateDescription
        };
    }else {
        pare = @{@"_api_key":api_key,
                 @"buildInstallType":@"2",
                 @"buildPassword":password,
                 @"buildUpdateDescription":buildUpdateDescription
        };
    }
    
    if (filePath == nil || [[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"ipa文件不存在"}];
        failure(error);
        return;
    }
    
    [[ESCNetWorkManager sharedNetWorkManager].httpSessionManager POST:ESCPgyerUploadIPAURLPath parameters:pare headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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

+ (void)uploadToFirimWithFilePath:(NSString *)filePath
                        api_token:(NSString *)api_token
           buildUpdateDescription:(NSString *)buildUpdateDescription
                         progress:(void (^)(NSProgress * progress))cuploadProgress
                          success:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure {
    //获取信息
    NSDictionary *dict = [[ESCFileManager sharedFileManager] getAppInfoWithIPAFilePath:filePath];
    
    NSString *bundle_id = [dict objectForKey:@"CFBundleIdentifier"];
    NSString *appname = [dict objectForKey:@"CFBundleName"];
    NSString *version = [dict objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [dict objectForKey:@"CFBundleVersion"];
    
    if (filePath == nil || [[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"ipa文件不存在"}];
        failure(error);
        return;
    }
    
    //获取上传凭证
    [self getFirimCertWithType:@"ios" bundle_id:bundle_id api_token:api_token success:^(NSDictionary *result) {
        //        NSLog(@"result == %@",result);
        //上传ipa
        NSDictionary *cert = [result objectForKey:@"cert"];
        NSDictionary *binary = [cert objectForKey:@"binary"];
        NSString *upload_url = [binary objectForKey:@"upload_url"];
        NSString *key = [binary objectForKey:@"key"];
        NSString *token = [binary objectForKey:@"token"];
        NSDictionary *para = @{@"key":key,
                               @"token":token,
                               @"x:name":appname,
                               @"x:version":version,
                               @"x:build":build,
                               @"x:changelog":buildUpdateDescription
        };
        [[ESCNetWorkManager sharedNetWorkManager].httpSessionManager POST:upload_url parameters:para headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
            //            NSLog(@"%@",uploadProgress);
            dispatch_async(dispatch_get_main_queue(), ^{
                cuploadProgress(uploadProgress);
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //            NSLog(@"%@",responseObject);
            /*
             {
             "download_url" = "https://proqn-app-.jappstore.com/763c6c311df7f2b8375584294c9ef91c2c08a992?attname=NewBaoJun.ipa&e=1592910870&token=LOvmia8oXF4xnLh0IdH05XMYpH6ENHNpARlmPc-T:iT3otsKCp6Yq6kA3HFiu-LJB_Yo=";
             "is_completed" = 1;
             "release_id" = 5ef1d60623389f2a502c3ea5;
             }
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSInteger code = [[responseObject objectForKey:@"is_completed"] integerValue];
                    if (code == 1) {
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
            failure(error);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getFirimCertWithType:(NSString *)type
                   bundle_id:(NSString *)bundle_id
                   api_token:(NSString *)api_token
                     success:(void (^)(NSDictionary *result))success
                     failure:(void (^)(NSError *error))failure {
    NSDictionary *para = @{@"type":type,
                           @"bundle_id":bundle_id,
                           @"api_token":api_token
    };
    [[ESCNetWorkManager sharedNetWorkManager].httpSessionManager POST:ESCFireGetCertURLPath parameters:para headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
