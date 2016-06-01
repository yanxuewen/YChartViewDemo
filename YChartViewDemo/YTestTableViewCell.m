//
//  YTestTableViewCell.m
//
//
//  Created by yxw on 16/5/20.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "YTestTableViewCell.h"
#import "YChartView.h"

@interface YTestTableViewCell ()

@property (nonatomic,strong) YChartView *chartV;

@end

@implementation YTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        YChartView *chartV = [[YChartView alloc] initWithFrame:CGRectMake(20, 10, [[UIScreen mainScreen] bounds].size.width-40, 100)];
        chartV.displaysAsynchronously = YES;
        _chartV = chartV;
        [self.contentView addSubview:chartV];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setAsynON:(BOOL)asynON{
    _asynON = asynON;
    _chartV.displaysAsynchronously = asynON;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    _chartV.dataArray = dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
