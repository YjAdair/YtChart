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

@interface YjLineGenericChart ()<CAAnimationDelegate>

/** X轴节点文本 **/
@property (nonatomic, strong) NSMutableArray *xAxisLableViews;
/** Y轴节点文本 **/
@property (nonatomic, strong) NSMutableArray *yAxisLableViews;
///** 说明模块集 **/
//@property (nonatomic, strong) NSMutableArray<_YjLegendModule *> *legends;
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
    self.backgroundColor = [UIColor whiteColor];
    self.xAxisLablesColor = [UIColor blackColor];
    self.yAxisLablesColor = [UIColor blackColor];
    self.xAxisColor = [UIColor blackColor];
    self.yAxisColor = [UIColor blackColor];
    self.axisMargin = 10;
    self.xAxisLableViews = [NSMutableArray array];
    self.yAxisLableViews = [NSMutableArray array];
    self.showXGridLine = YES;
    self.showYGridLine = YES;
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
    
    [self removeLayersAndViews];
    [self configDrawData];
    [self strokeDataTitle];
    [self strokeLinePath];
    [self strokePoint];
    [self strokeYAxisLabel];
    [self strokeXAxisLable];
    [self configAnimation];
    [self setNeedsDisplay];
}

- (void)strokeDataTitle {
    
    BOOL isExistTitle = NO;
    for (YjLineChartItem *chartItem in self.chartData) {
        if (chartItem.dataTitle) {
            isExistTitle = YES;
            break;
        }
    }
    if (!isExistTitle) return;
    for (NSInteger index = 0; index < self.chartData.count; index++) {
        YjLineChartItem *chartItem = self.chartData[index];
        UILabel *dataTitle = [UILabel new];
        dataTitle.text = chartItem.dataTitle;
        dataTitle.font = [UIFont systemFontOfSize:10];
        dataTitle.textColor = [UIColor blackColor];
        [dataTitle sizeToFit];
        CGFloat indicateWH = CGRectGetHeight(dataTitle.frame);
        
        UIView *dataIndicate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, indicateWH, indicateWH)];
        dataIndicate.layer.cornerRadius = 3;
        dataIndicate.layer.masksToBounds = YES;
        dataIndicate.backgroundColor = chartItem.pathColor;
        dataTitle.frame = CGRectMake(CGRectGetMaxX(dataIndicate.frame) + 5, 0, CGRectGetWidth(dataTitle.frame), indicateWH);
        
        CGFloat x = self.originPoint.x + self.xAxisLength - CGRectGetMaxX(dataTitle.frame);
        CGFloat y = self.chartMargin.top - CGRectGetHeight(dataTitle.frame);
        CGFloat w = CGRectGetMaxX(dataTitle.frame);
        CGFloat h = indicateWH;
        if (index != 0) {
            _YjLegendModule *preModule = self.chartData[index - 1].module;
            if (preModule) {
                x = preModule.frame.origin.x - w - 5;
            }
        }
        _YjLegendModule *module = [[_YjLegendModule alloc] initWithFrame:CGRectMake(x, y, w, h)];
        chartItem.module = module;
        module.legendTitle = dataTitle;
        module.legendView = dataIndicate;
        [module addSubview:dataTitle];
        [module addSubview:dataIndicate];
        [self addSubview:module];
    }
}

- (void)strokeLinePath {
    
    for (YjLineChartItem *chartItem in self.chartData) {
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        chartItem.pathLayer = pathLayer;
        pathLayer.lineCap = kCALineCapRound;
        pathLayer.lineJoin = kCALineJoinBevel;
        pathLayer.fillColor = [UIColor clearColor].CGColor;
        pathLayer.lineWidth = 2.0f;
        pathLayer.strokeColor = chartItem.pathColor.CGColor;
        pathLayer.strokeStart = 0.0f;
        pathLayer.strokeEnd = 0.0;
        pathLayer.opacity = 0.0f;
        pathLayer.path = [self preparePointPathWithChartItem:chartItem].CGPath;
        [self.layer addSublayer:pathLayer];
    }
}

- (void)strokePoint {
    
    NSInteger xItems = self.xAxisLables.count;
    for (YjLineChartItem *chartItem in self.chartData) {
        if (!chartItem.showPointLayer && !chartItem.showPointLable) continue;
        for (NSInteger index = 0; index < chartItem.chartPointArray.count; index++) {
            _YjlinkedMapNode *node = chartItem.chartPointArray[index];
            /** 创建point Text **/
            if (chartItem.showPointLable) {
                CATextLayer *pointText = [CATextLayer layer];
                node.pointText = pointText;
                pointText.alignmentMode = kCAAlignmentCenter;
                pointText.foregroundColor = chartItem.pointLabelColor.CGColor;
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
                if (y == self.originPoint.y + pointText.fontSize) {
                    y = node.point.y - font.pointSize*3/2;
                }
                pointText.position = CGPointMake(x, y);
                [self.layer addSublayer:pointText];
            }
            
            if (chartItem.showPointLayer) {
                /** 创建point Layer **/
                CAShapeLayer *pointLayer = [CAShapeLayer layer];
                node.pointLayer = pointLayer;
                pointLayer.frame = CGRectMake(0, 0, 8, 8);
                pointLayer.position = node.point;
                pointLayer.fillColor = chartItem.pointColor.CGColor;
                UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:pointLayer.bounds];
                pointLayer.path = path.CGPath;
                [self.layer addSublayer:pointLayer];
            }
        }
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

#pragma mark - Public
- (void)updateChartDataWithChartItem:(YjLineChartItem *)chartItem {
    
    if (!chartItem.pathLayer) return;
    UIBezierPath *newestPath = [self preparePointPathWithChartItem:chartItem];
    [self setPathAnimationWithLayer:chartItem.pathLayer newestPath:newestPath.CGPath animationKey:@"pathLayer"];
    for (_YjlinkedMapNode *node in chartItem.chartPointArray) {
        [self setPositionAnimationWithLayer:node.pointLayer newestPoint:node.point animationKey:@"pointLayer"];
    }
}

#pragma mark - Private
- (UIBezierPath *)preparePointPathWithChartItem:(YjLineChartItem *)chartItem {
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (NSInteger index = 0;index < chartItem.pointData.count ; index++) {
        CGFloat scaleY = ([chartItem.pointData[index] floatValue] - self.yAxisMinValue)/(self.yAxisMaxValue - self.yAxisMinValue);
        CGFloat y = self.originPoint.y - self.yUnitLength*(self.yAxisLables.count-1)*scaleY;
        CGFloat x = self.xUnitLength*index + self.chartMargin.left;
        CGPoint point = CGPointMake(x, y);
        if (index == 0) {
            [linePath moveToPoint:point];
        }else {
            [linePath addLineToPoint:point];
        }
        
        _YjlinkedMapNode *node = nil;
        if (index < chartItem.chartPointArray.count) {
              node = chartItem.chartPointArray[index];
        }
        if (!node) {
            node = [[_YjlinkedMapNode alloc] init];
        }
        node.point = point;
        node.data = [chartItem.pointData[index] floatValue];
        _YjlinkedMapNode *lastNode = chartItem.chartPointArray.lastObject;
        if (lastNode) {
            node._prePoint = lastNode;
            lastNode._nextPoint = node;
        }
        [chartItem.chartPointArray addObject:node];
    }
    return linePath;
}

- (void)removeLayersAndViews {
    
    for (YjLineChartItem *chartItem in self.chartData) {
        [chartItem.pathLayer removeFromSuperlayer];
        for (_YjlinkedMapNode *node in chartItem.chartPointArray) {
            if (node.pointLayer) {
                [node.pointLayer removeFromSuperlayer];
            }
            if (node.pointText) {
                [node.pointText removeFromSuperlayer];
            }
        }
        [chartItem.chartPointArray removeAllObjects];
        [chartItem.module removeFromSuperview];
    }
    for (UIView *view in self.xAxisLableViews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.yAxisLableViews) {
        [view removeFromSuperview];
    }
    [self.xAxisLableViews removeAllObjects];
    [self.yAxisLableViews removeAllObjects];
}

#pragma mark - Animation
- (void)configAnimation {
    
    for (YjLineChartItem *chartItem in self.chartData) {
        /** pathLayer **/
        [self setStrokeEndAnimationWithLayer:chartItem.pathLayer animationKey:@"lineLayer"];
        [self setFadeAnimationWithLayer:chartItem.pathLayer animationKey:@"lineLayer"];
        /** pointLayer\pointText **/
        for (_YjlinkedMapNode *node in chartItem.chartPointArray) {
            [self setFadeAnimationWithLayer:node.pointLayer animationKey:@"pointLayer"];
            [self setFadeAnimationWithLayer:node.pointText animationKey:@"pointText"];
        }
    }
}

- (void)setFadeAnimationWithLayer:(CALayer *)layer animationKey:(NSString *)animationKey {
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @1.0f;
    fadeAnimation.duration = 1.0f;
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.fillMode = kCAFillModeForwards;
    [layer addAnimation:fadeAnimation forKey:[NSString stringWithFormat:@"%@_OpacityAnimation",animationKey]];
}

- (void)setStrokeEndAnimationWithLayer:(CALayer *)layer animationKey:(NSString *)animationKey {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:[NSString stringWithFormat:@"%@_StrokeAnimation",animationKey]];
}

- (void)setPathAnimationWithLayer:(CAShapeLayer *)layer newestPath:(CGPathRef )newestPath animationKey:(NSString *)animationKey {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id _Nullable)(layer.path);
    pathAnimation.toValue = (__bridge id _Nullable)(newestPath);
    pathAnimation.duration = 0.5;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
//    [pathAnimation setValue:layer forKey:@"layer_path_identity"];
//    [pathAnimation setValue:(__bridge id _Nullable)(newestPath) forKey:@"layer_path_newestPath"];
//    pathAnimation.delegate = self;
    [layer addAnimation:pathAnimation forKey:[NSString stringWithFormat:@"%@_PathAnimation",animationKey]];
}

- (void)setPositionAnimationWithLayer:(CAShapeLayer *)layer newestPoint:(CGPoint)newestPoint animationKey:(NSString *)animationKey {
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:newestPoint];
    positionAnimation.duration = 0.5;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
//    [positionAnimation setValue:layer forKey:@"layer_position_identity"];
//    [positionAnimation setValue:[NSValue valueWithCGPoint:newestPoint] forKey:@"layer_position_newestPath"];
//    positionAnimation.delegate = self;
    [layer addAnimation:positionAnimation forKey:[NSString stringWithFormat:@"%@_PointAnimation",animationKey]];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
//    for (YjLineChartItem *chartItem in self.chartData) {
//        if ([[anim valueForKey:@"layer_path_identity"] isEqual:chartItem.pathLayer]) {
//            chartItem.pathLayer.path = (__bridge CGPathRef _Nullable)([anim valueForKey:@"layer_path_newestPath"]);
//        }
//    }
//    
//    for (YjLineChartItem *chartItem in self.chartData) {
//        for (_YjlinkedMapNode *node in chartItem.chartPointArray) {
//            if ([[anim valueForKey:@"layer_position_identity"] isEqual:node.pointLayer]) {
//                NSValue *positionValue = (NSValue *)[anim valueForKey:@"layer_position_newestPath"];
//                node.pointLayer.position = [positionValue CGPointValue];
//            }
//        }
//    }
}
#pragma mark - Accessors
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
