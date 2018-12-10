//
//  UIButton+ImagePositionAndHitArea.h
//  RHCApp
//
//  Created by daishaoyang on 2018/6/25.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ImagePosition) {
    ImagePositionLeft = 0,  // 图片在左，文字在右，默认
    ImagePositionRight,     // 图片在右，文字在左
    ImagePositionTop,       // 图片在上，文字在下
    ImagePositionBottom,    // 图片在下，文字在上
};
@interface UIButton (ImagePositionAndHitArea)
// 设置文字图片位置、文字与图片间距
- (void)setImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing;
// 热区修改，负值为扩大，正值为缩小
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
@end
