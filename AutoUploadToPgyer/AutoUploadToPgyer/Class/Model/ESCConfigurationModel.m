//
//  ESCConfigurationModel.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 04/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "ESCConfigurationModel.h"

@interface ESCConfigurationModel ()

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

@end
