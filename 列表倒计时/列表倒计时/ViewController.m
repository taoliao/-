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

@property(nonatomic,strong) NSThread *foreverThread;

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
    
//    [self addRunLoopObserver];
    
    //延迟调用 指定runloop的mode  @[NSDefaultRunLoopMode,UITrackingRunLoopMode]
//    [self performSelector:@selector(test) withObject:nil afterDelay:2.0 inModes:@[NSDefaultRunLoopMode,UITrackingRunLoopMode]];
    
    
}

//测试添加一个RunLoopObserver
- (void)addRunLoopObserver {
    
    /*
     第一个：kCFAllocatorDefault 分配储存空间
     第二个：要监听的状态 // kCFRunLoopEntry = (1UL << 0),
     kCFRunLoopBeforeTimers = (1UL << 1),
     kCFRunLoopBeforeSources = (1UL << 2),
     kCFRunLoopBeforeWaiting = (1UL << 5),
     kCFRunLoopAfterWaiting = (1UL << 6),
     kCFRunLoopExit = (1UL << 7),
     kCFRunLoopAllActivities = 0x0
     
     */
    
 CFRunLoopObserverRef observer =  CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"runloop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"runloop要去处理timer");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"runloop要去处理Sources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"runloop睡觉了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"runloop醒了");
                break;
            case kCFRunLoopExit:
                NSLog(@"runloop退出");
                break;
                
            default:
                break;
        }
        
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    CFRelease(observer);
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

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     [self addForeverThread];

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

    [self performSelector:@selector(tlThreadAction) onThread:self.foreverThread withObject:nil waitUntilDone:YES];

}

- (void)tlThreadAction {

    NSLog(@"*********%@ ****",[NSRunLoop currentRunLoop]);

}

//添加常驻线程
- (void)addForeverThread {
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadDO) object:nil];
    
    self.foreverThread = thread;
    
    [thread start];
    
}

- (void)threadDO {
    
    NSLog(@"------ %s ------",__func__);
 
    //给RunLoop添加Source，NSTimer 才能使RunLoop运行，但是添加Observer不行
 
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop currentRunLoop] run];  //给子线程添加一个runloop并且启动 runloop
}
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
