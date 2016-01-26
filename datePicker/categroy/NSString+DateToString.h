//
//  NSString+DateToString.h
//  datePicker
//
//  Created by Mac on 16/1/26.
//  Copyright © 2016年 wmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateToString)
/**
 *  日期转化string
 *
 *  @param date   转化的日期
 *  @param format 格式
 *
 *  @return 字符串
 */
+ (NSString *)dateFromString:(NSDate *)date withFormat:(NSString *)format;
@end
