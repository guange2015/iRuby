//
//  Api.m
//  iRuby
//
//  Created by xiaoguang huang on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Api.h"

@implementation Api


+(NSString *)hunmanDate:(NSDate *)date {
    NSTimeInterval n = [date timeIntervalSinceNow];
    long n1 = (long)ABS(n);
    
    int days = 0;
    int hour = 0;
    int min = 0;
    if (n1/60/60>0) {
        hour = n1/60/60;
    } else {
        min = n1/60;
    }
    
    if (hour/24>0) {
        days = hour/24;
    }
    NSString* time = @"刚刚";
    if (min>0){
        time = [NSString stringWithFormat:@"%d分钟前", min];
    }
    if (hour>0) {
        time = [NSString stringWithFormat:@"%d小时前", hour]; //需计算
    }
    if (days>0) {
        time = [NSString stringWithFormat:@"%d天前", days]; //需计算
    }
    return time;
}

@end
