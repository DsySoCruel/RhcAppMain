//
//  AccessoriesStoreDetailController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/3.
//

#import "AccessoriesStoreDetailController.h"
#import "AccessoriesStoreDetailModel.h"
#import "AccessoriesStoreHeaderView.h"
#import "ProductDetailViewBottomTool.h"
#import "RequestManager.h"
#import "BuySelectMenuView.h"
#import "OrderMakeViewController.h"
#import "ShopCarListModel.h"

@interface AccessoriesStoreDetailController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIWebView   *mainWebView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isNeedScroll;//评论完成后刷新界面加载数据时完成后滚动的第一个位置
@property (nonatomic,strong) AccessoriesStoreDetailModel *accessorDetailModel;//详细数据
@property (nonatomic,strong) AccessoriesStoreHeaderView *headView;
@property (nonatomic,strong) ProductDetailViewBottomTool *bottomTool;

////蒙板上的控件
//@property (nonatomic , strong) UIView *backgroundForParameterView;//透明蒙板
//@property (nonatomic , strong) UIView *selectParameterView;//选择参数View
//@property (nonatomic , strong) UIView *presentParameterView;//展示参数View
//@property (nonatomic , strong) NSString *ConfirmName;
//@property (nonatomic , strong) UIImageView *goodImageView;
//@property (nonatomic , strong) UILabel *goodsPriceLabel;
//@property (nonatomic , strong) UIImageView *zhaoshaDiscount;
//@property (nonatomic , strong) UILabel *availableNumLa;
//@property (nonatomic , strong) UILabel *selectStateLabel;

@end

@implementation AccessoriesStoreDetailController

- (AccessoriesStoreHeaderView *)headView{
    if(!_headView){
        _headView = [AccessoriesStoreHeaderView new];
        CGFloat height = 0;
        height = YXDScreenW/1.84 + 110;
        _headView.frame = CGRectMake(0, 0, 0, height);
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self loadData];
}
- (void)loadData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"id"] = self.pid;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_AccessoriesDetail parameters:parames successed:^(id json) {
        if (json) {
            Weakself.accessorDetailModel = [AccessoriesStoreDetailModel mj_objectWithKeyValues:json[@"accessories"]];
            Weakself.accessorDetailModel.selectNum = 1;
            
            [Weakself.mainWebView loadHTMLString:Weakself.accessorDetailModel.detail baseURL:nil];
            
            //设置右边功能按钮
            UIBarButtonItem *share = [UIBarButtonItem itemWithimage:IMAGECACHE(@"chequan_9") highImage:IMAGECACHE(@"chequan_9") target:Weakself action:@selector(rightBarButtonItemAction)];
            //            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [btn setImage:IMAGECACHE(@"soucang_02") forState:UIControlStateNormal];
            //            [btn setImage:IMAGECACHE(@"soucang_01") forState:UIControlStateSelected];
            //            [btn sizeToFit];
            //            [btn addTarget:Weakself action:@selector(rightBarButtonLikeAction:) forControlEvents:UIControlEventTouchUpInside];
            //            btn.selected = Weakself.carDetailModel.collectionId.length;
            //待添加详情的收藏状态
            //            UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
            //            [containView addSubview:btn];
            //            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:containView];
            Weakself.navigationItem.rightBarButtonItem = share;
            [Weakself.tableView reloadData];
            Weakself.bottomTool.accModel = Weakself.accessorDetailModel;
            Weakself.headView.accModel = Weakself.accessorDetailModel;
            Weakself.tableView.tableHeaderView = Weakself.headView;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupUI{
    self.dataArray = [NSMutableArray array];
    //1.设置tableView
    [self.view addSubview:self.tableView];
    //    [self adjustInsetWithScrollView:self.tableView];
    //    [self loadNewsData];
    self.bottomTool = [[ProductDetailViewBottomTool alloc] initWithType:ProductDetailViewBottomToolTypeAccessoriesStore];
    WeakObj(self);
    self.bottomTool.firstButtonBlock = ^{
        //弹出选择参数面板
        BuySelectMenuView *addMessage = [[BuySelectMenuView alloc] initWithDataSource:Weakself.accessorDetailModel withType:BuySelectMenuViewTypeAdd];
        [addMessage showInView:Weakself.navigationController];
    };
    
    self.bottomTool.secondButtonBlock = ^{
        //直接购买了
        BuySelectMenuView *addMessage = [[BuySelectMenuView alloc] initWithDataSource:Weakself.accessorDetailModel withType:BuySelectMenuViewTypeAdd];
        [addMessage showInView:Weakself.navigationController];
    };
    [self.view addSubview:self.bottomTool];
}
//分享
- (void)rightBarButtonItemAction{
    
}

- (void)setupLayout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.top.offset = SafeTopSpace;
        make.bottom.mas_equalTo(- (40+SafeBottomSpace*0.5));
    }];
    [self.bottomTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.offset = 0;
        make.height.offset = 40;
        //        make.bottom.offset = - SafeBottomSpace * 0.5;
    }];
    
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        [_tableView registerClass:[ProductDetailParamesCell class] forCellReuseIdentifier:kProductDetailParamesCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        //        _tableView.estimatedRowHeight = 150;
        _tableView.tableFooterView = self.mainWebView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 55)];
    headerView.backgroundColor = [UIColor whiteColor];
    YXDButton *a = [[YXDButton alloc] initWithAlignmentStatus:MoreStyleStatusLeft];
    [a addTarget:self action:@selector(aButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [a setTitle:@"选择款式" forState:UIControlStateNormal];
    [a setTitleColor:SMTextColor forState:UIControlStateNormal];
    a.titleLabel.textAlignment = NSTextAlignmentLeft;
    a.titleLabel.font = LPFFONT(14);
    [headerView addSubview:a];
    [a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.offset = 0;
        make.bottom.offset = -10;
        make.right.offset = -10;
    }];
    UIImageView *jiantou = [UIImageView new];
    jiantou.image = IMAGECACHE(@"shangpinxiangqing_01");
    [headerView addSubview:jiantou];
    [jiantou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.centerY.equalTo(a);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = SMViewBGColor;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset = 0;
        make.height.offset = 10;
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *a = [UILabel new];
    a.text = @"--商品详情--";
    a.textColor = SMParatextColor;
    a.font = LPFFONT(12);
    a.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:a];
    [a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset = 0;
    }];
    return headerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}


#pragma mark - 设置网页内容
- (UIWebView *)mainWebView{
    if (!_mainWebView) {
        _mainWebView = [[UIWebView alloc] init ];
        _mainWebView.backgroundColor = [UIColor whiteColor];
        _mainWebView.delegate = self;
        [(UIScrollView *)[[_mainWebView subviews] objectAtIndex:0] setScrollEnabled:NO];
        //监听内容高度改变的通知，用于图片没有加载出来的时候高度不准确
        //        [_mainWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _mainWebView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat webViewHeight = [[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        NSLog(@"------%f",webViewHeight);
        CGRect newFrame       = self.mainWebView.frame;
        newFrame.size.height  = webViewHeight;
        self.mainWebView.frame = newFrame;
        [self.tableView setTableFooterView:self.mainWebView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    CGFloat webViewHeight = [[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    NSLog(@"------+++++++%f",webViewHeight);
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight + 50;
    webView.frame = newFrame;
    [self.tableView setTableFooterView:webView];
    [MBHUDHelper hideHUDView];
}


#pragma mark -- 设置选择参数蒙版

//- (void)animationDidStart{
//    [self.view addSubview:self.backgroundForParameterView];
//    [self.view addSubview:self.selectParameterView];

//    [UIView animateWithDuration:0.5 animations:^{
//        //动画执行结果
//        //1.蒙板渐渐显灰色
//        self.backgroundForParameterView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        //2.参数视图渐渐上来
//        self.selectParameterView.frame = CGRectMake(0, kScreenHeight * 0.27 -10, kScreenWidth, kScreenHeight * 0.73 + 10);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.selectParameterView.frame = CGRectMake(0, kScreenHeight * 0.27, kScreenWidth, kScreenHeight * 0.73 + 10);
//        }];
//    }];
//}
- (void)aButtonAction{
    //直接购买
    BuySelectMenuView *addMessage = [[BuySelectMenuView alloc] initWithDataSource:self.accessorDetailModel withType:BuySelectMenuViewTypeAdd];
    [addMessage showInView:self.navigationController];
}
@end
