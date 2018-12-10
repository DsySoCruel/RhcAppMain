//
//  MBHUDHelper.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "MBHUDHelper.h"

static MBProgressHUD *HUDView = nil;

#define defaultText @"努力加载中"
#define defaultAfterDelay 1.5

@implementation MBHUDHelper

+ (void)showWarningWithText:(NSString *)text
{
    [MBHUDHelper showWarningWithText:text delegate:nil];
}

+ (void)showWarningWithText:(NSString *)text completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    [MBHUDHelper showWarningWithText:text delegate:nil];
    if (completionBlock) {
        completionBlock();
    }
}

+ (void)showWarningWithText:(NSString *)text withView:(UIView*)view;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = stringIsNilToEmpty(text);
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    hud.label.superview.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    hud.margin = 12.f;
    hud.label.font = LPFFONT(14);
    [hud hideAnimated:YES afterDelay:defaultAfterDelay];
}

+ (void)showWarningWithText:(NSString *)text delegate:(id<MBProgressHUDDelegate>)delegate
{
    UIWindow *window = (UIWindow *)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.delegate = delegate;
    hud.label.text = stringIsNilToEmpty(text);
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    hud.label.superview.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    hud.margin = 12.f;
    hud.label.font = LPFFONT(14);
    [hud hideAnimated:YES afterDelay:defaultAfterDelay];
}

+ (void)showError:(NSString *)text {
    [MBHUDHelper showWarningWithText:text delegate:nil];
    //    [self showCustomIcon:@"dsy_error.png" Title:text ToView:nil];
}

+ (void)showSuccess:(NSString *)text {
    [MBHUDHelper showWarningWithText:text delegate:nil];
    //    [self showCustomIcon:@"dsy_yes.png" Title:text ToView:nil];
}

+ (void)showError:(NSString *)error ToView:(UIView *)view{
    [self showCustomIcon:@"dsy_error.png" Title:error ToView:view];
}

+ (void)showSuccess:(NSString *)success ToView:(UIView *)view
{
    [self showCustomIcon:@"dsy_yes.png" Title:success ToView:view];
}

+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view
{
    if (view == nil) view = (UIWindow*)[UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // 设置图片
    if ([iconName isEqualToString:@"error.png"] || [iconName isEqualToString:@"success.png"]) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", iconName]]];
    }else{
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    }
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 设置label属性
    hud.label.text = title;
    hud.label.superview.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = LPFFONT(14);
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:.9];
}

+ (void)setupCommonWithView:(UIView *)view text:(NSString *)text mode:(MBProgressHUDMode)mode {
    HUDView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUDView.mode = mode;
    HUDView.margin = 18.f;
    HUDView.label.text = stringIsNilToEmpty(text);
    //    HUDView.minShowTime = 0.3;
    HUDView.label.font = [UIFont boldSystemFontOfSize:14];
    HUDView.label.superview.backgroundColor = [UIColor blackColor];
    HUDView.label.textColor = [UIColor whiteColor];
    HUDView.activityIndicatorColor = [UIColor whiteColor];
    
    
    //    UIActivityIndicatorView *ccc = [UIActivityIndicatorView appearance];
    //    ccc.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //    ccc.color = [UIColor whiteColor];
    
    //    if ([UIDevice currentDevice].systemVersion.floatValue>=10.0) {
    //        [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[HUDView class]]].color = [UIColor whiteColor];
    //    } else {
    //        [UIActivityIndicatorView appearanceWhenContainedIn:[HUDView class], nil].color = [UIColor whiteColor];
    //    }
}

+ (void)showLoadingHUDView:(UIView*)view
{
    [self setupCommonWithView:view text:defaultText mode:MBProgressHUDModeIndeterminate];
}

+ (void)showLoadingHUDView:(UIView*)view withMode:(MBProgressHUDMode)modeType  {
    [self setupCommonWithView:view text:defaultText mode:modeType];
}

+ (void)showLoadingHUDView:(UIView*)view withMode:(MBProgressHUDMode)modeType text:(NSString *)text {
    [self setupCommonWithView:view text:text mode:modeType];
}

+ (void)showLoadingHUDView:(UIView*)view withText:(NSString *)text {
    [self setupCommonWithView:view text:text mode:MBProgressHUDModeIndeterminate];
}

+ (void)showLoadingHUDView:(UIView *)view OnlyWithText:(NSString *)text
{
    HUDView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUDView.mode = MBProgressHUDModeText;
    HUDView.margin = 12.f;
    HUDView.label.text = stringIsNilToEmpty(text);
    //    HUDView.minShowTime = 0.3;
    HUDView.label.superview.backgroundColor = [UIColor blackColor];
    HUDView.label.textColor = [UIColor whiteColor];
    HUDView.label.font = [UIFont boldSystemFontOfSize:14];
}

+ (void)hideHUDView
{
    [HUDView hideAnimated:YES];
}

+ (void)setProgress:(CGFloat)progress {
    HUDView.progress = progress;
}


@end
