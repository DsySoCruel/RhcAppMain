//
//  HomeSeckillControllerCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/7/19.
//

#import "HomeSeckillControllerCell.h"


@interface HomeSeckillControllerCell()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UIImageView *typeImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *oldPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *firstPayLabel;
@property (nonatomic,strong) UILabel  *realHave;//剩余几台
@property (nonatomic,strong) UIButton *qingButton;
//设置剩余库存
@property (nonatomic, strong) UIView *progressbackView;
@property (nonatomic, strong) UIView *progressView;
@end

@implementation HomeSeckillControllerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = SMViewBGColor;
    
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];    
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backView addSubview:self.iconImageView];
    
    self.typeImageView = [UIImageView new];
    [self.backView addSubview:self.typeImageView];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"本田思域-放哪少的发卡打发时间福克斯打飞机";
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.textColor = SMParatextColor;
    self.nameLabel.font = LPFFONT(16);
    [self.backView addSubview:self.nameLabel];
    
    //厂商指导价
    self.oldPriceLabel = [UILabel new];
    self.oldPriceLabel.textColor = SMParatextColor;
    self.oldPriceLabel.font = LPFFONT(12);
    [self.backView addSubview:self.oldPriceLabel];
    
    //现价
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.font = MFFONT(14);
    [self.backView addSubview:self.priceLabel];
    
    //首付
    self.firstPayLabel = [UILabel new];
    self.firstPayLabel.text = @"首付2.19万";
    self.firstPayLabel.textColor = [UIColor redColor];
    self.firstPayLabel.font = MFFONT(12);
    [self.backView addSubview:self.firstPayLabel];
    
    
    self.realHave = [UILabel new];
    self.realHave.textColor = SMTextColor;
    self.realHave.font = LPFFONT(11);
    self.realHave.textAlignment = NSTextAlignmentCenter;
    [self.iconImageView addSubview:self.realHave];

    self.qingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qingButton setTitle:@"立即抢" forState:UIControlStateNormal];
    [self.qingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.qingButton.titleLabel.font = LPFFONT(14);
    self.qingButton.backgroundColor = [UIColor redColor];
    self.qingButton.layer.cornerRadius = 12.5;
    self.qingButton.layer.masksToBounds = YES;
    self.qingButton.userInteractionEnabled = NO;
    [self.backView addSubview:self.qingButton];
    
    
    self.progressbackView = [UIView new];
    self.progressView = [UIView new];
    self.progressbackView.backgroundColor = SMViewBGColor;
    self.progressbackView.layer.cornerRadius = 5;
    self.progressbackView.clipsToBounds = YES;
    self.progressView.backgroundColor = SMThemeColor;
    self.progressView.layer.cornerRadius = 5;
    self.progressView.clipsToBounds = YES;
    [self.progressbackView addSubview:self.progressView];
    [self.backView addSubview:self.progressbackView];
}

- (void)setupLayout{
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.top.left.offset = 10;
        make.bottom.equalTo(self.contentView.mas_bottom).offset = 0;
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset = 15;
        make.right.offset = -15;
        make.height.offset = 150;
    }];
    
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 0;
        make.left.offset = 10;
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.iconImageView.mas_bottom).offset = 5;
    }];
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.nameLabel.mas_bottom).offset = 2;
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.oldPriceLabel);
        make.top.equalTo(self.oldPriceLabel.mas_bottom).offset = 2;
    }];
    [self.firstPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.progressbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.width.offset = Screen_W * 0.4;
        make.height.offset = 10;
        make.centerY.equalTo(self.qingButton);
    }];
    
    [self.qingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.height.offset = 25;
        make.width.offset = 70 ;
        make.top.equalTo(self.priceLabel.mas_bottom).offset = 10;
//        make.centerY.equalTo(self.oldPriceLabel.mas_centerY);
        make.bottom.offset = -15;
    }];
    [self.realHave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.qingButton.mas_left).offset = -10;
        make.left.equalTo(self.progressbackView.mas_right).offset = 10;
        make.centerY.equalTo(self.qingButton);
    }];
}

- (void)setModel:(ProductModel *)model{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:URLWithImageName(model.img) placeholderImage:IMAGECACHE(@"zhan_mid")];
    //设置品牌型号信息
    NSString *brandName = [NSString stringWithFormat:@"%@%@",model.brandName,model.typeName];
    NSMutableAttributedString *aaa = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@-%@",brandName,model.title]];
    [aaa addAttribute:NSForegroundColorAttributeName value:SMTextColor range:NSMakeRange(0,brandName.length)];
    [aaa addAttribute:NSFontAttributeName value:BFONT(16) range:NSMakeRange(0,brandName.length)];

    self.nameLabel.attributedText = aaa;
    NSString *oldPrice = [NSString stringWithFormat:@"厂商指导价%@",[model.reference_price priceWithWan]];
    NSUInteger length = [oldPrice length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:SMViewBGColor range:NSMakeRange(0, length)];
    [self.oldPriceLabel setAttributedText:attri];

    self.priceLabel.text = [NSString stringWithFormat:@"现价%@",[model.price priceWithWan]];
    self.firstPayLabel.text = [NSString stringWithFormat:@"首付%@",[model.min_down_payment priceWithWan]];
    self.typeImageView.hidden = !model.showstate.length;
    if ([model.showstate isEqualToString:@"爆款"]) {
        self.typeImageView.image = IMAGECACHE(@"SecKill_01");
    }else if ([model.showstate isEqualToString:@"钜惠"]){
        self.typeImageView.image = IMAGECACHE(@"SecKill_02");
    }else if ([model.showstate isEqualToString:@"优选"]){
        self.typeImageView.image = IMAGECACHE(@"SecKill_03");
    }else{
        self.typeImageView.hidden = YES;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"仅剩 %@ 台",model.aparinventory]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.aparinventory.length)];
    [str addAttribute:NSFontAttributeName value:BFONT(15) range:NSMakeRange(3, model.aparinventory.length)];
    self.realHave.attributedText = str;
    if ([model.apinventory integerValue] == 0) {
        [self setpress:1.0];
    }else{
        [self setpress:[model.aparinventory integerValue]/[model.apinventory integerValue]];
    }
}

-(void)setpress:(CGFloat)num{
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.offset = 0;
        make.width.mas_equalTo(self.progressbackView.mas_width).multipliedBy(num);
    }];
    [self layoutIfNeeded];
}
@end
