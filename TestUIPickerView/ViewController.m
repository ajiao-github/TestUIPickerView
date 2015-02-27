//
//  ViewController.m
//  TestUIPickerView
//
//  Created by ajiao on 2015-02-10.
//  Copyright (c) 2015年 tdwl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic,strong) NSCalendar *calendar;
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,strong) NSDate *selectedDate;
@property (nonatomic,strong)NSDateComponents *selectedDateComponets;

@property (nonatomic,strong)NSArray *hourArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendar = [NSCalendar autoupdatingCurrentCalendar];
    self.startDate = [NSDate date];
    self.endDate = [NSDate dateWithTimeIntervalSinceNow:24*3*3600];
    self.selectedDate = self.startDate;
    
    self.hourArray = @[@(7),@(8),@(9),@(10),@(11),@(12),@(13),@(14),@(15),@(16),@(17),@(18),@(19),@(20),@(21)];
    
    NSDate *currentDate = [NSDate date];
    
    
//    self.pickerView selectRow:<#(NSInteger)#> inComponent:<#(NSInteger)#> animated:<#(BOOL)#>
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) { // component是栏目index，从0开始，后面的row也一样是从0开始
        case 0: { // 第一栏为年，这里startDate和endDate为起始时间和截止时间，请自行指定
            NSDateComponents *startCpts = [self.calendar components:NSYearCalendarUnit
                                                           fromDate:self.startDate];
            NSDateComponents *endCpts = [self.calendar components:NSYearCalendarUnit
                                                         fromDate:self.endDate];
            return [endCpts year] - [startCpts year] + 1;
        }
        case 1: // 第二栏为月份
            return 12;
        case 2: { // 第三栏为对应月份的天数
            NSRange dayRange = [self.calendar rangeOfUnit:NSDayCalendarUnit
                                                   inUnit:NSMonthCalendarUnit
                                                  forDate:self.selectedDate];
            NSLog(@"current month: %d, day number: %d", [[self.calendar components:NSMonthCalendarUnit fromDate:self.selectedDate] month], dayRange.length);
            return dayRange.length;
        }
        case 3:{
            return self.hourArray.count;
        }
            
        default:
            return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        [dateLabel setFont:[UIFont systemFontOfSize:12]];
        [dateLabel setTextColor:[UIColor redColor]];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    switch (component) {
        case 0: {
            NSDateComponents *components = [self.calendar components:NSYearCalendarUnit
                                                            fromDate:self.startDate];
            NSString *currentYear = [NSString stringWithFormat:@"%d", [components year] + row];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentRight;
            NSLog(@"年%@",currentYear);
            break;
        }
        case 1: { // 返回月份可以用DateFormatter，这样可以支持本地化
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            NSArray *monthSymbols = [formatter monthSymbols];
            [dateLabel setText:[monthSymbols objectAtIndex:row]];
            dateLabel.textAlignment = NSTextAlignmentCenter;
             NSLog(@"月%@",[monthSymbols objectAtIndex:row]);
            break;
        }
        case 2: {
            NSRange dateRange = [self.calendar rangeOfUnit:NSDayCalendarUnit
                                                    inUnit:NSMonthCalendarUnit
                                                   forDate:self.selectedDate];
            NSString *currentDay = [NSString stringWithFormat:@"%02d", (row + 1) % (dateRange.length + 1)];
            [dateLabel setText:currentDay];
            dateLabel.textAlignment = NSTextAlignmentLeft;
            NSLog(@"日%@",currentDay);

            break;
        }
        case 3: {
            dateLabel.text = [NSString stringWithFormat:@"%@",self.hourArray[row]];
            NSLog(@"小时%@",self.hourArray[row]);
            
            break;
        }
        default:
            break;
    }
    
    return dateLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    switch (component) {
        case 0: {
            NSDateComponents *indicatorComponents = [self.calendar components:NSYearCalendarUnit
                                                                     fromDate:self.startDate];
            NSInteger year = [indicatorComponents year] + row;
            NSDateComponents *targetComponents = [self.calendar components:unitFlags
                                                                  fromDate:self.selectedDate];
            [targetComponents setYear:year];
            self.selectedDateComponets = targetComponents;
            [pickerView selectRow:0 inComponent:1 animated:YES];
            break;
        }
        case 1: {
            NSDateComponents *targetComponents = [self.calendar components:unitFlags
                                                                  fromDate:self.selectedDate];
            [targetComponents setMonth:row + 1];
            self.selectedDateComponets = targetComponents;
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
        }
        case 2: {
            NSDateComponents *targetComponents = [self.calendar components:unitFlags
                                                                  fromDate:self.selectedDate];
            [targetComponents setDay:row + 1];
            self.selectedDateComponets = targetComponents;
            break;
        }
        case 3: {
            NSLog(@"%@",self.hourArray[row]);
            NSDateComponents *targetComponents = [self.calendar components:unitFlags
                                                                  fromDate:self.selectedDate];
            [targetComponents setHour:row + 1];
            self.selectedDateComponets = targetComponents;
            break;
        }
        default:
            break;
    }
    [pickerView reloadAllComponents]; // 注意，这一句不能掉，否则选择后每一栏的数据不会重载，其作用与UITableView中的reloadData相似
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
