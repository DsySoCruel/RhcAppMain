//
//  HomeViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/20.
//

#import "HomeViewController.h"
#import "NavigationSearchBarView.h"
#import "HomeHeadView.h"
#import "HomeViewListModel.h"
#import "FindViewDetailViewCell.h"
#import "FindViewDetailViewBigCell.h"
#import "FindViewDetailViewNoneCell.h"
#import "CircleVClistCell.h"
#import "FindDetailContentController.h"
#import "CircleDetailViewController.h"
#import "ProductModel.h"
#import "HomeBrandCell.h"

static NSString *hFindViewDetailViewNoneCell = @"HomeFindViewDetailViewNoneCell";
static NSString *hFindViewDetailViewCell = @"HomeFindViewDetailViewCell";
static NSString *hFindViewDetailViewBigCell = @"HomeFindViewDetailViewBigCell";
static NSString *hCircleVClistCell = @"HomeCircleVClistCell";
static NSString *hHomeBrandCell = @"HomeBrandCell";


@interface HomeViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NavigationSearchBarView *naviView;
@property (nonatomic,strong) HomeHeadView *headView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *miaoshaArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (HomeHeadView *)headView{
    if(!_headView){
        _headView = [HomeHeadView new];
        CGFloat height = 0;
        height = YXDScreenW/1.84 + 365 + 50 + 50;
        _headView.frame = CGRectMake(0, 0, Screen_W, height);
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    self.dataArray = [NSMutableArray array];
    self.miaoshaArray = [NSMutableArray array];
    //1.设置tableView
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
    [self loadNewsData];
    //2.设置导航条
    self.naviView = [[NavigationSearchBarView alloc] initWithType:NavigationSearchBarTypeHome];
    [self.view addSubview:self.naviView];
}
- (void)setupLayout{
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset = 0;
        make.height.offset = 64 + SafeTopSpace;
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
//        make.top.offset = -StatusBar_H;
        make.top.offset = 0;
        make.bottom.offset = -49;
    }];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[FindViewDetailViewNoneCell class] forCellReuseIdentifier:hFindViewDetailViewNoneCell];
        [_tableView registerClass:[FindViewDetailViewCell class] forCellReuseIdentifier:hFindViewDetailViewCell];
        [_tableView registerClass:[FindViewDetailViewBigCell class] forCellReuseIdentifier:hFindViewDetailViewBigCell];
        [_tableView registerClass:[CircleVClistCell class] forCellReuseIdentifier:hCircleVClistCell];
        [_tableView registerClass:[HomeBrandCell class] forCellReuseIdentifier:hHomeBrandCell];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150;
        _tableView.tableHeaderView = self.headView;
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

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY < 0) {
//        [self.userInfoView adustHeaderView:offsetY];
//    }
    [self.naviView changeAlphaWithOffset:scrollView.contentOffset.y];
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    HomeSectionHeaderView *headView = [[HomeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, YXDScreenW, 50)];
//    return headView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeViewListBigModel *bigmodel = self.dataArray[indexPath.row];
    //判断模型类型
    if ([bigmodel.type isEqualToString:@"app_car_brand"]) {
        HomeBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:hHomeBrandCell];
        cell.model = bigmodel.data;
        return cell;
    }else{
        HomeViewListModel *model = bigmodel.data;
        //判断是车圈还是发现
        if (model.userID.length) {//车圈
            CircleVClistCell *cell = [tableView dequeueReusableCellWithIdentifier:hCircleVClistCell];
            cell.homeModel = model;
            return cell;
        }else{//发现
//            if ([model.showway integerValue] == 1) {//小图
//                FindViewDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hFindViewDetailViewCell];
//                cell.homeModel = model;
//                return cell;
//            }else if ([model.showway integerValue] == 2){//大图
//                FindViewDetailViewBigCell *cell = [tableView dequeueReusableCellWithIdentifier:hFindViewDetailViewBigCell];
//                cell.homeModel = model;
//                return cell;
//            }else{//没有图
//                FindViewDetailViewNoneCell *cell = [tableView dequeueReusableCellWithIdentifier:hFindViewDetailViewNoneCell];
//                cell.homeModel = model;
//                return cell;
//            }
                    FindViewDetailViewBigCell *cell = [tableView dequeueReusableCellWithIdentifier:hFindViewDetailViewBigCell];
                    cell.homeModel = model;
                    return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeViewListBigModel *bigmodel = self.dataArray[indexPath.row];
    if (![bigmodel.type isEqualToString:@"app_car_brand"]) {
        HomeViewListModel *model = bigmodel.data;
        if (model.userID.length) {//车圈
            CircleDetailViewController *vc = [CircleDetailViewController new];
            vc.cid =model.hid;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            FindDetailContentController *vc = [FindDetailContentController new];
            vc.fid =model.hid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)loadNewsData{
    WeakObj(self);
    self.cape = 1;
    //1.设置秒杀数据
    NSMutableDictionary *parames0 = [NSMutableDictionary dictionary];
    ;
    parames0[@"pageSize"] = @"10";
    parames0[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    parames0[@"showType"] = @"1";
    parames0[@"activeType"] = @"2";
    [[NetWorkManager shareManager] POST:USER_ProductList parameters:parames0 successed:^(id json) {
        if (json) {
            //优化首页秒杀区
            [Weakself.miaoshaArray removeAllObjects];
            NSArray *tempArray = [ProductModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            for (int i = 0; i < tempArray.count; i++) {
                if (i < 10) {
                    [Weakself.miaoshaArray addObject:tempArray[i]];
                }
            }
            //设置首页头部view高度
            NSInteger h = Weakself.miaoshaArray.count/2;
            NSInteger l = Weakself.miaoshaArray.count%2;
            CGFloat height = 0;
            height = YXDScreenW/1.84 + 265 + 240*(h+l) + (h + l) - 1 + 2;
            Weakself.headView.frame = CGRectMake(0, 0, Screen_W, height);
            Weakself.headView.miaoshaArray = Weakself.miaoshaArray;

        }
    } failure:^(NSError *error) {
        
    }];
    
    //2.设置发现与车圈 品牌专区
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    [[NetWorkManager shareManager] POST:USER_GetCommonHome parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [HomeViewListBigModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            for (HomeViewListBigModel *model in array) {
                if ([model.type isEqualToString:@"app_post"] || [model.type isEqualToString:@"app_information"] || [model.type isEqualToString:@"app_car_brand"] ) {
                    [Weakself.dataArray  addObject:model];
                }
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
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_GetCommonHome parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [HomeViewListBigModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            if (array.count == 0) {//没有数据、
                [Weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (HomeViewListBigModel *model in array) {
                    if ([model.type isEqualToString:@"app_post"] || [model.type isEqualToString:@"app_information"] || [model.type isEqualToString:@"app_car_brand"] ) {
                        [Weakself.dataArray  addObject:model];
                    }
                }
                [Weakself.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [Weakself.tableView.mj_footer endRefreshing];
    }];
}
@end
