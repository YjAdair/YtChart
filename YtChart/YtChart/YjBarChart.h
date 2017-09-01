//
//  YjBarChart.h
//  YtChart
//
//  Created by yankezhi on 2017/9/1.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat left, top, right, bottom;
} YjBarChartMargin;

@interface YjBarChart : UIView

/** y轴文本 **/
@property (nonatomic, copy) NSArray *yAxisLables;
/** 坐标轴距离视图的间距 **/
@property (nonatomic) YjBarChartMargin chartMargin;
/********************** Color **************************/
/** x轴颜色 **/
@property (nonatomic, strong) UIColor *xAxisColor;
/** y轴颜色 **/
@property (nonatomic, strong) UIColor *yAxisColor;
- (void)strokeChart;
extern YjBarChartMargin YjBarChartMarginMake(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom);
@end
