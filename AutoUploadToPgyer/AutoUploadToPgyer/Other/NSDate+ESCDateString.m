//
//  NSDate+ESCDateString.m
//  AutoUploadToPgyer
//
//  Created by xiangmingsheng on 02/09/2017.
//  Copyright © 2017 XMSECODE. All rights reserved.
//

#import "NSDate+ESCDateString.h"
#import "NSDate+Utilities.h"

@implementation NSDate (ESCDateString)

- (NSString *)getOffTime {
    if (self.isToday && [self isEarlierThanDate:[[NSDate alloc] init]]) {
        NSInteger delta = [self minutesBeforeDate:[NSDate date]];
        if (delta == 0) {
            return @"刚刚";
        } else if (delta < 60) {
            return [NSString stringWithFormat:@"%ld分钟前",(long)delta];
        } else {
            return [NSString stringWithFormat:@"%ld小时前",(long)[self hoursBeforeDate:[NSDate date]]];
        }
        
    }
    
    if (self.isYesterday) {
        return [self stringWithFormat:@"昨天 hh:mm"];
    }
    
    if (self.isInPast) {
        return self.shortDateString;
    }
    
    return nil;
}

@end
