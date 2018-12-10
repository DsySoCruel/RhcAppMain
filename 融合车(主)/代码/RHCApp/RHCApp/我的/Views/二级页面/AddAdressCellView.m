//
//  AddAdressCellView.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/17.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "AddAdressCellView.h"

@interface AddAdressCellView()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *jiantouImage;
@property (nonatomic,assign) BOOL isNeedPush;
//@property (nonatomic,strong) UIView *lineView;
@end
@implementation AddAdressCellView


- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder isNeedPush:(BOOL)isNeedPush{
    if (self = [super init]) {
//        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        self.textField = [UITextField new];
        self.textField.placeholder = placeholder;
        [self addSubview:self.textField];
        if (isNeedPush) {
            self.jiantouImage = [[UIImageView alloc] initWithImage:IMAGECACHE(@"shangpinxiangqing_01")];
            [self.jiantouImage setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

            [self addSubview:self.jiantouImage];
            _isNeedPush = YES;
            self.textField.enabled = NO;
        }
        
        [self setupLayout];
    }
    //添加手势进行选择
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adView1Action)];
    [self addGestureRecognizer:tap1];
    
    return self;
}


//- (void)setupUI{
//
//    self.titleLabel = [UILabel new];
//    [self addSubview:self.titleLabel];
//
//    self.textField = [UITextField new];
//    [self addSubview:self.textField];
//
//    self.jiantouImage = [[UIImageView alloc] initWithImage:IMAGECACHE(@"")];
//    [self addSubview:self.jiantouImage];
//}

- (void)setupLayout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.bottom.offset = 0;
    }];
    
    if (_isNeedPush) {
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset = 5;
            make.top.bottom.offset = 0;
            make.right.equalTo(self.jiantouImage.mas_left);
        }];
        
        [self.jiantouImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.centerY.offset = 0;
//            make.width.offset = 20;
        }];
    }else{
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset = 5;
            make.top.bottom.offset = 0;
            make.right.offset = -10;
        }];
    }
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.offset = 0;
//        make.height.offset = 1;
//    }];
}

- (void)adView1Action{
    if (self.needPushBlock) {
        self.needPushBlock();
    }
}

@end
