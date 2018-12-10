//
//  YXdTextView.m
//  YXDApp
//
//  Created by daishaoyang on 2017/12/4.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "YXdTextView.h"

@interface YXdTextView ()

@property (nonatomic, weak) UILabel *placelabel;


@end


@implementation YXdTextView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        // 1.添加label
        UILabel *placelabel = [[UILabel alloc] init];
        placelabel.rcm_x = 5;
        placelabel.rcm_y = 5;
        placelabel.numberOfLines = 0;
        placelabel.font = self.font;
        placelabel.textColor = [UIColor lightGrayColor];
        [self addSubview:placelabel];
        self.placelabel = placelabel;
        
        // 2.监听自己文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
        
        
    }
    return self;
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  文字改变了
 */
- (void)textChange
{
    if (self.text.length) { // 有文字
        self.placelabel.hidden = YES;
    } else {  // 没有文字
        self.placelabel.hidden = NO;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    // 设置占位文字
    self.placelabel.text = placeholder;
    
    // 计算label的尺寸
    
    CGSize size = [self getSizeWith:placeholder];
    
    self.placelabel.rcm_width = size.width;
    self.placelabel.rcm_height = size.height;
    
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placelabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placelabel.font = font;
}


- (CGSize)getSizeWith:(NSString *)str{
    return [str boundingRectWithSize:CGSizeMake(YXDScreenW - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placelabel.font } context:nil].size;
}
@end
