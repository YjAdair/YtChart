//
//  YjBarChartItem.h
//  YtChart
//
//  Created by yankezhi on 2017/9/2.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _YjBarLegendModule : UIView
/** 说明文本 **/
@property (nonatomic, strong) UILabel *legendTitle;
/** 说明标示 **/
@property (nonatomic, strong) UIView *legendView;
@end

@interface _YjBarModule : NSObject

@property (nonatomic, assign) CGRect barRect;
@property (nonatomic, assign) CGFloat data;
/** barLayer **/
@property (nonatomic, strong) CAShapeLayer *barLayer;
@end

@interface YjBarChartItem : NSObject
/** 元数据 **/
@property (nonatomic, copy) NSArray *barData;
/** 元数据组标题 **/
@property (nonatomic, copy) NSString *dataTitle;
/** 填充颜色 **/
@property (nonatomic, strong) UIColor *fillColor;
/********************** ViewInfo **************************/
/** 所有bar数据 **/
@property (nonatomic, strong) NSMutableArray<_YjBarModule *> *chartBarArray;
/** 说明模块 **/
@property (nonatomic, strong) _YjBarLegendModule *legendModule;
@end
