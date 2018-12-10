//
//  ProductBuyDetailController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/14.
//

#import "ProductBuyDetailController.h"
#import "KemaoTextView.h"
#import "ProductBuyDetailCell.h"
#import "ServiceStationSelectViewController.h"
#import "BuyCarMenuView.h"
#import "ProductBuyDetailFenqiHeaderView.h"//分期头部
#import "ProductBuyDetailFreedomHeaderView.h"//自由分期头部
#import "RequestManager.h"

static NSString *kProductBuyDetailCell = @"ProductBuyDetailCell";

@interface ProductBuyDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
//设置tableViewHeaderView
@property (nonatomic,strong) ProductBuyDetailFenqiHeaderView *headerView;//分期

//设置tableViewFooterView
@property (nonatomic,strong) UIView      *footView;
@property (nonatomic,strong) KemaoTextView *textView;
@property (nonatomic,strong) UIButton    *agreeButton;
@property (nonatomic,strong) UILabel     *agreeContentLabel1;
@property (nonatomic,strong) UIButton     *agreeContentLabel2;
//设置view底部
@property (nonatomic,strong) UIView         *kefuView;
@property (nonatomic,strong) UIImageView    *phoneImageView;
@property (nonatomic,strong) UILabel        *label1;
@property (nonatomic,strong) UILabel        *label2;
@property (nonatomic,strong) UIButton       *senderButton;
//保存的h数据
@property (nonatomic,strong) NSString       *colorName;
@property (nonatomic,strong) NSString       *colorId;
@property (nonatomic,strong) NSString       *incolorName;
@property (nonatomic,strong) NSString       *incolorId;
@property (nonatomic,strong) NSString       *carshopName;
@property (nonatomic,strong) NSString       *carshopId;

@end

@implementation ProductBuyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.carshopName = @"请选择提车地点";
    [self setupUI];
    [self setupLayout];
    if (self.buyType == BuyTypeAging) {
        self.title = @"分期购";
        self.headerView = [[ProductBuyDetailFenqiHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 155 + 130)];
        self.headerView.model = self.carDetailModel;
        self.headerView.productSchemeListModel = self.productSchemeListModel;
        self.tableView.tableHeaderView = self.headerView;
    }
    
    if (self.buyType == BuyTypeAll) {
        self.title = @"全款购";
    }
    if (self.buyType == BuyTypeFreedom) {
        self.title = @"自由计算";
        ProductBuyDetailFreedomHeaderView *freeDomHeadView = [[ProductBuyDetailFreedomHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 155 + 110 + 220)];
        freeDomHeadView.model = self.carDetailModel;
        freeDomHeadView.productSchemeListModel = self.productSchemeListModel;
        self.tableView.tableHeaderView = freeDomHeadView;
    }
}

- (void)setupUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SMViewBGColor;
    [self.tableView registerClass:[ProductBuyDetailCell class] forCellReuseIdentifier:kProductBuyDetailCell];
    [self.view addSubview:self.tableView];
    //设置底部footerView
    self.footView = [UIView new];
    self.footView.frame = CGRectMake(0, 0, Screen_W, 150);
    self.footView.backgroundColor = SMViewBGColor;
    
    UIView *tempView = [UIView new];
    tempView.backgroundColor = [UIColor whiteColor];
    [self.footView addSubview:tempView];
    
    self.textView = [KemaoTextView new];
    self.textView.font = PFFONT(14);
    self.textView.textColor = SMTextColor;
    self.textView.placeholderColor = SMParatextColor;
    //    self.textView.delegate = self;
    self.textView.placeholder = @"您还有什么要补充的吗";
    [tempView addSubview:self.textView];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 10;
        make.bottom.offset = -30;
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.offset = 5;
        make.bottom.offset = 0;
    }];
    //2.设置我已阅读相关声明
    self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreeButton setImage:IMAGECACHE(@"tijiaodongdan_02") forState:UIControlStateNormal];
    [self.agreeButton setImage:IMAGECACHE(@"tijiaodongdan_01") forState:UIControlStateSelected];
    self.agreeButton.selected = YES;
    [self.footView addSubview:self.agreeButton];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = 0;
        make.left.offset = 15;
    }];
    [self.agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.agreeContentLabel1 = [UILabel new];
    self.agreeContentLabel1.text = @"我已阅读并同意";
    self.agreeContentLabel1.font = LPFFONT(14);
    self.agreeContentLabel1.textColor = SMTextColor;
    [self.footView addSubview:self.agreeContentLabel1];
    
    self.agreeContentLabel2 = [UIButton new];
    [self.agreeContentLabel2 setTitle:@"《豆芽购车授权协议》" forState:UIControlStateNormal];
    self.agreeContentLabel2.titleLabel.font = LPFFONT(14);
    [self.agreeContentLabel2 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.footView addSubview:self.agreeContentLabel2];
    [self.agreeContentLabel2 addTarget:self action:@selector(agreeContentLabel2Action:) forControlEvents:UIControlStateNormal];
    
    [self.agreeContentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreeButton);
        make.left.equalTo(self.agreeButton.mas_right).offset = 10;
    }];
    [self.agreeContentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreeButton);
        make.left.equalTo(self.agreeContentLabel1.mas_right).offset = 0;
    }];
    self.tableView.tableFooterView = self.footView;
    
    
    self.senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.senderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    self.senderButton.backgroundColor = [UIColor redColor];
    self.senderButton.titleLabel.font = LPFFONT(15);
    [self.view addSubview:self.senderButton];
    [self.senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = 0;
        make.right.equalTo(self.footView.mas_right).offset = 0;
        make.left.equalTo(self.footView.mas_left).offset = 100;
        make.height.offset = 50;
    }];
    [self.senderButton addTarget:self action:@selector(senderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.kefuView = [UIView new];
    UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    r5.numberOfTapsRequired = 1;
    [self.kefuView addGestureRecognizer:r5];
    [self.view addSubview:self.kefuView];
    
    self.phoneImageView = [UIImageView new];
    self.phoneImageView.image = IMAGECACHE(@"shop_02");
    self.phoneImageView.userInteractionEnabled = YES;
    [self.kefuView addSubview:self.phoneImageView];
    
    self.label1 = [UILabel new];
    self.label1.text = @"咨询客服";
    self.label1.textColor = SMParatextColor;
    self.label1.font = LPFFONT(12);
    [self.kefuView addSubview:self.label1];
    
    self.label2 = [UILabel new];
    self.label2.text = @"9:00-21:00";
    self.label2.textColor = SMParatextColor;
    self.label2.font = LPFFONT(10);
    [self.kefuView addSubview:self.label2];
    
    [self.kefuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 100;
        make.height.offset = 50;
        make.bottom.offset = 0;
        make.left.offset = 0;
    }];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 10;
    }];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.top.offset = 10;
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.bottom.offset = -5;
    }];

    
}
- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.offset = 0;
        make.bottom.offset = -50;
    }];
    
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductBuyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductBuyDetailCell];
    if (indexPath.section == 0) {
        NSString *selectStr = @"";
        if (self.colorId.length && self.incolorId.length) {
            selectStr = [NSString stringWithFormat:@"已选 %@ %@",self.colorName,self.incolorName];
        }
        [cell configCellWith:@"颜色规格" andSubStr:selectStr];
    }
    if (indexPath.section == 1) {
        [cell configCellWith:@"提车地址" andSubStr:self.carshopName];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BuyCarMenuView *vc = [[BuyCarMenuView alloc] initWithDataSource:self.carDetailModel];
        WeakObj(self);
        vc.selectColorBlock = ^(NSString * _Nonnull colorName, NSString * _Nonnull colorId, NSString * _Nonnull inClorName, NSString * _Nonnull inColorId) {
            Weakself.colorName = colorName;
            Weakself.colorId = colorId;
            Weakself.incolorName = inClorName;
            Weakself.incolorId = inColorId;
            [Weakself.tableView reloadData];
        };
        [vc showInView:nil];
    }
    if (indexPath.section == 1) {
        ServiceStationSelectViewController *vc = [ServiceStationSelectViewController new];
        WeakObj(self);
        vc.selectCarShopBlock = ^(NSString *carshopName, NSString *carshopId) {
            Weakself.carshopName = carshopName;
            Weakself.carshopId = carshopId;
            [Weakself.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = SMViewBGColor;
    headerView.frame = CGRectMake(0, 0, 0, 10);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)senderButtonAction{
    if (!self.agreeButton.selected) {
        [MBHUDHelper showError:@"请阅读相关协议"];
        return;
    }
    if (!self.colorId.length || !self.incolorId.length) {
        [MBHUDHelper showError:@"请选择规格"];
        return;
    }
    if (!self.carshopId.length) {
        [MBHUDHelper showError:@"请选择取车地点"];
        return;
    }
    //开始下的订单了哈哈
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"productId"] = self.carDetailModel.pid;
    parames[@"addressId"] = self.carshopId;
    parames[@"colorId"] = self.colorId;
    parames[@"inColorId"] = self.incolorId;
    if (self.textView.text.length) {
        parames[@"remark"] = self.textView.text;
    }
    if (self.buyType == BuyTypeAging || self.buyType == BuyTypeFreedom) {
        if (self.productSchemeListModel.list.count) {
            ProductSchemeModel *model = self.productSchemeListModel.list.firstObject;
                        parames[@"monthlyCoefficient"] = model.monthly_coefficient;//月供系数
            parames[@"downPaymentRate"] = model.down_payment_rate;//首付比例
            parames[@"numberOfPeriods"] = model.number_of_periods;//分期期数
        }
    }

    [[NetWorkManager shareManager] POST:USER_AddProductOrder parameters:parames successed:^(id json) {
        if (json) {
            [MBHUDHelper showSuccess:@"订单提交成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)agreeButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (void)agreeContentLabel2Action:(UIButton *)sender{
    //跳转到网页界面
    WebViewController *webView = [WebViewController new];
    webView.title = @"用户服务协议";
    [webView loadWebWithUrl:@"http://106.15.103.137/zycartrade-app/resources/yhfwxy.html"];
    [self.navigationController pushViewController:webView animated:YES];
}

-(void)doTapChange:(UITapGestureRecognizer *)sender{
    [[RequestManager sharedInstance] connectWithServer];
}
@end
