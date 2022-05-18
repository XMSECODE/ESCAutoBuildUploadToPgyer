//
//  ESCConfigurationModel.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCConfigurationModel.h"
#import "ESCConfigManager.h"
#import "MJExtension.h"
#import "ESCFileManager.h"

@interface ESCConfigurationModel ()<MJKeyValue>

@property (nonatomic, readwrite,copy) NSString *historyLogPath;


@end

@implementation ESCConfigurationModel

- (NSString *)appUdid {
    if (_appUdid == nil || _appUdid.length == 0) {
        _appUdid = [self longUuidString];
    }
    return _appUdid;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"bundleIdModelArray":@"ESCBundleIdModel"};
}


- (NSString *)longUuidString {
    NSString *uuidString = [ESCConfigurationModel uuidString];
    uuidString = [uuidString stringByAppendingString:[ESCConfigurationModel uuidString]];
    uuidString = [uuidString stringByAppendingString:[ESCConfigurationModel uuidString]];
    return uuidString;
}

+ (NSString *)uuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString * _Nonnull)(uuid_string_ref)];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

- (void)setProjectPath:(NSString *)projectPath {
    _projectPath = projectPath;
    NSString *fileName = projectPath.lastPathComponent;
    NSArray *array = [fileName componentsSeparatedByString:@"."];
    self.projectName = array.firstObject;
    
}

- (NSString *)historyLogPath {
    NSString *path = [NSString stringWithFormat:@"%@/log/",self.ipaPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }else {
        NSError *error;
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (result) {
            return path;
        }else {
            return  self.ipaPath;
        }
    }
}

- (NSString *)ipaPath {
    NSString *path = [NSString stringWithFormat:@"%@/log/",_ipaPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        NSError *error;
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (result == NO) {
            NSLog(@"创建文件夹失败==%@===%@",path,error);
        }
    }
    return _ipaPath;
}

- (void)calculateNetWorkRate {
    if (self.networkRecordArray == nil) {
        self.networkRecordArray = [NSMutableArray array];
    }
    
    double currentTime = CFAbsoluteTimeGetCurrent();
    
    double offtime1 = 0;
    
    {
        NSDictionary *firstDict = self.networkRecordArray.firstObject;
        double startTime = [[firstDict objectForKey:@"time"] doubleValue];
        
        NSDictionary *lastDict = self.networkRecordArray.lastObject;
        double endTime = [[lastDict objectForKey:@"time"] doubleValue];
        
        offtime1 = endTime - startTime;
    }
    
    
    if (self.networkRecordArray.count < 1 ) {
        //填充数据
        NSDictionary *dict = @{@"time":@(currentTime),
                               @"sendSize":@(self.sendSize)
                               };
        [self.networkRecordArray addObject:dict];
        return;
    }else if(self.networkRecordArray.count <= 2000 && offtime1 < 3){
        //填充数据，求平均值
        //填充数据
        NSDictionary *dict = @{@"time":@(currentTime),
                               @"sendSize":@(self.sendSize)
                               };
        [self.networkRecordArray addObject:dict];

    }else {
        //填充数据，移除最前面的数据
        NSDictionary *dict = @{@"time":@(currentTime),
                               @"sendSize":@(self.sendSize)
                               };
        NSMutableArray *temArray = [NSMutableArray array];
        for (int i = 0; i < self.networkRecordArray.count - 1; i++) {
            [temArray addObject:self.networkRecordArray[i+1]];
        }
        [temArray addObject:dict];
        self.networkRecordArray = temArray;
        
    }
    
    //求值
    NSDictionary *firstDict = self.networkRecordArray.firstObject;
    double startTime = [[firstDict objectForKey:@"time"] doubleValue];
    int startSize = [[firstDict objectForKey:@"sendSize"] intValue];
    
    NSDictionary *lastDict = self.networkRecordArray.lastObject;
    double endTime = [[lastDict objectForKey:@"time"] doubleValue];
    int endSize = [[lastDict objectForKey:@"sendSize"] intValue];
    
    double offTime = endTime - startTime;
    if (offTime < 1) {
        return;
    }
    double offSize = endSize - startSize;
    
    double netRate = offSize * 1.0 / offTime;
    double netRatekb = netRate / 1024.0;
//    double netRatemb = netRatekb / 1024.0;
    
    //剩余时间  秒
    double remainTime = (self.totalSize - self.sendSize) * 1.0 / netRate;
    self.needRemainTime = remainTime;
    
    if (self.needRemainTime <= 60) {
        self.needRemainTimeString = [NSString stringWithFormat:@"剩余%d秒\n%.0fkb/s",self.needRemainTime,netRatekb];
    }else if(self.needRemainTime <= 60 * 60){
        int m = self.needRemainTime / 60.0;
        int s = self.needRemainTime % 60;
        self.needRemainTimeString = [NSString stringWithFormat:@"剩余%d分%d秒\n%.0fkb/s",m,s,netRatekb];
    }else {
        int h = self.needRemainTime / 3600.0;
        int m = (self.needRemainTime % 3600) / 60.0;
        int s = self.needRemainTime % 60;
        self.needRemainTimeString = [NSString stringWithFormat:@"剩余%d小时%d分%d秒\n%.0fkb/s",h,m,s,netRatekb];
    }
    
//    NSLog(@"%lf===%lf===%lf===%lf",netRate,netRatekb,netRatemb,remainTime);
    
}

- (int)getAllFileSize {
    NSString *dirPath = self.ipaPath;
    int size = [ESCFileManager getDirectorySize:dirPath];
    return size;
}

- (NSString *)buildUpdateDescription {
    if (_buildUpdateDescription == nil) {
        return @"";
    }
    return _buildUpdateDescription;
}

- (void)resetNetworkRate {
    self.networkRecordArray = nil;
}

@end
