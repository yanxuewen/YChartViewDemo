//
//  YChartLayout.h
//  YChartViewDemo
//
//  Created by yxw on 16/6/1.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface YChartLayout : NSObject

- (void)drawChart:(CGContextRef)context size:(CGSize)size array:(NSArray *)array cancel:(BOOL (^)(void))cancel;


@end
