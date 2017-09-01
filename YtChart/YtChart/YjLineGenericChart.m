//
//  YjLineGenericChart.m
//  YtChart
//
//  Created by yankezhi on 2017/8/29.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import "YjLineGenericChart.h"
#import "YjLineChartItem.h"
#import <CoreText/CoreText.h>
#import "YjChartColor.h"
YjLineChartMargin YjChartMarginMake(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom) {
    YjLineChartMargin chartMargin;
    chartMargin.left = left;
    chartMargin.top = top;
    chartMargin.right = right;
    chartMargin.bottom = bottom;
    return chartMargin;
}
@interface _YjlinkedMapNode : NSObject

/** 前一个点 **/
@property (nonatomic, weak) _YjlinkedMapNode *_prePoint;
/** 后一个点 **/
@property (nonatomic, weak) _YjlinkedMapNode *_nextPoint;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat data;
/** pointLayer **/
@property (nonatomic, strong) CAShapeLayer *pointLayer;
/** pointText **/
@property (nonatomic, strong) CATextLayer *pointText;
@end
@implementation _YjlinkedMapNode
@end

@interface _YjLegendModule : UIView
/** 说明文本 **/
@property (nonatomic, strong) UILabel *legendTitle;
/** 说明标示 **/
@property (nonatomic, strong) UIView *legendView;
@end
@implementation _YjLegendModule
@end

@interface YjLineGenericChart ()
/** 所有point数据 **/
@property (nonatomic, strong) NSMutableArray<_YjlinkedMapNode *> *chartPointArray;
/** X轴节点文本 **/
@property (nonatomic, strong) NSMutableArray *xAxisLableViews;
/** Y轴节点文本 **/
@property (nonatomic, strong) NSMutableArray *yAxisLableViews;
/** 说明模块集 **/
@property (nonatomic, strong) NSMutableArray<_YjLegendModule *> *legends;
/** 最后一个单元线距坐标轴末尾的长度 **/
@property (nonatomic, assign) CGFloat axisMargin;
/** 坐标轴原点 **/
@property (nonatomic, assign) CGPoint originPoint;
/** X轴长度 **/
@property (nonatomic, assign) CGFloat xAxisLength;
/** Y轴长度 **/
@property (nonatomic, assign) CGFloat yAxisLength;
/** X轴单元长度 **/
@property (nonatomic, assign) CGFloat xUnitLength;
/** Y轴单元长度 **/
@property (nonatomic, assign) CGFloat yUnitLength;
/** 数据路径 **/
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@end

@implementation YjLineGenericChart

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
    
    self.chartMargin = YjChartMarginMake(25.f, 25.f, 25.f, 25.f);
    self.lineColor = YjBlueChartColor;
    self.pointColor = YjBlueChartColor;
    self.pointLabelColor = [UIColor blackColor];
    self.xAxisLablesColor = [UIColor blackColor];
    self.yAxisLablesColor = [UIColor blackColor];
    self.xAxisColor = [UIColor blackColor];
    self.yAxisColor = [UIColor blackColor];
    self.showXGridLine = YES;
    self.showYGridLine = YES;
    self.axisMargin = 10;
    self.chartPointArray = [NSMutableArray array];
    self.xAxisLableViews = [NSMutableArray array];
    self.yAxisLableViews = [NSMutableArray array];
    self.legends = [NSMutableArray array];
}

- (void)configDrawData {
    self.originPoint = CGPointMake(self.chartMargin.left, CGRectGetHeight(self.frame) - self.chartMargin.top);
    self.xAxisLength = CGRectGetWidth(self.frame) - self.chartMargin.left - self.chartMargin.right;
    self.yAxisLength = CGRectGetHeight(self.frame) - self.chartMargin.top - self.chartMargin.bottom;
    self.xUnitLength = (self.xAxisLength-self.axisMargin)/(self.xAxisLables.count - 1);
    self.yUnitLength = (self.yAxisLength-self.axisMargin)/(self.yAxisLables.count - 1);
}
#pragma mark - Draw
- (void)strokeChart {
    
    [self removeLayer];
    [self configDrawData];
    [self strokeDataTitle];
    [self strokeLinePath];
    [self strokePoint];
    [self strokeYAxisLabel];
    [self strokeXAxisLable];
    [self setNeedsDisplay];
}

- (void)strokeLinePath {
    
    CGFloat yAxisMaxValue = 40.f;
    CGFloat yAxisMinValue = 0.0f;
    self.lineLayer = [CAShapeLayer layer];
    _lineLayer.lineCap = kCALineCapRound;
    _lineLayer.lineJoin = kCALineJoinBevel;
    _lineLayer.fillColor = [UIColor clearColor].CGColor;
    _lineLayer.lineWidth = 2.0f;
    _lineLayer.strokeColor = self.lineColor.CGColor;
    _lineLayer.strokeStart = 0.0f;
    _lineLayer.strokeEnd = 0.0;
    _lineLayer.opacity = 0.0f;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (NSInteger index = 0;index < self.pointData.count ; index++) {
        
        CGFloat scaleY = ([self.pointData[index] floatValue] - yAxisMinValue)/(yAxisMaxValue - yAxisMinValue);
        CGFloat y = self.originPoint.y - self.yUnitLength*(self.yAxisLables.count-1)*scaleY;
        CGFloat x = self.xUnitLength*index + self.chartMargin.left;
        CGPoint point = CGPointMake(x, y);
        if (index == 0) {
            [linePath moveToPoint:point];
        }else {
            [linePath addLineToPoint:point];
        }
        
        _YjlinkedMapNode *node = [[_YjlinkedMapNode alloc] init];
        node.point = point;
        node.data = [self.pointData[index] floatValue];
        _YjlinkedMapNode *lastNode = self.chartPointArray.lastObject;
        if (lastNode) {
            node._prePoint = lastNode;
            lastNode._nextPoint = node;
        }
        [self.chartPointArray addObject:node];
    }
    _lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:_lineLayer];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_lineLayer addAnimation:animation forKey:@"lineLayer_StrokeAnimation"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @1.0f;
    fadeAnimation.duration = 1.0f;
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.fillMode = kCAFillModeForwards;
    [_lineLayer addAnimation:fadeAnimation forKey:@"lineLayer_OpacityAnimation"];
}

- (void)strokePoint {
    NSInteger xItems = self.xAxisLables.count;
    for (NSInteger index = 0; index < self.chartPointArray.count; index++) {
        _YjlinkedMapNode *node = self.chartPointArray[index];
        /** 创建point Text **/
        CATextLayer *pointText = [CATextLayer layer];
        node.pointText = pointText;
        pointText.alignmentMode = kCAAlignmentCenter;
        pointText.foregroundColor = self.pointLabelColor.CGColor;
        pointText.backgroundColor = [UIColor clearColor].CGColor;
        UIFont *font = [UIFont systemFontOfSize:8];
        pointText.font = (__bridge CFTypeRef _Nullable)(font);
        pointText.fontSize = font.pointSize;
        pointText.contentsScale = [UIScreen mainScreen].scale;
        pointText.wrapped = YES;
        pointText.opacity = 0.0f;
        pointText.string = [[NSString alloc] initWithFormat:@"%.2f",node.data];
        pointText.frame = CGRectMake(0, 0, (self.xAxisLength-10)/(xItems-1), pointText.fontSize);
        CGFloat x = 0;
        CGFloat y = 0;
        if (node._nextPoint) {
            if (node._nextPoint.point.y > node.point.y) {
                y = node.point.y - pointText.fontSize;
            }else {
                y = node.point.y + pointText.fontSize;
            }
        }else {
            if (node._prePoint.point.y > node.point.y) {
                y = node.point.y - pointText.fontSize;
            }else {
                y = node.point.y + pointText.fontSize;
            }
        }
        if (node._nextPoint && node._prePoint) {
            if ((node.point.y > node._prePoint.point.y && node.point.y < node._nextPoint.point.y) || (node.point.y < node._prePoint.point.y && node.point.y > node._nextPoint.point.y)) {
                x = node.point.x + pointText.frame.size.width/2;
            }else {
                x = node.point.x;
            }
        }else {
            x = node.point.x;
        }
        if (x == self.chartMargin.left) {
            x = node.point.x + pointText.frame.size.width/2;
        }
        pointText.position = CGPointMake(x, y);
        [self.layer addSublayer:pointText];
        /** 创建point Layer **/
        CAShapeLayer *pointLayer = [CAShapeLayer layer];
        node.pointLayer = pointLayer;
        pointLayer.frame = CGRectMake(0, 0, 8, 8);
        pointLayer.position = node.point;
        pointLayer.fillColor = self.pointColor.CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:pointLayer.bounds];
        pointLayer.path = path.CGPath;
        [self.layer addSublayer:pointLayer];
        
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue = @0.0f;
        fadeAnimation.toValue = @1.0f;
        fadeAnimation.duration = 1.0f;
        fadeAnimation.removedOnCompletion = NO;
        fadeAnimation.fillMode = kCAFillModeForwards;
        [pointText addAnimation:fadeAnimation forKey:@"pointText_OpacityAnimation"];
        [pointLayer addAnimation:fadeAnimation forKey:@"pointText_OpacityAnimation"];
    }
}

- (void)strokeYAxisLabel {
    
    for (NSInteger index = 0; index < self.yAxisLables.count; index++) {
        UILabel *lable = [[UILabel alloc] init];
        lable.text = self.yAxisLables[index];
        lable.font = [UIFont systemFontOfSize:8];
        lable.textColor = self.yAxisLablesColor;
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.frame = CGRectMake(0, 0, self.chartMargin.left, self.yUnitLength);
        CGPoint tempCenter = lable.center;
        tempCenter.y = self.originPoint.y - lable.frame.size.height*index;
        lable.center = tempCenter;
        [self addSubview:lable];
        [self.xAxisLableViews addObject:lable];
    }
}

- (void)strokeXAxisLable {
    
    for (NSInteger index = 0; index < self.xAxisLables.count; index++) {
        UILabel *lable = [[UILabel alloc] init];
        lable.text = self.xAxisLables[index];
        lable.font = [UIFont systemFontOfSize:8];
        lable.textColor = self.xAxisLablesColor;
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.contentMode = UIViewContentModeTop;
        lable.frame = CGRectMake(self.chartMargin.left, self.originPoint.y + 5, self.xUnitLength, self.chartMargin.bottom);
        [lable sizeToFit];
        if (index != 0) {
            CGPoint tempCenter = lable.center;
            tempCenter.x = self.xUnitLength*index + self.chartMargin.left;
            lable.center = tempCenter;
        }
        [self addSubview:lable];
        [self.yAxisLableViews addObject:lable];
    }
}

- (void)strokeDataTitle {
    
    UILabel *dataTitle = [UILabel new];
    dataTitle.text = self.dataTitle;
    dataTitle.font = [UIFont systemFontOfSize:10];
    dataTitle.textColor = [UIColor blackColor];
    [dataTitle sizeToFit];
    CGFloat indicateWH = CGRectGetHeight(dataTitle.frame);
    
    UIView *dataIndicate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, indicateWH, indicateWH)];
    dataIndicate.layer.cornerRadius = 3;
    dataIndicate.layer.masksToBounds = YES;
    dataIndicate.backgroundColor = self.lineColor;
    dataTitle.frame = CGRectMake(CGRectGetMaxX(dataIndicate.frame) + 5, 0, CGRectGetWidth(dataTitle.frame), indicateWH);
    
    _YjLegendModule *module = [[_YjLegendModule alloc] initWithFrame:CGRectMake(self.originPoint.x + self.xAxisLength - CGRectGetMaxX(dataTitle.frame), self.chartMargin.top - CGRectGetHeight(dataTitle.frame), CGRectGetMaxX(dataTitle.frame), indicateWH)];
    module.legendTitle = dataTitle;
    module.legendView = dataIndicate;
    [module addSubview:dataTitle];
    [module addSubview:dataIndicate];
    [self addSubview:module];
    [self.legends addObject:module];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
     /** 绘制 **/
    CGContextSetLineWidth(context, 1.0);
    //X轴
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.xAxisColor.CGColor);
    CGContextMoveToPoint(context, self.originPoint.x, self.originPoint.y);
    CGContextAddLineToPoint(context, self.originPoint.x + self.xAxisLength, self.originPoint.y);
    CGContextStrokePath(context);
        //X轴箭头
    CGContextMoveToPoint(context, self.xAxisLength + self.chartMargin.left - 5, self.yAxisLength + self.chartMargin.top - 5);
    CGContextAddLineToPoint(context, self.xAxisLength + self.chartMargin.left, self.yAxisLength + self.chartMargin.top);
    CGContextAddLineToPoint(context, self.xAxisLength + self.chartMargin.left - 5, self.yAxisLength + self.chartMargin.top+ 5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    //Y轴
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.yAxisColor.CGColor);
    CGContextMoveToPoint(context, self.originPoint.x, self.originPoint.y);
    CGContextAddLineToPoint(context, self.originPoint.x, self.originPoint.y - self.yAxisLength);
    CGContextStrokePath(context);
        //Y轴箭头
    CGContextMoveToPoint(context, self.chartMargin.left - 5, self.chartMargin.top + 5);
    CGContextAddLineToPoint(context, self.chartMargin.left, self.chartMargin.top);
    CGContextAddLineToPoint(context, self.chartMargin.left + 5, self.chartMargin.top + 5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    //X轴单元线
    NSInteger xItems = self.xAxisLables.count;
    NSInteger yItems = self.yAxisLables.count;
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.xAxisColor.CGColor);
    for (NSInteger index = 1;index < xItems ; index++) {
        CGPoint xPoint = CGPointMake(self.xUnitLength*index + self.originPoint.x, self.originPoint.y);
        CGContextMoveToPoint(context, xPoint.x, self.originPoint.y);
        CGContextAddLineToPoint(context, xPoint.x, self.originPoint.y - 5);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    //Y轴单元线
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.yAxisColor.CGColor);
    for (NSInteger index = 1; index < yItems; index++) {
        CGPoint yPoint = CGPointMake(self.originPoint.x, self.originPoint.y - self.yUnitLength*index);
        CGContextMoveToPoint(context, self.originPoint.x, yPoint.y);
        CGContextAddLineToPoint(context, self.originPoint.x + 5, yPoint.y);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    //网格
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat dash[] = {6, 5};
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineDash(context, 0.0, dash, 2);
    if (_showXGridLine) {
        for (NSInteger index = 1;index < xItems ; index++) {
            CGPoint xPoint = CGPointMake(self.xUnitLength*index + self.originPoint.x, self.originPoint.y);
            CGContextMoveToPoint(context, xPoint.x, xPoint.y - 5);
            CGContextAddLineToPoint(context, xPoint.x, self.axisMargin + self.chartMargin.top);
            CGContextStrokePath(context);
        }
    }
    if (_showYGridLine) {
        for (NSInteger index = 1; index < yItems; index++) {
            CGPoint yPoint = CGPointMake(self.originPoint.x, self.originPoint.y - self.yUnitLength*index);
            CGContextMoveToPoint(context, yPoint.x + 5, yPoint.y);
            CGContextAddLineToPoint(context, self.originPoint.x + self.xUnitLength*(xItems - 1), yPoint.y);
            CGContextStrokePath(context);
        }
    }
    CGContextRestoreGState(context);
}

#pragma mark - Private
- (void)removeLayer {
    [self.lineLayer removeFromSuperlayer];
    for (_YjlinkedMapNode *node in self.chartPointArray) {
        if (node.pointLayer) {
            [node.pointLayer removeFromSuperlayer];
            node.pointLayer = nil;
        }
        if (node.pointText) {
            [node.pointText removeFromSuperlayer];
            node.pointText = nil;
        }
    }
    [self.chartPointArray removeAllObjects];
    for (UILabel *lable in self.xAxisLableViews) {
        [lable removeFromSuperview];
    }
    for (UILabel *lable in self.yAxisLableViews) {
        [lable removeFromSuperview];
    }
    [self.xAxisLableViews removeAllObjects];
    [self.yAxisLableViews removeAllObjects];
}

#pragma mark - Accessors
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    if (self.lineLayer) {
        self.lineLayer.strokeColor = lineColor.CGColor;
        self.legends.lastObject.legendView.backgroundColor = lineColor;
    }
}

- (void)setPointColor:(UIColor *)pointColor {
    _pointColor = pointColor;
    if (self.chartPointArray.count == 0) return;
    for (_YjlinkedMapNode *node in self.chartPointArray) {
        node.pointLayer.fillColor = pointColor.CGColor;
    }
}

- (void)setPointColors:(NSArray *)pointColors {
    _pointColors = pointColors;
    if (self.chartPointArray.count == 0) return;
    if (self.pointData.count != pointColors.count) {
        NSLog(@"pointColors count is not equal pointData count");
        return;
    }
    for (NSInteger index = 0; index < self.pointColors.count; index++) {
        _YjlinkedMapNode *node = self.chartPointArray[index];
        node.pointLayer.fillColor = self.pointColors[index].CGColor;
    }
}

- (void)setPointLabelColor:(UIColor *)pointLabelColor {
    _pointLabelColor = pointLabelColor;
    if (self.chartPointArray.count == 0) return;
    for (_YjlinkedMapNode *node in self.chartPointArray) {
        node.pointText.foregroundColor = pointLabelColor.CGColor;
    }
}

- (void)setXAxisLablesColor:(UIColor *)xAxisLablesColor {
    _xAxisLablesColor = xAxisLablesColor;
    if (self.xAxisLableViews.count == 0) return;
    for (UILabel *lable in self.xAxisLableViews) {
        lable.textColor = xAxisLablesColor;
    }
}

- (void)setYAxisLablesColor:(UIColor *)yAxisLablesColor {
    _yAxisLablesColor = yAxisLablesColor;
    if (self.yAxisLableViews.count == 0) return;
    for (UILabel *lable in self.yAxisLableViews) {
        lable.textColor = yAxisLablesColor;
    }
}

- (void)setXAxisColor:(UIColor *)xAxisColor {
    _xAxisColor = xAxisColor;
    [self setNeedsDisplay];
}

- (void)setYAxisColor:(UIColor *)yAxisColor {
    _yAxisColor = yAxisColor;
    [self setNeedsDisplay];
}

- (void)setShowXGridLine:(BOOL)showXGridLine {
    _showXGridLine = showXGridLine;
    [self setNeedsDisplay];
}

- (void)setShowYGridLine:(BOOL)showYGridLine {
    _showYGridLine = showYGridLine;
    [self setNeedsDisplay];
}
@end
