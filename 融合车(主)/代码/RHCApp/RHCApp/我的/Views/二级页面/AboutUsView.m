//
//  AboutUsView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/28.
//

#import "AboutUsView.h"

@interface AboutUsView()

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UIView  *line;


@end

@implementation AboutUsView

- (instancetype)initWith:(NSString *)title andSubsTitle:(NSString *)subTitle subTitleColor:(UIColor *)subTitleColor{
    if (self = [super init]) {
        [self setupUIWith:(NSString *)title andSubsTitle:(NSString *)subTitle subTitleColor:(UIColor *)subTitleColor];
        [self setupLayout];
    }
    return self;
}

- (void)setupUIWith:(NSString *)title andSubsTitle:(NSString *)subTitle subTitleColor:(UIColor *)subTitleColor{
    self.label1 = [UILabel new];
    self.label1.textColor = SMParatextColor;
    self.label1.font = MFFONT(16);
    self.label1.text = title;
    [self addSubview:self.label1];
    
    self.label2 = [UILabel new];
    self.label2.text = subTitle;
    self.label2.textColor = subTitleColor;
    self.label2.font = LPFFONT(14);
    [self addSubview:self.label2];
    
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self addSubview:self.line];
}

- (void)setupLayout{
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 0;
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.offset = 0;
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 0.5;
        make.bottom.offset = 0;
    }];    
}


@end
