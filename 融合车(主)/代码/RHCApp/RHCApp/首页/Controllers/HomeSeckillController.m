//
//  HomeSeckillController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/7/19.
//

#import "HomeSeckillController.h"
#import "HomeSeckillControllerCell.h"
#import "ProductDetailViewController.h"
#import "RequestManager.h"
//#import "SDCycleScrollView.h"
//#import "HomBannerModel.h"
//#import "HomeSeckillModel.h"
//#import "HomeGroupModel.h"
//#import "GoodController.h"

static NSString *kHomeSeckillControllerCell = @"HomeSeckillController";

@interface HomeSeckillController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *bannerImageView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）

@end

@implementation HomeSeckillController

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//    [self.navigationController setNavigationBarHidden:!isShowHomePage animated:YES];
//}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)rightBarButtonItemAction{
    [[RequestManager sharedInstance] connectWithServer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"限时秒杀";
    UIBarButtonItem *message = [UIBarButtonItem itemWithimage:IMAGECACHE(@"home_02") highImage:IMAGECACHE(@"home_02") target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = message;

    WeakObj(self)
    self.bannerImageView = [UIImageView new];
    self.bannerImageView.image = IMAGECACHE(@"home_20");
    self.bannerImageView.frame = CGRectMake(0, 0, 0, YXDScreenW/2.4);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[HomeSeckillControllerCell class] forCellReuseIdentifier:kHomeSeckillControllerCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 190;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.bannerImageView;
    self.tableView.backgroundColor = SMViewBGColor;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [Weakself.tableView.mj_footer resetNoMoreData];
        [Weakself loadNewsData];
    }];
    
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
        [Weakself loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
//        make.top.equalTo(self.bannerImageView.mas_bottom).offset = 0;
        make.top.offset = 64 + SafeTopSpace;
    }];
    
    //1.请求数据
    [self loadNewsData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeSeckillControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeSeckillControllerCell];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductModel *model = self.dataArray[indexPath.row];
//    GoodController *goodController = [GoodController new];
//    goodController.goodsId = model.goodsId;
//    goodController.shopId = model.shopId;
//    [self.navigationController pushViewController:goodController animated:YES];
    ProductDetailViewController *vc = [ProductDetailViewController new];
    vc.pid = model.pid;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark-请求数据
- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ActivityList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [ProductModel mj_objectArrayWithKeyValuesArray:json[@"productList"]];
            [Weakself.dataArray addObjectsFromArray:array];
            [Weakself.tableView reloadData];
            if (Weakself.dataArray.count == 0) {
                [Weakself showEmptyMessage:@"暂无秒杀信息"];
            }else{
                [Weakself hideEmptyView];
            }
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
    [[NetWorkManager shareManager] POST:USER_ActivityList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [ProductModel mj_objectArrayWithKeyValuesArray:json[@"productList"]];
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
