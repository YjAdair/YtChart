//
//  YjLineGenericChart.h
//  YtChart
//
//  Created by yankezhi on 2017/8/29.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YjLineChartItem;

typedef struct {
    CGFloat left, top, right, bottom;
} YjLineChartMargin;

@interface YjLineGenericChart : UIView
/** x轴文本 **/
@property (nonatomic, copy) NSArray *xAxisLables;
/** y轴文本 **/
@property (nonatomic, copy) NSArray *yAxisLables;
/** y轴最大值 **/
@property (nonatomic, assign) CGFloat yAxisMaxValue;
/** y轴最小值 **/
@property (nonatomic, assign) CGFloat yAxisMinValue;
/** 坐标轴距离视图的间距 **/
@property (nonatomic) YjLineChartMargin chartMargin;
/** chartData **/
@property (nonatomic, copy) NSArray<YjLineChartItem *> *chartData;
/********************** Color **************************/
/** x轴文本颜色 **/
@property (nonatomic, strong) UIColor *xAxisLablesColor;
/** y轴文本颜色 **/
@property (nonatomic, strong) UIColor *yAxisLablesColor;
/** x轴颜色 **/
@property (nonatomic, strong) UIColor *xAxisColor;
/** y轴颜色 **/
@property (nonatomic, strong) UIColor *yAxisColor;
/********************** ViewControl **************************/
/** 是否展示x轴上的网格 默认YES**/
@property (nonatomic, assign) BOOL showXGridLine;
/** 是否展示y轴上的网格 默认YES**/
@property (nonatomic, assign) BOOL showYGridLine;
/********************** Function **************************/
- (void)strokeChart;
- (void)updateChartDataWithChartItem:(YjLineChartItem *)chartItem;
extern YjLineChartMargin YjChartMarginMake(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);
@end
