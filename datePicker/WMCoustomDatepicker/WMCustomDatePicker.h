//
//  WMCustomDatePicker.h
//  datePicker
//
//  Created by Mac on 15-4-29.
//  Copyright (c) 2015年 wmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    WMDateStyle_YearMonthDayHourMinute = 0,
    WMDateStyle_YearMonthDay,
    WMDateStyle_MonthDayHourMinute,
    WMDateStyle_HourMinute
    
}WMDateStyle;
@class WMCustomDatePicker;

@protocol WMCustomDatePickerDelegate <NSObject>
@optional
//选择完成之后调用
-(void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker
                            year:(NSString *)year
                           month:(NSString *)month
                             day:(NSString *)day
                            hour:(NSString *)hour
                          minute:(NSString *)minute
                         weekDay:(NSString *)weekDay;
-(void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker
                            date:(NSDate *)date;
@end




@interface WMCustomDatePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, assign)id<WMCustomDatePickerDelegate>delegate;
@property (nonatomic, assign) WMDateStyle datePickerStyle;
@property (nonatomic, retain) NSDate *ScrollToDate;//滚到指定日期
@property (nonatomic, retain) NSDate *maxLimitDate;//限制最大时间（没有设置默认2049）
@property (nonatomic, retain) NSDate *minLimitDate;//限制最小时间（没有设置默认1970）

- (id)initWithframe:(CGRect)frame Delegate:(id<WMCustomDatePickerDelegate>)delegate PickerStyle:(WMDateStyle)WMDateStyle;




@end
