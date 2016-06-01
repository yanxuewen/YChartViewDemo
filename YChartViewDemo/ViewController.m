//
//  ViewController.m
//  YChartViewDemo
//
//  Created by yxw on 16/6/1.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "ViewController.h"
#import "YTestTableViewCell.h"
#import "YYFPSLabel.h"

#define kMainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kMainScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    BOOL _asynON;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //test data
    _dataArray = ({
        NSMutableArray *array = [NSMutableArray new];
        for (NSInteger i = 0; i < 120; i++) {
            [array addObject:@(arc4random()%100)];
        }
        
        NSMutableArray *arrayB = [NSMutableArray arrayWithObject:array];
        [arrayB addObject:array.copy];
        [arrayB addObject:array.copy];
        [arrayB addObject:array.copy];
        
        arrayB;
    });
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        tableView.rowHeight = 120;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[YTestTableViewCell class] forCellReuseIdentifier:@"YTestTableViewCell"];
        [self.view addSubview:tableView];
        tableView;
    });
    
    {
        UISwitch *asynSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kMainScreenWidth - 90, 24, 60, 30)];
        [asynSwitch addTarget:self action:@selector(swithcON:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:asynSwitch];
        _asynON = YES;
        [asynSwitch setOn:_asynON];
    }
    
    {
        YYFPSLabel *fps = [YYFPSLabel new];
        fps.frame = CGRectMake(20, 24, 100, 40);
        [self.view addSubview:fps];
    }
    
}

- (void)swithcON:(UISwitch *)sender{
    _asynON = sender.isOn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 200;
}

-  (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTestTableViewCell" forIndexPath:indexPath];
    cell.asynON = _asynON;
    cell.dataArray = _dataArray;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
