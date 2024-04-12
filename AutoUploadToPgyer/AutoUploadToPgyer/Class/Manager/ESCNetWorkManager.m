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

NSString *ESCPgyerGetTokenURLPath = @"https://www.pgyer.com/apiv2/app/getCOSToken";

NSString *ESCPgyerGetBuildInfoURLPath = @"https://www.pgyer.com/apiv2/app/buildInfo";



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
                          api_key:(NSString *)api_key
                         fileType:(ESCFileType)filetype
                         password:(NSString *)password
           buildUpdateDescription:(NSString *)buildUpdateDescription
                         progress:(void (^)(NSProgress * progress))cuploadProgress
                          success:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure {
    
    if (api_key == nil || api_key.length <= 0) {
        NSError *error = [NSError errorWithDomain:@"apikey is null" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"apikey is null"}];
        failure(error);
        return;
    }
    
    NSDictionary *pare = nil;
    if (buildUpdateDescription == nil) {
        buildUpdateDescription = @"";
    }
    NSString *typeString = @"ios";
    if (filetype == ESCFileTypeApk) {
        typeString = @"android";
    }
    if (password == nil || password.length <= 0) {
        pare = @{@"_api_key":api_key,
                 @"buildInstallType":@"1",
                 @"buildType":typeString,
                 @"buildUpdateDescription":buildUpdateDescription
        };
    }else {
        pare = @{@"_api_key":api_key,
                 @"buildInstallType":@"2",
                 @"buildType":typeString,
                 @"buildPassword":password,
                 @"buildUpdateDescription":buildUpdateDescription
        };
    }
    
    if (filePath == nil || [[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"ipa文件不存在"}];
        failure(error);
        return;
    }
    [[ESCNetWorkManager sharedNetWorkManager].httpSessionManager POST:ESCPgyerGetTokenURLPath parameters:pare headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        /*
         {
             code = 0;
             data =     {
                 endpoint = "https://pgy-apps-1251724549.cos.ap-guangzhou.myqcloud.com";
                 key = "15ea0158859b937532c260029d9b5733.ipa";
                 params =         {
                     key = "15ea0158859b937532c260029d9b5733.ipa";
                     signature = "q-sign-algorithm=sha1&q-ak=AKIDy85gaufeX7r28eSHqhKED6EZzdQlmKB-L6wRoqhk58l7eda2HUSIrcdsYAhCpcBa&q-sign-time=1665468225;1665470085&q-key-time=1665468225;1665470085&q-header-list=&q-url-param-list=&q-signature=43fd385f8b35ec5cfc77082488c54098da94f83d";
                     "x-cos-security-token" = "0Xpn4l4QB15y97l1gyvfUun2tWW0aTBa269932095ea8cc1199a3043e44e1112bNU43IfpOhqNiH-U0pJ-muG_Hf921Rz5ZXdw6Il3GyECeNNPq9ds_cqvO-gVU88UnfKsdyRFClx1zV4ugbRVt3qXGZNkqdg5_q43aCxlLOjgODavi7a2orvBqWFsMdNS_GEnTg1-u_kUaJUdDhGjYjD37knzTIixVHT8NSFpE42Kv--sCr4N1s6l9RGmPk6iPvy3xMg_7d22yzkD4hpcyZlv8hNTb0KJwTeeJu2EuMLXy_ini7kBpc6VmpAp3xF1iN_-1TFZ4wpS3tgkdKCLif1upEdY-c8OXtXSykRcxna4ON91m7Su5AOF8yU9_RRgh47smEJA_jQvh7IdK5QQqtk-gziNbOAP7uQTgUbVW5YU";
                 };
             };
             message = "";
         }
         */
        int code = [[responseObject valueForKey:@"code"] intValue];
        NSString *message = [responseObject valueForKey:@"message"];
        if (code == 0) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *endpoint = [data valueForKey:@"endpoint"];
            NSString *key = [data valueForKey:@"key"];
            NSMutableDictionary *params = [[data valueForKey:@"params"] mutableCopy];
            
            
            [[ESCNetWorkManager sharedNetWorkManager].httpSessionManager POST:endpoint parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
                
                [self uploadToPgyerGetBuildInfoWithKey:key api_key:api_key success:success failure:failure];
              
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }];

            
            
        }else {
            NSError *error = [NSError errorWithDomain:@"" code:code userInfo:@{NSLocalizedDescriptionKey:message}];
            failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

+ (void)uploadToPgyerGetBuildInfoWithKey:(NSString *)key
                                 api_key:(NSString *)api_key
                                 success:(void (^)(NSDictionary *result))success
                                 failure:(void (^)(NSError *error))failure {
    NSDictionary *paras = @{@"_api_key":api_key,
                            @"buildKey":key
    };
    [[ESCNetWorkManager sharedNetWorkManager].httpSessionManager GET:ESCPgyerGetBuildInfoURLPath parameters:paras headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 0) {
                success(responseObject);
            }else if(code == 1247){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self uploadToPgyerGetBuildInfoWithKey:key api_key:api_key success:success failure:failure];
                });
            }else {
                NSString *errorString = [responseObject mj_JSONString];
                if (errorString == nil) {
                    errorString = @"上传失败";
                }
                NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorString}];
                failure(error);
            }
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
    if (api_token == nil || api_token.length <= 0) {
        NSError *error = [NSError errorWithDomain:@"api_token is null" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"api_token is null"}];
        failure(error);
        return;
    }
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
