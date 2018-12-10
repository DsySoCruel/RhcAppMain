//
//  SelfSizingCollectCell.m
//  Scimall
//
//  Created by Draven on 2017/7/13.
//  Copyright © 2017年 贾培军. All rights reserved.
//

#import "SelfSizingCollectCell.h"

#define itemHeight 60

@interface SelfSizingCollectCell ()

@end
@implementation SelfSizingCollectCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self bootstrapBackgroundStyle:self.contentView];
        // 用约束来初始化控件:
        self.textLabel = [[UILabel alloc] init];
        [self bootstrapStyle:self.textLabel];
        [self.contentView addSubview:self.textLabel];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(7.5);
            make.bottom.right.offset(-7.5);
        }];

    }
    return self;
}

#pragma mark -- Helper
-(void)bootstrapBackgroundStyle:(UIView *)view {    
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.8;
    view.layer.borderColor = SMLineColor.CGColor;
}

#pragma mark -- Helper
-(void)bootstrapStyle:(UILabel *)textLabel {
    textLabel.textAlignment =NSTextAlignmentCenter;
    textLabel.font = LPFFONT(15);
    textLabel.textColor = SMTextColor;
    textLabel.backgroundColor = [UIColor whiteColor];
}

@end
