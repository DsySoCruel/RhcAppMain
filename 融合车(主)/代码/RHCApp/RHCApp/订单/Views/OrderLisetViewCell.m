//
//  OrderLisetViewCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/21.
//

#import "OrderLisetViewCell.h"
#import "OrderLisetModel.h"
#import "PayViewController.h"
#import "RequestManager.h"

@interface OrderLisetViewCell()
@property (nonatomic,strong) UIView      *lineView;
@property (nonatomic,strong) UILabel     *Label1;
@property (nonatomic,strong) UILabel     *ordernumLabel;
@property (nonatomic,strong) YXDButton   *button;//分期付款申请
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel     *label2;//状态
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *priceLabel;
@property (nonatomic,strong) UILabel     *moneyLabel;//需要支付订金
@property (nonatomic,strong) UILabel     *label3;//订金说明
@property (nonatomic,strong) UIView      *line;
@property (nonatomic,strong) UILabel     *orderStatus;//审核状态
@property (nonatomic,strong) UIButton    *button1;//联系客服
@property (nonatomic,strong) UIButton    *button2;//支付订金
@property (nonatomic,strong) UIButton    *button3;//查看原因
@property (nonatomic,strong) UIButton    *button4;//催促审核
@property (nonatomic,strong) UIButton    *button5;//查看详情

@end

@implementation OrderLisetViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.lineView];
    //1.
    self.Label1 = [UILabel new];
    self.Label1.text = @"订单号:";
    self.Label1.font = LPFFONT(14);
    [self.contentView addSubview:self.Label1];
    
    self.ordernumLabel = [UILabel new];
    self.ordernumLabel.text = @"3457847546358474";
    self.ordernumLabel.font = LPFFONT(13);
    self.ordernumLabel.textColor = SMParatextColor;
    [self.contentView addSubview:self.ordernumLabel];
    
    self.button = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.button setImage:IMAGECACHE(@"shangpinxiangqing_01") forState:UIControlStateNormal];
    [self.button setTitle:@"分期付款" forState:UIControlStateNormal];
    [self.button setTitleColor:SMThemeColor forState:UIControlStateNormal];
    self.button.titleLabel.font = MFFONT(12);
    self.button.status =  MoreStyleStatusCenter;
    self.button.padding = 10;
    [self.contentView addSubview:self.button];
    
    //2.
    self.image = [UIImageView new];
    self.image.image = IMAGECACHE(@"zhan_mid");
    [self.contentView addSubview:self.image];
    
    self.label2 = [UILabel new];
    self.label2.font = SFONT(12);
    self.label2.backgroundColor = RGB(0xFFDC00);
    self.label2.textColor = SMTextColor;
    self.label2.layer.cornerRadius = 9;
    self.label2.layer.masksToBounds = YES;
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.text = @"爆款";
    [self.imageView addSubview:self.label2];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"朗逸 2017新款";
    [self.contentView addSubview:self.nameLabel];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"￥ 212000.0";
    [self.contentView addSubview:self.priceLabel];
    
    //
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"需要支付订金 ￥：12304.0";
    self.moneyLabel.font = LPFFONT(14);
    [self.contentView addSubview:self.moneyLabel];
    
    self.label3 = [UILabel new];
    self.label3.font = LPFFONT(12);
    self.label3.textColor = SMParatextColor;
    self.label3.numberOfLines = 0;
    self.label3.textAlignment = NSTextAlignmentRight;
    self.label3.text = @"为保证恶性不良交易信用，双方需交纳购车意向保证金，由第三户监管为交易担保。具体相关";
    [self.contentView addSubview:self.label3];
    
    //
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.line];
    
    self.orderStatus = [UILabel new];
    self.orderStatus.text = @"审核通过";
    self.orderStatus.font = LPFFONT(13);
    [self.contentView addSubview:self.orderStatus];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button1 setTitle:@"联系客服" forState:UIControlStateNormal];
    [self.button1 setTitleColor:SMThemeColor forState:UIControlStateNormal];
    self.button1.layer.cornerRadius = 12.5;
    self.button1.layer.borderWidth = 1;
    self.button1.layer.borderColor = SMThemeColor.CGColor;
    self.button1.titleLabel.font = LPFFONT(12);
    [self.button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button1];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button2 setTitle:@"支付订金" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button2.layer.cornerRadius = 12.5;
    self.button2.backgroundColor = SMThemeColor;
    [self.button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    self.button2.titleLabel.font = LPFFONT(12);
    [self.contentView addSubview:self.button2];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button3 setTitle:@"催促审核" forState:UIControlStateNormal];
    [self.button3 setTitleColor:SMThemeColor forState:UIControlStateNormal];
    self.button3.layer.cornerRadius = 12.5;
    self.button3.layer.borderWidth = 1;
    self.button3.layer.borderColor = SMThemeColor.CGColor;
    [self.button3 addTarget:self action:@selector(button3Action:) forControlEvents:UIControlEventTouchUpInside];
    self.button3.titleLabel.font = LPFFONT(12);
    [self.contentView addSubview:self.button3];
    
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button4 setTitle:@"查看原因" forState:UIControlStateNormal];
    [self.button4 setTitleColor:SMThemeColor forState:UIControlStateNormal];
    self.button4.layer.cornerRadius = 12.5;
    self.button4.layer.borderWidth = 1;
    self.button4.layer.borderColor = SMThemeColor.CGColor;
    self.button4.titleLabel.font = LPFFONT(12);
    [self.button4 addTarget:self action:@selector(button4Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button4];
    
    self.button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button5 setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.button5 setTitleColor:SMThemeColor forState:UIControlStateNormal];
    self.button5.layer.cornerRadius = 12.5;
    self.button5.layer.borderWidth = 1;
    self.button5.layer.borderColor = SMThemeColor.CGColor;
    self.button5.titleLabel.font = LPFFONT(12);
    self.button5.userInteractionEnabled = NO;
//    [self.button5 addTarget:self action:@selector(button5Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button5];
    
    
}

- (void)setupLayout{
    [self.Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.height.offset = 45;
        make.top.offset = 0;;
        make.width.offset = 60;
    }];
    [self.ordernumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1);
        make.left.equalTo(self.Label1.mas_right).offset = 0;
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.Label1);
        make.right.offset = -10;
        make.height.offset = 30;
        make.width.offset = 70;
    }];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 100;
        make.height.offset = 80;
        make.left.equalTo(self.Label1);
        make.top.equalTo(self.Label1.mas_bottom).offset = 10;
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset = 0;
        make.width.offset = 40;
        make.height.offset = 18;
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image);
        make.left.equalTo(self.image.mas_right).offset = 20;
        make.right.offset = -20;
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset = 20;
        make.left.equalTo(self.image.mas_right).offset = 20;
        make.right.offset = -20;
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image.mas_bottom).offset(20);
        make.right.offset = -20;
        make.left.offset = 20;
        make.height.offset = 20;
    }];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset = 5;
        make.right.offset = -20;
        make.left.offset = 20;
        make.height.offset = 50;
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.height.offset = 0.5;
        make.top.equalTo(self.label3.mas_bottom).offset = 10;
    }];
    [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.height.offset = 40;
        make.top.equalTo(self.line.mas_bottom);
        make.bottom.offset = -10;
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset = 0;
        make.height.offset = 10;
    }];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderStatus);
        make.right.offset = -10;
        make.width.offset = 70;
        make.height.offset = 25;
    }];
    
    [self.button5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderStatus);
        make.right.offset = -10;
        make.width.offset = 70;
        make.height.offset = 25;
    }];
    
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderStatus);
        make.width.offset = 70;
        make.height.offset = 25;
        make.right.equalTo(self.button2.mas_left).offset = -20;
    }];
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderStatus);
        make.right.offset = -10;
        make.width.offset = 70;
        make.height.offset = 25;
    }];
    [self.button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderStatus);
        make.right.offset = -10;
        make.width.offset = 70;
        make.height.offset = 25;
    }];
}

- (void)buttonAction{
    
}


- (void)setModel:(OrderLisetModel *)model{
    _model = model;
    self.button.hidden = !model.scheme_id.length;
    NSString *orderStatus = @"";
    if ([model.order_status isEqualToString:@"wait_pending"]) {//待审核
        self.button1.hidden = YES;
        self.button2.hidden = YES;
        self.button5.hidden = YES;
        self.button3.hidden = NO;
        self.button4.hidden = YES;
        self.moneyLabel.hidden = YES;
        self.label3.hidden = YES;
        
        if ([model.isCuicu integerValue] == 1) {//已催促
            self.button3.userInteractionEnabled = NO;
            self.button3.backgroundColor = UNAble_color;
            self.button3.layer.borderColor = UNAble_color.CGColor;
            [self.button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [self.button3 setTitleColor:SMThemeColor forState:UIControlStateNormal];
            self.button3.layer.borderColor = SMThemeColor.CGColor;
            self.button3.backgroundColor = [UIColor whiteColor];
            self.button3.userInteractionEnabled = YES;
        }
        orderStatus = @"正在审核中...";
//        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.image.mas_bottom).offset = 10;
//        }];
        [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
            make.top.equalTo(self.image.mas_bottom).offset(0);
        }];
        [self.label3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
            make.top.equalTo(self.moneyLabel.mas_bottom).offset = 0;
        }];
    }else if ([model.order_status isEqualToString:@"wait_pay"]){//待支付
        self.button1.hidden = NO;
        self.button2.hidden = NO;
        self.button5.hidden = YES;
        self.button3.hidden = YES;
        self.button4.hidden = YES;
        self.moneyLabel.hidden = NO;
        self.label3.hidden = NO;
        orderStatus = @"审核通过";
        [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 20;
            make.top.equalTo(self.image.mas_bottom).offset(20);
        }];
        [self.label3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 50;
            make.top.equalTo(self.moneyLabel.mas_bottom).offset = 5;
        }];
        
    }else if ([model.order_status isEqualToString:@"wait_shipments"]){//待支付
        self.button1.hidden = NO;
        self.button2.hidden = YES;
        self.button5.hidden = NO;
        self.button3.hidden = YES;
        self.button4.hidden = YES;
        self.moneyLabel.hidden = NO;
        self.label3.hidden = NO;
        orderStatus = @"审核通过";
        [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 20;
            make.top.equalTo(self.image.mas_bottom).offset(20);
        }];
        [self.label3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 50;
            make.top.equalTo(self.moneyLabel.mas_bottom).offset = 5;
        }];
        
    }else if ([model.order_status isEqualToString:@"fail"]){//失败
        self.button1.hidden = YES;
        self.button2.hidden = YES;
        self.button5.hidden = YES;
        self.button3.hidden = YES;
        self.button4.hidden = NO;
        self.moneyLabel.hidden = YES;
        self.label3.hidden = YES;
        [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
            make.top.equalTo(self.image.mas_bottom).offset(0);
        }];
        [self.label3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
            make.top.equalTo(self.moneyLabel.mas_bottom).offset = 0;
        }];
        orderStatus = @"审核失败";
    }
    
    self.ordernumLabel.text = model.order_no;//订单号
    [self.image sd_setImageWithURL:URLWithImageName(model.img) placeholderImage:IMAGECACHE(@"zhan_mid")];
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@%@",model.brandName,model.typeName],model.title];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    self.orderStatus.text = orderStatus;
}

- (void)button1Action:(UIButton *)sender{
    [[RequestManager sharedInstance] connectWithServer];
}

- (void)button2Action:(UIButton *)sender{
    PayViewController *vc = [PayViewController new];
    vc.orderId = self.model.oid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)button3Action:(UIButton *)sender{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"orderId"] = self.model.oid;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_AddOrderUrge parameters:parames successed:^(id json) {
        if (json) {
            sender.userInteractionEnabled = NO;
            sender.backgroundColor = UNAble_color;
            sender.layer.borderColor = UNAble_color.CGColor;
            Weakself.model.isCuicu = @"1";
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [MBHUDHelper showSuccess:@"催促成功,请耐心等待!"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)button4Action:(UIButton *)sender{
    
}

//- (void)button5Action:(UIButton *)sender{
//
//}


@end
