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
    
    [self testGCDTarget];
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


-(void)testGCDTarget {
    //可修改 targetQueue DISPATCH_QUEUE_SERIAL 为 DISPATCH_QUEUE_CONCURRENT
    dispatch_queue_t targetQueue = dispatch_queue_create("test.target.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);
    
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    
    dispatch_async(queue1, ^{
        NSLog(@"1 in %s",dispatch_queue_get_label(queue1));
        
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"1 out %s",dispatch_queue_get_label(queue1));
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"2 in %s",dispatch_queue_get_label(queue2));
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"2 out %s",dispatch_queue_get_label(queue2));
    });
    dispatch_async(queue3, ^{
        NSLog(@"3 in %s",dispatch_queue_get_label(queue3));
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"3 out %s",dispatch_queue_get_label(queue3));
    });
    
    dispatch_async(queue1, ^{
        NSLog(@"4 in %s",dispatch_queue_get_label(queue1));
        
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"4 out %s",dispatch_queue_get_label(queue1));
    });
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
