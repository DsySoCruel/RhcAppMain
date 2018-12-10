//
//  MyCollectionViewDetailController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/22.
//

#import "MyCollectionViewDetailController.h"
#import "CollectCarListCell.h"//汽车
#import "CollectArticalListCell.h"//资讯
#import "CollectProductListCell.h"//配件
#import "MyCollectListModel.h"
#import "RequestManager.h"

#import "ProductDetailViewController.h"
#import "FindDetailContentController.h"
#import "AccessoriesStoreDetailController.h"

static NSString *kCollectCarListCell = @"CollectCarListCell";
static NSString *kCollectArticalListCell = @"CollectArticalListCell";
static NSString *kCollectProductListCell = @"CollectProductListCell";


@interface MyCollectionViewDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MyCollectionViewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    //1.设置tableView
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
//    [self adjustInsetWithScrollView:self.tableView];
    [self loadNewsData];

}
- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.offset = 0;
        make.bottom.offset = 0;
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CollectCarListCell class] forCellReuseIdentifier:kCollectCarListCell];
        [_tableView registerClass:[CollectArticalListCell class] forCellReuseIdentifier:kCollectArticalListCell];
        [_tableView registerClass:[CollectProductListCell class] forCellReuseIdentifier:kCollectProductListCell];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消收藏";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //执行删除操作
        MyCollectListModel *model = self.dataArray[indexPath.row];
        [RequestManager collectWithId:model.cid andWith:self.type collectResultBlock:^{
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"app_product"]) {
        CollectCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectCarListCell];
        cell.model = self.dataArray[indexPath.row];
        return cell;

    }else if ([self.type isEqualToString:@"app_information"]){
        CollectArticalListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectArticalListCell];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    CollectProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectProductListCell];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectListModel *model = self.dataArray[indexPath.row];
    if ([self.type isEqualToString:@"app_product"]) {
        ProductDetailViewController *vc = [ProductDetailViewController new];
        vc.pid = model.cid;
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([self.type isEqualToString:@"app_information"]){
        FindDetailContentController *vc = [FindDetailContentController new];
        vc.fid = model.cid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AccessoriesStoreDetailController *vc = [AccessoriesStoreDetailController new];
        vc.pid = model.cid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    parames[@"fromTable"] = self.type;
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;

    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_CollectionList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [MyCollectListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:array];
            [Weakself.tableView reloadData];
            if (!self.dataArray.count) {
                [self showEmptyMessage:@"暂无收藏数据"];
            }else{
                [self hideEmptyView];
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
    parames[@"fromTable"] = self.type;
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_CollectionList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [MyCollectListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
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
