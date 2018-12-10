//
//  ServiceStationViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/28.
//

#import "ServiceStationViewController.h"
#import "ServiceStationViewCell.h"
#import "ServiceStationViewCellModel.h"

static NSString *kServiceStationViewCell = @"ServiceStationViewCell";

@interface ServiceStationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）

@end

@implementation ServiceStationViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务网点";
    self.view.backgroundColor = SMViewBGColor;
    [self setupUI];
    [self setupLayout];
}
#pragma mark UI
-(void)setupUI{
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SMViewBGColor;
    [self.tableView registerClass:[ServiceStationViewCell class] forCellReuseIdentifier:kServiceStationViewCell];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self loadNewsData];
    }];
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];
    [self loadNewsData];
    [self adjustInsetWithScrollView:self.tableView];

}

-(void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.top.offset = 64 + SafeTopSpace;
    }];
}
#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceStationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceStationViewCell forIndexPath:indexPath];
    [cell configModel:self.dataArray[indexPath.section] with:indexPath];
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceStationViewCellModel *model = self.dataArray[indexPath.section];
    if (self.selectCarShopBlock) {
        self.selectCarShopBlock(model.name, model.sid);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 320;
}


- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
//    parames[@"areaId2"] = model.areaId2;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
//    parames[@"lon"] = @"116.342459";
//    parames[@"lat"] = @"40.049781";
//    parames[@"addressId"] = @"1";
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ScreentoneList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [ServiceStationViewCellModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:array];
  
            [Weakself.tableView reloadData];
            if (Weakself.dataArray.count == 0) {
                [Weakself showEmptyMessage:@"暂无服务网点"];
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
//    parames[@"areaId2"] = model.areaId2;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ScreentoneList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [ServiceStationViewCellModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
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
