//
//  CircleViewControllerHeaderView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/9.
//

#import <UIKit/UIKit.h>

@interface CircleViewControllerHeaderView : UIView
@property (nonatomic, copy) void(^updateOrderBlock)(void);//已评价 进行刷新
- (void)updateIcon;//登录之后更新用户图像
@end
