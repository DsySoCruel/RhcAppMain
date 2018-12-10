//
//  OrderListViewPeijianControllerViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/14.
//

#import "OrderListViewPeijianControllerViewController.h"
#import "OrderPeijianListCell.h"

static NSString *kOrderPeijianListCell = @"OrderPeijianListCell";

@interface OrderListViewPeijianControllerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation OrderListViewPeijianControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}



- (void)setupUI{
    //1.设置tableView
    self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = SMViewBGColor;
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
    [self loadNewsData];
}
- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.offset = 10;
        make.bottom.offset = -49;
    }];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150;
        _tableView.backgroundColor = SMViewBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[OrderPeijianListCell class] forCellReuseIdentifier:kOrderPeijianListCell];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderPeijianListCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderPeijianListCell];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_OrderList parameters:parames successed:^(id json) {
        if (json) {
//            [Weakself.dataArray removeAllObjects];
//            NSArray *array = [OrderLisetModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
//            [Weakself.dataArray addObjectsFromArray:array];
//            [Weakself.tableView reloadData];
//            if (!array.count) {
//                [self showEmptyMessage:@"暂无订单"];
//            }else{
//                [self hideEmptyView];
//            }
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
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_OrderList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
//            NSArray *array = [OrderLisetModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
//            if (array.count == 0) {//没有数据、
//                [Weakself.tableView.mj_footer endRefreshingWithNoMoreData];
//            }else{
//                [Weakself.dataArray addObjectsFromArray:array];
//                [Weakself.tableView reloadData];
//            }
        }
    } failure:^(NSError *error) {
        [Weakself.tableView.mj_footer endRefreshing];
    }];
}

@end
