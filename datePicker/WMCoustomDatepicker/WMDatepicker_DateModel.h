//
//  WMDatepicke_DateModel.h
//  datePicker
//
//  Created by Mac on 15-4-29.
//  Copyright (c) 2015年 wmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDatepicker_DateModel : NSObject
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *month;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *hour;
@property (nonatomic, retain) NSString *minute;

- (id)initWithDate:(NSDate *)date;
@end
