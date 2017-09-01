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
@interface ViewController ()
@property (nonatomic, strong) YjLineGenericChart *lineChart;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"DidLoad");
    
    if (self.lineChart) {
        [self.lineChart removeFromSuperview];
    }
    self.lineChart = [[YjLineGenericChart alloc] initWithFrame:CGRectMake(10, 100, 400, 300)];
    _lineChart.backgroundColor = [UIColor whiteColor];
    _lineChart.layer.borderColor = [UIColor orangeColor].CGColor;
    _lineChart.layer.borderWidth = 1.0f;
    [self.view addSubview:_lineChart];
    NSArray *yLables = @[@"0\nmin",@"10\nmin",@"20\nmin",@"30\nmin",@"40\nmin"];
    NSArray *xLables = @[@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日"];
    _lineChart.pointData = @[@20,@10,@30.5,@5,@10,@40,@25.567,@8,@33,@15];
    _lineChart.xAxisLables = xLables;
    _lineChart.yAxisLables = yLables;
    _lineChart.dataTitle = @"YjAdair";
    [_lineChart strokeChart];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    if (_lineChart.chartMargin.left == 25.f) {
//        _lineChart.chartMargin = YjChartMarginMake(30, 50, 30, 50);
//    }else {
//        _lineChart.chartMargin = YjChartMarginMake(25, 25, 25, 25);
//    }
//     [_lineChart strokeChart];
    
    _lineChart.lineColor = [UIColor orangeColor];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
