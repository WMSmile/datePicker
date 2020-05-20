# datePicker
主要功能是 ：实现四种时间选择器的模式

```
     WMDateStyle_YearMonthDayHourMinute //年月日时分
     WMDateStyle_YearMonthDay,//年月日
     WMDateStyle_MonthDayHourMinute,//月日时分
     WMDateStyle_HourMinute//时分
```
可以加上时间限制，不可选为红色，可选为黑色

在**WMCustomDatePicker.m**中可以修改一下内容

```
#define DATEPICKER_interval 1//设置分钟时间间隔
#define DATEMAXFONT 20 //修改最大的文字大小
//改变颜色
#define DATE_GRAY [UIColor redColor];//不可选的状态
#define DATE_BLACK [UIColor blackColor];//可选状态

```


使用说明：

```
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
    picker.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30];
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

```
