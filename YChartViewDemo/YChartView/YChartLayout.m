//
//  YChartLayout.m
//  YChartViewDemo
//
//  Created by yxw on 16/6/1.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "YChartLayout.h"
#import <UIKit/UIKit.h>


@implementation YChartLayout

- (void)drawChart:(CGContextRef)context size:(CGSize)size array:(NSArray *)array cancel:(BOOL (^)(void))cancel{
    if ( array == nil || array.count == 0 ) {
        return;
    }
    
    CGContextSaveGState(context);
    NSMutableArray *mutableArray = [NSMutableArray array] ;
    for (int i = 0; i < array.count; i++) {
        if( cancel && cancel() ){
            break;
        }
        [mutableArray addObject:@(findMaxValueFromArray(array[i]))];
    }
//    CGContextSetAllowsAntialiasing(context, YES);
//    CGContextSetShouldAntialias(context, YES);
    for (int i = 0; i < array.count; i++) {
        if( cancel && cancel() ){
            break;
        }
        drawLineInContext(context, size, array[i], [mutableArray[i] doubleValue]);
        CGMutablePathRef path = CGPathCreateMutable();
        drawLineGradientInContext(context, size, array[i], [mutableArray[i] doubleValue],path);
        CGPathRelease(path);
    }
    
    CGContextRestoreGState(context);
}

static double findMaxValueFromArray(NSArray *array){
    double maxValue = 0.0;
    for (int i = 0; i < array.count; i++) {
        double value = [array[i] doubleValue];
        if (maxValue < value) {
            maxValue = value;
        }
    }
    return maxValue;
}

static void drawLineInContext(CGContextRef context,CGSize size,NSArray *array,double maxValue){
    CGFloat xWidth = size.width / (array.count - 1);
    CGContextSaveGState(context);
    for (int i = 0; i < array.count; i++) {
        double value = 0.0;
        if (maxValue != 0) {
            value = [array[i] doubleValue] / maxValue * size.height * 0.9;
        }
        if (i == 0) {
            CGContextMoveToPoint(context, 0, size.height - value - 1);
        }else{
            CGContextAddLineToPoint(context, xWidth * i, size.height - value - 1);
        }
    }
    [[UIColor colorWithRed:0 green:0xae/255.0 blue:0xae/255.0 alpha:1] setStroke];
    CGContextSetLineWidth(context, 2);
        CGContextSetLineDash(context, 0, 0, 0);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

static void drawLineGradientInContext(CGContextRef context,CGSize size,NSArray *array,double maxValue,CGMutablePathRef path){
    CGFloat xWidth = size.width / (array.count - 1);
    CGPathMoveToPoint(path, NULL,0, size.height - 1);
    for (int i = 0; i < array.count; i++) {
        double value = 0.0;
        if (maxValue != 0) {
            value = [array[i] doubleValue] / maxValue * size.height * 0.9;
        }
        CGPathAddLineToPoint(path, NULL, xWidth * i, size.height - value - 1);
    }
    
    CGPathAddLineToPoint(path, NULL, xWidth * (array.count - 1), size.height - 1);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[3] = {0.0,0.5,1.0};
    NSArray *colors = @[(__bridge id)([UIColor colorWithRed:0xec/255.0 green:1 blue:1 alpha:1].CGColor),(__bridge id)([UIColor colorWithRed:0x80/255.0 green:1 blue:1 alpha:1].CGColor),(__bridge id)([UIColor colorWithRed:0 green:0xae/255.0 blue:0xae/255.0 alpha:1].CGColor)];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end
