//
//  ESCNotificationManager.h
//  AutoUploadToPgyer
//
//  Created by xiang on 2020/5/29.
//  Copyright © 2020 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESCNotificationManager : NSObject

@property(nonatomic,assign)BOOL notificationSwitchIsOpen;

+ (instancetype)sharedManager;

- (void)pushNotificationMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
