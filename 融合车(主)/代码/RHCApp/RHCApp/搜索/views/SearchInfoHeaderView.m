//
//  SearchInfoHeaderView.m
//  Scimall
//
//  Created by Draven on 2017/7/14.
//  Copyright © 2017年 贾培军. All rights reserved.
//

#import "SearchInfoHeaderView.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)
@interface SearchInfoHeaderView ()
@property (nonatomic,strong) UIButton  *addButton;
@property (nonatomic,strong) UILabel   *msgLabel;
@property (nonatomic,strong) UILabel   *lineLabel;
@property (nonatomic, copy) void(^tapAction)(id,NSInteger);
@end

@implementation SearchInfoHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI {
    self.msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.msgLabel.text = @"";
    self.msgLabel.textColor =  SMParatextColor;
    self.msgLabel.font = LPFFONT(17);
    [self addSubview:self.msgLabel];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addButton setBackgroundColor:[UIColor clearColor]];
    [self.addButton setImage:IMAGECACHE(@"huishou") forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    
    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lineLabel.backgroundColor = SMLineColor;
    [self addSubview:self.lineLabel];
}
- (void)setupLayout {
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.equalTo(self);
        make.width.mas_equalTo(100);
    }];
 
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(30);
        make.bottom.mas_equalTo(-5);
    }];
  
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self).offset(-.5);
    }];
   
}

- (void)loadHeadDataSource:(NSString *)text {
    
    self.msgLabel.text = text;
    if (self.section == 0 && [text isEqualToString:@"搜索记录"]) {
        self.addButton.hidden = NO;
    }else {
        self.addButton.hidden = YES;
    }
}

- (void)setHeaderBackgroundColor:(UIColor *)color{
    self.backgroundColor = color;
}
- (void)addButtonAction:(id)sender{
    if (self.tapAction) {
        self.tapAction(sender,self.section);
    }
}
- (void)didSelectedTapBlock:(void (^)(id, NSInteger))tapAction{
    self.tapAction = tapAction;
}

@end
