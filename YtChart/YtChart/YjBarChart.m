//
//  YjBarChart.m
//  YtChart
//
//  Created by yankezhi on 2017/9/1.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import "YjBarChart.h"
#import "YjBarChartItem.h"
YjBarChartMargin YjBarChartMarginMake(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom) {
    YjBarChartMargin chartMargin;
    chartMargin.left = left;
    chartMargin.top = top;
    chartMargin.right = right;
    chartMargin.bottom = bottom;
    return chartMargin;
}

@interface YjBarChart ()
/** X轴节点文本 **/
@property (nonatomic, strong) NSMutableArray *xAxisLableViews;
/** Y轴节点文本 **/
@property (nonatomic, strong) NSMutableArray *yAxisLableViews;
/** 坐标轴原点 **/
@property (nonatomic, assign) CGPoint originPoint;
/** 最后一个单元线距坐标轴末尾的长度 **/
@property (nonatomic, assign) CGFloat axisMargin;
/** bar之间的间距 **/
@property (nonatomic, assign) CGFloat barMargin;
/** X轴长度 **/
@property (nonatomic, assign) CGFloat xAxisLength;
/** Y轴长度 **/
@property (nonatomic, assign) CGFloat yAxisLength;
/** X轴单元长度 **/
@property (nonatomic, assign) CGFloat xUnitLength;
/** Y轴单元长度 **/
@property (nonatomic, assign) CGFloat yUnitLength;
/** bar宽 **/
@property (nonatomic, assign) CGFloat barWidth;
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
    self.axisMargin = 10.f;
    self.barMargin = 2.5f;
    self.axisLineWidth = 0.5f;
    self.backgroundColor = [UIColor whiteColor];
    self.xAxisColor = [UIColor grayColor];
    self.yAxisColor = [UIColor grayColor];
    self.xAxisLablesColor = [UIColor blackColor];
    self.yAxisLablesColor = [UIColor blackColor];
    self.xAxisLableViews = [NSMutableArray array];
    self.yAxisLableViews = [NSMutableArray array];
}

- (void)configDrawData {
    self.originPoint = CGPointMake(self.chartMargin.left, CGRectGetHeight(self.frame) - self.chartMargin.top);
    self.xAxisLength = CGRectGetWidth(self.frame) - self.chartMargin.left - self.chartMargin.right;
    self.yAxisLength = CGRectGetHeight(self.frame) - self.chartMargin.top - self.chartMargin.bottom;
    self.xUnitLength = (self.xAxisLength-self.axisMargin)/self.xAxisLables.count;
    self.yUnitLength = self.yAxisLength/(self.yAxisLables.count - 1);
    /**
     Unitlength* Maxdatacount = barW*MaxdataCount*chardataCount + barW*MaxdataCount + margin * Maxdatacount * (chardataCount - 1)
     barW = (Unitlength - margin * (chardataCount - 1) )/(chardataCount + 1)
     **/
    self.barWidth = (self.xUnitLength - self.barMargin*(self.chartData.count-1))/(self.chartData.count + 1);
}

#pragma mark - Draw
- (void)strokeChart {
    [self configDrawData];
    [self strokeDataTitle];
    [self strokeXAxisLable];
    [self strokeYAxisLabel];
    [self strokeBar];
    [self configAnimation];
    [self setNeedsDisplay];
}

- (void)strokeDataTitle {
    
    BOOL isExistTitle = NO;
    for (YjBarChartItem *chartItem in self.chartData) {
        if (chartItem.dataTitle) {
            isExistTitle = YES;
            break;
        }
    }
    if (!isExistTitle) return;
    for (NSInteger index = 0; index < self.chartData.count; index++) {
        YjBarChartItem *chartItem = self.chartData[index];
        UILabel *dataTitle = [UILabel new];
        dataTitle.text = chartItem.dataTitle;
        dataTitle.font = [UIFont systemFontOfSize:10];
        dataTitle.textColor = [UIColor blackColor];
        [dataTitle sizeToFit];
        CGFloat indicateWH = CGRectGetHeight(dataTitle.frame);
        
        UIView *dataIndicate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, indicateWH, indicateWH)];
        dataIndicate.layer.cornerRadius = 3;
        dataIndicate.layer.masksToBounds = YES;
        dataIndicate.backgroundColor = chartItem.fillColor;
        dataTitle.frame = CGRectMake(CGRectGetMaxX(dataIndicate.frame) + 5, 0, CGRectGetWidth(dataTitle.frame), indicateWH);
        
        CGFloat x = self.originPoint.x + self.xAxisLength - CGRectGetMaxX(dataTitle.frame);
        CGFloat y = self.chartMargin.top - CGRectGetHeight(dataTitle.frame) - 5;
        CGFloat w = CGRectGetMaxX(dataTitle.frame);
        CGFloat h = indicateWH;
        if (index != 0) {
            _YjBarLegendModule *preModule = self.chartData[index - 1].legendModule;
            if (preModule) {
                x = preModule.frame.origin.x - w - 5;
            }
        }
        _YjBarLegendModule *module = [[_YjBarLegendModule alloc] initWithFrame:CGRectMake(x, y, w, h)];
        chartItem.legendModule = module;
        module.legendTitle = dataTitle;
        module.legendView = dataIndicate;
        [module addSubview:dataTitle];
        [module addSubview:dataIndicate];
        [self addSubview:module];
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
        lable.frame = CGRectMake(self.chartMargin.left, self.originPoint.y + 5, self.xUnitLength, self.chartMargin.bottom);
        [lable sizeToFit];
        CGPoint tempCenter = lable.center;
        tempCenter.x = self.xUnitLength*(index+1) - self.xUnitLength/2 + self.chartMargin.left;
        lable.center = tempCenter;
        [self addSubview:lable];
        [self.yAxisLableViews addObject:lable];
    }
}

- (void)strokeBar {
    
    for (NSInteger index = 0; index < self.chartData.count; index++) {
        [self prepareSingleBar:self.chartData[index] barIndex:index];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.axisLineWidth);
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
    //网格
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

#pragma mark - Public
- (void)updateChartDataWithBarItem:(YjBarChartItem *)barItem barIndex:(NSInteger)barIndex {
    
//    [self prepareSingleBar:barItem barIndex:barIndex];
//    for (_YjBarModule *barModule in barItem.chartBarArray) {
//        barModule.barLayer.frame = barModule.barRect;
//        barModule.barLayer.position = CGPointMake(barModule.barRect.origin.x + barModule.barRect.size.width/2, self.originPoint.y);
//        barModule.barLayer.anchorPoint = CGPointMake(0.5, 1);
//        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, barModule.barRect.size.width, barModule.barRect.size.height)];
//        [self setPathAnimationWithLayer:barModule.barLayer newestPath:path.CGPath animationKey:@"barLayer"];
//    }
}

#pragma mark - Private
- (void)prepareSingleBar:(YjBarChartItem *)barItem barIndex:(NSInteger)barIndex {
    for (NSInteger index = 0;index < barItem.barData.count ;index++) {
        
        _YjBarModule *module = nil;
        if (index < barItem.chartBarArray.count) {
            module = barItem.chartBarArray[index];
        }
        if (!module) {
            module = [[_YjBarModule alloc] init];
        }
        module.data = [barItem.barData[index] floatValue];
        CGFloat scaleY = ([barItem.barData[index] floatValue] - self.yAxisMinValue)/(self.yAxisMaxValue - self.yAxisMinValue);
        CGFloat y = self.originPoint.y - self.yUnitLength*(self.yAxisLables.count-1)*scaleY;
        CGFloat w = self.barWidth;
        //x = barW/2 + barIndex*barW + barIndex*margin + index*Unitlength
        CGFloat x = self.barWidth/2 + barIndex*self.barWidth + barIndex*self.barMargin + index*self.xUnitLength + self.originPoint.x;
        CGFloat h = self.originPoint.y - y;
        module.barRect = CGRectMake(x, y, w, h);
        
        if (!module.barLayer) {
            CAShapeLayer *barLayer = [CAShapeLayer layer];
            module.barLayer = barLayer;
            barLayer.frame = module.barRect;
            barLayer.fillColor = barItem.fillColor.CGColor;
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, w, h)];
            barLayer.path = path.CGPath;
            barLayer.transform = CATransform3DScale(CATransform3DIdentity, 1, 0, 1);
            barLayer.position = CGPointMake(x + w/2, self.originPoint.y);
            barLayer.anchorPoint = CGPointMake(0.5, 1);
            [self.layer addSublayer:barLayer];
        }
        
        [barItem.chartBarArray addObject:module];
    }
}

#pragma mark - Animation
- (void)configAnimation {
    
    for (YjBarChartItem *barItem in self.chartData) {
        for (_YjBarModule *barModule in barItem.chartBarArray) {
            [self setTransformYAnimationWithLayer:barModule.barLayer animationKey:@"barLayer"];
        }
    }
}

- (void)setTransformYAnimationWithLayer:(CAShapeLayer *)layer animationKey:(NSString *)animationKey {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.duration = 0.5f;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:pathAnimation forKey:[NSString stringWithFormat:@"%@_PathAnimation",animationKey]];
}

- (void)setPathAnimationWithLayer:(CAShapeLayer *)layer newestPath:(CGPathRef )newestPath animationKey:(NSString *)animationKey {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id _Nullable)(layer.path);
    pathAnimation.toValue = (__bridge id _Nullable)(newestPath);
    pathAnimation.duration = 0.5;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [layer addAnimation:pathAnimation forKey:[NSString stringWithFormat:@"%@_PathAnimation",animationKey]];
}
@end
