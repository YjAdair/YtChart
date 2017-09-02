//
//  YjBarChart.h
//  YtChart
//
//  Created by yankezhi on 2017/9/1.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YjBarChartItem;
typedef struct {
    CGFloat left, top, right, bottom;
} YjBarChartMargin;

@interface YjBarChart : UIView

/** x轴文本 **/
@property (nonatomic, copy) NSArray *xAxisLables;
/** y轴文本 **/
@property (nonatomic, copy) NSArray *yAxisLables;
/** y轴最大值 **/
@property (nonatomic, assign) CGFloat yAxisMaxValue;
/** y轴最小值 **/
@property (nonatomic, assign) CGFloat yAxisMinValue;
/** 坐标轴距离视图的间距 **/
@property (nonatomic) YjBarChartMargin chartMargin;
/** chartData **/
@property (nonatomic, copy) NSArray<YjBarChartItem *> *chartData;
/********************** Color **************************/
/** x轴颜色 **/
@property (nonatomic, strong) UIColor *xAxisColor;
/** y轴颜色 **/
@property (nonatomic, strong) UIColor *yAxisColor;
/** x轴文本颜色 **/
@property (nonatomic, strong) UIColor *xAxisLablesColor;
/** y轴文本颜色 **/
@property (nonatomic, strong) UIColor *yAxisLablesColor;
/********************** ViewsControl **************************/
/** 坐标轴线宽 **/
@property (nonatomic, assign) CGFloat axisLineWidth;
- (void)strokeChart;
- (void)updateChartDataWithBarItem:(YjBarChartItem *)barItem barIndex:(NSInteger)barIndex;
extern YjBarChartMargin YjBarChartMarginMake(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);
@end
