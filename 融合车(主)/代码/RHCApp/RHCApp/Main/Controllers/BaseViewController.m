//
//  BaseViewController.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "BaseViewController.h"

static BaseViewController *lastViewController = nil;

@interface BaseViewController ()

@property (nonatomic,strong) UIView *emptyView;
@property (nonatomic,strong) UILabel *messageLabel;

@end

@implementation BaseViewController

- (UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [UIView new];
    }
    return _emptyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"---------->>>>> %@ <<<<<----------", self.class);
}


+ (BaseViewController*)topViewController {
    return (BaseViewController *)[self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[BaseViewController class]]) {
        lastViewController = (BaseViewController *)rootViewController;
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        if ([presentedViewController isKindOfClass:[UIAlertController class]]) {
            UIWindow *window =  [UIApplication sharedApplication].delegate.window;
            UIViewController *vc = window.rootViewController;
            return [self topViewControllerWithRootViewController:vc];
        }
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        
        return rootViewController;
    }
}

-(void)showEmptyMessage:(NSString *)message{
    [self.view addSubview:self.emptyView];
    self.messageLabel = [UILabel new];
    self.messageLabel.textColor = SMParatextColor;
    self.messageLabel.text = message;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = LPFFONT(13);
    [self.emptyView addSubview:self.messageLabel];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 200;
        make.centerY.offset = 0;
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset = 0;
    }];
}
-(void)hideEmptyView{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
}
#pragma mark - For iOS 11
- (void)adjustInsetWithScrollView:(UIScrollView *)scrollView {
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


@end
