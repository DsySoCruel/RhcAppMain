//
//  OrderMakeViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/18.
//

#import "OrderMakeViewController.h"
#import "OrderPeijianCell.h"
#import "MyAddressController.h"
#import "PayViewController.h"

static NSString *kOrderPeijianCell = @"OrderPeijianCell";
@interface OrderMakeViewController ()<UITableViewDelegate,UITableViewDataSource>

//1.tableView
@property (nonatomic,strong) UITableView *tableView;

//2.bottomView
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UIButton *buyButton;

//3.设置收货地址
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIImageView *dituImage;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *phone;
@property (nonatomic,strong) UILabel *address;
@property (nonatomic,strong) UIImageView *jiantouImage;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,assign) BOOL isNeedPop;


@end

@implementation OrderMakeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNeedPop) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交订单";
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    self.view.backgroundColor = SMViewBGColor;
    //1.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[OrderPeijianCell class] forCellReuseIdentifier:kOrderPeijianCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = SMViewBGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //2.
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    self.priceLabel = [UILabel new];
    [self.bottomView addSubview:self.priceLabel];
//    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥0.00"]];
//    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, titleString.length)];
//    [titleString addAttribute:NSFontAttributeName value:LPFFONT(20) range:NSMakeRange(1, titleString.length-1)];
    [self.priceLabel setAttributedText:self.titleString];
    
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyButton.backgroundColor = SMThemeColor;
    [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buyButton.titleLabel.font = LPFFONT(15);
    self.buyButton.layer.masksToBounds = YES;
    [self.buyButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [self.bottomView addSubview:self.buyButton];
    [self.buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置收货地址
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 100)];
    self.topView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap)];
    [self.topView addGestureRecognizer:tap];
    self.dituImage = [UIImageView new];
    self.dituImage.image = IMAGECACHE(@"shop_01");
    [self.topView addSubview:self.dituImage];
    
    self.name = [UILabel new];
    self.name.font = LPFFONT(16);
    self.name.textColor = SMTextColor;
    [self.topView addSubview:self.name];
    
    self.phone = [UILabel new];
    self.phone.font = LPFFONT(16);
    self.phone.textColor = SMTextColor;
    [self.topView addSubview:self.phone];
    
    self.address = [UILabel new];
    self.address.font = LPFFONT(14);
    self.address.textColor = SMTextColor;
    self.address.numberOfLines = 2;
    [self.topView addSubview:self.address];
    
    self.jiantouImage = [UIImageView new];
    self.jiantouImage.image = IMAGECACHE(@"me_07");
    [self.topView addSubview:self.jiantouImage];
     
     self.line = [UIView new];
     self.line.backgroundColor = SMViewBGColor;
    [self.topView addSubview:self.line];
     
    [self.dituImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = -5;
        make.left.offset = 15;
    }];
     [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.offset = 45;
         make.top.offset = 20;
     }];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -45;
        make.top.offset = 20;
    }];
     [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.name.mas_bottom).offset = 15;
         make.left.offset = 45;
         make.right.offset = -45;
     }];
    [self.jiantouImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = -5;
        make.right.offset = -15;
    }];
     [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.bottom.offset = 0;
         make.height.offset = 10;
     }];
    
    self.tableView.tableHeaderView = self.topView;
    //设置数据
    [self setupAddress];
}
- (void)setupLayout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 64 + SafeTopSpace + 10;
        make.right.left.offset = 0;
        make.bottom.offset = -50;
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 50;
        make.bottom.offset = 0;
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.offset = 0;
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.top.offset = 0;
        make.bottom.offset = 0;
        make.width.offset = 100;
    }];
}

#pragma mark-tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectGoodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderPeijianCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderPeijianCell];
    cell.model = self.selectGoodsArray[indexPath.row];
    return cell;
}

//如果志超没有删除的话  这里执行删除并刷新列表
//- (void)deletAllButtonAction:(UIButton *)sender{
//    //删除所有
//    //进行删除操作
//    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
//    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
//    NSString *ids = @"";
//    for (int i = 0; i < self.dataArray.count; i++) {
//        ShopCarListModel *model = self.dataArray[i];
//        if (i == 0) {
//            ids = [ids stringByAppendingString:model.goodsId];
//        }else{
//            ids = [ids stringByAppendingString:[NSString stringWithFormat:@",%@",model.goodsId]];
//        }
//    }
//    parames[@"id"] = ids;
//    WeakObj(self);
//    [[NetWorkManager shareManager] POST:USER_ProductDeleteCarItem parameters:parames successed:^(id json) {
//        if (json) {
//            [MBHUDHelper showSuccess:@"删除成功"];
//            [Weakself loadNewsData];
//            Weakself.selectAllButton.selected = NO;
//        }
//    } failure:^(NSError *error) {
//    }];
//}
#pragma mark--生成订单
- (void)buyButtonAction:(UIButton *)sender{
    NSString *tempIds = @"";
    for (ShopCarListModel *model in self.selectGoodsArray) {
        tempIds = [tempIds stringByAppendingString:[NSString stringWithFormat:@"%@,",model.goodsId]];
    }
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"ids"] = [tempIds substringToIndex:tempIds.length-1];
    parames[@"addressId"] = self.addressModel.addressId;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_SettleAccounts parameters:parames successed:^(id json) {
        if (json) {
            [MBHUDHelper showSuccess:@"提交成功"];
            if (json[@"order"][@"id"]) {
                PayViewController *vc = [PayViewController new];
                vc.orderId = json[@"order"][@"id"];
                //设置
                Weakself.isNeedPop = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
//            [self.navigationController popViewControllerAnimated:YES];
//            {
//                "status": 0,
//                "msg": "",
//                "code": "",
//                "data": {
//                    "order": {
//                        "price": 170.0,
//                        "order_no": "201810291160740294049350"
//                    }
//                }
//            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    //    BOOL isCanPush = NO;
    //    for (ShopCarDetailGoodsModel *model in self.dataArray) {
    //        if (model.isSelect) {
    //            isCanPush = YES;
    //            break;
    //        }
    //    }
    //    if (!isCanPush) {
    //        [MBHUDHelper showSuccess:@"没有选中商品"];
    //        return;
    //    }
    //    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    //    parames[@"userId"] = [YXDUserInfoStore sharedInstance].userModel.userId;
    //    parames[@"accessToken"] = UserAccessToken;
    //    parames[@"shopId"] = self.shopId;
    //
    //    NSString *str = @"";
    //    for (ShopCarDetailGoodsModel *model in self.dataArray) {
    //        if (model.isSelect) {
    //            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@:%@,",model.goodsId,model.cnt]];
    //        }
    //    }
    //    NSString *ids = [str substringToIndex:str.length - 1];
    //    parames[@"ids"] = ids;
    //    WeakObj(self);
    //    [[NetWorkManager shareManager] POST:USER_toOrderCart parameters:parames successed:^(id json) {
    //        if (json) {
    //            [MBHUDHelper showSuccess:@"下单成功"];
    //            OrderProducModel *model = [OrderProducModel mj_objectWithKeyValues:json];
    //            OrderProducController *vc = [OrderProducController new];
    //            vc.model = model;
    //            vc.shopId = Weakself.shopId;
    //            [Weakself.navigationController pushViewController:vc animated:YES];
    //        }
    //        [Weakself.tableView.mj_header endRefreshing];
    //    } failure:^(NSError *error) {
    //        [Weakself.tableView.mj_header endRefreshing];
    //    }];
    
}

- (void)setupAddress{
    self.name.text = [NSString stringWithFormat:@"收货人: %@",self.addressModel.name];
    self.phone.text = self.addressModel.phone;
    self.address.text = [NSString stringWithFormat:@"%@ %@",self.addressModel.area_names,self.addressModel.address];
}

- (void)doTap{
    MyAddressController *vc = [MyAddressController new];
    vc.isNeedSelect = YES;
    WeakObj(self);
    vc.selectAddressBlock = ^(MyAddressModel *addressModel) {
        Weakself.addressModel = addressModel;
        [Weakself setupAddress];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
