//
//  ProductListFooterView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/31.
//

#import "ProductListFooterView.h"

@interface ProductListFooterView()
//@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *checkMoreButton;

@end

@implementation ProductListFooterView

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    if (self = [super init]) {
        self.backgroundColor = SMViewBGColor;
        self.checkMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkMoreButton setTitle:@"查看全部秒杀 ➞" forState:UIControlStateNormal];
        [self.checkMoreButton setTitleColor:SMTextColor forState:UIControlStateNormal];
        self.checkMoreButton.backgroundColor = [UIColor whiteColor];
        self.checkMoreButton.titleLabel.font = LPFFONT(12);
        [self addSubview:self.checkMoreButton];
        [self.checkMoreButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self .checkMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.offset = 0;
            make.bottom.offset = -15;
        }];
    }
    return self;
}


@end
