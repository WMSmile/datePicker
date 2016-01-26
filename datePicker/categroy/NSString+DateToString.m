//
//  NSString+DateToString.m
//  datePicker
//
//  Created by Mac on 16/1/26.
//  Copyright © 2016年 wmeng. All rights reserved.
//

#import "NSString+DateToString.h"

@implementation NSString (DateToString)
//根据date返回string
+ (NSString *)dateFromString:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSString *dateStr = [inputFormatter stringFromDate:date];
    return dateStr;
}

@end
