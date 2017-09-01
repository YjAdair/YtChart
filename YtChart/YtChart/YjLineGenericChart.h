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
/** 元数据 **/
@property (nonatomic, copy) NSArray *pointData;
/** 元数据标题 **/
@property (nonatomic, copy) NSString *dataTitle;
/** 坐标轴距离视图的间距 **/
@property (nonatomic) YjLineChartMargin chartMargin;
/********************** Color **************************/
/** lineColor **/
@property (nonatomic, strong) UIColor *lineColor;
/** pointColor全局设置 **/
@property (nonatomic, strong) UIColor *pointColor;
/** pointColor集合 **/
@property (nonatomic, copy) NSArray<UIColor *> *pointColors;
/** point文本颜色 **/
@property (nonatomic, strong) UIColor *pointLabelColor;
/** x轴文本颜色 **/
@property (nonatomic, strong) UIColor *xAxisLablesColor;
/** y轴文本颜色 **/
@property (nonatomic, strong) UIColor *yAxisLablesColor;
/** x轴颜色 **/
@property (nonatomic, strong) UIColor *xAxisColor;
/** y轴颜色 **/
@property (nonatomic, strong) UIColor *yAxisColor;
/********************** ViewControl **************************/
/** 是否展示x轴上的网格 **/
@property (nonatomic, assign) BOOL showXGridLine;
/** 是否展示y轴上的网格 **/
@property (nonatomic, assign) BOOL showYGridLine;
/********************** Function **************************/
- (void)strokeChart;
extern YjLineChartMargin YjChartMarginMake(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);
@end
