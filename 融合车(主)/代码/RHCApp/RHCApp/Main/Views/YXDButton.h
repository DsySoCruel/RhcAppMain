//
//  YXDButton.h
//  YXDApp
//
//  Created by daishaoyang on 2017/12/24.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MoreStyleStatusNormal,//左图标右文本 居中显示
    MoreStyleStatusImageLeft, //左图标右文本(靠左显示)
    MoreStyleStatusLeft,// 左文本右图标 靠左显示
    MoreStyleStatusCenter,// 左文本右图标 居中显示
    MoreStyleStatusRight,// 左文本右图标 靠右显示
    MoreStyleStatusTop,// 图标在上，文本在下(居中)
    MoreStyleStatusBottom, // 图标在下，文本在上(居中)
}MoreStyleStatus;

typedef void(^RCMButtonBlock)(id);


@interface YXDButton : UIButton

/**
 *  外界通过设置按钮的status属性，创建不同类型的按钮
 */
@property (nonatomic,assign)MoreStyleStatus status;
@property (nonatomic,assign)CGFloat padding;

+ (instancetype)shareButton;

- (instancetype)initWithAlignmentStatus:(MoreStyleStatus)status;

@property (nonatomic,copy)RCMButtonBlock block;

@end
