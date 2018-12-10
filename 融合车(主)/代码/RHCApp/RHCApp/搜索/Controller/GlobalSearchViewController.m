//
//  GlobalSearchViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/5.
//

#import "GlobalSearchViewController.h"
#import "NavigationSearchBarView.h"
#import "HotSearchListModel.h"
#import "SearchHistoryView.h"
#import "SearchEngine.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"
#import "SendWantCarView.h"
#import "FindViewDetailViewCell.h"
#import "FindViewDetailViewBigCell.h"
#import "FindViewDetailViewNoneCell.h"
#import "FindDetailContentController.h"
//产品
static NSString *kProductCell = @"ProductCell";
//资讯
static NSString *kFindViewDetailViewNoneCell = @"FindViewDetailViewNoneCell";
static NSString *kFindViewDetailViewCell = @"FindViewDetailViewCell";
static NSString *kFindViewDetailViewBigCell = @"FindViewDetailViewBigCell";


@interface GlobalSearchViewController () <NavigationSearchBarViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic, strong)  NavigationSearchBarView *naviView;
@property (nonatomic, strong)  SearchHistoryView *searchHistoryView;
@property (nonatomic, strong)  UITableView             *tableView;
@property (nonatomic, strong)  NSMutableArray          *dataArray;
@property (nonatomic, assign)  NSInteger               cape;//分页筛选（上提加载）
@property (nonatomic, strong)  SendWantCarView         *sendWantCarView;


@end

@implementation GlobalSearchViewController

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
        
        [_tableView registerClass:[FindViewDetailViewNoneCell class] forCellReuseIdentifier:kFindViewDetailViewNoneCell];
        [_tableView registerClass:[FindViewDetailViewCell class] forCellReuseIdentifier:kFindViewDetailViewCell];
        [_tableView registerClass:[FindViewDetailViewBigCell class] forCellReuseIdentifier:kFindViewDetailViewBigCell];
        
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    
    //请求历史纪录
    [[NetWorkManager shareManager] POST:USER_GetHotsearchListlist parameters:nil successed:^(id json) {
        NSArray *tempArray = [HotSearchListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        NSMutableArray *hotArray = [NSMutableArray array];
        [hotArray addObjectsFromArray:tempArray];
        self.searchHistoryView.item = hotArray;
        [self.searchHistoryView loadDataView];
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupUI{
    //1.

    //2.设置导航条
    self.naviView = [[NavigationSearchBarView alloc] initWithType:NavigationSearchBarTypeSearchView];
    self.naviView.searchDelegate = self;
    [self.naviView didCloseTapBlock:^(UITextField *obj) {
        
    }];
    [self.view addSubview:self.naviView];
    
    //3.设置搜索记录和热门搜索
    self.searchHistoryView = [[SearchHistoryView alloc]initWithFrame:CGRectZero];
    self.searchHistoryView.hidden = NO;
    WeakObj(self);
    [self.searchHistoryView didSelectedTapBlock:^(id obj, NSInteger section) {
//        [[SearchEngine shareInstance] addSearchHistory:obj];
        Weakself.searchHistoryView.hidden = YES;
        [Weakself.naviView.searchField resignFirstResponder];
        Weakself.naviView.searchField.text = obj;
        [self loadNewsData];
//        [self setupPageViewController];
    }];
    [self.searchHistoryView didTapCollectionViewBlock:^{
        [Weakself.naviView.searchField resignFirstResponder];
    }];
//    self.pageView.hidden = !self.searchHistoryView.hidden;
    [self.searchHistoryView loadDataView];
    [self.view addSubview:self.searchHistoryView];
    //4.设置搜索展示数据
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    //5.设置没有搜索数据的展示
    self.sendWantCarView = [SendWantCarView new];
    [self.view addSubview:self.sendWantCarView];
    self.sendWantCarView.hidden = YES;
}

- (void)setupLayout{
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset = 0;
        make.height.offset = 64 + SafeTopSpace;
    }];
    [self.searchHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset = 0;
        make.top.equalTo(self.naviView.mas_bottom).offset = 0;
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset = 0;
        make.top.equalTo(self.naviView.mas_bottom).offset = 0;
    }];
    [self.sendWantCarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset = 0;
        make.top.equalTo(self.naviView.mas_bottom).offset = 0;
    }];
}


#pragma mark -- NavigationSearchBarView Delagate
//点击键盘搜索 调用
- (void)searchViewReturnButtonClicked:(UITextField *)searchBar{
//    self.searchHistoryView.hidden = YES;
    [self.naviView.searchField resignFirstResponder];
    [self searchActionWithNeedEndEditing:YES isNeedAddHistory:YES];
}

//1.点击搜索框 开始编辑之前调用  2.首次进入
- (void)searchViewTextDidBeginEditing:(UITextField *)searchBar{
    
}

- (void)searchBar:(UITextField *)searchBar textDidChange:(NSString *)searchText{
//    self.searchHistoryView.hidden = searchBar.text.length;
}

#pragma mark ---  实实在在的进行搜索

- (void)searchActionWithNeedEndEditing:(BOOL)isNeedEndEdit isNeedAddHistory:(BOOL)isNeedAddHistory{
    if (self.naviView.searchField.text.length == 0) {
        [MBHUDHelper showError:@"请输入搜索关键词"];
        [self.view bringSubviewToFront:self.searchHistoryView];
        self.searchHistoryView.dataSource = [[SearchEngine shareInstance] getSearchEngineData];
        [self.searchHistoryView loadDataView];
    }else{
        self.searchHistoryView.hidden = YES;
        if (isNeedEndEdit) {
            [self.view endEditing:YES];
            [self.naviView.searchField resignFirstResponder];
        }
        if (isNeedAddHistory) {
            [[SearchEngine shareInstance] addSearchHistory:self.naviView.searchField.text];
        }
        self.searchHistoryView.hidden = YES;
        
        //进行请求数据了
        [self loadNewsData];
    }
}


#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.globalSearchType == GlobalSearchTypeProduct) {
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCell];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    
    //根据图片大多少 判断大图 小图 无图的 情况
    FindViewListModel *model = self.dataArray[indexPath.row];
    if ([model.showway integerValue] == 1) {//小图
        FindViewDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFindViewDetailViewCell];
        cell.model = model;
        return cell;
    }else if ([model.showway integerValue] == 2){//大图
        FindViewDetailViewBigCell *cell = [tableView dequeueReusableCellWithIdentifier:kFindViewDetailViewBigCell];
        cell.model = model;
        return cell;
    }else{//没有图
        FindViewDetailViewNoneCell *cell = [tableView dequeueReusableCellWithIdentifier:kFindViewDetailViewNoneCell];
        cell.model = model;
        return cell;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.globalSearchType == GlobalSearchTypeProduct) {
        ProductDetailViewController *vc = [ProductDetailViewController new];
        ProductModel *model = self.dataArray[indexPath.row];
        vc.pid = model.pid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        FindViewListModel *model = self.dataArray[indexPath.row];
        FindDetailContentController *vc = [FindDetailContentController new];
        vc.fid = model.fid;
        [self.navigationController pushViewController:vc animated:YES];
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
    parames0[@"key"] = self.naviView.searchField.text;
    parames0[@"type"] = self.globalSearchType == GlobalSearchTypeProduct ? @"product" : @"information";
    [[NetWorkManager shareManager] POST:USER_SearchList parameters:parames0 successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];

            if (Weakself.globalSearchType == GlobalSearchTypeProduct) {
                NSArray *array = [ProductModel mj_objectArrayWithKeyValuesArray:json[@"productList"]];
                [Weakself.dataArray addObjectsFromArray:array];
                Weakself.sendWantCarView.hidden = Weakself.dataArray.count;
                Weakself.tableView.hidden = !Weakself.dataArray.count;
            }else{
                NSArray *array = [FindViewListModel mj_objectArrayWithKeyValuesArray:json[@"informationList"]];
                [Weakself.dataArray addObjectsFromArray:array];
                Weakself.sendWantCarView.hidden = YES;
                Weakself.tableView.hidden = NO;
                if (!array.count) {
                    [self showEmptyMessage:@"未搜索到数据"];
                }else{
                    [self hideEmptyView];
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
    parames[@"key"] = self.naviView.searchField.text;
    parames[@"type"] = self.globalSearchType == GlobalSearchTypeProduct ? @"product" : @"information";
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_SearchList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            if (Weakself.globalSearchType == GlobalSearchTypeProduct) {
                NSArray *array = [ProductModel mj_objectArrayWithKeyValuesArray:json[@"productList"]];
                if (array.count == 0) {//没有数据、
                    [Weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [Weakself.dataArray addObjectsFromArray:array];
                    [Weakself.tableView reloadData];
                }
            }else{
                NSArray *array = [FindViewListModel mj_objectArrayWithKeyValuesArray:json[@"informationList"]];
                if (array.count == 0) {//没有数据、
                    [Weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [Weakself.dataArray addObjectsFromArray:array];
                    [Weakself.tableView reloadData];
                }
            }
        }
    } failure:^(NSError *error) {
        [Weakself.tableView.mj_footer endRefreshing];
    }];
}
@end
