//
//  ProductBuyDetailFenqiHeaderView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/22.
//

#import "ProductBuyDetailFenqiHeaderView.h"
#import "SectionFooterView1.h"
#import "MIngxiController.h"


@interface ProductBuyDetailFenqiHeaderView ()

@property (nonatomic, strong) UIView  *line;
@property (nonatomic, strong) SectionFooterView1 *view1;
@property (nonatomic, strong) UIView             *middleView;
@property (nonatomic, strong) UILabel            *label4;
@property (nonatomic, strong) UILabel            *label5;
@property (nonatomic, strong) UILabel            *label6;
@property (nonatomic, strong) UILabel            *label7;
@property (nonatomic, strong) UILabel            *label8;
@property (nonatomic, strong) UILabel            *label9;

//设置展示的 购置税 手续费 保险 等
@property (nonatomic, strong) YXDButton            *middleButton1;
@property (nonatomic, strong) YXDButton            *middleButton2;
@property (nonatomic, strong) YXDButton            *middleButton3;
@property (nonatomic, strong) UIView               *line3;
@property (nonatomic, strong) UILabel              *label10;
@property (nonatomic, strong) UILabel              *label11;
@property (nonatomic, strong) YXDButton            *moreProjectbButton;

@property (nonatomic, strong) UIView             *line2;
@end

@implementation ProductBuyDetailFenqiHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark- UI
- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self addSubview:self.line];
    //2.
    self.view1 = [[SectionFooterView1 alloc] initWithTitle:@""];
    [self addSubview:self.view1];
    
    self.middleView = [UIView new];
    self.middleView.backgroundColor = SMViewBGColor;
    self.middleView.layer.cornerRadius = 5;
    self.middleView.layer.masksToBounds = YES;
    [self addSubview:self.middleView];
    
    self.label4 = [UILabel new];
    self.label4.text = @"首付(元)";
    self.label4.textColor = SMTextColor;
    self.label4.font = LPFFONT(13);
    self.label4.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:self.label4];
    
    self.label7 = [UILabel new];
    //    self.label7.text = @"210900";
    self.label7.textColor = [UIColor redColor];
    self.label7.font = BPFFONT(15);
    self.label7.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:self.label7];
    
    self.label5 = [UILabel new];
    self.label5.text = @"月供(元)";
    self.label5.textColor = SMTextColor;
    self.label5.font = LPFFONT(13);
    self.label5.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:self.label5];
    
    self.label8 = [UILabel new];
    //    self.label8.text = @"210900";
    self.label8.textColor = [UIColor redColor];
    self.label8.font = BPFFONT(15);
    self.label8.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:self.label8];
    
    self.label6 = [UILabel new];
    self.label6.text = @"期数";
    self.label6.textColor = SMTextColor;
    self.label6.font = LPFFONT(13);
    self.label6.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:self.label6];
    
    self.label9 = [UILabel new];
    //    self.label9.text = @"210900";
    self.label9.textColor = [UIColor redColor];
    self.label9.font = BPFFONT(15);
    self.label9.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:self.label9];
    
    //---------------------------------------------------------------------
    self.middleButton1 = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.middleButton1 setImage:IMAGECACHE(@"baokan") forState:UIControlStateNormal];
    [self.middleButton1 setTitle:@"含购置税" forState:UIControlStateNormal];
    [self.middleButton1 setTitleColor:SMParatextColor forState:UIControlStateNormal];
    self.middleButton1.titleLabel.font = LPFFONT(11);
    self.middleButton1.status = MoreStyleStatusNormal;
    self.middleButton1.padding = 5;
    [self addSubview:self.middleButton1];
    
    self.middleButton2 = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.middleButton2 setImage:IMAGECACHE(@"baokan") forState:UIControlStateNormal];
    [self.middleButton2 setTitle:@"含手续费" forState:UIControlStateNormal];
    [self.middleButton2 setTitleColor:SMParatextColor forState:UIControlStateNormal];
    self.middleButton2.titleLabel.font = LPFFONT(11);
    self.middleButton2.status = MoreStyleStatusNormal;
    self.middleButton2.padding = 5;
    [self addSubview:self.middleButton2];
    
    self.middleButton3 = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.middleButton3 setImage:IMAGECACHE(@"bubaohan") forState:UIControlStateNormal];
    [self.middleButton3 setTitle:@"不含保险" forState:UIControlStateNormal];
    [self.middleButton3 setTitleColor:SMParatextColor forState:UIControlStateNormal];
    self.middleButton3.titleLabel.font = LPFFONT(11);
    self.middleButton3.status = MoreStyleStatusNormal;
    self.middleButton3.padding = 5;
    [self addSubview:self.middleButton3];
    
    self.line3 = [UIView new];
    self.line3.backgroundColor = SMViewBGColor;
    [self addSubview:self.line3];
    
    self.label10 = [UILabel new];
    self.label10.textColor = SMTextColor;
    self.label10.font = BPFFONT(15);
    self.label10.textAlignment = NSTextAlignmentLeft;
    self.label10.text = @"保险费预计需花费 6200";
    [self addSubview:self.label10];
    
    self.label11 = [UILabel new];
    self.label11.text = @"*分期贷款买车需缴纳全额保险。";
    self.label11.textAlignment = NSTextAlignmentLeft;
    self.label11.textColor = SMParatextColor;
    self.label11.font = LPFFONT(12);
    [self addSubview:self.label11];

    self.moreProjectbButton = [YXDButton buttonWithType:UIButtonTypeCustom];
    self.moreProjectbButton.backgroundColor = SMLineColor;
    [self.moreProjectbButton setTitle:@"查看费用明细" forState:UIControlStateNormal];
    self.moreProjectbButton.titleLabel.font = LPFFONT(14);
    [self.moreProjectbButton setTitleColor:UNAble_color forState:UIControlStateNormal];
    self.moreProjectbButton.layer.cornerRadius = 3;
    self.moreProjectbButton.layer.masksToBounds = YES;
    self.moreProjectbButton.status = MoreStyleStatusCenter;
    [self.moreProjectbButton setImage:IMAGECACHE(@"sanjiao") forState:UIControlStateNormal];
    self.moreProjectbButton.padding = 5;
    [self addSubview:self.moreProjectbButton];
    [self.moreProjectbButton addTarget:self action:@selector(moreProjectbButtonAction) forControlEvents:UIControlEventTouchUpInside];

    self.line2 = [UIView new];
    self.line2.backgroundColor = SMViewBGColor;
    [self addSubview:self.line2];
}

- (void)setupLayout{
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.height.offset = 10;
        make.top.offset = 0;
    }];
    
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 40;
        make.top.equalTo(self.line.mas_bottom).offset = 0;
    }];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.view1.mas_bottom).offset = 5;
        make.height.offset = 80;
    }];
    
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 15;
        make.left.offset = 0;
        make.right.equalTo(self.label5.mas_left).offset = 0;
        make.width.equalTo(@[self.label5,self.label6]);
    }];
    [self.label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.label4);
        make.top.equalTo(self.label4.mas_bottom).offset = 5;
    }];
    [self.label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 15;
        make.left.equalTo(self.label4.mas_right).offset = 0;
        make.right.equalTo(self.label5.mas_left).offset = 0;
        make.width.equalTo(@[self.label4,self.label6]);
    }];
    [self.label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.label5);
        make.top.equalTo(self.label5.mas_bottom).offset = 5;
    }];
    [self.label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 15;
        make.right.offset = 0;
        make.left.equalTo(self.label5.mas_right).offset = 0;
        make.width.equalTo(@[self.label5,self.label4]);
    }];
    [self.label9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.label6);
        make.top.equalTo(self.label6.mas_bottom).offset = 5;
    }];
    
    [self.middleButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset = 10;
        make.left.offset = 18;
    }];
    
    [self.middleButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset = 10;
        make.centerX.offset = 0;
    }];
    
    [self.middleButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset = 10;
        make.right.offset = -18;
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.height.offset = 0.5;
        make.top.equalTo(self.middleButton1.mas_bottom).offset = 10;
    }];
    
    [self.label10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.line3.mas_bottom).offset = 10;
    }];
    
    [self.label11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.label10.mas_bottom).offset = 10;
    }];
    
    [self.moreProjectbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.label11.mas_bottom).offset = 10;
        make.height.offset = 35;
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.offset = 0;
        make.height.offset = 0;
    }];
}

//设置默认分期的参数
- (void)setProductSchemeListModel:(ProductSchemeListModel *)productSchemeListModel{
    _productSchemeListModel = productSchemeListModel;
    
    if (productSchemeListModel.list.count) {
        ProductSchemeModel *model = productSchemeListModel.list.firstObject;
        
        //1.设置首付
        CGFloat down_payment = [model.down_payment floatValue];
        //设置押金
        CGFloat yajin = 0.0;
        if ([self.model.price floatValue] <= 100000) {
            yajin = 2000;
        }else if ([self.model.price floatValue] <= 200000){
            yajin = 3000;
        }else if ([self.model.price floatValue] <= 400000){
            yajin = 5000;
        }else{
            yajin = 5000;
        }
        CGFloat real_down_payment = down_payment + [self.model.purchaseTax floatValue] + [self.model.onCards floatValue] + [self.model.poundage floatValue] + yajin;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"分期方案 - %@ 开回家",[[NSString stringWithFormat:@"%.2f",real_down_payment] priceWithWan]]];
        [str addAttribute:NSForegroundColorAttributeName value:SMParatextColor range:NSMakeRange(5,str.length - 5)];
        //    [str addAttribute:NSFontAttributeName value:BFONT(15) range:NSMakeRange(6, str.length - 6)];
        self.view1.label.attributedText = str;
        
        self.label7.text = [NSString stringWithFormat:@"%.2f",real_down_payment];
        //计算月供
        //1.计算百位归零
        NSInteger a = [self.model.price integerValue] * (1 - [model.down_payment_rate floatValue] * 0.01);
        NSInteger b = a % 1000;
        CGFloat c = (a - b) * [model.monthly_coefficient floatValue];
        self.label8.text = [NSString stringWithFormat:@"%.2f",c];
        self.label9.text = model.number_of_periods;
    }    
}

//查看费用明细
- (void)moreProjectbButtonAction{
    MIngxiController *vc = [MIngxiController new];
    vc.model = self.model;
    vc.productSchemeListModel = self.productSchemeListModel;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
