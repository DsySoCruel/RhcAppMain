//
//  AddAdressCellView.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/17.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAdressCellView : UIView
@property (nonatomic,strong) UITextField *textField;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder isNeedPush:(BOOL)isNeedPush;

@property (nonatomic, copy) void(^needPushBlock)(void);

@end
