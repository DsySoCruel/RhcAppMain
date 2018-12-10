//
//  UserHomepageController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "UserHomepageController.h"
#import "UserVCNaviView.h"
#import "CircleVClistCell.h"
#import "CircleDetailViewController.h"

static NSString *kCircleVClistCell = @"CircleVClistCell";

@interface UserHomepageController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic,strong) UserVCNaviView *myNaviView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *userInfoView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）

@end

@implementation UserHomepageController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    [self setupLayout];
    
}

- (void)setupData{
    self.type = @"1";
    self.dataArray = [NSMutableArray array];
}

#pragma mark UI
-(void)setupUI{
    CGFloat height = 169.0 + SafeTopSpace + 50;
    self.userInfoView = [UIView new];
    self.userInfoView.backgroundColor = [UIColor whiteColor];
    self.userInfoView.frame = CGRectMake(0, 0, Screen_W, height);
    self.myNaviView.headerHeight = height;
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.backgroundColor = [UIColor grayColor];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 35;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.headImage] placeholderImage:IMAGECACHE(@"zhan_head")];
    [self.userInfoView addSubview:self.iconImageView];
    
    self.name = [UILabel new];
    self.name.text = self.namestr;
    self.name.font = SFONT(17);
    self.name.numberOfLines = 3;
    self.name.textColor = SMTextColor;
    self.name.textAlignment = NSTextAlignmentCenter;
    [self.userInfoView addSubview:self.name];
    
    NSArray *array = [NSArray arrayWithObjects:@"最新",@"热门", nil];

    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    //设置frame
    segment.selectedSegmentIndex = 0;
    segment.tintColor = SMTextColor;
    UIColor *segmentColor = UIColorFromRGB(0x90959E);
    
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObjectsAndKeys:segmentColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName,nil];
    [segment setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    segment.layer.cornerRadius = 12.5;
    segment.layer.masksToBounds = YES;
    segment.layer.borderColor = [UIColor whiteColor].CGColor;
    segment.layer.borderWidth = 1;
    
    [segment addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
    //添加到视图
    [self.userInfoView addSubview:segment];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.width.height.offset = 70;
        make.top.offset = 70;
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.iconImageView.mas_bottom).offset = 5;
        make.left.offset = 15;;
        make.right.offset = -15;
    }];
    
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.bottom.offset = -15;
        make.width.offset = 100;
        make.height.offset = 25;
    }];
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SMViewBGColor;
    [self.tableView registerClass:[CircleVClistCell class] forCellReuseIdentifier:kCircleVClistCell];
    self.tableView.tableHeaderView = self.userInfoView;
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self loadNewsData];
    }];
    
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];
    self.myNaviView = [[UserVCNaviView alloc] init];
    self.myNaviView.titleStr = self.namestr;
    [self adjustInsetWithScrollView:self.tableView];
    [self loadNewsData];
}

-(void)setupLayout{
    [self.view addSubview:self.myNaviView];
    [self.myNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(NAVI_H);
        make.width.mas_equalTo(Screen_W);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
}

//再次更改高度
//-(void)setHeader{
//
//    CGFloat height = 0;
//    if ([TouristManager isTouristMode]) {
//        height = 169.0 - 15;
//    }
//    else{
//        height = (self.itemInfo.percent.integerValue == 100) ? 169.0 -15 : 199.0 -15;
//    }
//    height += SafeTopSpace;
//    self.userInfoView.frame = CGRectMake(0, 0, Screen_W, height);
//    [self.userInfoView setCellWithUserModel:self.itemInfo];
//    self.myNaviView.headerHeight = height;
//    self.tableView.tableHeaderView = self.userInfoView;
//}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
//        [self.userInfoView adustHeaderView:offsetY];
    }
    [self.myNaviView changeAlphaWithOffset:scrollView.contentOffset.y];
}

#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleVClistCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleVClistCell forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];

    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 10;
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = SMViewBGColor;
    return view;
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
    //    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"id"] = self.uid;
    parames[@"pageSize"] = @"10";
    parames[@"ordertype"] = self.type;
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_Mylist parameters:parames successed:^(id json) {
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
    //    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"id"] = self.uid;
    parames[@"pageSize"] = @"10";
    parames[@"ordertype"] = self.type;
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_Mylist parameters:parames successed:^(id json) {
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

-(void)segmentSelect:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;

    NSLog(@"%tu",index);
    if (index == 1) {
        self.type = @"2";
    }else{
        self.type = @"1";
    }
    [self loadNewsData];
}

@end
