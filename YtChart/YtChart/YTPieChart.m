//
//  YTPieChart.m
//  YtChart
//
//  Created by yankezhi on 2017/8/11.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import "YTPieChart.h"

@interface YTPieChart ()

@property (nonatomic) NSArray *items;
@end

@implementation YTPieChart

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        _items =  [NSArray arrayWithArray:items];
        [self baseConfig];
    }
    return self;
}

- (void)baseConfig {
    
}
@end
