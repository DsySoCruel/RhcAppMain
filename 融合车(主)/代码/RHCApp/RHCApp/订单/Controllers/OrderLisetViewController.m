//
//  OrderLisetViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/21.
//

#import "OrderLisetViewController.h"
#import "OrderLisetViewCell.h"
#import "OrderLisetModel.h"
#import "OrderDetailController.h"

static NSString *kOrderLisetViewCell = @"OrderLisetViewCell";

@interface OrderLisetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,  copy) NSString *parameter;//页面参数

@end

@implementation OrderLisetViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    //注册通知 用于订单支付成功后回来的刷新
    //注册支付宝回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payPaySucceed:) name:@"payPaySucceed" object:nil];
}

- (void)payPaySucceed:(NSNotification *)notification{
    for (OrderLisetModel *model in self.dataArray) {
        if ([model.oid isEqualToString:notification.object]) {
//            model.order_status = @"";???????
            [self.tableView reloadData];
            break;
        }
    }
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
        _tableView.estimatedRowHeight = 200;
        _tableView.backgroundColor = SMViewBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[OrderLisetViewCell class] forCellReuseIdentifier:kOrderLisetViewCell];
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
    OrderLisetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderLisetViewCell];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailController *vc = [OrderDetailController new];
    OrderLisetModel *model = self.dataArray[indexPath.row];
    vc.orderId = model.oid;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    parames[@"claz"] = self.parameter;
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductOrderList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [OrderLisetModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            if (!array.count) {
                [self showEmptyMessage:@"暂无订单"];
            }else{
                [self hideEmptyView];
            }
            [Weakself.dataArray addObjectsFromArray:array];
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
    parames[@"claz"] = self.parameter;
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;

    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductOrderList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [OrderLisetModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
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
