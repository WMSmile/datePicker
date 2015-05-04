//
//  ViewController.m
//  datePicker
//
//  Created by Mac on 15-4-29.
//  Copyright (c) 2015年 wmeng. All rights reserved.
//

#import "ViewController.h"
#import "WMCustomDatePicker.h"

@interface ViewController ()<WMCustomDatePickerDelegate>
{
    UITextField *_TF;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    _TF = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, 300, 100)];
    _TF.placeholder = @"请输入时间";
    _TF.layer.cornerRadius = 4;
    _TF.layer.borderColor = [UIColor blackColor].CGColor;
    _TF.layer.borderWidth = 0.5f;
    [self.view addSubview:_TF];

    /*
     可以根据不同的情况进行定义；
     设置字体的大小
     设置分钟的间隔
     同意在WMCustomDatePicker。m文件里面修改
     可以设置最大的和最小的时间
    
    武猛创作 （参考uudate的源代码 ）在此感谢uuDatepicker的作者    
     */
    
    WMCustomDatePicker *picker = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) Delegate:self PickerStyle:WMDateStyle_YearMonthDayHourMinute];
    picker.minLimitDate = [NSDate date];
    _TF.inputView = picker;
    
    /*
     
     WMDateStyle_YearMonthDayHourMinute = 0,
     WMDateStyle_YearMonthDay,
     WMDateStyle_MonthDayHourMinute,
     WMDateStyle_HourMinute
     
     
     可以设置多种模式再次我只是演示了一种方法的使用
     其他的模式类似哦！
     希望亲们给我提出更好的意见哦
     欢迎如果发现问题请发邮件给我哦！！944261495@qq.com
     
     
     */
    
    
}
#pragma mark - WMCustomDatePickerDelegate
- (void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute weekDay:(NSString *)weekDay
{
    NSLog(@"%@====%@=====%@=====%@=====%@=====%@=====",year,month,day,hour,minute,weekDay);
    _TF.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",year,month,day,hour,minute,weekDay];
}

- (void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker date:(NSDate *)date
{
    NSLog(@"%@",date);
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
