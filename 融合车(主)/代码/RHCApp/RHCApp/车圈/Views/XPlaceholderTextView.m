//
//  XPlaceholderTextView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "XPlaceholderTextView.h"

static NSString *maxNumber = @"200";

@interface XPlaceholderTextView () <UITextViewDelegate>
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign) CGRect textFrame;
@end

@implementation XPlaceholderTextView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

-(void)initData{
    self.backColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    self.placeholderColor = RGB(0x8e8ca7);
    self.textColor = RGB(0x484578);
    self.textFont = SFONT(14);
    self.cornerRadius = 3.0;
    self.placeholder = @"请输入...";
}

-(void)setupUI{
    self.backgroundColor = self.backColor;
    self.layer.cornerRadius = self.cornerRadius;
    
    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.font = self.textFont;
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.placeholderColor;
    
    self.maxNumLabel = [UILabel new];
    self.maxNumLabel.font = self.textFont;
    self.maxNumLabel.text = maxNumber;
    self.maxNumLabel.textColor = self.textColor;
    self.maxNumLabel.hidden = YES;
    [self.maxNumLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.maxNumLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    
    self.textView = [UITextView new];
    self.textView.font = self.textFont;
    self.textView.textColor = self.textColor;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeySend;
    
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.maxNumLabel];
    [self addSubview:self.textView];
}

-(void)setupLayout{
    
    [self.maxNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.priorityHigh().offset = -10;
        make.bottom.offset = -9;
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5+6;
        make.right.equalTo(self.maxNumLabel.mas_left).offset(-10).priorityHigh();
        make.top.bottom.offset = 0;
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 6;
        make.right.equalTo(self.maxNumLabel.mas_left).offset = -5;
        make.bottom.offset = 0;
        make.height.priorityHigh().offset = 35;
        make.top.equalTo(self.mas_top).offset = 0;
    }];
}

-(void)setReturnKeySendBlock:(ReturnKeySendBlock)returnKeySendBlock{
    _returnKeySendBlock = returnKeySendBlock;
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
}

-(void)setText:(NSString *)text{
    self.textView.text = text;
    if (text.length < 1) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
}
-(NSString *)text{
    return self.textView.text;
}

#pragma mark textViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    NSInteger number = [textView.text length];
    if (number >= [maxNumber integerValue]) {
        textView.text = [textView.text substringToIndex:[maxNumber integerValue]];
    }
    self.maxNumLabel.text = [NSString stringWithFormat:@"%llu",[maxNumber longLongValue] - textView.text.length];
    
    CGFloat width = CGRectGetWidth(textView.frame);
    //    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    //    CGRect oldFrame = self.textFrame;
    //    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    //    textView.frame= newFrame;
    
    if (newSize.height <= 35) {
        newSize.height = 35;
    }else{
        if (newSize.height >= 80)
        {
            newSize.height = 80;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = newSize.height;
        }];
        [self layoutIfNeeded];
    }];
    
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if (self.returnKeySendBlock) {
            self.returnKeySendBlock();
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


/**
 评论成功后的回收键盘
 */
- (void)resetTextView{
    self.text = @"";
    self.maxNumLabel.text = maxNumber;
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 35;
        }];
        [self layoutIfNeeded];
    }];
}
//
////评论失败的回收键盘
//- (void)regiesterTextView{
//    [self endEditing:YES];
//}

@end
