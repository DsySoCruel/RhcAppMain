//
//  SelectBrandNameCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/22.
//

#import "SelectBrandNameCell.h"

@interface SelectBrandNameCell()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UIView      *line;

@end


@implementation SelectBrandNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.icon addRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(20, 20)];
    [self.contentView addSubview:self.icon];
    self.nameLabel = [UILabel new];
    self.nameLabel.font = LPFFONT(14);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = SMTextColor;
    self.nameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.nameLabel];
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.line];
}

- (void)setupLayout{
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 15;
        make.height.offset = 40;
        make.width.offset = 40;
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.equalTo(self.icon.mas_right).offset = 15;
        make.right.offset = -15;
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 0.5;
        make.left.right.bottom.offset = 0;
    }];
}

- (void)setModel:(BrandModel *)model{
    _model = model;
    [self.icon sd_setImageWithURL:URLWithImageName(model.img) placeholderImage:IMAGECACHE(@"zhan_head")];
    self.nameLabel.text = model.title;
}
@end
