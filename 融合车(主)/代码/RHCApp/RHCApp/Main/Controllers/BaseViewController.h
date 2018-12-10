//
//  BaseViewController.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

+ (BaseViewController*)topViewController;

-(void)showEmptyMessage:(NSString *)message;//提示信息
-(void)hideEmptyView;
- (void)adjustInsetWithScrollView:(UIScrollView *)scrollView;

@end
