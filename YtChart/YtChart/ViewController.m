//
//  ViewController.m
//  YtChart
//
//  Created by yankezhi on 2017/8/11.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import "ViewController.h"
#import "YjLineGenericChart.h"
#import "YjLineChartItem.h"
#import "YjBarChart.h"
#import "YjBarChartItem.h"
@interface ViewController ()
@property (nonatomic, strong) YjLineGenericChart *lineChart;
@property (nonatomic, strong) YjBarChart *barChart;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"DidLoad");
    
    if (self.lineChart) {
        [self.lineChart removeFromSuperview];
    }
    self.lineChart = [[YjLineGenericChart alloc] initWithFrame:CGRectMake(10, 100, 400, 300)];
    _lineChart.layer.borderColor = [UIColor orangeColor].CGColor;
    _lineChart.layer.borderWidth = 1.0f;
    [self.view addSubview:_lineChart];
    _lineChart.xAxisLables = @[@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日"];
    _lineChart.yAxisLables = @[@"0\nmin",@"10\nmin",@"20\nmin",@"30\nmin",@"40\nmin"];
    _lineChart.yAxisMaxValue = 40.f;
    _lineChart.yAxisMinValue = 0.f;
    
    YjLineChartItem *chartItem1 = [[YjLineChartItem alloc] init];
    chartItem1.pointData = @[@20,@10,@30.5,@5,@10,@40,@25.567,@8,@33,@15];
    chartItem1.dataTitle = @"YjAdair";
    chartItem1.showPointLable = NO;
    YjLineChartItem *chartItem2 = [[YjLineChartItem alloc] init];
    chartItem2.pointData = @[@30,@15,@5,@15,@0,@35,@38,@22,@30,@30];
    chartItem2.dataTitle = @"Stark";
    chartItem2.pathColor = [UIColor orangeColor];
    chartItem2.pointColor = [UIColor orangeColor];
    chartItem2.showPointLable = NO;
    YjLineChartItem *chartItem3 = [[YjLineChartItem alloc] init];
    chartItem3.pointData = @[@0,@26,@40,@40,@35,@35,@33,@11,@13.5,@0];
    chartItem3.dataTitle = @"Snow";
    chartItem3.pathColor = [UIColor purpleColor];
    chartItem3.pointColor = [UIColor purpleColor];
    chartItem3.showPointLable = NO;
    _lineChart.chartData = @[chartItem1,chartItem2,chartItem3];
    [_lineChart strokeChart];
    
    self.barChart = [[YjBarChart alloc] initWithFrame:CGRectMake(10, 450, 400, 200)];
    _barChart.layer.borderColor = [UIColor orangeColor].CGColor;
    _barChart.layer.borderWidth = 1.0f;
    _barChart.yAxisMaxValue = 40.f;
    _barChart.yAxisMinValue = 0.f;
    _barChart.xAxisLables = @[@"Mon",@"Tue",@"Web",@"Thu",@"Fn",@"Sat",@"Sun"];
    _barChart.yAxisLables = @[@"0\nmin",@"10\nmin",@"20\nmin",@"30\nmin",@"40\nmin"];
    [self.view addSubview:_barChart];
    
    YjBarChartItem *barItem1 = [[YjBarChartItem alloc] init];
    barItem1.barData = @[@20,@10,@30.5,@5,@10,@40,@33];
    barItem1.dataTitle = @"YjAdair";
    
    YjBarChartItem *barItem3 = [[YjBarChartItem alloc] init];
    barItem3.barData = @[@5,@26,@40,@40,@35,@35,@33];
    barItem3.fillColor = [UIColor brownColor];
    barItem3.dataTitle = @"Snow";
    
    _barChart.chartData = @[barItem1,barItem3];
    [_barChart strokeChart];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

//    if (_lineChart.chartMargin.left == 25.f) {
//        _lineChart.chartMargin = YjChartMarginMake(30, 50, 30, 50);
//    }else {
//        _lineChart.chartMargin = YjChartMarginMake(25, 25, 25, 25);
//    }
    
//    self.lineChart.frame = CGRectMake(10, 100, 300, 200);
//    [self.lineChart strokeChart];
//    self.lineChart.chartData.lastObject.pointData = @[@20,@10,@30.5,@5,@10,@40,@25.567,@8,@33,@15];
//    [_lineChart updateChartDataWithChartItem:self.lineChart.chartData.lastObject];
    
//    NSArray *pathColors = @[[UIColor purpleColor],[UIColor brownColor],[UIColor blueColor]];
//    for (NSInteger index = 0; index < self.lineChart.chartData.count;index++ ) {
//        YjLineChartItem *chartItem = self.lineChart.chartData[index];
//        chartItem.pathColor = pathColors[index];
//        chartItem.pointColor = pathColors[index];
//    }
//    [_lineChart strokeChart];
    
//    if (_lineChart.pointColor == [UIColor orangeColor]) {
//        _lineChart.pointColor = [UIColor blackColor];
//        _lineChart.pointColors = @[[UIColor orangeColor],[UIColor blueColor],[UIColor redColor],[UIColor yellowColor],[UIColor blackColor],[UIColor lightGrayColor],[UIColor brownColor],[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor]];
//        _lineChart.lineColor = [UIColor brownColor];
//    }else {
//        _lineChart.pointColor = [UIColor orangeColor];
//    }
    
//    _lineChart.pointLabelColor = [UIColor orangeColor];
    
//    _lineChart.xAxisLablesColor = [UIColor orangeColor];
//    _lineChart.yAxisLablesColor = [UIColor orangeColor];
    
//    _lineChart.xAxisColor = [UIColor orangeColor];
//    _lineChart.yAxisColor = [UIColor blueColor];
    
   
//    if (_lineChart.showYGridLine) {
//        _lineChart.showXGridLine = YES;
//        _lineChart.showYGridLine = NO;
//    }else {
//        _lineChart.showXGridLine = NO;
//        _lineChart.showYGridLine = YES;
//    }

    /********************** Bar **************************/
//    NSArray *pathColors = @[[UIColor purpleColor],[UIColor brownColor],[UIColor blueColor]];
//    for (NSInteger index = 0; index < self.barChart.chartData.count;index++ ) {
//        YjBarChartItem *chartItem = self.barChart.chartData[index];
//        chartItem.fillColor = pathColors[index];
//    }
    self.barChart.chartData.lastObject.barData = @[@30,@15,@5,@15,@0,@35,@38];
    [_barChart updateChartDataWithBarItem:self.barChart.chartData.lastObject barIndex:self.barChart.chartData.count-1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
