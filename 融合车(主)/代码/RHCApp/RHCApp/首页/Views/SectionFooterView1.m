//
//  SectionFooterView1.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/1.
//

#import "SectionFooterView1.h"

@implementation SectionFooterView1

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        //1.
        UIView *orangeView = [UIView new];
        orangeView.backgroundColor = [UIColor redColor];
        [self addSubview:orangeView];
        
        self.label = [UILabel new];
        if (title.length) {
            self.label.text = title;
        }
        self.label.textColor = SMTextColor;
        self.label.font = LPFFONT(12);
        [self addSubview:self.label];
        
        [orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.width.offset = 5;
            make.height.offset = 20;
            make.left.offset = 15;
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.left.equalTo(orangeView.mas_right).offset = 5;
        }];
    }
    return self;
}
@end
