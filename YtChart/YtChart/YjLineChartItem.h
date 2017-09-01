//
//  YjLineChartItem.h
//  YtChart
//
//  Created by yankezhi on 2017/8/30.
//  Copyright © 2017年 caohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _YjLegendModule : UIView
/** 说明文本 **/
@property (nonatomic, strong) UILabel *legendTitle;
/** 说明标示 **/
@property (nonatomic, strong) UIView *legendView;
@end

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

@interface YjLineChartItem : NSObject
/** 元数据 **/
@property (nonatomic, copy) NSArray *pointData;
/** 元数据标题 **/
@property (nonatomic, copy) NSString *dataTitle;
/** pathColor **/
@property (nonatomic, strong) UIColor *pathColor;
/** pointColor全局设置 **/
@property (nonatomic, strong) UIColor *pointColor;
/** pointColor集合 **/
@property (nonatomic, copy) NSArray<UIColor *> *pointColors;
/** point文本颜色 **/
@property (nonatomic, strong) UIColor *pointLabelColor;
/********************** Views **************************/
/** 说明模块 **/
@property (nonatomic, strong) _YjLegendModule *module;
/** 数据路径 **/
@property (nonatomic, strong) CAShapeLayer *pathLayer;
/** 所有point数据 **/
@property (nonatomic, strong) NSMutableArray<_YjlinkedMapNode *> *chartPointArray;
/********************** ViewsControl **************************/
/** 是否展示point文本 默认YES**/
@property (nonatomic, assign) BOOL showPointLable;
/** 是否展示point 默认YES**/
@property (nonatomic, assign) BOOL showPointLayer;
@end
