//
//  YChartView.m
//  YChartViewDemo
//
//  Created by yxw on 16/6/1.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "YChartView.h"
#import "YChartAsyncLayer.h"
#import "YChartLayout.h"
static dispatch_queue_t YChartGetReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

#define kAsyncFadeDuration 0.08

@interface YChartView ()<YChartAsyncLayerDelegate>

@property (strong,nonatomic) YChartLayout *chartLayout;

@end

@implementation YChartView

- (void)p_clearContents{
    CGImageRef image = (__bridge_retained CGImageRef)(self.layer.contents);
    self.layer.contents = nil;
    if (image) {
        dispatch_async(YChartGetReleaseQueue(), ^{
            CFRelease(image);
        });
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        ((YChartAsyncLayer *)self.layer).displaysAsynchronously = NO;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.contentMode = UIViewContentModeRedraw;
        _chartLayout = [YChartLayout new];
        self.frame = frame;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    CGSize oldSize = self.bounds.size;
    [super setFrame:frame];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        if (_displaysAsynchronously) {
            [self p_clearContents];
        }
        [self p_setLayoutNeedRedraw];
    }
}

- (void)setBounds:(CGRect)bounds{
    CGSize oldSize = self.bounds.size;
    [super setBounds:bounds];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        if (_displaysAsynchronously) {
            [self p_clearContents];
        }
        [self p_setLayoutNeedRedraw];
    }
}

+ (Class)layerClass {
    return [YChartAsyncLayer class];
}


- (void)setDisplaysAsynchronously:(BOOL)displaysAsynchronously {
    _displaysAsynchronously = displaysAsynchronously;
    ((YChartAsyncLayer *)self.layer).displaysAsynchronously = displaysAsynchronously;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if (_displaysAsynchronously) {
        [self p_clearContents];
    }
    [self p_setLayoutNeedRedraw];
}

- (void)p_setLayoutNeedRedraw{
    [self.layer setNeedsDisplay];
}

- (YChartAsyncLayerDisplayTask *)newAsyncDisplayTask{
    
    
    BOOL fadeForAsync = _displaysAsynchronously;
    NSArray *array = _dataArray;
    YChartLayout *layout = _chartLayout;
    
    YChartAsyncLayerDisplayTask *task = [YChartAsyncLayerDisplayTask new];
    
    task.willDisplay = ^(CALayer *layer){
        [layer removeAnimationForKey:@"contents"];
    };

    task.display = ^(CGContextRef context,CGSize size,BOOL (^isCancelled)(void)){
        if ( isCancelled() ) {
            return ;
        }
        [layout drawChart:context size:size array:array cancel:isCancelled];
    };
    
    task.didDisplay = ^(CALayer *layer,BOOL finished){
        if (!finished) {
            return ;
        }
        [layer removeAnimationForKey:@"contents"];
        if (fadeForAsync) {
            CATransition *transition = [CATransition animation];
            transition.duration = kAsyncFadeDuration;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            transition.type = kCATransitionFade;
            [layer addAnimation:transition forKey:@"contents"];
        }
        
    };
    
    return task;
    
}


@end














