//
//  FindDetailContentController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/19.
//

#import "FindDetailContentController.h"
#import "FindDetailModel.h"
#import "CircleDetailViewCommentCell.h"
#import "CircleCommendModel.h"
//#import "RelyBottomView.h"
#import "RequestManager.h"
#import "FindViewListModel.h"
#import "FindViewDetailViewCell.h"
#import "FindViewDetailViewBigCell.h"
#import "FindViewDetailViewNoneCell.h"
#import "FindDetailContentFirstCell.h"

static NSString *kCircleDetailViewCommentCell = @"CircleDetailViewCommentCell";

static NSString *kFindViewDetailViewNoneCell = @"FindViewDetailViewNoneCell";
static NSString *kFindViewDetailViewCell = @"FindViewDetailViewCell";
static NSString *kFindViewDetailViewBigCell = @"FindViewDetailViewBigCell";

static NSString *kFindDetailContentFirstCell = @"FindDetailContentFirstCell";

@interface FindDetailContentController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIWebView *mainWebView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isNeedScroll;//评论完成后刷新界面加载数据时完成后滚动的第一个位置
@property (nonatomic,strong) FindDetailModel *articleModel;
//@property (nonatomic,strong) RelyBottomView *bottomToolView;


@end

@implementation FindDetailContentController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //最后还设置回来,不要影响其他页面的效果
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self loadData];
}

- (void)loadData{
    [MBHUDHelper showLoadingHUDView:self.view];

    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"id"] = self.fid;
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    }
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_InformationDetail parameters:parames successed:^(id json) {
        if (json) {
            Weakself.articleModel = [FindDetailModel mj_objectWithKeyValues:json[@"information"]];
            NSArray *array = [FindViewListModel mj_objectArrayWithKeyValuesArray:json[@"informationList"]];
            [Weakself.dataArray addObjectsFromArray:array];
            [Weakself.tableView reloadData];
            
            NSString *cssHtml = [NSString stringWithFormat:@"<link href=\"%@\" rel=\"stylesheet\">",[[NSBundle mainBundle] URLForResource:@"Article" withExtension:@"css"]];
            
            // 创建标题的HTML标签
            NSString *titleHtml = [NSString stringWithFormat:@"<div id=\"mainTitle\">%@</div>",Weakself.articleModel.title];
            
            // 创建子标题的HTML标签
            NSString *subTitleHtml = [NSString stringWithFormat:@"<div id=\"subTitle\"><span class=\"time\">%@</span><span>%@</span></div>",[Weakself.articleModel.create_time timeTypeFromNow],Weakself.articleModel.praise_number];
            // 拼接HTML
            NSString *html = [NSString stringWithFormat:@"<html><head>%@</head><body>%@%@%@</body></html>",cssHtml,titleHtml,subTitleHtml,Weakself.articleModel.content];
            
            [Weakself.mainWebView loadHTMLString:html baseURL:nil];
            
            //设置收藏状态
            //设置右边功能按钮
            UIBarButtonItem *share = [UIBarButtonItem itemWithimage:IMAGECACHE(@"chequan_9") highImage:IMAGECACHE(@"chequan_9") target:Weakself action:@selector(rightBarButtonItemAction)];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:IMAGECACHE(@"soucang_02") forState:UIControlStateNormal];
            [btn setImage:IMAGECACHE(@"soucang_01") forState:UIControlStateSelected];
            [btn sizeToFit];
            [btn addTarget:Weakself action:@selector(rightBarButtonLikeAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.selected = Weakself.articleModel.collectionId.length;
            UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
            [containView addSubview:btn];
             UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:containView];
            Weakself.navigationItem.rightBarButtonItems = @[share,buttonItem];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupUI{
    self.dataArray = [NSMutableArray array];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //1.设置tableView
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
//    [self loadNewsData];
//
//    self.bottomToolView = [[RelyBottomView alloc] initDetailBottomView];
//    self.bottomToolView.requsetType = CommentRequestTypeCircle;
//    self.bottomToolView.mainId = self.fid;
//    WeakObj(self);
//    self.bottomToolView.requestCompletionBlock = ^{
//        [Weakself loadNewsData];
//    };
//    [self.view addSubview:self.bottomToolView];
}
//分享
- (void)rightBarButtonItemAction{
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    [[RequestManager sharedInstance] shareActionwith:shareObject];
}
//收藏
- (void)rightBarButtonLikeAction:(UIButton *)sender{
    [RequestManager collectWithId:self.articleModel.fid andWith:CollectTypeArticle button:sender];
}
- (void)setupLayout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.top.offset = SafeTopSpace;
        make.bottom.mas_equalTo(- (SafeBottomSpace*0.5));
    }];
//    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.offset = 0;
//        make.bottom.offset = - SafeBottomSpace * 0.5;
//    }];

}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[CircleDetailViewCommentCell class] forCellReuseIdentifier:kCircleDetailViewCommentCell];
        
        [_tableView registerClass:[FindViewDetailViewNoneCell class] forCellReuseIdentifier:kFindViewDetailViewNoneCell];
        [_tableView registerClass:[FindViewDetailViewCell class] forCellReuseIdentifier:kFindViewDetailViewCell];
        [_tableView registerClass:[FindViewDetailViewBigCell class] forCellReuseIdentifier:kFindViewDetailViewBigCell];
        
        [_tableView registerClass:[FindDetailContentFirstCell class] forCellReuseIdentifier:kFindDetailContentFirstCell];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150;
        _tableView.tableHeaderView = self.mainWebView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //        header.lastUpdatedTimeLabel.hidden = YES;
        //        header.stateLabel.font = LPFFONT(13);
        //        header.ignoredScrollViewContentInsetTop = NAVI_H;
        //        _tableView.mj_header = header;
//        _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//            [self.tableView.mj_footer resetNoMoreData];
//            [self loadNewsData];
//        }];
//        RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
//            [self loadMoreData];
//        }];
//        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        FindDetailContentFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:kFindDetailContentFirstCell];
        cell.model = self.articleModel;
        return cell;
    }
    //根据图片大多少 判断大图 小图 无图的 情况
    FindViewListModel *model = self.dataArray[indexPath.row - 1];
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
    if (indexPath.row > 0) {
        FindViewListModel *model = self.dataArray[indexPath.row - 1];
        FindDetailContentController *vc = [FindDetailContentController new];
        vc.fid = model.fid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 设置网页内容
- (UIWebView *)mainWebView{
    if (!_mainWebView) {
        _mainWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _mainWebView.backgroundColor = [UIColor whiteColor];
        _mainWebView.delegate = self;
        [(UIScrollView *)[[_mainWebView subviews] objectAtIndex:0] setScrollEnabled:NO];
        //监听内容高度改变的通知，用于图片没有加载出来的时候高度不准确
        [_mainWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _mainWebView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGFloat webViewHeight = [[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        CGFloat webViewHeight = [self.mainWebView sizeThatFits:CGSizeZero].height;
        CGRect newFrame       = self.mainWebView.frame;
        newFrame.size.height  = webViewHeight;
        self.mainWebView.frame = newFrame;
        [self.tableView setTableHeaderView:self.mainWebView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGFloat webViewHeight = [webView.scrollView contentSize].height;
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = webViewHeight;
//    webView.frame = newFrame;
//    [self.tableView setTableHeaderView:webView];
    [MBHUDHelper hideHUDView];
}


@end
