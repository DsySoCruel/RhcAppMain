//
//  YXDNavigationController.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/14.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "YXDNavigationController.h"

@interface YXDNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation YXDNavigationController


+ (void)load
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    
    // 只要是通过模型设置,都是通过富文本设置
    // 设置导航条标题 => UINavigationBar
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = PFFONT(16);
    
    [navBar setTitleTextAttributes:attrs];
    
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    // 1.获得appearance对象, 就能修改主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 2.设置背景
    /******普通状态******/
    // 按钮文字
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    // 设置文字颜色
    textAttrs[NSForegroundColorAttributeName] = SMThemeColor;
    // 设置文字字体
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    /******不可用状态******/
    // 按钮文字
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    // 设置文字颜色
    disableTextAttrs[NSForegroundColorAttributeName] = UNAble_color;
    // 设置文字字体
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航控制器为手势识别器的代理
    self.interactivePopGestureRecognizer.delegate = self;
    
    self.delegate = self;
    self.navigationBar.tintColor = RGB(0x6F7179);
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(-0.8, 0);
    self.view.layer.shadowOpacity = 0.6;
}
/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果viewController不是最早push进来的子控制器
        // 左上角
        
        // 恢复滑动返回功能 -> 分析:把系统的返回按钮覆盖 -> 1.手势失效(1.手势被清空 2.可能手势代理做了一些事情,导致手势失效)
        viewController.hidesBottomBarWhenPushed = YES;
        
        //    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:imageNamed(@"navigationButtonReturnClick") highImage:imageNamed(@"navigationButtonReturnClick") target:self action:@selector(back)];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        

        [backButton setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateHighlighted];
//        backButton.backgroundColor = [UIColor redColor];
        backButton.frame = CGRectMake(0, 0, 40, 44);
//        [backButton sizeToFit];
        // 这句代码放在sizeToFit后面
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setImage:[UIImage imageNamed:@"icon_7"] forState:UIControlStateNormal];
//        [backButton setImage:[UIImage imageNamed:@"icon_7"] forState:UIControlStateHighlighted];
//        [backButton setTitle:@"返回" forState:UIControlStateNormal];
//        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [backButton sizeToFit];
//        // 这句代码放在sizeToFit后面
//        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//
//        // 隐藏底部的工具条
//        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 所有设置搞定后, 再push控制器
    [super pushViewController:viewController animated:animated];
}


#pragma mark - <UIGestureRecognizerDelegate>
/**
 *  手势识别器对象会调用这个代理方法来决定手势是否有效
 *
 *  @return YES : 手势有效, NO : 手势无效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}
@end
