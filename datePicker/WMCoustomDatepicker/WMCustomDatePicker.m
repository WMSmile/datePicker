//
//  WMCustomDatePicker.m
//  datePicker
//
//  Created by Mac on 15-4-29.
//  Copyright (c) 2015年 wmeng. All rights reserved.
//

#import "WMCustomDatePicker.h"
#import "WMDatepicker_DateModel.h"

#define DATEPICKER_MAXDATE 2050
#define DATEPICKER_MINDATE 1970

#define DATEPICKER_MONTH 12
#define DATEPICKER_HOUR 24
#define DATEPICKER_MINUTE 60

#define DATEPICKER_interval 1//设置分钟时间间隔
#define DATEMAXFONT 20 //修改最大的文字大小

#define DATE_GRAY [UIColor redColor];
#define DATE_BLACK [UIColor blackColor];
#define WMSCREENWEIGHT [UIScreen mainScreen].bounds.size.width

@interface WMCustomDatePicker()
{
    UIPickerView *myPickerView;
    
    //日期存储数组
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    NSMutableArray *hourArray;
    NSMutableArray *minuteArray;
    
    //限制model
    WMDatepicker_DateModel *maxDateModel;
    WMDatepicker_DateModel *minDateModel;
    
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
}
@property (nonatomic,strong)NSDateFormatter *inputFormatter;


@end

@implementation WMCustomDatePicker

- (id)initWithframe:(CGRect)frame Delegate:(id<WMCustomDatePickerDelegate>)delegate PickerStyle:(WMDateStyle)WMDateStyle
{
    self.datePickerStyle = WMDateStyle;
    self.delegate = delegate;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;
}
//初始化
- (void)drawRect:(CGRect)rect
{
    [self reloadViewsAndData];
}
#pragma mark - 初始化以及刷新界面
-(void)reloadViewsAndData
{
    //  初始化数组
    yearArray   = [self ishave:yearArray];
    monthArray  = [self ishave:monthArray];
    dayArray    = [self ishave:dayArray];
    hourArray   = [self ishave:hourArray];
    minuteArray = [self ishave:minuteArray];
    
    //  进行数组的赋值
    for (int i= 0 ; i<60; i++)
    {
        if (i<24) {
            if (i<12) {
                [monthArray addObject:[NSString stringWithFormat:@"%d月",i+1]];
                
            }
            [hourArray addObject:[NSString stringWithFormat:@"%02d时",i]];
        }
        if (i%DATEPICKER_interval==0) {
            [minuteArray addObject:[NSString stringWithFormat:@"%02d分",i]];
        }
        
        
    }
    for (int i = DATEPICKER_MINDATE; i<=DATEPICKER_MAXDATE; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    //最大最小限制
    if (self.maxLimitDate) {
        maxDateModel = [[WMDatepicker_DateModel alloc]initWithDate:self.maxLimitDate];
    }else{
        self.maxLimitDate = [self dateFromString:[NSString stringWithFormat:@"%d12312359",DATEPICKER_MAXDATE-1] withFormat:@"yyyyMMddHHmm"];
        maxDateModel = [[WMDatepicker_DateModel alloc]initWithDate:self.maxLimitDate];
    }
    //最小限制
    if (self.minLimitDate) {
        minDateModel = [[WMDatepicker_DateModel alloc]initWithDate:self.minLimitDate];
    }else{
        self.minLimitDate = [self dateFromString:[NSString stringWithFormat:@"%d01010000",DATEPICKER_MINDATE] withFormat:@"yyyyMMddHHmm"];
        minDateModel = [[WMDatepicker_DateModel alloc]initWithDate:self.minLimitDate];
    }
    
    //获取当前日期，储存当前时间位置
    NSArray *indexArray = [self getNowDate:self.ScrollToDate];
    myPickerView = nil;
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.backgroundColor = [UIColor clearColor];
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    [self addSubview:myPickerView];
    
    //调整为现在的时间
    for (int i=0; i<indexArray.count; i++) {
        [myPickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:NO];
    }
    

}
- (void)setDatePickerStyle:(WMDateStyle)datePickerStyle
{
    if (_datePickerStyle!=datePickerStyle) {
        _datePickerStyle = datePickerStyle;
        //刷新数据和界面
        [self reloadViewsAndData];
    }
}
#pragma mark - 初始化赋值操作
- (NSMutableArray *)ishave:(id)mutableArray
{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}
//获取当前时间解析及位置
- (NSArray *)getNowDate:(NSDate *)date
{
    NSDate *dateShow;
    if (date) {
        dateShow = date;
    }else{
        dateShow = [NSDate date];
    }
    WMDatepicker_DateModel *model = [[WMDatepicker_DateModel alloc]initWithDate:dateShow];
    
    [self DaysfromYear:[model.year integerValue] andMonth:[model.month integerValue]];
    
    yearIndex = [model.year intValue]-DATEPICKER_MINDATE;
    monthIndex = [model.month intValue]-1;
    dayIndex = [model.day intValue]-1;
    hourIndex = [model.hour intValue]-0;
    
    //    minuteIndex = [model.minute intValue]-0;
    
    minuteIndex = [self findMinuteIndex:model.minute];//武猛修改
    
    
    NSNumber *year   = [NSNumber numberWithInteger:yearIndex];
    NSNumber *month  = [NSNumber numberWithInteger:monthIndex];
    NSNumber *day    = [NSNumber numberWithInteger:dayIndex];
    NSNumber *hour   = [NSNumber numberWithInteger:hourIndex];
    NSNumber *minute = [NSNumber numberWithInteger:minuteIndex];

    self.date = [self dateFromString:[NSString stringWithFormat:@"%@%@%@%@%@",yearArray[yearIndex],monthArray[monthIndex],dayArray[dayIndex],hourArray[hourIndex],minuteArray[minuteIndex]] withFormat:@"yyyy年MM月dd日HH时mm分"];//选择器时间

    if (self.datePickerStyle == WMDateStyle_YearMonthDayHourMinute)
        return @[year,month,day,hour,minute];
    if (self.datePickerStyle == WMDateStyle_YearMonthDay)
        return @[year,month,day];
    if (self.datePickerStyle == WMDateStyle_MonthDayHourMinute)
        return @[month,day,hour,minute];
    if (self.datePickerStyle == WMDateStyle_HourMinute)
        return @[hour,minute];
    return nil;
}
//武猛添加
- (NSInteger)findMinuteIndex:(NSString *)minute
{
    for ( int i = 0; i<60; i++) {
        
        if ([minute integerValue]%DATEPICKER_interval==0) {
            return [minute integerValue]/DATEPICKER_interval;
        }
        else
        {
            minute = [NSString stringWithFormat:@"%ld",[minute integerValue] +1] ;
        }
        
    }
    
    return 0;
    
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.datePickerStyle == WMDateStyle_YearMonthDayHourMinute){
        
        return 5;
    }
    if (self.datePickerStyle == WMDateStyle_YearMonthDay){
               return 3;
    }
    if (self.datePickerStyle == WMDateStyle_MonthDayHourMinute){
                return 4;
    }
    if (self.datePickerStyle == WMDateStyle_HourMinute){
               return 2;
    }
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.datePickerStyle == WMDateStyle_YearMonthDayHourMinute){
        if (component == 0) return DATEPICKER_MAXDATE-DATEPICKER_MINDATE;
        if (component == 1) return DATEPICKER_MONTH;
        if (component == 2) {
            return [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        }
        if (component == 3) return DATEPICKER_HOUR;
        if (component == 4) return DATEPICKER_MINUTE/DATEPICKER_interval;
    }
    if (self.datePickerStyle == WMDateStyle_YearMonthDay)
    {
        if (component == 0) return DATEPICKER_MAXDATE-DATEPICKER_MINDATE;
        if (component == 1) return DATEPICKER_MONTH;
        if (component == 2){
            return [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        }
    }
    if (self.datePickerStyle == WMDateStyle_MonthDayHourMinute)
    {
        if (component == 0) return DATEPICKER_MONTH;
        if (component == 1){
            return [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        }
        if (component == 2) return DATEPICKER_HOUR;
        if (component == 3) return DATEPICKER_MINUTE/DATEPICKER_interval;
    }
    if (self.datePickerStyle == WMDateStyle_HourMinute)
    {
        if (component == 0) return DATEPICKER_HOUR;
        else                return DATEPICKER_MINUTE/DATEPICKER_interval;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (self.datePickerStyle) {
        case WMDateStyle_YearMonthDayHourMinute:{
            if (component==0) return 70*self.frame.size.width/320;
            if (component==1) return 50*self.frame.size.width/320;
            if (component==2) return 50*self.frame.size.width/320;
            if (component==3) return 50*self.frame.size.width/320;
            if (component==4) return 50*self.frame.size.width/320;
        }
            break;
        case WMDateStyle_YearMonthDay:{
            if (component==0) return 70*self.frame.size.width/320;
            if (component==1) return 100*self.frame.size.width/320;
            if (component==2) return 50*self.frame.size.width/320;
        }
            break;
        case WMDateStyle_MonthDayHourMinute:{
            if (component==0) return 70*self.frame.size.width/320;
            if (component==1) return 60*self.frame.size.width/320;
            if (component==2) return 60*self.frame.size.width/320;
            if (component==3) return 60*self.frame.size.width/320;
        }
            break;
        case WMDateStyle_HourMinute:{
            if (component==0) return 100*self.frame.size.width/320;
            if (component==1) return 100*self.frame.size.width/320;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UILabel *)recycledLabel
{
    UILabel *customLabel = recycledLabel;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:DATEMAXFONT]];
    }
    UIColor *textColor = [UIColor blackColor];
    NSString *title;
    
    switch (self.datePickerStyle) {
        case WMDateStyle_YearMonthDayHourMinute:{
            if (component==0) {
                title = yearArray[row];
                textColor = [self returnYearColorRow:row];
            }
            if (component==1) {
                title = monthArray[row];
                textColor = [self returnMonthColorRow:row];
            }
            if (component==2) {
                title = dayArray[row];
                textColor = [self returnDayColorRow:row];
            }
            if (component==3) {
                title = hourArray[row];
                textColor = [self returnHourColorRow:row];
            }
            if (component==4) {
                title = minuteArray[row];
                textColor = [self returnMinuteColorRow:row];
            }
        }
            break;
            
            
        case WMDateStyle_YearMonthDay:{
            if (component==0) {
                title = yearArray[row];
                textColor = [self returnYearColorRow:row];
            }
            if (component==1) {
                title = monthArray[row];
                textColor = [self returnMonthColorRow:row];
            }
            if (component==2) {
                title = dayArray[row];
                textColor = [self returnDayColorRow:row];
            }
        }
            break;
            
        case WMDateStyle_MonthDayHourMinute:{
            if (component==0) {
                title = monthArray[row];
                textColor = [self returnMonthColorRow:row];
            }
            if (component==1) {
                title = dayArray[row];
                textColor = [self returnDayColorRow:row];
            }
            if (component==2) {
                title = hourArray[row];
                textColor = [self returnHourColorRow:row];
            }
            if (component==3) {
                title = minuteArray[row];
                textColor = [self returnMinuteColorRow:row];
            }
        }
            break;
            
        case WMDateStyle_HourMinute:{
            if (component==0) {
                title = hourArray[row];
                textColor = [self returnHourColorRow:row];
            }
            if (component==1) {
                title = minuteArray[row];
                textColor = [self returnMinuteColorRow:row];
            }
        }
            break;
        default:
            break;
    }
    customLabel.text = title;
    customLabel.textColor = textColor;
    return customLabel;



}
#pragma mark -datePickerDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.datePickerStyle) {
        case WMDateStyle_YearMonthDayHourMinute:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1 || component == 2){
                [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
                if (dayArray.count-1<dayIndex) {
                    dayIndex = dayArray.count-1;
                }
                //                [pickerView reloadComponent:2];
                
            }
        }
            break;
            
            
        case WMDateStyle_YearMonthDay:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
                if (dayArray.count-1<dayIndex) {
                    dayIndex = dayArray.count-1;
                }
                //                [pickerView reloadComponent:2];
            }
        }
            break;
            
            
        case WMDateStyle_MonthDayHourMinute:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            if (component == 0) {
                monthIndex = row;
                if (dayArray.count-1<dayIndex) {
                    dayIndex = dayArray.count-1;
                }
                //                [pickerView reloadComponent:1];
            }
            [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
            
        }
            break;
            
            
        case WMDateStyle_HourMinute:{
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    [self playTheDelegate];
}

#pragma mark - WMdatapickerDelegate代理回调方法
- (void)playTheDelegate
{
    self.date = [self dateFromString:[NSString stringWithFormat:@"%@%@%@%@%@",yearArray[yearIndex],monthArray[monthIndex],dayArray[dayIndex],hourArray[hourIndex],minuteArray[minuteIndex]] withFormat:@"yyyy年MM月dd日HH时mm分"];
    if ([_date compare:self.minLimitDate] == NSOrderedAscending) {
        NSArray *array = [self getNowDate:self.minLimitDate];
        for (int i=0; i<array.count; i++) {
            [myPickerView reloadComponent:i];
            [myPickerView selectRow:[array[i] integerValue] inComponent:i animated:YES];
        }
    }else if ([_date compare:self.maxLimitDate] == NSOrderedDescending){
        NSArray *array = [self getNowDate:self.maxLimitDate];
        for (int i=0; i<array.count; i++) {
            [myPickerView reloadComponent:i];
            [myPickerView selectRow:[array[i] integerValue] inComponent:i animated:YES];
        }
    }
    
    NSString *strWeekDay = [self getWeekDayWithYear:yearArray[yearIndex] month:monthArray[monthIndex] day:dayArray[dayIndex]];
    
    //代理回调
    if ([self.delegate respondsToSelector:@selector(finishDidSelectDatePicker:year:month:day:hour:minute:weekDay:)]) {
        [self.delegate finishDidSelectDatePicker:self
                                            year:yearArray[yearIndex]
                                           month:monthArray[monthIndex]
                                             day:dayArray[dayIndex]
                                            hour:hourArray[hourIndex]
                                          minute:minuteArray[minuteIndex]
                                         weekDay:strWeekDay];
    }
    if ([self.delegate respondsToSelector:@selector(finishDidSelectDatePicker:date:)]) {
        
        [self.delegate finishDidSelectDatePicker:self date:_date];
    }
}

#pragma mark - 数据处理
//通过日期求星期
- (NSString*)getWeekDayWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day
{
    NSString *dateStr = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    NSDate *inputDate = [self dateFromString:dateStr withFormat:@"yyyy年MM月dd日"];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0 // 当前支持的sdk版本是否低于6.0
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;

#else
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
#endif
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
//根据string返回date
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    if (!_inputFormatter) {
        _inputFormatter = [[NSDateFormatter alloc] init];
    }
    [_inputFormatter setDateFormat:format];
    NSDate *date = [_inputFormatter dateFromString:string];
    return date;
}
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:{
            [self setdayArray:31];
            return 31;
        }
            break;
        case 4:
        case 6:
        case 9:
        case 11:{
            [self setdayArray:30];
            return 30;
        }
            break;
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}
//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [dayArray addObject:[NSString stringWithFormat:@"%02d日",i]];
    }
}

#pragma mark - 返回颜色的数字
- (UIColor *)returnYearColorRow:(NSInteger)row
{
    if ([yearArray[row] intValue] < [minDateModel.year intValue] || [yearArray[row] intValue] > [maxDateModel.year intValue]) {
        return  DATE_GRAY;
    }else{
        return DATE_BLACK;
    }
}
- (UIColor *)returnMonthColorRow:(NSInteger)row
{
    
    if ([yearArray[yearIndex] intValue] < [minDateModel.year intValue] || [yearArray[yearIndex] intValue] > [maxDateModel.year intValue]) {
        return DATE_GRAY;
    }else if([yearArray[yearIndex] intValue] > [minDateModel.year intValue] && [yearArray[yearIndex] intValue] < [maxDateModel.year intValue]){
        return DATE_BLACK;
    }else if ([minDateModel.year intValue]==[maxDateModel.year intValue]){
        if ([monthArray[row] intValue] >= [minDateModel.month intValue] && [monthArray[row] intValue] <= [maxDateModel.month intValue]) {
            return DATE_BLACK;
        }else {
            return DATE_GRAY;
        }
    }else if ([yearArray[yearIndex] intValue] == [minDateModel.year intValue]){
        if ([monthArray[row] intValue] >= [minDateModel.month intValue]) {
            return DATE_BLACK;
        }else{
            return DATE_GRAY;
        }
    }else {
        if ([monthArray[row] intValue] > [maxDateModel.month intValue]) {
            return DATE_GRAY;
        }else{
            return DATE_BLACK;
        }
    }
}
- (UIColor *)returnDayColorRow:(NSInteger)row
{
    if ([yearArray[yearIndex] intValue] < [minDateModel.year intValue] || [yearArray[yearIndex] intValue] > [maxDateModel.year intValue]) {
        return DATE_GRAY;
    }else if([yearArray[yearIndex] intValue] > [minDateModel.year intValue] && [yearArray[yearIndex] intValue] < [maxDateModel.year intValue]){
        return DATE_BLACK;
    }else if ([minDateModel.year intValue]==[maxDateModel.year intValue]){
        if ([monthArray[monthIndex] intValue] > [minDateModel.month intValue] && [monthArray[monthIndex] intValue] < [maxDateModel.month intValue]) {
            return DATE_BLACK;
        }else if ([minDateModel.month intValue]==[maxDateModel.month intValue]){
            if ([dayArray[row] intValue] >= [minDateModel.day intValue] && [dayArray[row] intValue] <= [maxDateModel.day intValue]) {
                return DATE_BLACK;
            }else{
                return DATE_GRAY;
            }
        }else  if ([monthArray[monthIndex] intValue] == [minDateModel.month intValue]){
            if ([dayArray[row] intValue] >= [minDateModel.day intValue]) {
                return DATE_BLACK;
            }else{
                return DATE_GRAY;
            }
        }else {
            if ([dayArray[row] intValue] > [maxDateModel.day intValue]) {
                return DATE_GRAY;
            }else{
                return DATE_BLACK;
            }
        }
    }else if ([yearArray[yearIndex] intValue] == [minDateModel.year intValue]){
        if ([monthArray[monthIndex] intValue] < [minDateModel.month intValue]) {
            return DATE_GRAY;
        }else if([monthArray[monthIndex] intValue] == [minDateModel.month intValue]){
            if ([dayArray[row] intValue] >= [minDateModel.day intValue]) {
                return DATE_BLACK;
            }else {
                return DATE_GRAY;
            }
        }else{
            return DATE_BLACK;
        }
    }else {
        if ([monthArray[monthIndex] intValue] > [maxDateModel.month intValue]) {
            return DATE_GRAY;
        }else if([monthArray[monthIndex] intValue] == [maxDateModel.month intValue]){
            if ([dayArray[row] intValue] <= [maxDateModel.day intValue]) {
                return DATE_BLACK;
            }else{
                return DATE_GRAY;
            }
        }else{
            return DATE_BLACK;
        }
    }
}
- (UIColor *)returnHourColorRow:(NSInteger)row
{
    NSString *minDateStr = [NSString stringWithFormat:@"%@%@%@",minDateModel.year,minDateModel.month,minDateModel.day];
    NSDate *minDate = [self dateFromString:minDateStr withFormat:@"yyyyMMdd"];
    
    NSString *maxDateStr = [NSString stringWithFormat:@"%@%@%@",maxDateModel.year ,maxDateModel.month ,maxDateModel.day];
    NSDate *maxDate = [self dateFromString:maxDateStr withFormat:@"yyyyMMdd"];
    
    NSString *currentDateStr = [NSString stringWithFormat:@"%@%@%@",yearArray[yearIndex] ,monthArray[monthIndex],dayArray[dayIndex] ];
    
    NSDate *currentDate = [self dateFromString:currentDateStr withFormat:@"yyyy年MM月dd日"];
    
    
    NSComparisonResult minResult = [currentDate compare:minDate];
    NSComparisonResult maxResult = [currentDate compare:maxDate];
    
    
    if (minResult == NSOrderedAscending || maxResult == NSOrderedDescending) {
        return DATE_GRAY;
    }
    else
    {
        
        NSComparisonResult minMaxResult = [minDate compare:maxDate];
        
        if (minMaxResult == NSOrderedSame)
        {
            if ([hourArray[row] intValue] >= [minDateModel.hour intValue] && [hourArray[row] intValue] <= [maxDateModel.hour intValue]) {
                return DATE_BLACK;
            }else {
                return DATE_GRAY;
            }
            
        }else if (minResult==NSOrderedSame){
            if ([hourArray[row] intValue] >= [minDateModel.hour intValue]) {
                return DATE_BLACK;
            }else{
                return DATE_GRAY;
            }
            
        }else if (maxResult==NSOrderedSame)
        {
            if ([hourArray[row] intValue] > [maxDateModel.hour intValue]) {
                return DATE_GRAY;
            }else{
                return DATE_BLACK;
            }
        }
        else
        {
            return DATE_BLACK;
        }
        
    }

}
- (UIColor *)returnMinuteColorRow:(NSInteger)row
{
    NSString *minDateStr = [NSString stringWithFormat:@"%@%@%@%@%@",minDateModel.year,minDateModel.month,minDateModel.day,minDateModel.hour,minDateModel.minute];
    NSDate *minDate = [self dateFromString:minDateStr withFormat:@"yyyyMMddHHmm"];
    
    NSString *maxDateStr = [NSString stringWithFormat:@"%@%@%@%@%@",maxDateModel.year ,maxDateModel.month ,maxDateModel.day ,maxDateModel.hour,maxDateModel.minute];
    NSDate *maxDate = [self dateFromString:maxDateStr withFormat:@"yyyyMMddHHmm"];
    
    NSString *currentDateStr = [NSString stringWithFormat:@"%@%@%@%@%@",yearArray[yearIndex] ,monthArray[monthIndex],dayArray[dayIndex] ,hourArray[hourIndex],minuteArray[row]];
    
    NSDate *currentDate = [self dateFromString:currentDateStr withFormat:@"yyyy年MM月dd日HH时mm分"];
    
    
    NSComparisonResult minResult = [currentDate compare:minDate];
    NSComparisonResult maxResult = [currentDate compare:maxDate];
    
    if (minResult == NSOrderedAscending || maxResult == NSOrderedDescending) {
        return DATE_GRAY;
    }
    else
    {
        return DATE_BLACK;
    }
    


}



@end
