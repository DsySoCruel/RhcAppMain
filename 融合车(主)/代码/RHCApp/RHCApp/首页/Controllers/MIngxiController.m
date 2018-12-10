//
//  MIngxiController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/8.
//

#import "MIngxiController.h"
#import "SectionFooterView1.h"

@interface MIngxiController ()
@property (nonatomic, strong) SectionFooterView1 *view1;
@property (nonatomic, strong) UILabel *a;
@property (nonatomic, strong) UILabel *ab;
@property (nonatomic, strong) UILabel *b;
@property (nonatomic, strong) UILabel *bb;
@property (nonatomic, strong) UILabel *c;
@property (nonatomic, strong) UILabel *cb;
@property (nonatomic, strong) UILabel *d;
@property (nonatomic, strong) UILabel *db;
@property (nonatomic, strong) UILabel *e;
@property (nonatomic, strong) UILabel *eb;
@property (nonatomic, strong) UIButton *buttom;

@end

@implementation MIngxiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    self.view1 = [[SectionFooterView1 alloc] initWithTitle:@"费用明细"];
    self.view1.label.font = LPFFONT(16);
    [self.view addSubview:self.view1];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 40;
        make.top.offset = 64 + 10;
    }];
    
    self.a = [UILabel new];
    self.a.textColor = SMTextColor;
    self.a.font = PFFONT(14);
    self.a.text = @"首付";
    [self.view addSubview:self.a];
    self.ab = [UILabel new];
    self.ab.textColor = SMParatextColor;
    self.ab.font = LPFFONT(14);
    [self.view addSubview:self.ab];
    
    self.b = [UILabel new];
    self.b.textColor = SMTextColor;
    self.b.font = PFFONT(14);
    self.b.text = @"购置税";
    [self.view addSubview:self.b];
    self.bb = [UILabel new];
    self.bb.textColor = SMParatextColor;
    self.bb.font = LPFFONT(14);
    [self.view addSubview:self.bb];
    
    self.c = [UILabel new];
    self.c.textColor = SMTextColor;
    self.c.font = PFFONT(14);
    self.c.text = @"手续费";
    [self.view addSubview:self.c];
    self.cb = [UILabel new];
    self.cb.textColor = SMParatextColor;
    self.cb.font = LPFFONT(14);
    [self.view addSubview:self.cb];
    
    self.d = [UILabel new];
    self.d.textColor = SMTextColor;
    self.d.font = PFFONT(14);
    self.d.text = @"保证金";
    [self.view addSubview:self.d];
    self.db = [UILabel new];
    self.db.textColor = SMParatextColor;
    self.db.font = LPFFONT(14);
    [self.view addSubview:self.db];
    
    self.e = [UILabel new];
    self.e.textColor = SMTextColor;
    self.e.font = PFFONT(14);
    self.e.text = @"上牌费";
    [self.view addSubview:self.e];
    self.eb = [UILabel new];
    self.eb.textColor = SMParatextColor;
    self.eb.font = LPFFONT(14);
    [self.view addSubview:self.eb];
    
    
    self.eb.text = self.model.onCards;
    self.bb.text = self.model.purchaseTax;
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
    self.db.text = [NSString stringWithFormat:@"%f",yajin];
    self.cb.text = self.model.poundage;
    
    
    
    if (self.productSchemeListModel.list.count) {
        ProductSchemeModel *model = self.productSchemeListModel.list.firstObject;
        self.ab.text = model.down_payment;
    }
    
    [self.a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(self.view1.mas_bottom).offset = 10;
    }];
    [self.ab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 70;
        make.centerY.equalTo(self.a);
        make.right.offset = -10;
        make.height.offset = 30;
    }];
    
    [self.b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(self.a.mas_bottom).offset = 10;
    }];
    [self.bb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 70;
        make.centerY.equalTo(self.b);
    }];
    
    [self.c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(self.b.mas_bottom).offset = 10;
    }];
    [self.cb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 70;
        make.centerY.equalTo(self.c);
    }];
    
    [self.d mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(self.c.mas_bottom).offset = 10;
    }];
    [self.db mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 70;
        make.centerY.equalTo(self.d);
    }];
    
    [self.e mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(self.d.mas_bottom).offset = 10;
    }];
    [self.eb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 70;
        make.centerY.equalTo(self.e);
    }];
    
    self.buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttom setTitle:@"确定" forState:UIControlStateNormal];
    [self.buttom addTarget:self action:@selector(buttomAction) forControlEvents:UIControlEventTouchUpInside];
    self.buttom.backgroundColor = SMButtonBGColor;
    [self.view addSubview:self.buttom];
    
    [self.buttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 45;
    }];
}

- (void)buttomAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//赋值
//- (void)setModel:(CarDetailModel *)model{
//    _model = model;
//
//}

//- (void)setProductSchemeListModel:(ProductSchemeListModel *)productSchemeListModel{
//    _productSchemeListModel = productSchemeListModel;
//
//}


@end
