//
//  YChartView.h
//  YChartViewDemo
//
//  Created by yxw on 16/6/1.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YChartView : UIView<NSCoding>


@property (nonatomic) BOOL displaysAsynchronously;//default:NO

@property (nonatomic,copy,nullable) NSArray *dataArray;

@end
