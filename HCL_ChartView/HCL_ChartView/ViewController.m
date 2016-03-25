//
//  ViewController.m
//  HCL_ChartView
//
//  Created by bryantcharyn on 16/3/25.
//  Copyright © 2016年 linkloving. All rights reserved.
//

#import "ViewController.h"
#import "HCL_ChartView.h"
@interface ViewController () <HCL_ChartViewDataSource>
{
    NSArray *dataSourceArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSourceArr = @[@"1",@"2",@"3",@"4",@"5",@"10",@"30",@"1",@"2",@"3",@"4",@"5",@"10",@"30",@"1",@"2",@"3",@"4",@"5",@"10",@"30",@"1",@"2",@"3",@"4",@"5",@"10",@"30",@"1",@"2",@"3",@"4",@"5",@"10",@"30",@"1",@"2",@"3",@"4",@"5",@"10",@"30",@"1",@"2",@"3",@"4",@"5",@"10",];
    // Do any additional setup after loading the view, typically from a nib.
    HCL_ChartView *view = [[HCL_ChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    view.barColor = [UIColor whiteColor];
    
    view.bgColor = [UIColor orangeColor];
    view.xyLabelColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    view.labelTextColor = [UIColor whiteColor];
    view.dataSource = self;
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfX:(HCL_ChartView *)chartView
{
    return dataSourceArr.count;
}
-(NSInteger)numberOfY:(HCL_ChartView *)chartView
{
    return  dataSourceArr.count;
}

-(NSArray *)xTitlesForView:(HCL_ChartView *)chartView
{
    return dataSourceArr;
}
-(NSArray *)yTitlesForView:(HCL_ChartView *)chartView
{
    return dataSourceArr;
}
-(HCLRange)maxAndMinForView:(HCL_ChartView *)chartView
{
    return HCLRangeMake(50, 0);
}
-(NSArray *)ySideLabelsForView:(HCL_ChartView *)chartView
{
    return @[@"0",@"25"];
}
-(NSArray *)xSideLabelsForView:(HCL_ChartView *)chartView
{
    return @[@"12am",@"6am",@"12pm",@"6pm",@"12am"];
}
@end
