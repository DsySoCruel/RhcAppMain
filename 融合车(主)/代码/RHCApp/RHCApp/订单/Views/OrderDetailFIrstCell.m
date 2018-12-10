//
//  OrderDetailFIrstCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/30.
//

#import "OrderDetailFIrstCell.h"
#import "OrderCarDetailModel.h"
@interface OrderDetailFIrstCell ()
@property (nonatomic,strong) UILabel *a;
@property (nonatomic,strong) UIView  *b;
@property (nonatomic,strong) UILabel *c;
@property (nonatomic,strong) UILabel *d;
@property (nonatomic,strong) UILabel *e;
@property (nonatomic,strong) UIView  *f;
@end

@implementation OrderDetailFIrstCell

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
    
    self.f = [UIView new];
    self.f.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.f];
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
    [self.c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.b.mas_bottom).offset = 5;
    }];
    [self.d mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.c.mas_bottom).offset = 5;
    }];
    [self.e mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.d.mas_bottom).offset = 5;
    }];
    [self.f mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.equalTo(self.e.mas_bottom).offset = 5;
        make.bottom.offset = 0;
        make.height.offset = 10;
    }];
}
//设置数据
- (void)setModel:(OrderCarDetailModel *)model{
    _model = model;
    self.a.text = [NSString stringWithFormat:@"订单号:%@",model.order_no];
    NSString *orderStatus = @"";
    if ([model.order_status isEqualToString:@"wait_pending"]) {//待审核
        orderStatus = @"正在审核中...";
    }else if ([model.order_status isEqualToString:@"wait_pay"]){//待支付
        orderStatus = @"审核通过";
    }else if ([model.order_status isEqualToString:@"fail"]){//失败
        orderStatus = @"审核失败";
    }
    self.c.text = [NSString stringWithFormat:@"订单状态: %@",orderStatus];
    self.d.text = [NSString stringWithFormat:@"支付方式: %@",model.scheme_id.length?@"分期付款":@"全款支付"];
    self.e.text = [NSString stringWithFormat:@"创建时间: %@",[model.create_time timeFromNow]];
}


@end
