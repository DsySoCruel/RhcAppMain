//
//  MyShopCarViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/8.
//

#import "MyShopCarViewController.h"
#import "ShopCarCell.h"
#import "ShopCarListModel.h"
#import "MyAddressModel.h"
#import "OrderMakeViewController.h"

//#import "ShopCarViewModel.h"
//#import "ShopCarDetailModel.h"
//#import "OrderProducController.h"
//#import "OrderProducModel.h"

static NSString *kShopCarCell = @"ShopCarCell";

@interface MyShopCarViewController ()<UITableViewDelegate,UITableViewDataSource>

//1.tableView
@property (nonatomic,strong) UITableView *tableView;

//2.bottomView
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *selectAllButton;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UIButton *buyButton;
@property (nonatomic,strong) UIButton *deletAllButton;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
//@property (nonatomic,strong) ShopCarDetailModel *model;
@property (nonatomic,strong) MyAddressModel *addressModel;
@property (nonatomic,strong) NSMutableAttributedString *titleString;
@end

@implementation MyShopCarViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewsData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    [self setupUI];
    [self setupLayout];
    
    UIBarButtonItem *edit = [UIBarButtonItem itemtitle:@"管理" target:self action:@selector(rightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = edit;
}
- (void)setupUI{
    self.view.backgroundColor = SMViewBGColor;
    //1.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[ShopCarCell class] forCellReuseIdentifier:kShopCarCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = SMViewBGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        [self.tableView.mj_footer resetNoMoreData];
//        [self loadNewsData];
//    }];
    //
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];
    //2.
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    self.priceLabel = [UILabel new];
    [self.bottomView addSubview:self.priceLabel];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥0.00"]];
    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, titleString.length)];
    [titleString addAttribute:NSFontAttributeName value:LPFFONT(20) range:NSMakeRange(1, titleString.length-1)];
    [self.priceLabel setAttributedText:titleString];
    
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyButton.backgroundColor = SMThemeColor;
    [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buyButton.titleLabel.font = LPFFONT(15);
    self.buyButton.layer.cornerRadius = 20;
    self.buyButton.layer.masksToBounds = YES;
    [self.buyButton setTitle:@"去结算" forState:UIControlStateNormal];
    [self.bottomView addSubview:self.buyButton];
    [self.buyButton addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectAllButton setImage:IMAGECACHE(@"gouwuche_01") forState:UIControlStateNormal];
    [self.selectAllButton setImage:IMAGECACHE(@"gouwuche_02") forState:UIControlStateSelected];
    [self.selectAllButton addTarget:self action:@selector(selectAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectAllButton setTitleColor:SMParatextColor forState:UIControlStateNormal];
    [self.selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    self.selectAllButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.selectAllButton.titleLabel.font = LPFFONT(13);
    [self.bottomView addSubview:self.selectAllButton];
    
    self.deletAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deletAllButton setTitle:@"清除购物车" forState:UIControlStateNormal];
    [self.deletAllButton setImage:IMAGECACHE(@"icon_51") forState:UIControlStateNormal];
    [self.deletAllButton setTitleColor:SMParatextColor forState:UIControlStateNormal];
    self.deletAllButton.titleLabel.font = LPFFONT(13);
    [self.deletAllButton addTarget:self action:@selector(deletAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deletAllButton.hidden = YES;
    [self.bottomView addSubview:self.deletAllButton];
    
}
- (void)setupLayout{

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 64 + SafeTopSpace + 10;
        make.right.left.offset = 0;
        make.bottom.offset = -50 - SafeBottomSpace * 0.5;
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 50;
        make.bottom.offset = - SafeBottomSpace * 0.5;
    }];
    
    [self.selectAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 2;
        make.centerY.offset = 0;
        make.width.offset = 70;
        make.height.offset = 50;
    }];
    [self.deletAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.offset = 0;
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.offset = 0;
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.top.offset = 5;
        make.bottom.offset = -5;
        make.width.offset = 100;
    }];
}

#pragma mark-tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCarCell];
    ShopCarListModel *model = self.dataArray[indexPath.row];
    cell.goodModel = model;
    WeakObj(self);
    cell.needContTotalPriceBlock = ^{
        [Weakself countTotalPrice];
    };
    cell.selectButtonActionBlock = ^{
        //统计全选按钮是否需要选中
        BOOL isSelectAll = YES;
        for (ShopCarListModel *model in Weakself.dataArray) {
            if (!model.isSelect) {
                isSelectAll = NO;
                break;
            }
        }
        Weakself.selectAllButton.selected = isSelectAll;
        [Weakself countTotalPrice];
    };
    cell.needUpdataBlock = ^{
        [Weakself loadNewsData];
    };
    return cell;
}

- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductCarList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [ShopCarListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            
            [Weakself.dataArray addObjectsFromArray:array];
            [Weakself.tableView reloadData];
            if (Weakself.dataArray.count == 0) {
                [Weakself showEmptyMessage:@"购物车为空"];
            }else{
                [Weakself hideEmptyView];
            }
            //重置全选状态的按钮
            self.selectAllButton.selected = NO;
            [self countTotalPrice];
        }
    } failure:^(NSError *error) {
    }];
}
- (void)loadMoreData{
    self.cape++;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductCarList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [ShopCarListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            if (array.count == 0) {//没有数据、
                [Weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [Weakself.dataArray addObjectsFromArray:array];
                [Weakself.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [Weakself.tableView.mj_footer endRefreshing];
    }];
}


- (void)selectAllButtonAction:(UIButton *)sender{
    BOOL isSelectAll = YES;
    for (ShopCarListModel *model in self.dataArray) {
        if (!model.isSelect) {
            isSelectAll = NO;//当前没有全部选中
            break;
        }
    }
    for (ShopCarListModel *model in self.dataArray) {
        if (isSelectAll) {//取消全部选中
            model.isSelect = NO;
        }else{
            if (!model.isSelect) {
                model.isSelect = YES;
            }
        }
    }
    sender.selected = !sender.selected;
    [self.tableView reloadData];
    [self countTotalPrice];
}
- (void)deletAllButtonAction:(UIButton *)sender{
    //删除所有
    //进行删除操作
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    NSString *ids = @"";
    for (int i = 0; i < self.dataArray.count; i++) {
        ShopCarListModel *model = self.dataArray[i];
        if (i == 0) {
            ids = [ids stringByAppendingString:model.goodsId];
        }else{
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@",%@",model.goodsId]];
        }
    }
    parames[@"id"] = ids;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductDeleteCarItem parameters:parames successed:^(id json) {
        if (json) {
            [MBHUDHelper showSuccess:@"删除成功"];
            [Weakself loadNewsData];
            Weakself.selectAllButton.selected = NO;            
        }
    } failure:^(NSError *error) {
    }];
}
#pragma mark--生成订单
- (void)buyButtonAction:(UIButton *)sender{
    
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
    
    //到下订单页面
    NSMutableArray *tempArray = [NSMutableArray array];
    for (ShopCarListModel *model in self.dataArray) {
        if (model.isSelect) {
            [tempArray addObject:model];
        }
    }
    if (!tempArray.count) {
        [MBHUDHelper showSuccess:@"请选择商品!"];
        return;
    }
    OrderMakeViewController *makeOrderVC = [OrderMakeViewController new];
    makeOrderVC.addressModel = self.addressModel;//设置收货地址
    //设置选中的商品数组
    makeOrderVC.selectGoodsArray = tempArray;
    makeOrderVC.titleString = self.titleString;
    [self.navigationController pushViewController:makeOrderVC animated:YES];
}


#pragma mark--计算价钱
- (void)countTotalPrice{
    CGFloat totalPrice = 0.00;
    for (ShopCarListModel *model in self.dataArray) {
        if (model.isSelect) {
            totalPrice += [model.price floatValue]*[model.cnt integerValue];
        }
    }
    self.titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",totalPrice]];
    [self.titleString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, self.titleString.length)];
    [self.titleString addAttribute:NSFontAttributeName value:LPFFONT(20) range:NSMakeRange(1, self.titleString.length-1)];
    [self.priceLabel setAttributedText:self.titleString];
}

- (void)rightBarButtonItemAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.priceLabel.hidden = YES;
        self.buyButton.hidden = YES;
        self.deletAllButton.hidden = NO;
    }else{
        self.priceLabel.hidden = NO;
        self.buyButton.hidden = NO;
        self.deletAllButton.hidden = YES;
    }
}


//判断有没有收货地址
- (void)loadData{
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_myaddress parameters:parames successed:^(id json) {
        if (json) {
            NSArray *moreArray = [MyAddressModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            for (MyAddressModel *addressModel in moreArray) {
                if ([addressModel.isDefault isEqualToString:@"1"]) {
                    self.addressModel = addressModel;
                    break;
                }
            }
            if (moreArray.count) {
                [Weakself buyButtonAction:self.buyButton];
            }else{
                [MBHUDHelper showError:@"请先添加收货地址!"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
