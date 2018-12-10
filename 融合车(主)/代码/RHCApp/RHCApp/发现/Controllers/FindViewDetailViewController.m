//
//  FindViewDetailViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/16.
//

#import "FindViewDetailViewController.h"
#import "FindViewDetailViewCell.h"
#import "FindViewDetailViewBigCell.h"
#import "FindViewDetailViewNoneCell.h"
#import "FindHeadView.h"
#import "FindViewListModel.h"
#import "FindDetailContentController.h"

static NSString *kFindViewDetailViewNoneCell = @"FindViewDetailViewNoneCell";
static NSString *kFindViewDetailViewCell = @"FindViewDetailViewCell";
static NSString *kFindViewDetailViewBigCell = @"FindViewDetailViewBigCell";

@interface FindViewDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) FindHeadView *headView;

@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,  copy) NSString *parameter;//页面参数
@end

@implementation FindViewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    //1.设置tableView
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
    [self loadNewsData];
}
- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.offset = 0;
        make.bottom.offset = -49;
    }];
}

- (FindHeadView *)headView{
    if(!_headView){
        _headView = [FindHeadView new];
        CGFloat height = 0;
        height = YXDScreenW/2.65;
        _headView.frame = CGRectMake(0, 0, 0, height);
    }
    return _headView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150;
        _tableView.tableHeaderView = self.headView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FindViewDetailViewNoneCell class] forCellReuseIdentifier:kFindViewDetailViewNoneCell];
        [_tableView registerClass:[FindViewDetailViewCell class] forCellReuseIdentifier:kFindViewDetailViewCell];
        [_tableView registerClass:[FindViewDetailViewBigCell class] forCellReuseIdentifier:kFindViewDetailViewBigCell];
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
    FindViewListModel *model = self.dataArray[indexPath.row];
    FindDetailContentController *vc = [FindDetailContentController new];
    vc.fid = model.fid;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    if ([self.parameter integerValue]) {
        parames[@"showType"] = self.parameter;
    }
    NSLog(@"%@",parames);
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_InformationList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [FindViewListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:array];
//            [Weakself.dataArray addObject:array.firstObject];
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
    if ([self.parameter integerValue]) {
        parames[@"showType"] = self.parameter;
    }
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_InformationList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [FindViewListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            if (array.count == 0) {//没有数据、
                [Weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [Weakself.dataArray addObjectsFromArray:array];
//                [Weakself.dataArray addObject:array.firstObject];
                [Weakself.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [Weakself.tableView.mj_footer endRefreshing];
    }];
}
@end
