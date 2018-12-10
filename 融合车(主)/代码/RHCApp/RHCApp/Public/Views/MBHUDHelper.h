//
//  MBHUDHelper.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBHUDHelper : NSObject

/** 只显示文字信息 */
+ (void)showWarningWithText:(NSString *)text;
+ (void)showWarningWithText:(NSString *)text delegate:(id<MBProgressHUDDelegate>)delegate;
+ (void)showWarningWithText:(NSString *)text withView:(UIView*)view;

+ (void)showWarningWithText:(NSString *)text completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

/** 显示文字信息和图片 */
+ (void)showError:(NSString *)text;
+ (void)showError:(NSString *)error ToView:(UIView *)view;

+ (void)showSuccess:(NSString *)text;
+ (void)showSuccess:(NSString *)success ToView:(UIView *)view;

+ (void)showCustomIcon:(NSString *)iconName Title:(NSString *)title ToView:(UIView *)view;

/** 显示进度信息 需要手动隐藏 */
+ (void)showLoadingHUDView:(UIView*)view;
+ (void)showLoadingHUDView:(UIView*)view withMode:(MBProgressHUDMode)modeType;
+ (void)showLoadingHUDView:(UIView*)view withMode:(MBProgressHUDMode)modeType text:(NSString *)text;
+ (void)showLoadingHUDView:(UIView*)view withText:(NSString *)text;
+ (void)showLoadingHUDView:(UIView *)view OnlyWithText:(NSString *)text;
+ (void)hideHUDView;

/** 设置上传or下载进度值 --- 与showLoadingHUDView:withMode:(text:) 方法结合使用（modetype传可以添加进度的mode） */
+ (void)setProgress:(CGFloat)progress;


@end
