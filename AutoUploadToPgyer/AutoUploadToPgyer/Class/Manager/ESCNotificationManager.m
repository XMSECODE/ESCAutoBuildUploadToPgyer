//
//  ESCNotificationManager.m
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/5/29.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import "ESCNotificationManager.h"
#import <UserNotifications/UNNotification.h>

@interface ESCNotificationManager ()

@end

static ESCNotificationManager *staticESCNotificationManager;

static NSString *ESCNotification_key = @"ESCNotification_key";

@implementation ESCNotificationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.notificationSwitchIsOpen = [[[NSUserDefaults standardUserDefaults] objectForKey:ESCNotification_key] boolValue];
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticESCNotificationManager = [[ESCNotificationManager alloc] init];
    });
    return staticESCNotificationManager;
}

- (void)setNotificationSwitchIsOpen:(BOOL)notificationSwitchIsOpen {
    _notificationSwitchIsOpen = notificationSwitchIsOpen;
    if (notificationSwitchIsOpen == YES) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ESCNotification_key];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:ESCNotification_key];
    }
}

- (void)pushNotificationMessage:(NSString *)message {
    //添加推送
    if (self.notificationSwitchIsOpen == YES) {
        NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        [notification setTitle:message];
        [center scheduleNotification:notification];
    }
}

@end
