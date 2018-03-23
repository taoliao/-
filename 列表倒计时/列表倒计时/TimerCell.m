//
//  TimerCell.m
//  列表倒计时
//
//  Created by corepress on 2018/3/23.
//  Copyright © 2018年 corepress. All rights reserved.
//

#import "TimerCell.h"

@implementation TimerCell

- (void) setModel:(Model *)model {
    
    _model = model;
    
    self.textLabel.text = [NSString stringWithFormat:@"%ld",model.num];
    
}


@end
