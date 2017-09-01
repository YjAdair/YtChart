//
//  YjBarChart.m
//  YtChart
//
//  Created by yankezhi on 2017/9/1.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import "YjBarChart.h"

YjBarChartMargin YjBarChartMarginMake(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom) {
    YjBarChartMargin chartMargin;
    chartMargin.left = left;
    chartMargin.top = top;
    chartMargin.right = right;
    chartMargin.bottom = bottom;
    return chartMargin;
}

@interface YjBarChart ()
/** 坐标轴原点 **/
@property (nonatomic, assign) CGPoint originPoint;
/** X轴长度 **/
@property (nonatomic, assign) CGFloat xAxisLength;
/** Y轴长度 **/
@property (nonatomic, assign) CGFloat yAxisLength;
/** Y轴单元长度 **/
@property (nonatomic, assign) CGFloat yUnitLength;

@end

@implementation YjBarChart

#pragma mark - Initialization
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefaultValus];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefaultValus];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultValus];
    }
    return self;
}

#pragma mark - Config
- (void)setupDefaultValus {
    self.chartMargin = YjBarChartMarginMake(25.f, 25.f, 25.f, 25.f);
    self.backgroundColor = [UIColor whiteColor];
    self.xAxisColor = [UIColor grayColor];
    self.yAxisColor = [UIColor grayColor];
}

- (void)configDrawData {
    self.originPoint = CGPointMake(self.chartMargin.left, CGRectGetHeight(self.frame) - self.chartMargin.top);
    self.xAxisLength = CGRectGetWidth(self.frame) - self.chartMargin.left - self.chartMargin.right;
    self.yAxisLength = CGRectGetHeight(self.frame) - self.chartMargin.top - self.chartMargin.bottom;
    self.yUnitLength = self.yAxisLength/(self.yAxisLables.count - 1);
}

#pragma mark - Draw
- (void)strokeChart {
    [self configDrawData];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    //X轴
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.xAxisColor.CGColor);
    CGContextMoveToPoint(context, self.originPoint.x, self.originPoint.y);
    CGContextAddLineToPoint(context, self.originPoint.x + self.xAxisLength, self.originPoint.y);
    CGContextRestoreGState(context);
    //Y轴
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.yAxisColor.CGColor);
    CGContextMoveToPoint(context, self.originPoint.x, self.originPoint.y);
    CGContextAddLineToPoint(context, self.originPoint.x, self.originPoint.y - self.yAxisLength);
    CGContextStrokePath(context);

    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.yAxisColor.CGColor);
    for (NSInteger index = 1; index < self.yAxisLables.count; index++) {
        CGPoint yPoint = CGPointMake(self.originPoint.x, self.originPoint.y - self.yUnitLength*index);
        CGContextMoveToPoint(context, yPoint.x, yPoint.y);
        CGContextAddLineToPoint(context, self.originPoint.x + self.xAxisLength, yPoint.y);
        CGContextStrokePath(context);
    }
    CGContextStrokePath(context);
}

@end
