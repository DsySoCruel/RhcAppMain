//
//  CollectCarListCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/3.
//

#import "CollectCarListCell.h"

@interface CollectCarListCell ()
@property (nonatomic,strong) UIImageView   *headImageView;
@property (nonatomic,strong) UILabel       *brandLabel;
@property (nonatomic,strong) UILabel       *typeLabel;
@property (nonatomic,strong) UILabel       *priceLabel;
@property (nonatomic,strong) UILabel       *timeLabel;
@property (nonatomic,strong) UIView        *lineView;
@end


@implementation CollectCarListCell

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
    
    self.brandLabel = [UILabel new];
    self.brandLabel.font = SFONT(17);
    self.brandLabel.textColor = SMTextColor;
    self.brandLabel.numberOfLines = 1;
    
    self.typeLabel = [UILabel new];
    self.typeLabel.font = SFONT(15);
    self.typeLabel.textColor = SMTextColor;
    self.typeLabel.numberOfLines = 2;
    
    self.priceLabel = [UILabel new];
    self.priceLabel.font = LPFFONT(10);
    self.priceLabel.textColor = SMParatextColor;
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = LPFFONT(10);
    self.timeLabel.textColor = SMParatextColor;
    
    self.lineView = [UILabel new];
    self.lineView.backgroundColor = SMViewBGColor;
    
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.brandLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineView];
    
}

-(void)setupLayout{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(15).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(115, 76.5));
        make.bottom.offset = -15;
    }];
    
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.headImageView);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.brandLabel.mas_bottom).offset = 2;
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.typeLabel.mas_bottom).offset = 2;
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.priceLabel.mas_bottom).offset = 2;
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

- (void)setModel:(MyCollectListModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:URLWithImageName(model.url) placeholderImage:IMAGECACHE(@"zhan_mid")];
    self.brandLabel.text = [NSString stringWithFormat:@"%@%@",model.brandName,model.typeName];
    self.typeLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"厂商指导价%@",[model.reference_price priceWithWan]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 收藏",[model.create_time timeTypeFromNow]];
}
@end
