//
//  OrderDetailSecondCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/30.
//

#import "OrderDetailSecondCell.h"
#import "OrderCarDetailModel.h"
#import "AllConfigurationController.h"

@interface OrderDetailSecondCell ()
@property (nonatomic,strong) UILabel *a;//订单详情
@property (nonatomic,strong) UIView  *b;//line
@property (nonatomic,strong) UIImageView *carIconView;//图片
@property (nonatomic,strong) UILabel *carName;//
@property (nonatomic,strong) UILabel *carPrice;//
@property (nonatomic,strong) UIView  *b1;//line
@property (nonatomic,strong) UILabel *c;//车辆颜色
@property (nonatomic,strong) UILabel *d;//内饰颜色
@property (nonatomic,strong) UILabel *e;//配置详情
@property (nonatomic,strong) UIButton *eButton;//配置详情
@property (nonatomic,strong) UILabel *f;//贷款金额
@property (nonatomic,strong) UILabel *g;//车辆首付
@property (nonatomic,strong) UILabel *h;//手续费
@property (nonatomic,strong) UILabel *i;//上牌费
@property (nonatomic,strong) UILabel *j;//保险押金
@property (nonatomic,strong) UILabel *k;//提车首付总计
@property (nonatomic,strong) UILabel *l;//月供
@property (nonatomic,strong) UILabel *m;//还款期数
@property (nonatomic,strong) UILabel *n;//赠品
@property (nonatomic,strong) UIView  *o;//line

@end


@implementation OrderDetailSecondCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.a = [UILabel new];
    self.a.font = LPFFONT(16);
    self.a.textColor = SMTextColor;
    [self.contentView addSubview:self.a];
    
    self.b = [UIView new];
    self.b.backgroundColor = SMLineColor;
    [self.contentView addSubview:self.b];
    
    self.carIconView = [UIImageView new];
    [self.contentView addSubview:self.carIconView];
    
    self.carName = [UILabel new];
    self.carName.font = LPFFONT(16);
    self.carPrice.textColor = SMTextColor;
    [self.contentView addSubview:self.carName];
    
    self.carPrice = [UILabel new];
    self.carName.font = LPFFONT(16);
    self.carPrice.textColor = SMTextColor;
    [self.contentView addSubview:self.carPrice];
    
    self.b1 = [UIView new];
    self.b1.backgroundColor = SMLineColor;
    [self.contentView addSubview:self.b1];
    
    self.c = [UILabel new];
    self.c.font = LPFFONT(14);
    self.c.textColor = SMParatextColor;
    [self.contentView addSubview:self.c];
    
    self.d = [UILabel new];
    self.d.font = LPFFONT(14);
    self.d.textColor = SMParatextColor;
    [self.contentView addSubview:self.d];
    
    self.e = [UILabel new];
    self.e.font = LPFFONT(14);
    self.e.textColor = SMParatextColor;
    [self.contentView addSubview:self.e];
    
    self.eButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.eButton setTitle:@"点击查看" forState:UIControlStateNormal];
    [self.eButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.eButton.titleLabel.font = LPFFONT(14);
    [self.eButton addTarget:self action:@selector(eButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.eButton];
    
    self.f = [UILabel new];
    self.f.font = LPFFONT(14);
    self.f.textColor = SMParatextColor;
    [self.contentView addSubview:self.f];
    
    self.g = [UILabel new];
    self.g.font = LPFFONT(14);
    self.g.textColor = SMParatextColor;
    [self.contentView addSubview:self.g];
    
    
    self.h = [UILabel new];
    self.h.font = LPFFONT(14);
    self.h.textColor = SMParatextColor;
    [self.contentView addSubview:self.h];
    
    
    self.i = [UILabel new];
    self.i.font = LPFFONT(14);
    self.i.textColor = SMParatextColor;
    [self.contentView addSubview:self.i];
    
    self.j = [UILabel new];
    self.j.font = LPFFONT(14);
    self.j.textColor = SMParatextColor;
    [self.contentView addSubview:self.j];
    
    self.k = [UILabel new];
    self.k.font = LPFFONT(14);
    self.k.textColor = SMParatextColor;
    [self.contentView addSubview:self.k];
    
    self.l = [UILabel new];
    self.l.font = LPFFONT(14);
    self.l.textColor = SMParatextColor;
    [self.contentView addSubview:self.l];
    
    self.m = [UILabel new];
    self.m.font = LPFFONT(14);
    self.m.textColor = SMParatextColor;
    [self.contentView addSubview:self.m];
    
    self.n = [UILabel new];
    self.n.font = LPFFONT(14);
    self.n.textColor = SMParatextColor;
    [self.contentView addSubview:self.n];
    
    self.o = [UIView new];
    self.o.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.o];
}

- (void)setupLayout{
    [self.a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.offset = 0;
        make.height.offset = 45;
    }];
    [self.b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 0.5;
        make.top.equalTo(self.a.mas_bottom).offset = 0;
    }];
    
    [self.carIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.width.offset = 95;
        make.height.offset = 75;
        make.top.equalTo(self.b.mas_bottom).offset = 15;
    }];
    
    [self.carName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.left.equalTo(self.carIconView.mas_right).offset = 10;
        make.top.equalTo(self.carIconView.mas_top).offset = 5;
    }];
    
    [self.carPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.left.equalTo(self.carIconView.mas_right).offset = 10;
        make.top.equalTo(self.carName.mas_bottom).offset = 10;
    }];
    
    [self.b1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 0.5;
        make.top.equalTo(self.carIconView.mas_bottom).offset = 10;
    }];
    
    
    [self.c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.b1.mas_bottom).offset = 15;
    }];
    [self.d mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.c.mas_bottom).offset = 5;
    }];
    [self.e mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
//        make.right.offset = -10;
        make.top.equalTo(self.d.mas_bottom).offset = 5;
    }];
    [self.eButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.e);
        make.left.equalTo(self.e.mas_right).offset = 5;
    }];
    [self.f mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.e.mas_bottom).offset = 5;
    }];
    [self.g mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.f.mas_bottom).offset = 5;
    }];
    [self.h mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.g.mas_bottom).offset = 5;
    }];
    [self.i mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.h.mas_bottom).offset = 5;
    }];
    [self.j mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.i.mas_bottom).offset = 5;
    }];
    [self.k mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.j.mas_bottom).offset = 5;
    }];
    [self.l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.k.mas_bottom).offset = 5;
    }];
    [self.m mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.l.mas_bottom).offset = 5;
    }];
    [self.n mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.m.mas_bottom).offset = 5;
    }];
    [self.o mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.equalTo(self.n.mas_bottom).offset = 5;
        make.bottom.offset = 0;
        make.height.offset = 10;
    }];
}

- (void)setModel:(OrderCarDetailModel *)model{
    _model = model;
    self.a.text = @"订单详情";
    [self.carIconView sd_setImageWithURL:URLWithImageName(model.img) placeholderImage:IMAGECACHE(@"zhan_mid")];
    self.carName.text = model.title;
    self.carPrice.text = [NSString stringWithFormat:@"￥ %@",[model.productPrice priceWithWan]];
    self.c.text = [NSString stringWithFormat:@"车辆颜色: %@",model.color];
    self.d.text = [NSString stringWithFormat:@"内饰颜色: %@",model.inColor];
    self.e.text = @"配置详情:";
    self.f.text = [NSString stringWithFormat:@"贷款金额: %@",model.color];
    self.g.text = [NSString stringWithFormat:@"车辆首付(30.0%%): %@",model.color];
    self.h.text = [NSString stringWithFormat:@"手续费: %@",model.color];
    self.i.text = [NSString stringWithFormat:@"上牌费: %@",model.color];
    self.j.text = [NSString stringWithFormat:@"保险押金: %@",model.color];
    self.k.text = [NSString stringWithFormat:@"提车首付总合计: %@",model.color];
    self.l.text = [NSString stringWithFormat:@"月供: %@",model.color];
    self.m.text = [NSString stringWithFormat:@"还款期数: %@(期)",model.color];
    self.n.text = [NSString stringWithFormat:@"赠品: %@",model.remark];
}

- (void)eButtonAction:(UIButton *)sender{
    AllConfigurationController *vc = [AllConfigurationController new];
    vc.paramesArray = self.model.configList;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
