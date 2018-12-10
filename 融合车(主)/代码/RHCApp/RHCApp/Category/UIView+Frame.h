//
//  UIView+Frame.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/14.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property CGFloat rcm_x;
@property CGFloat rcm_y;
@property CGFloat rcm_width;
@property CGFloat rcm_height;
@property CGFloat rcm_centerX;
@property CGFloat rcm_centerY;
@property CGFloat rcm_bottom;
@property CGFloat rcm_right;

+ (instancetype)rcm_viewFromXib;

- (void)removeAllSubviews;
- (void)addHeaderSeparator;
- (void)addFooterSeparator;
- (void)addFooterSeparatorFull;//顶到两端的line
- (void)setShadowWithColor:(UIColor *)color;//画圆角，可画半圆
- (void)addRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UINavigationController *navigationController;


@end
