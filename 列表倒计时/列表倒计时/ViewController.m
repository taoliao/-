//
//  ViewController.m
//  列表倒计时
//
//  Created by corepress on 2018/3/23.
//  Copyright © 2018年 corepress. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "TimerCell.h"

static NSString *const cellId = @"defultCellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSourch;

@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic,strong) dispatch_source_t gdcTimer; //GCD timer

@end

@implementation ViewController

- (NSMutableArray *)dataSourch {
    
    if (!_dataSourch) {
        _dataSourch = [NSMutableArray array];
    }
    return _dataSourch;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self getDatas];
    
    [self starTimer];
    
}

- (void)getDatas {
    
    for (int i = 0; i < 30; i++) {
        
        Model *model = [[Model alloc] init];
        
        model.num = CFAbsoluteTimeGetCurrent() + i * (10);
        
        [self.dataSourch addObject:model];
    }
    
    [self.tableView reloadData];
    
}

- (void)starTimer {
    
    if(!self.timer) {
        
//         self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDO:) userInfo:nil repeats:YES];
//         [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        
        dispatch_queue_t queue = dispatch_get_main_queue();
        
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        self.gdcTimer = timer;

        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);

        dispatch_source_set_event_handler(timer, ^{
            
            [self timeDO:self.gdcTimer];
            
        });

        dispatch_resume(timer);
        
    }
    
}

- (void)timeDO:(dispatch_source_t)timer {
    
    [self.dataSourch enumerateObjectsUsingBlock:^(Model  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.num == CFAbsoluteTimeGetCurrent()) {
            
        }else {
            obj.num  = obj.num - 1;
        }

    }];

    [[self.tableView visibleCells]enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        TimerCell *cell = (TimerCell *)obj;
        
        cell.model = cell.model;

    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSourch.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

   cell.model = [self.dataSourch objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
