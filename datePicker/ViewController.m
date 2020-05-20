//
//  ViewController.m
//  datePicker
//
//  Created by Mac on 15-4-29.
//  Copyright (c) 2015年 wmeng. All rights reserved.
//
/*
 
 WMDateStyle_YearMonthDayHourMinute = 0,//年月日时分秒
 WMDateStyle_YearMonthDay,//年月日
 WMDateStyle_YearMonth,//年月
 WMDateStyle_MonthDayHourMinute,//月日时分秒
 WMDateStyle_HourMinute//时分秒
 
 
 可以设置多种模式再次我只是演示了一种方法的使用
 其他的模式类似哦！
 希望亲们给我提出更好的意见哦
 
 
 */
#import "ViewController.h"
#import "WMCustomDatePicker.h"
#import "NSString+DateToString.h"

@interface ViewController ()<WMCustomDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ymdsmmTF;
@property (weak, nonatomic) IBOutlet UITextField *ymdTF;
@property (weak, nonatomic) IBOutlet UITextField *ymTF;
@property (weak, nonatomic) IBOutlet UITextField *mdhmsTF;
@property (weak, nonatomic) IBOutlet UITextField *hmTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    /*
     可以根据不同的情况进行定义；
     设置字体的大小
     设置分钟的间隔
     同意在WMCustomDatePicker。m文件里面修改
     可以设置最大的和最小的时间
    
    武猛创作 （参考uudate的源代码 ）在此感谢uuDatepicker的作者
     */
    //年月日时分秒
    WMCustomDatePicker *picker = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) PickerStyle:WMDateStyle_YearMonthDayHourMinute didSelectedDateFinishBack:^(WMCustomDatePicker *picker, NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        NSLog(@"%@====%@=====%@=====%@=====%@=====%@=====",year,month,day,hour,minute,weekDay);
        self.ymdsmmTF.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",year,month,day,hour,minute,weekDay];
    }];
    
    picker.minLimitDate = [NSDate date];
    picker.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    self.ymdsmmTF.inputView = picker;
    
     //年月日
    WMCustomDatePicker *picker1 = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) PickerStyle:WMDateStyle_YearMonthDay didSelectedDateFinishBack:^(WMCustomDatePicker *picker, NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        NSLog(@"%@====%@=====%@=",year,month,day);
        self.ymdTF.text = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    }];
    
    picker1.minLimitDate = [NSDate date];
    picker1.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    self.ymdTF.inputView = picker1;
    
    
     //年月
    WMCustomDatePicker *picker2 = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) PickerStyle:WMDateStyle_YearMonth didSelectedDateFinishBack:^(WMCustomDatePicker *picker, NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        NSLog(@"%@====%@=====",year,month);
        self.ymTF.text = [NSString stringWithFormat:@"%@%@",year,month];
    }];
    
    picker2.minLimitDate = [NSDate date];
    picker2.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    self.ymTF.inputView = picker2;
    
     //月日时分秒
    WMCustomDatePicker *picker3 = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) PickerStyle:WMDateStyle_MonthDayHourMinute didSelectedDateFinishBack:^(WMCustomDatePicker *picker, NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        NSLog(@"%@=====%@=====%@=====%@=====%@=====",month,day,hour,minute,weekDay);
        self.mdhmsTF.text = [NSString stringWithFormat:@"%@%@%@%@%@",month,day,hour,minute,weekDay];
    }];
    
    picker3.minLimitDate = [NSDate date];
    picker3.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    self.mdhmsTF.inputView = picker3;
    
    
    
    
    
    
     //时分
    WMCustomDatePicker *picker5 = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) Delegate:self PickerStyle:WMDateStyle_HourMinute];
    picker5.minLimitDate = [NSDate date];
    picker5.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    self.hmTF.inputView = picker5;

    
    
}
#pragma mark - WMCustomDatePickerDelegate
- (void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute weekDay:(NSString *)weekDay
{
    NSLog(@"%@=====%@=====",hour,minute);
    self.hmTF.text = [NSString stringWithFormat:@"%@%@",hour,minute];
}

- (void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker date:(NSDate *)date
{
    NSLog(@"%@_____formatterDate == %@",date,[NSString dateFromString:date withFormat:@"yyMMdd HH:mm"]);
}





/**
 * 取消输入法
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
