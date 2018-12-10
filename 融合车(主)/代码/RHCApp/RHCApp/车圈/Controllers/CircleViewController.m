//
//  CircleViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/20.
//

#import "CircleViewController.h"
#import "CircleViewControllerHeaderView.h"
#import "CircleViewControllerListModel.h"
#import "CircleVClistCell.h"
#import "CircleDetailViewController.h"
#import "PostViewController.h"

static NSString *kCircleVClistCell = @"CircleVClistCell";

@interface CircleViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) CircleViewControllerHeaderView *headerView;
//加载更多
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *postButton;
@end

@implementation CircleViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self.headerView updateIcon];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;//必须写
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    self.dataArray = [NSMutableArray array];
    self.headerView = [CircleViewControllerHeaderView new];
    self.headerView.frame = CGRectMake(0, 0, 0, 245);
    WeakObj(self);
    self.headerView.updateOrderBlock = ^{//发布成功
        [Weakself loadNewsData];
    };
//    [self.view addSubview:self.headerView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[CircleVClistCell class] forCellReuseIdentifier:kCircleVClistCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 190;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = SMViewBGColor;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self loadNewsData];
    }];
    
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
    [self loadNewsData];
    
    self.postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.postButton.backgroundColor = SMThemeColor;
    [self.postButton setImage:IMAGECACHE(@"chequan_4") forState:UIControlStateNormal];
    self.postButton.layer.cornerRadius = 25;
    self.postButton.layer.masksToBounds = YES;
    [self.postButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.postButton];
}

- (void)postButtonAction{
    PostViewController *vc = [PostViewController new];
    vc.updateOrderBlock = ^{
        [self loadNewsData];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)setupLayout{
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.top.offset = 0;
//        make.height.offset = 245;
//    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.bottom.offset = - 49;
        make.top.offset = 20;
    }];
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 50;
        make.centerY.offset = 0;
        make.right.offset = -15;
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *icon = [UIImageView new];
    icon.image = IMAGECACHE(@"chequan_3");
    [headerView addSubview:icon];
    UILabel *label = [UILabel new];
    label.text = @"车圈精选";
    label.textColor = SMTextColor;
    label.font = LPFFONT(14);
    [headerView addSubview:label];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:menuButton];
    [menuButton setImage:IMAGECACHE(@"chequan_2") forState:UIControlStateNormal];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 15;
        make.width.height.offset = 25;
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.equalTo(icon.mas_right).offset = 10;
    }];
    [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.offset = -15;
    }];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleVClistCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleVClistCell];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleDetailViewController *vc = [CircleDetailViewController new];
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadNewsData{
    
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_PostList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [CircleViewControllerListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:array];
            [Weakself.tableView reloadData];
//            if (Weakself.dataArray.count == 0) {
//                [Weakself showEmptyMessage:@"暂无团购信息"];
//            }else{
//                [Weakself hideEmptyView];
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
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_PostList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [CircleViewControllerListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
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
