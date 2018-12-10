//
//  UIImage+YXDImage.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/14.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YXDImage)

+ (instancetype)imageOriginalWithName:(NSString *)imageName;

- (instancetype)rcm_circleImage;

+ (instancetype)rcm_circleImageNamed:(NSString *)name;

+ (instancetype)imageWithBorderWidth:(CGFloat)borderW borderColor:(UIColor *)color image:(NSString *)imageName;

#pragma mark -- 返回一张可以随意拉伸不变形的图片
+ (UIImage *)resizableImage:(NSString *)name;

#pragma mark -- 返回一张高斯模糊的图片
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

- (UIImage *)blurryImagewithBlurLevel:(CGFloat)blur;//使用这个

@end
