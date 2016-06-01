//
//  YChartAsyncLayer.h
//  YChartViewDemo
//
//  Created by yxw on 16/6/1.
//  Copyright © 2016年 yxw. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class YChartAsyncLayerDisplayTask;

NS_ASSUME_NONNULL_BEGIN

@interface YChartAsyncLayer : CALayer

@property BOOL displaysAsynchronously;

@end


@protocol YChartAsyncLayerDelegate <NSObject>
@required

- (YChartAsyncLayerDisplayTask *)newAsyncDisplayTask;
@end





@interface YChartAsyncLayerDisplayTask : NSObject

@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);

@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));

@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);

@end

NS_ASSUME_NONNULL_END





