//
//  YjBarChartItem.m
//  YtChart
//
//  Created by yankezhi on 2017/9/2.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import "YjBarChartItem.h"
#import "YjChartColor.h"

@implementation _YjBarLegendModule
@end

@implementation _YjBarModule
@end

@implementation YjBarChartItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefaultValus];
    }
    return self;
}

- (void)setupDefaultValus {
    self.fillColor = YjBlueChartColor;
    self.chartBarArray = [NSMutableArray array];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    if (self.chartBarArray.count) {
        for (_YjBarModule *layerModule in self.chartBarArray) {
            layerModule.barLayer.fillColor = fillColor.CGColor;
        }
    }
    if (self.legendModule) {
        self.legendModule.legendView.backgroundColor = fillColor;
    }
}
@end
