//
//  RefreshFooterView.m
//  YXDApp
//
//  Created by daishaoyang on 2018/5/14.
//  Copyright © 2018年 beijixing. All rights reserved.
//

#import "RefreshFooterView.h"

@implementation RefreshFooterView

- (void)prepare {
    [super prepare];
//    self.mj_h = 65;
//    NSMutableArray *images = [NSMutableArray array];
//    for (int i = 1; i <= 9; i++) {
//        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d帧",i]]];
//    }
//    [self setImages:images forState:MJRefreshStatePulling];
//    [self setImages:images forState:MJRefreshStateIdle];
//    [self setImages:images forState:MJRefreshStateRefreshing];
//
//    [self setTitle:@"正在加载中" forState:MJRefreshStatePulling];
    [self setTitle:@"" forState:MJRefreshStateIdle];
//    [self setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    self.stateLabel.font = LPFFONT(13);
//    self.triggerAutomaticallyRefreshPercent = 0;
//    self.stateLabel.textAlignment = NSTextAlignmentCenter;
//    self.stateLabel.textColor = [UIColor colorWithHexString:@"8e8ca7"];
}

@end
