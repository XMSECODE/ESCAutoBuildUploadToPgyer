//
//  ESCConfigurationModel.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCConfigurationModel.h"

@interface ESCConfigurationModel ()

@property (nonatomic, readwrite,copy) NSString *historyLogPath;


@end

@implementation ESCConfigurationModel

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
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:yearMask attributes:nil error:&error];
        if (result) {
            return path;
        }else {
            return  self.ipaPath;
        }
    }
}

- (void)calculateNetWorkRate {
    if (self.networkRecordArray == nil) {
        self.networkRecordArray = [NSMutableArray array];
    }
    
    double currentTime = CFAbsoluteTimeGetCurrent();
    if (self.networkRecordArray.count < 1 ) {
        //填充数据
        NSDictionary *dict = @{@"time":@(currentTime),
                               @"sendSize":@(self.sendSize)
                               };
        [self.networkRecordArray addObject:dict];
        return;
    }else if(self.networkRecordArray.count <= 3){
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

- (void)resetNetworkRate {
    self.networkRecordArray = nil;
}

@end
