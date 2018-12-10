//
//  UIView+Frame.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/14.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "UIView+Frame.h"



@implementation UIView (Frame)

@dynamic viewController;


+ (instancetype)rcm_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setRcm_height:(CGFloat)rcm_height
{
    CGRect rect = self.frame;
    rect.size.height = rcm_height;
    self.frame = rect;
}

- (CGFloat)rcm_height
{
    return self.frame.size.height;
}

- (CGFloat)rcm_width
{
    return self.frame.size.width;
}
- (void)setRcm_width:(CGFloat)rcm_width
{
    CGRect rect = self.frame;
    rect.size.width = rcm_width;
    self.frame = rect;
}

- (CGFloat)rcm_x
{
    return self.frame.origin.x;
    
}

- (void)setRcm_x:(CGFloat)rcm_x
{
    CGRect rect = self.frame;
    rect.origin.x = rcm_x;
    self.frame = rect;
}

- (void)setRcm_y:(CGFloat)rcm_y
{
    CGRect rect = self.frame;
    rect.origin.y = rcm_y;
    self.frame = rect;
}

- (CGFloat)rcm_y
{
    
    return self.frame.origin.y;
}

- (void)setRcm_centerX:(CGFloat)rcm_centerX
{
    CGPoint center = self.center;
    center.x = rcm_centerX;
    self.center = center;
}

- (CGFloat)rcm_centerX
{
    return self.center.x;
}

- (void)setRcm_centerY:(CGFloat)rcm_centerY
{
    CGPoint center = self.center;
    center.y = rcm_centerY;
    self.center = center;
}

- (CGFloat)rcm_centerY
{
    return self.center.y;
}


- (CGFloat)rcm_right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)rcm_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setRcm_right:(CGFloat)rcm_right
{
    self.rcm_x = rcm_right - self.rcm_width;
}

- (void)setRcm_bottom:(CGFloat)rcm_bottom
{
    self.rcm_y = rcm_bottom - self.rcm_height;
}


- (UIViewController *)viewController
{
    for (UIView *view = self; view; view = view.superview) {
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)view.nextResponder;
        }
    }
    return nil;
}

- (UINavigationController *)navigationController{
    return self.viewController.navigationController;
}
-(void)setNavigationController:(UINavigationController *)navigationController{
    self.navigationController = navigationController;
}

- (void)setShadowWithColor:(UIColor *)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowRadius = 0;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 1;
}

- (void)addFooterSeparator{
    UIView *view = [UIView new];
    view.backgroundColor = RGB(0xe4edff);
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

- (void)addHeaderSeparator{
    UIView *view = [UIView new];
    view.backgroundColor = RGB(0xe4edff);
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 0.5;
    }];
}

//顶到两端的line
- (void)addFooterSeparatorFull{
    UIView *view = [UIView new];
    view.backgroundColor = RGB(0xe4edff);
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 0.5;
    }];
}
- (void)removeAllSubviews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)addRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}



@end
