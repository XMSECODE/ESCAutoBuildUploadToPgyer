//
//  ESCBundleIdModel.m
//  iOSAutoBuildAndUpload
//
//  Created by xiangmingsheng on 2021/3/20.
//  Copyright © 2021 XMSECODE. All rights reserved.
//

#import "ESCBundleIdModel.h"

@implementation ESCBundleIdModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bundleId = @"bundleId";
        self.profileName = @"profileName";
    }
    return self;
}

- (NSString *)bundleId {
    if (_bundleId == nil) {
        _bundleId = @"bundleId";
    }
    return _bundleId;
}

- (NSString *)profileName {
    if (_profileName == nil) {
        _profileName = @"profileName";
    }
    return _profileName;
}

@end
