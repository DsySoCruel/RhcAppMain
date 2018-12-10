//
//  OrderPeijianCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/18.
//

#import "OrderPeijianCell.h"


@interface OrderPeijianCell ()
@property (nonatomic,strong) UIImageView   *headImageView;
@property (nonatomic,strong) UILabel       *titlLabel;
@property (nonatomic,strong) UILabel       *priceLabel;
@property (nonatomic,strong) UILabel       *numberLabel;
@property (nonatomic,strong) UIView        *lineView;
@end

@implementation OrderPeijianCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

-(void)setupUI{
    
    self.headImageView = [UIImageView new];
    
    self.titlLabel = [UILabel new];
    self.titlLabel.font = SFONT(15);
    self.titlLabel.textColor = SMTextColor;
    self.titlLabel.numberOfLines = 2;
    
    self.priceLabel = [UILabel new];
    self.priceLabel.font = LPFFONT(13);
    self.priceLabel.textColor = [UIColor redColor];
    
    self.numberLabel = [UILabel new];
    self.numberLabel.font = LPFFONT(13);
    self.numberLabel.textColor = SMParatextColor;
    
    self.lineView = [UILabel new];
    self.lineView.backgroundColor = SMViewBGColor;
    
    [self.contentView addSubview:self.titlLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.lineView];
    
}

-(void)setupLayout{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(15).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(115, 76.5));
        make.bottom.offset = -15;
    }];
    
    [self.titlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.headImageView).offset =10;
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
//        make.right.offset = -10;
        make.bottom.equalTo(self.headImageView.mas_bottom).offset = -10;
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -15;
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

- (void)setModel:(ShopCarListModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:URLWithImageName(model.goodsImage) placeholderImage:IMAGECACHE(@"zhan_mid")];
    self.titlLabel.text = model.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[model.price priceWithWan]];
    self.numberLabel.text = [NSString stringWithFormat:@"x%@",model.cnt];
}

@end
