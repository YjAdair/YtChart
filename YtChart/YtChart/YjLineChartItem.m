//
//  YjLineChartItem.m
//  YtChart
//
//  Created by yankezhi on 2017/8/30.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import "YjLineChartItem.h"
#import "YjChartColor.h"

@implementation _YjLegendModule
@end

@implementation _YjlinkedMapNode
@end

@implementation YjLineChartItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefaultValus];
    }
    return self;
}

- (void)setupDefaultValus {
    self.pathColor = YjBlueChartColor;
    self.pointColor = YjBlueChartColor;
    self.pointLabelColor = [UIColor blackColor];
    self.chartPointArray = [NSMutableArray array];
    self.showPointLable = YES;
    self.showPointLayer = YES;
}

- (void)setPathColor:(UIColor *)pathColor {
    _pathColor = pathColor;
    if (self.pathLayer) {
        self.pathLayer.strokeColor = pathColor.CGColor;
        self.module.legendView.backgroundColor = pathColor;
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
@end
