//
//  XPlaceholderTextView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnKeySendBlock)(void);

@interface XPlaceholderTextView : UIView
@property (nonatomic, copy) ReturnKeySendBlock returnKeySendBlock;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont  *textFont;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, copy)   NSString *placeholder;
@property (nonatomic, copy)   NSString *text;
//外部调用
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *maxNumLabel;

//评论结束后输入框回复原状
- (void)resetTextView;
@end
