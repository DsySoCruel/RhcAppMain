//
//  ShopCarCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/8.
//

#import "ShopCarCell.h"
#import "ShopCarListModel.h"

@interface ShopCarCell()
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UIButton *jian;
@property (nonatomic,strong) UILabel *num;
@property (nonatomic,strong) UIButton *jia;
@property (nonatomic,strong) UIView *line;
@end

@implementation ShopCarCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI{
    //    self.contentView.backgroundColor = SMViewBGColor;
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:IMAGECACHE(@"gouwuche_01") forState:UIControlStateNormal];
    [self.selectButton setImage:IMAGECACHE(@"gouwuche_02") forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];
    [self.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.iconImageView = [UIImageView new];
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = LPFFONT(15);
    self.nameLabel.textColor = SMTextColor;
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];
    
    self.typeLabel = [UILabel new];
    self.typeLabel.font = LPFFONT(12);
    self.typeLabel.textColor = SMParatextColor;
    self.typeLabel.numberOfLines = 1;
    [self.contentView addSubview:self.typeLabel];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.font = LPFFONT(13);
    self.priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:self.priceLabel];
    
    self.jian = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.jian setImage:IMAGECACHE(@"icon_52") forState:UIControlStateNormal];
    [self.contentView addSubview:self.jian];
    [self.jian addTarget:self action:@selector(jianButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.num = [UILabel new];
    self.num.textColor = SMParatextColor;
    self.num.font = LPFFONT(13);
    self.num.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.num];
    
    self.jia = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.jia setImage:IMAGECACHE(@"icon_53") forState:UIControlStateNormal];
    [self.contentView addSubview:self.jia];
    [self.jia addTarget:self action:@selector(jiaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.line];
    
}

- (void)setupLayout{
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 50;
        make.height.width.offset = 45;
        make.top.offset = 15;
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.centerY.equalTo(self.iconImageView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset = 10;
        make.right.offset = -15;
        make.top.equalTo(self.iconImageView.mas_top).offset = 0;
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset = 10;
        make.top.equalTo(self.nameLabel.mas_bottom).offset = 3;
        make.right.offset = -15;
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset = 10;
        make.top.equalTo(self.typeLabel.mas_bottom).offset = 10;
        make.bottom.offset = -10;
    }];
    
    [self.jia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.bottom.offset = -10;
        make.width.height.offset = 25;
    }];
    
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jia.mas_left).offset = -10;
        make.width.height.offset = 30;
        make.centerY.equalTo(self.jia).offset = 0;
    }];
    
    [self.jian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.num.mas_left).offset = -10;
        make.centerY.equalTo(self.jia).offset = 0;
        make.width.height.offset = 25;
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 0.5;
        make.bottom.offset = 0;
    }];
    
}

- (void)setGoodModel:(ShopCarListModel *)goodModel{
    _goodModel = goodModel;
    [self.iconImageView sd_setImageWithURL:URLWithImageName(goodModel.goodsImage) placeholderImage:IMAGECACHE(@"icon_0000")];
    self.nameLabel.text = goodModel.goodsName;
    self.typeLabel.text = [NSString stringWithFormat:@"%@ %@",goodModel.style,goodModel.color];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",goodModel.price];
    self.num.text = goodModel.cnt;
    self.selectButton.selected = goodModel.isSelect;
}

- (void)selectButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.goodModel.isSelect = sender.selected;
    if (self.selectButtonActionBlock) {
        self.selectButtonActionBlock();
    }
}

- (void)jianButtonAction:(UIButton *)sender{
    //    if ([self.goodModel.cnt integerValue] <= 1) {
    //        [MBHUDHelper showSuccess:@"亲,真的不能再少了"];
    //        return;
    //    }
    NSInteger cnt = [self.goodModel.cnt integerValue];
    --cnt;
    
    //减少商品数量
    sender.userInteractionEnabled = NSNotFound;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"id"] = self.goodModel.goodsId;
    parames[@"number"] = [NSString stringWithFormat:@"%tu",cnt];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductUpdateCarItemNumber parameters:parames successed:^(id json) {
        if (json) {
            Weakself.goodModel.cnt = [NSString stringWithFormat:@"%tu",cnt];
            //改变商品数量更新总价
            if (Weakself.needContTotalPriceBlock && Weakself.selectButton.selected) {
                Weakself.needContTotalPriceBlock();
            }
            if ([Weakself.goodModel.cnt integerValue] <= 0) {
                //执行删除操作
                
                //进行删除操作
                NSMutableDictionary *parames = [NSMutableDictionary dictionary];
                parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
                parames[@"id"] = Weakself.goodModel.goodsId;
                WeakObj(self);
                [[NetWorkManager shareManager] POST:USER_ProductDeleteCarItem parameters:parames successed:^(id json) {
                    if (json) {
                        [MBHUDHelper showSuccess:@"删除成功"];
                        if (Weakself.needUpdataBlock) {
                            Weakself.needUpdataBlock();
                        }
                    }
                } failure:^(NSError *error) {
                }];
            }else{
                Weakself.num.text = Weakself.goodModel.cnt;
            }
        }
        sender.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        sender.userInteractionEnabled = YES;
        
    }];
}

- (void)jiaButtonAction:(UIButton *)sender{
    NSInteger cnt = [self.goodModel.cnt integerValue];
    ++cnt;
    //增加商品数量
    sender.userInteractionEnabled = NO;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"id"] = self.goodModel.goodsId;
    parames[@"number"] = [NSString stringWithFormat:@"%tu",cnt];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductUpdateCarItemNumber parameters:parames successed:^(id json) {
        if (json) {
            Weakself.goodModel.cnt = [NSString stringWithFormat:@"%tu",cnt];
            Weakself.num.text = Weakself.goodModel.cnt;
            //改变商品数量更新总价
            if (Weakself.needContTotalPriceBlock && Weakself.selectButton.selected) {
                Weakself.needContTotalPriceBlock();
            }
        }
        sender.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        sender.userInteractionEnabled = YES;
    }];
}


@end
