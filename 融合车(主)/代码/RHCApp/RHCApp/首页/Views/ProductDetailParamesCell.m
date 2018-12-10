//
//  ProductDetailParamesCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/2.
//

#import "ProductDetailParamesCell.h"

@interface ProductDetailParamesCell()
@property (nonatomic,strong) UILabel *keyLabel;
@property (nonatomic,strong) UILabel *valueLabel;//组织
@property (nonatomic,strong) UIView  *lineView;
@end

@implementation ProductDetailParamesCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    
    self.keyLabel = [UILabel new];
    self.keyLabel.font = BFONT(14);
    self.keyLabel.textColor = SMTextColor;
    [self.contentView addSubview:self.keyLabel];
    
    self.valueLabel = [UILabel new];
    self.valueLabel.font = LPFFONT(12);
    self.valueLabel.textColor = SMParatextColor;
    [self.contentView addSubview:self.valueLabel];
    
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.lineView];
}

- (void)setupLayout{
    
    [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.height.offset = 40;
        make.top.bottom.offset = 0;
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.top.bottom.offset = 0;
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 1;
    }];
}
- (void)setModel:(ParamesModel *)model{
    _model = model;
    self.keyLabel.text = model.key;
    self.valueLabel.text = model.value;
}


@end
