//
//  ProductBuyDetailFreedomHeaderView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/23.
//

#import "ProductBuyDetailFreedomHeaderView.h"
#import "SectionFooterView1.h"
#import "YLAwesomeData.h"
#import "YLDataConfiguration.h"
#import "YLAwesomeSheetController.h"
#import "MIngxiController.h"


@interface ProductBuyDetailFreedomHeaderView ()

@property (nonatomic, strong) UIView  *line;
@property (nonatomic, strong) SectionFooterView1 *view1;
//首付比例
@property (nonatomic, strong) UILabel            *aa;
@property (nonatomic, strong) UILabel            *ab;
@property (nonatomic, strong) UIImageView        *ac;
//贷款期限
@property (nonatomic, strong) UILabel            *ba;
@property (nonatomic, strong) UILabel            *bb;
@property (nonatomic, strong) UIImageView        *bc;
//系数
@property (nonatomic, strong) UILabel            *ca;
@property (nonatomic, strong) UILabel            *cb;
@property (nonatomic, strong) UIImageView        *cc;

//计算结果
@property (nonatomic, strong) UILabel            *label3;
//line
@property (nonatomic, strong) UIView             *line3;
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
@property (nonatomic, strong) UIView               *line4;
@property (nonatomic, strong) UILabel              *label10;
@property (nonatomic, strong) UILabel              *label11;
@property (nonatomic, strong) YXDButton            *moreProjectbButton;

@property (nonatomic, strong) UIView             *line2;

//保存数据
@property (nonatomic, strong) NSMutableArray    *arraya;
@property (nonatomic, strong) NSMutableArray    *arrayb;
@property (nonatomic, strong) NSMutableArray    *arrayc;

@end


@implementation ProductBuyDetailFreedomHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark- UI
- (void)setupUI{
    self.arraya = [NSMutableArray array];
    self.arrayb = [NSMutableArray array];
    self.arrayc = [NSMutableArray array];
    
    self.backgroundColor = [UIColor whiteColor];
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self addSubview:self.line];
    //2.
    self.view1 = [[SectionFooterView1 alloc] initWithTitle:@""];
    [self addSubview:self.view1];
    
    
    //3.
    self.aa = [UILabel new];
    self.aa.text = @"首付比例";
    self.aa.textColor = SMTextColor;
    self.aa.font = LPFFONT(15);
    [self addSubview:self.aa];
    self.ab = [UILabel new];
    self.ab.textColor = SMParatextColor;
    self.ab.font = LPFFONT(14);
    self.ab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapa = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(abdoTap:)];
    [self.ab addGestureRecognizer:tapa];
    [self addSubview:self.ab];
    self.ac = [UIImageView new];
    self.ac.image = IMAGECACHE(@"tijiaodongdan_03");
    self.ac.userInteractionEnabled = YES;
    [self addSubview:self.ac];
    
    //4.
    self.ba = [UILabel new];
    self.ba.text = @"贷款期限";
    self.ba.textColor = SMTextColor;
    self.ba.font = LPFFONT(15);
    [self addSubview:self.ba];
    self.bb = [UILabel new];
    self.bb.textColor = SMParatextColor;
    self.bb.font = LPFFONT(14);
    self.bb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapb = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bbdoTap:)];
    [self.bb addGestureRecognizer:tapb];
    [self addSubview:self.ab];

    [self addSubview:self.bb];
    self.bc = [UIImageView new];
    self.bc.image = IMAGECACHE(@"tijiaodongdan_03");
    self.bc.userInteractionEnabled = YES;
    [self addSubview:self.bc];
    
    //3.
    self.ca = [UILabel new];
    self.ca.text = @"分期方案";
    self.ca.textColor = SMTextColor;
    self.ca.font = LPFFONT(15);
    [self addSubview:self.ca];
    self.cb = [UILabel new];
    self.cb.textColor = SMParatextColor;
    self.cb.font = LPFFONT(14);
    self.cb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cbdoTap:)];
    [self.cb addGestureRecognizer:tapc];
    [self addSubview:self.cb];
    self.cc = [UIImageView new];
    self.cc.image = IMAGECACHE(@"tijiaodongdan_03");
    self.cc.userInteractionEnabled = YES;
    [self addSubview:self.cc];
    
    self.label3 = [UILabel new];
    self.label3.textColor = SMTextColor;
    self.label3.text = @"计算结果";
    self.label3.font = LPFFONT(14);
    [self addSubview:self.label3];
    
    self.line3 = [UIView new];
    self.line3.backgroundColor = SMViewBGColor;
    [self addSubview:self.line3];

    self.middleView = [UIView new];
    self.middleView.backgroundColor = [UIColor whiteColor];
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
    
    self.line4 = [UIView new];
    self.line4.backgroundColor = SMViewBGColor;
    [self addSubview:self.line4];
    
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
    //设置首付比例
    [self.aa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(self.view1.mas_bottom).offset = 0;
        make.height.offset = 50;
        make.width.offset = 80;
    }];
    [self.ab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.equalTo(self.aa);
        make.height.offset = 50;
        make.left.equalTo(self.aa.mas_right).offset = 10;
    }];
    [self.ac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aa);
        make.right.offset = -15;
    }];
    //设置贷款期限
    [self.ba mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(self.aa.mas_bottom).offset = 0;
        make.height.offset = 50;
        make.width.offset = 80;
    }];
    [self.bb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.equalTo(self.ba);
        make.height.offset = 50;
        make.left.equalTo(self.ba.mas_right).offset = 10;
    }];
    [self.bc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ba);
        make.right.offset = -15;
    }];
    //分期方案
    [self.ca mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(self.ba.mas_bottom).offset = 0;
        make.height.offset = 50;
        make.width.offset = 80;
    }];
    [self.cb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.equalTo(self.ca);
        make.height.offset = 50;
        make.left.equalTo(self.ca.mas_right).offset = 10;
    }];
    [self.cc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ca);
        make.right.offset = -15;
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.ca.mas_bottom).offset = 10;
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.height.offset = 0.5;
        make.top.equalTo(self.label3.mas_bottom).offset = 10;
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.line3.mas_bottom).offset = 5;
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
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.height.offset = 0.5;
        make.top.equalTo(self.middleButton1.mas_bottom).offset = 10;
    }];
    
    [self.label10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.line4.mas_bottom).offset = 10;
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

- (void)setModel:(CarDetailModel *)model{
    _model = model;
    self.view1.label.text = [NSString stringWithFormat:@"%@ - 现价%@",[NSString stringWithFormat:@"%@%@",model.brandName,model.typeName],model.price];
}

//设置默认分期的参数
- (void)setProductSchemeListModel:(ProductSchemeListModel *)productSchemeListModel{
    _productSchemeListModel = productSchemeListModel;
    if (productSchemeListModel.list.count) {
        ProductSchemeModel *model = productSchemeListModel.list.firstObject;
        //设置首付
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
        
        
        self.ab.text = [NSString stringWithFormat:@"%@%%",model.down_payment_rate];
        self.bb.text = model.number_of_periods;
        self.cb.text = model.monthly_coefficient;
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

-(void)abdoTap:(UITapGestureRecognizer *)sender{
    if (!self.arraya.count) {
        //请求
        WeakObj(self);
        [[NetWorkManager shareManager] POST:USER_FindProductSchemeDPList parameters:nil successed:^(id json) {
            if (json) {
                ProductSchemeListModel *model = [ProductSchemeListModel mj_objectWithKeyValues:json];
                [Weakself.arraya addObjectsFromArray:model.list];
                //弹出首付比例弹框
                [Weakself aAction];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        //弹出首付比例弹框
        [self aAction];
    }
    
}
-(void)bbdoTap:(UITapGestureRecognizer *)sender{
    if (!self.arrayb.count) {
        //请求
        WeakObj(self);
        [[NetWorkManager shareManager] POST:USER_FindProductSchemeNPList parameters:nil successed:^(id json) {
            if (json) {
                ProductSchemeListModel *model = [ProductSchemeListModel mj_objectWithKeyValues:json];
                [Weakself.arrayb addObjectsFromArray:model.list];
                ProductSchemeModel *aa = model.list.firstObject;
                [Weakself.arrayc removeAllObjects];
                [Weakself.arrayc addObjectsFromArray:aa.MCList];
                //弹出贷款期限弹框
                [Weakself bAction];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        //弹出贷款期限弹框
        [self bAction];
    }
}

- (void)cbdoTap:(UITapGestureRecognizer *)sender{
    if (!self.arrayb.count) {
        //请求
        WeakObj(self);
        [[NetWorkManager shareManager] POST:USER_FindProductSchemeNPList parameters:nil successed:^(id json) {
            if (json) {
                ProductSchemeListModel *model = [ProductSchemeListModel mj_objectWithKeyValues:json];
                [Weakself.arrayb addObjectsFromArray:model.list];
                //比较当前期数
                for (ProductSchemeModel *model in Weakself.arrayb) {
                    if ([Weakself.bb.text isEqualToString:model.number_of_periods]) {
                        [Weakself.arrayc removeAllObjects];
                        [Weakself.arrayc addObjectsFromArray:model.MCList];
                        //弹出贷款期限弹框
                        [Weakself cAction];
                    }
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        //弹出贷款期限弹框
        [self cAction];
    }
}

- (void)aAction{
    NSDictionary *data = @{@0:self.arraya};
    YLDataConfiguration *config = [[YLDataConfiguration alloc] initWithData:data selectedData:@[]];
    WeakObj(self);
    [[[YLAwesomeSheetController alloc] initWithTitle:nil config:config callBack:^(NSArray *selectedData) {
        ProductSchemeModel *data = [selectedData firstObject];
        Weakself.ab.text = [NSString stringWithFormat:@"%@%%",data.down_payment_rate];
        ProductSchemeModel *model = self.productSchemeListModel.list.firstObject;
        model.down_payment_rate = data.down_payment_rate;
        [Weakself countParames];
    }] showInController:self.navigationController];
}
- (void)bAction{
    NSDictionary *data = @{@0:self.arrayb};
    YLDataConfiguration *config = [[YLDataConfiguration alloc] initWithData:data selectedData:@[]];
    WeakObj(self);
    [[[YLAwesomeSheetController alloc] initWithTitle:nil config:config callBack:^(NSArray *selectedData) {
        ProductSchemeModel *data = [selectedData firstObject];
        Weakself.bb.text = data.number_of_periods;
        Weakself.cb.text = @"请选择系数";
        ProductSchemeModel *model = self.productSchemeListModel.list.firstObject;
        model.number_of_periods = data.number_of_periods;
        model.monthly_coefficient = data.monthly_coefficient;
        //给数组c赋值
        [Weakself.arrayc removeAllObjects];
        [Weakself.arrayc addObjectsFromArray:data.MCList];
//        [Weakself countParames];
    }] showInController:self.navigationController];
}

- (void)cAction{
    NSDictionary *data = @{@0:self.arrayc};
    YLDataConfiguration *config = [[YLDataConfiguration alloc] initWithData:data selectedData:@[]];
    WeakObj(self);
    [[[YLAwesomeSheetController alloc] initWithTitle:nil config:config callBack:^(NSArray *selectedData) {
        ProductSchemeListMCModel *data = [selectedData firstObject];
        Weakself.cb.text = data.monthly_coefficient;
        ProductSchemeModel *model = self.productSchemeListModel.list.firstObject;
        model.monthly_coefficient = data.monthly_coefficient;
        Weakself.model.poundage = data.poundage;
        //给数组c赋值
        [Weakself countParames];
    }] showInController:self.navigationController];
}



//进行分期重计算
- (void)countParames{
    ProductSchemeModel *model = self.productSchemeListModel.list.firstObject;
    
    NSLog(@"%@ %@ %@", model.down_payment_rate ,model.number_of_periods ,model.monthly_coefficient);
    
    //1.计算百位归零
    NSInteger a = [self.model.price integerValue] * (1 - [model.down_payment_rate floatValue] * 0.01);
    NSInteger b = a % 1000;
    
    //计算首付 总价 * 首付比例 + 百位归零
    CGFloat c = [self.model.price integerValue] * [model.down_payment_rate floatValue] * 0.01 + b;
    
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
    CGFloat real_down_payment = c + [self.model.purchaseTax floatValue] + [self.model.onCards floatValue] + [self.model.poundage floatValue] + yajin;
    
    self.label7.text = [NSString stringWithFormat:@"%.2f",real_down_payment];

    //计算月供
    CGFloat d = (a - b) * [model.monthly_coefficient floatValue];
    self.label8.text = [NSString stringWithFormat:@"%.2f",d];
    self.label9.text = model.number_of_periods;    
}

- (void)moreProjectbButtonAction{
    MIngxiController *vc = [MIngxiController new];
    vc.model = self.model;
    vc.productSchemeListModel = self.productSchemeListModel;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
