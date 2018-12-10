//
//  BookCarriageViewCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/1.
//

#import "BookCarriageViewCell.h"

@interface BookCarriageViewCell()
@end

@implementation BookCarriageViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setupUI{
    self.label1 = [UILabel new];
    self.label1.textColor = SMTextColor;
    self.label1.font = LPFFONT(13);
    [self.contentView addSubview:self.label1];
}
- (void)setupLayout{
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 10;
    }];
}

@end
