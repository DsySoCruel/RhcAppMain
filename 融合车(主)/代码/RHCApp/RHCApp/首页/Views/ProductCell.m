//
//  ProductCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/30.
//

#import "ProductCell.h"

@interface ProductCell()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel     *label1;//秒杀
@property (nonatomic,strong) UILabel     *canBuyNum;//超值优惠限购几台
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UIImageView *typeImageView;//火的标记
@property (nonatomic,strong) UILabel     *type;//车型
@property (nonatomic,strong) UILabel     *oldPriceLabel;
@property (nonatomic,strong) UILabel     *priceLabel;
@property (nonatomic,strong) UILabel     *firstPayLabel;
//设置剩余库存
@property (nonatomic, strong) UIView      *progressbackView;
@property (nonatomic, strong) UIView      *progressView;
@property (nonatomic, strong) UILabel     *realHave;//剩余几台

@property (nonatomic, strong) UIView *line;
@end


@implementation ProductCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI{
    
    self.iconImageView = [UIImageView new];
    //    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconImageView];
    
    self.label1 = [UILabel new];
    self.label1.font = BFONT(12);
    self.label1.backgroundColor = RGB(0xFFDC00);
    self.label1.textColor = SMTextColor;
    self.label1.layer.cornerRadius = 9;
    self.label1.layer.masksToBounds = YES;
    self.label1.text = @"秒杀";
    self.label1.textAlignment = NSTextAlignmentCenter;
    [self.iconImageView addSubview:self.label1];
    
    self.canBuyNum = [UILabel new];
    self.canBuyNum.font = LPFFONT(11);
    self.canBuyNum.backgroundColor = SMThemeColor;
    self.canBuyNum.textColor = [UIColor whiteColor];
    self.canBuyNum.text = @"猜你喜欢";
//    self.canBuyNum.text = @"超值优惠限购5台";
    self.canBuyNum.textAlignment = NSTextAlignmentCenter;
    [self.iconImageView addSubview:self.canBuyNum];
    
    
    self.nameLabel = [UILabel new];
//    self.nameLabel.text = @"本田思域";
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = BPFFONT(18);
    [self.contentView addSubview:self.nameLabel];
    
    self.typeImageView = [UIImageView new];
    [self.contentView addSubview:self.typeImageView];
    
    self.type = [UILabel new];
//    self.type.text = @"2017款180TURBO手动舒适版";
    self.type.numberOfLines = 2;
    self.type.textColor = [UIColor blackColor];
    self.type.font = BPFFONT(14);
    [self.contentView addSubview:self.type];
    
    //厂商指导价
    self.oldPriceLabel = [UILabel new];
    self.oldPriceLabel.textColor = SMParatextColor;
    self.oldPriceLabel.font = LPFFONT(12);
    [self.contentView addSubview:self.oldPriceLabel];
    
    //现价
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.font = MFFONT(14);
    [self.contentView addSubview:self.priceLabel];
    
    //首付
    self.firstPayLabel = [UILabel new];
    self.firstPayLabel.text = @"首付2.19万";
    self.firstPayLabel.textColor = [UIColor redColor];
    self.firstPayLabel.font = MFFONT(12);
    [self.contentView addSubview:self.firstPayLabel];
    
    
    self.realHave = [UILabel new];
    self.realHave.textColor = SMTextColor;
    self.realHave.font = LPFFONT(11);
    self.realHave.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.realHave];
    
    self.progressbackView = [UIView new];
    self.progressView = [UIView new];
    self.progressbackView.backgroundColor = SMViewBGColor;
    self.progressbackView.layer.cornerRadius = 5;
    self.progressbackView.clipsToBounds = YES;
    self.progressView.backgroundColor = SMThemeColor;
    self.progressView.layer.cornerRadius = 5;
    self.progressView.clipsToBounds = YES;
    [self.progressbackView addSubview:self.progressView];
    [self.contentView addSubview:self.progressbackView];
    
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.line];
}

- (void)setupLayout{
    //图片
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset  = 15;
        make.height.offset = 91;
        make.width.offset = 121;
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 2;
        make.top.offset = 5;
        make.width.offset = 40;
        make.height.offset = 18;
    }];
    
    [self.canBuyNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 17.5;
    }];
    
    //2.
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.iconImageView);
    }];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset = 5;
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.offset = -10;
        make.top.equalTo(self.nameLabel.mas_bottom).offset = 2;
    }];
    
    [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.offset = -10;
        make.top.equalTo(self.type.mas_bottom).offset = 3;
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
        make.left.equalTo(self.oldPriceLabel);
        make.width.offset = Screen_W * 0.35;
        make.height.offset = 10;
        make.top.equalTo(self.priceLabel.mas_bottom).offset = 10;
        make.bottom.offset = -15;
    }];

    [self.realHave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.left.equalTo(self.progressbackView.mas_right).offset = 10;
        make.centerY.equalTo(self.progressbackView);
    }];
}

- (void)setModel:(ProductModel *)model{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:URLWithImageName(model.img) placeholderImage:IMAGECACHE(@"zhan_mid")];
//    self.canBuyNum.text = @"";
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@",model.brandName,model.typeName];
    self.type.text = model.title;
    NSString *oldPrice = [NSString stringWithFormat:@"厂商指导价%@",[model.reference_price priceWithWan]];
    NSUInteger length = [oldPrice length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:SMParatextColor range:NSMakeRange(0, length)];
    [self.oldPriceLabel setAttributedText:attri];
    
    self.priceLabel.text = [NSString stringWithFormat:@"现价%@",[model.price priceWithWan]];
    self.firstPayLabel.text = [NSString stringWithFormat:@"首付%@",[model.min_down_payment priceWithWan]];
//    self.typeImageView.hidden = !model.showstate.length;
//    if ([model.showstate isEqualToString:@"推荐"]) {
//        self.typeImageView.image = IMAGECACHE(@"SecKill_01");
//    }else if ([model.showstate isEqualToString:@"钜惠"]){
//        self.typeImageView.image = IMAGECACHE(@"SecKill_02");
//    }else{
//        self.typeImageView.image = IMAGECACHE(@"SecKill_03");
//    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"仅剩 %@ 台",model.aparinventory]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.aparinventory.length)];
    [str addAttribute:NSFontAttributeName value:BFONT(15) range:NSMakeRange(3, model.aparinventory.length)];
    self.realHave.attributedText = str;
    if ([model.apinventory integerValue] == 0) {
        [self setpress:1.0];
    }else{
        [self setpress:[model.aparinventory integerValue]/[model.apinventory integerValue]];
    }
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.offset = 0;
        make.height.offset = 0.5;
    }];
    
    
    //区别秒杀
    if (model.isSkill) {
        self.label1.hidden = NO;
        self.progressbackView.hidden = NO;
        self.progressView.hidden = NO;
        self.realHave.hidden = NO;
        [self.firstPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.centerY.equalTo(self.priceLabel);
        }];
        [self.progressbackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.oldPriceLabel);
            make.width.offset = Screen_W * 0.35;
            make.height.offset = 10;
            make.top.equalTo(self.priceLabel.mas_bottom).offset = 10;
            make.bottom.offset = -15;
        }];

    }else{
        self.label1.hidden = YES;
        self.progressbackView.hidden = YES;
        self.progressView.hidden = YES;
        self.realHave.hidden = YES;
        [self.firstPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.centerY.equalTo(self.priceLabel);
            make.bottom.offset = -15;
        }];
        [self.progressbackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.oldPriceLabel);
            make.width.offset = Screen_W * 0.35;
            make.height.offset = 10;
            make.top.equalTo(self.priceLabel.mas_bottom).offset = 10;
        }];
    }
    
    if ([model.aparType integerValue] == 5) {
        self.canBuyNum.hidden = NO;
    }else{
        self.canBuyNum.hidden = YES;
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
