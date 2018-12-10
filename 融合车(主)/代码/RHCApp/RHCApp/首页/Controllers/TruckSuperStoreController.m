//
//  TruckSuperStoreController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/30.
//

#import "TruckSuperStoreController.h"
#import "NavigationSearchBarView.h"
#import "DOPDropDownMenu.h"
#import "ProductCell.h"
#import "ProductListFooterView.h"
#import "ProductDetailViewController.h"
#import "HomeSeckillController.h"
#import "BrandModel.h"
#import "SelectBrandNameController.h"
#import "OrganizationTagsView.h"

static NSString *kProductCell = @"ProductCell";

@interface TruckSuperStoreController ()<UINavigationControllerDelegate,DOPDropDownMenuDelegate, DOPDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NavigationSearchBarView *naviView;
@property (nonatomic,strong) DOPDropDownMenu *menu;
@property (nonatomic,strong) OrganizationTagsView *tagsView;
@property (nonatomic,strong) UITableView     *tableView;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *miaoshaArray;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSArray *array1;//默认排序
@property (nonatomic,strong) NSMutableArray *array2;//品牌
@property (nonatomic,strong) NSMutableArray *arrayid2;//品牌id
@property (nonatomic,strong) NSArray *array3;//首付
@property (nonatomic,strong) NSArray *array4;//价格
@property (nonatomic,strong) NSArray *array5;//类型

@property (nonatomic,strong) NSString *parames1;
@property (nonatomic,strong) NSString *parames2;
@property (nonatomic,strong) NSString *parames3;
@property (nonatomic,strong) NSString *parames4;
@property (nonatomic,strong) NSString *parames5;

//记录参数  为了展示
@property (nonatomic,strong) NSString *select1;
@property (nonatomic,strong) NSString *select2;
@property (nonatomic,strong) NSString *select3;
@property (nonatomic,strong) NSString *select4;
@property (nonatomic,strong) NSString *select5;
@property (nonatomic,assign) BOOL     isHavaPush;

@end

@implementation TruckSuperStoreController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.menu reloadData];
    self.isHavaPush = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    //1.设置导航条
    self.naviView = [[NavigationSearchBarView alloc] initWithType:NavigationSearchBarTypeTruckStore];
    self.naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.naviView];
    self.view.backgroundColor = SMViewBGColor;
    //    NSMutableArray *tempArray = [NSMutableArray array];
    //    [tempArray addObject:@"全部"];
    //    for (CategoryModel *model in self.itemTypeArray) {
    //        [tempArray addObject:model.title];
    //    }
    //     [tempArray addObject:@"1234"];
    self.array2 = [NSMutableArray array];
    self.arrayid2 = [NSMutableArray array];
    //2.
    self.array1 = @[@"默认排序",@"车价最高",@"车价最低",@"首付最低"];
    [self.array2 addObject:@"品牌"];
    self.array3 = @[@"首付",@"不限",@"1万以内",@"1-3万",@"3-5万",@"5万以上"];
    self.array4 = @[@"价格",@"不限",@"10万以内",@"10-20万",@"20-30万",@"30万以上"];
    self.array5 = @[@"类型",@"微卡",@"轻卡",@"重卡",@"牵引车",@"载货车",@"自卸车",@"皮卡",@"挂车",@"专用车"];;
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:30];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    self.menu.textSelectedColor = SMThemeColor;
    [self.view addSubview:self.menu];
    self.menu.remainMenuTitle = YES;
    self.tagsView = [[OrganizationTagsView alloc] init];
    WeakObj(self);
    //删除部分选中的
    self.tagsView.deleteTagsBlock = ^(NSString *tagsName) {
        if ([tagsName isEqualToString:Weakself.select1]) {
            Weakself.parames1 = @"";
            Weakself.select1 = @"";
        }
        if ([tagsName isEqualToString:Weakself.select2]) {
            Weakself.parames2 = @"";
            Weakself.select2 = @"";
        }
        if ([tagsName isEqualToString:Weakself.select3]) {
            Weakself.parames3 = @"";
            Weakself.select3 = @"";
        }
        if ([tagsName isEqualToString:Weakself.select4]) {
            Weakself.parames4 = @"";
            Weakself.select4 = @"";
        }
        if ([tagsName isEqualToString:Weakself.select5]) {
            Weakself.parames5 = @"";
            Weakself.select5 = @"";
        }
        [Weakself.menu reloadData];
        [Weakself loadNewsData];
    };
    //删除全部
    self.tagsView.deleteAllBlock = ^{
        Weakself.parames1 = @"";
        Weakself.select1 = @"";
        //        [Weakself.array2 removeAllObjects];
        //        [Weakself.array2 addObject:@"品牌"];
        Weakself.parames2 = @"";
        Weakself.select2 = @"";
        Weakself.parames3 = @"";
        Weakself.select3 = @"";
        Weakself.parames4 = @"";
        Weakself.select4 = @"";
        Weakself.parames5 = @"";
        Weakself.select5 = @"";
        [Weakself.menu reloadData];
        [Weakself loadNewsData];
    };
    [self.view addSubview:self.tagsView];
    
    //3
    self.dataArray = [NSMutableArray array];
    self.miaoshaArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
    [self loadNewsData];
}
- (void)setupLayout{
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset = 0;
        make.height.offset = 64 + SafeTopSpace;
    }];
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(self.naviView.mas_bottom);
        make.height.offset = 30;
    }];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.offset = 0;
        make.top.equalTo(self.menu.mas_bottom);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.top.equalTo(self.menu.mas_bottom);
    }];
}

#pragma mark -- DOPDropDownMenu 代理方法
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.array1.count;
    }else if (column == 1){
        //push到选择品牌界面
        if (!self.isHavaPush) {
            SelectBrandNameController *vc = [SelectBrandNameController new];
            self.isHavaPush = YES;
            WeakObj(self);
            
            vc.selectCarBlock = ^(NSString * _Nonnull carName, NSString * _Nonnull carId) {
//                [Weakself.array2 removeAllObjects];
//                [Weakself.array2 addObject:carName];
                Weakself.parames2 = carId;
                if (!carId.length) {//品牌
                    Weakself.select2 = @"";
                }else{
                    Weakself.select2 = carName;
                }
//                [Weakself.menu reloadData];
                [Weakself loadNewsData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }

        return self.array2.count;
    }else if (column == 2){
        return self.array3.count;
    }else if (column == 3){
        return self.array4.count;
    }else{
        return self.array5.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.array1[indexPath.row];
    }else if (indexPath.column == 1){
        if (self.array2.count) {
            return self.array2[indexPath.row];
        }else{
            return @"";
        }
    }else if (indexPath.column == 2){
        return self.array3[indexPath.row];
    }else if (indexPath.column == 3){
        return self.array4[indexPath.row];
    }else{
        return self.array5[indexPath.row];
    }
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 5;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"%ld, %ld, %ld", indexPath.column, indexPath.row, indexPath.item);
    
    //    NSLog(@"%@",self.itemTypeArray);
    
    if (indexPath.column == 0) {//第一列
        //筛选出项目ID
        
        //        NSString *tempStr = self.projrectsArray[indexPath.row];
        
        if (indexPath.row == 0) {
            //            self.saveStrForType = @"";
            self.parames1 = @"";
            self.select1 = @"";
        }else{
            //            for (CategoryModel *model in self.itemTypeArray) {
            //                if ([model.title isEqualToString:tempStr]) {
            //                    self.saveStrForType = model.titleId;
            //                    break;
            //                }
            //            }
            self.parames1 = [NSString stringWithFormat:@"%tu",indexPath.row];
            self.select1 = self.array1[indexPath.row];
        }
        
        //        [self loadNewTasks];
        
    }else if (indexPath.column == 1){//第二列
        if (indexPath.row == 0) {
            self.parames2 = @"";
            self.select2 = @"";
        }else{
            NSString *temp = self.array2[indexPath.row];
            
            for (BrandModel *model in self.arrayid2) {
                if ([temp isEqualToString:model.title]) {
                    self.parames2 = model.bid;
                    break;
                }
            }
        }
    }
    else if (indexPath.column == 2){//第三列
        if (indexPath.row == 0) {
            self.parames3 = @"";
            self.select3 = @"";
        }else{
            self.parames3 = [NSString stringWithFormat:@"%tu",indexPath.row - 1];
            self.select3 = self.array3[indexPath.row];
        }
    }
    else if (indexPath.column == 3){//第四列
        if (indexPath.row == 0) {
            self.parames4 = @"";
            self.select4 = @"";
        }else{
            self.parames4 = [NSString stringWithFormat:@"%tu",indexPath.row - 1];
            self.select4 = self.array4[indexPath.row];
        }
    }
    else if (indexPath.column == 4){//第五列
        if (indexPath.row == 0) {
            self.parames5 = @"";
            self.select5 = @"";
        }else{
            self.parames5 = [NSString stringWithFormat:@"%tu",indexPath.row];
            self.select5 = self.array5[indexPath.row];
        }
    }
    
    [self loadNewsData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ProductCell class] forCellReuseIdentifier:kProductCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //        header.lastUpdatedTimeLabel.hidden = YES;
        //        header.stateLabel.font = LPFFONT(13);
        //        header.ignoredScrollViewContentInsetTop = NAVI_H;
        //        _tableView.mj_header = header;
        _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self.tableView.mj_footer resetNoMoreData];
            [self loadNewsData];
        }];
        //
        RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

//- (void)loadNewData{
//    [self.tableView.mj_footer resetNoMoreData];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    [self.tableView.mj_header endRefreshing];
//    });
//}

#pragma mark tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.miaoshaArray.count) {
        if (section == 0) {
            ProductListFooterView *headView = [[ProductListFooterView alloc] initWithTarget:self action:@selector(checkMoreAction)];
            headView.frame = CGRectMake(0, 0, 0, 200);
            return headView;
        }
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.miaoshaArray.count) {
        if (section == 0) {
            return 50;
        }
    }
    return 0.0000001;
}

- (void)checkMoreAction{
    HomeSeckillController *vc = [HomeSeckillController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.miaoshaArray.count ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.miaoshaArray.count) {
        if (section == 0) {
            if (self.miaoshaArray.count > 2) {
                return 2;
            }else{
                return self.miaoshaArray.count;
            }
        }else{
            return self.dataArray.count;
        }
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCell];
    if (self.miaoshaArray.count) {
        if (indexPath.section == 0) {
            cell.model = self.miaoshaArray[indexPath.row];
        }else{
            cell.model = self.dataArray[indexPath.row];
        }
    }else{
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *pid = @"";
    if (self.miaoshaArray.count) {
        if (indexPath.section == 0) {
            ProductModel *model = self.miaoshaArray[indexPath.row];
            pid = model.pid;
        }else{
            ProductModel *model = self.dataArray[indexPath.row];
            pid = model.pid;
        }
    }else{
        ProductModel *model = self.dataArray[indexPath.row];
        pid = model.pid;
    }
    ProductDetailViewController *vc = [ProductDetailViewController new];
    vc.pid = pid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadNewsData{
    //判断是否有参数并组成数组
    NSMutableArray *tempArray = [NSMutableArray array];
    if (self.select1.length) {
        [tempArray addObject:self.select1];
    }
    if (self.select2.length) {
        [tempArray addObject:self.select2];
    }
    if (self.select3.length) {
        [tempArray addObject:self.select3];
    }
    if (self.select4.length) {
        [tempArray addObject:self.select4];
    }
    if (self.select5.length) {
        [tempArray addObject:self.select5];
    }
    
    [self.tagsView config:tempArray];
    CGFloat tagsViewH = [OrganizationTagsView cellHeightWithArray:tempArray];
    [self.tagsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.menu.mas_bottom);
        make.height.mas_equalTo(tempArray.count ? tagsViewH: 0);
    }];
    WeakObj(self);
    self.cape = 1;
    //1.设置秒杀数据
    if (self.parames1.length || self.parames2.length || self.parames3.length || self.parames4.length || self.parames5.length ) {//说明是刷选 不应有秒杀的数据
        [Weakself.miaoshaArray removeAllObjects];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset = 0;
            make.top.equalTo(self.menu.mas_bottom).offset = tempArray.count ? tagsViewH : 0;
        }];
    }else{
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset = 0;
            make.top.equalTo(self.menu.mas_bottom);
        }];
        NSMutableDictionary *parames0 = [NSMutableDictionary dictionary];
        ;
        parames0[@"pageSize"] = @"10";
        parames0[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
        parames0[@"showType"] = @"3";
        parames0[@"activeType"] = @"2";
        [[NetWorkManager shareManager] POST:USER_ProductList parameters:parames0 successed:^(id json) {
            if (json) {
                [Weakself.miaoshaArray removeAllObjects];
                NSArray *tempArray = [ProductModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
                for (ProductModel *model in tempArray) {
                    model.isSkill = YES;
                }
                [Weakself.miaoshaArray addObjectsFromArray:tempArray];
                [Weakself.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    
    //2.设置发现与车圈
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    parames[@"showType"] = @"3";
    if (self.parames1.length) {
        parames[@"order"] = self.parames1;
    }
    if (self.parames2.length) {
        parames[@"carBrand"] = self.parames2;
    }
    if (self.parames3.length) {
        parames[@"downPaymentType"] = self.parames3;
    }
    if (self.parames4.length) {
        parames[@"priceType"] = self.parames4;
    }
    if (self.parames5.length) {
        parames[@"carType"] = self.parames5;
    }
    [[NetWorkManager shareManager] POST:USER_ProductList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [ProductModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:array];
            if (!array.count) {
                [self showEmptyMessage:@"未搜索到数据"];
            }else{
                [self hideEmptyView];
            }
            [Weakself.tableView reloadData];
        }
        [Weakself.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [Weakself.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    self.cape++;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    parames[@"showType"] = @"3";
    if (self.parames1.length) {
        parames[@"order"] = self.parames1;
    }
    if (self.parames2.length) {
        parames[@"carBrand"] = self.parames2;
    }
    if (self.parames3.length) {
        parames[@"downPaymentType"] = self.parames3;
    }
    if (self.parames4.length) {
        parames[@"priceType"] = self.parames4;
    }
    if (self.parames5.length) {
        parames[@"carType"] = self.parames5;
    }
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [ProductModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
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
@end
