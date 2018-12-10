//
//  ProductDetailViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/31.
//

#import "ProductDetailViewController.h"
#import "CarDetailModel.h"
#import "ProductDetailViewHeaderView.h"
#import "ProductDetailViewBottomTool.h"
#import "RequestManager.h"
#import "AllConfigurationController.h"
#import "ProductDetailViewHeaderView.h"
#import "ProductSchemeListModel.h"


#import "ProductDetailParamesCell.h"//产品配置cell
#import "ProductDetailWebCell.h"
#import "ProductDetailOtherParamesCell.h"//购车须知 || 三步 cell
#import "ProductCell.h"//看了还想看cell



static NSString *kProductDetailParamesCell = @"ProductDetailParamesCell";
static NSString *kProductDetailWebCell = @"ProductDetailWebCell";
static NSString *kProductDetailOtherParamesCell = @"ProductDetailOtherParamesCell";
static NSString *kProductCell = @"ProductCell";

@interface ProductDetailViewController()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIWebView   *mainWebView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isNeedScroll;//评论完成后刷新界面加载数据时完成后滚动的第一个位置
@property (nonatomic,strong) CarModel       *carModel;//大model
@property (nonatomic,strong) CarModel       *tempCarModel;//详细数据
@property (nonatomic,strong) CarDetailModel *carDetailModel;//详细数据
@property (nonatomic,strong) ProductSchemeListModel *productSchemeListModel;//分期数据
@property (nonatomic,strong) ProductSchemeListModel *tempProductSchemeListModel;//分期数据
@property (nonatomic,strong) ProductDetailViewHeaderView *headView;
@property (nonatomic,strong) ProductDetailViewBottomTool *bottomTool;
@end

@implementation ProductDetailViewController

- (ProductDetailViewHeaderView *)headView{
    if(!_headView){
        _headView = [ProductDetailViewHeaderView new];
        CGFloat height = 0;
        height = YXDScreenW/1.84 + 110 + 190 + 60;
        _headView.frame = CGRectMake(0, 0, Screen_W, height);
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
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductDetail parameters:parames successed:^(id json) {
        if (json) {
//            Weakself.carDetailModel = [CarDetailModel mj_objectWithKeyValues:json[@"product"]];
            Weakself.carModel = [CarModel mj_objectWithKeyValues:json];
            Weakself.tempCarModel = [CarModel mj_objectWithKeyValues:json];
            Weakself.carDetailModel = Weakself.carModel.product;
            [Weakself.mainWebView loadHTMLString:Weakself.carDetailModel.detail baseURL:nil];
//            [Weakself.mainWebView loadHTMLString:@"<p>福田轻卡，值得信赖！</p>" baseURL:nil];

            //设置右边功能按钮
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
            UIBarButtonItem *share = [UIBarButtonItem itemWithimage:IMAGECACHE(@"chequan_9") highImage:IMAGECACHE(@"chequan_9") target:Weakself action:@selector(rightBarButtonItemAction)];
            Weakself.navigationItem.rightBarButtonItem = share;
            [Weakself.tableView reloadData];
            Weakself.bottomTool.model = Weakself.carDetailModel;
            Weakself.headView.model = Weakself.tempCarModel.product;
            Weakself.tableView.tableHeaderView = Weakself.headView;
            [Weakself loadSchemeList];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)loadSchemeList{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"productId"] = self.pid;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_SchemeList parameters:parames successed:^(id json) {
        if (json) {
            Weakself.productSchemeListModel = [ProductSchemeListModel mj_objectWithKeyValues:json];
            Weakself.tempProductSchemeListModel = [ProductSchemeListModel mj_objectWithKeyValues:json];
            Weakself.headView.productSchemeListModel = Weakself.tempProductSchemeListModel;
            Weakself.bottomTool.schemeListModel = Weakself.productSchemeListModel;
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)setupUI{
    self.dataArray = [NSMutableArray array];
    //1.设置tableView
    [self.view addSubview:self.mainWebView];
    [self.view addSubview:self.tableView];
//    [self adjustInsetWithScrollView:self.tableView];
    //    [self loadNewsData];
    self.bottomTool = [[ProductDetailViewBottomTool alloc] initWithType:ProductDetailViewBottomToolTypeCarStore];
    [self.view addSubview:self.bottomTool];
}
//分享
- (void)rightBarButtonItemAction{
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    [[RequestManager sharedInstance] shareActionwith:shareObject];

}

- (void)setupLayout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.top.offset = SafeTopSpace;
        make.bottom.mas_equalTo(- (40+SafeBottomSpace*0.5));
    }];
    [self.bottomTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.height.offset = 40;
        make.bottom.offset = - SafeBottomSpace * 0.5;
    }];
    
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[ProductDetailParamesCell class] forCellReuseIdentifier:kProductDetailParamesCell];
        [_tableView registerClass:[ProductDetailWebCell class] forCellReuseIdentifier:kProductDetailWebCell];
        [_tableView registerClass:[ProductDetailOtherParamesCell class] forCellReuseIdentifier:kProductDetailOtherParamesCell];
        [_tableView registerClass:[ProductCell class] forCellReuseIdentifier:kProductCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        //产品配置
        if (self.carDetailModel.configList.count > 6) {
            return 6;
        }
        return self.carDetailModel.configList.count;
    }else if (section == 1){
        //外观配饰
        return 1;
    }else if (section == 2){
        //购买须知
        return self.carModel.purchaseNotes.count;
    }else if (section == 3){
        //购车仅需三步
        return self.carModel.purchaseThree.count;
    }else{
        //看了这辆车的人还看了
        return self.carModel.lookproduct.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *a = [UILabel new];
    if (section == 0) {
        a.text = @"--产品配置--";
    }
    if (section == 1) {
        a.text = @"--外观配饰--";
    }
    if (section == 2) {
        a.text = @"--购买须知--";
    }
    if (section == 3) {
        a.text = @"--购车仅需三步--";
    }
    if (section == 4) {
        a.text = @"--看了这辆车的人还看了--";
    }
    a.textColor = SMParatextColor;
    a.font = LPFFONT(12);
    a.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:a];
    [a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset = 0;
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (self.carDetailModel.configList.count > 6 ) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
            headerView.backgroundColor = [UIColor whiteColor];
            UIButton *a = [UIButton buttonWithType:UIButtonTypeCustom];
            [a addTarget:self action:@selector(aButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [a setTitle:@"查看全部配置" forState:UIControlStateNormal];
            [a setTitleColor:SMThemeColor forState:UIControlStateNormal];
            a.titleLabel.font = LPFFONT(12);
            a.layer.cornerRadius = 15;
            a.layer.borderWidth = 0.5;
            a.layer.borderColor = SMThemeColor.CGColor;
            [headerView addSubview:a];
            [a mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset = 10;
                make.top.offset = 10;
                make.bottom.offset = 0;
                make.right.offset = -10;
            }];
            return headerView;
        }
    }
    UIView *lineView = [UIView new];
    lineView.backgroundColor = SMViewBGColor;
    lineView.frame = CGRectMake(0, 0, 0, 15);
    return lineView;
}

- (void)aButtonAction:(UIButton *)sender{
    AllConfigurationController *vc = [AllConfigurationController new];
    vc.paramesArray = self.carDetailModel.configList;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return self.carDetailModel.configList.count > 6 ? 40 : 15;
    }
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ProductDetailParamesCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductDetailParamesCell];
        cell.model = self.carDetailModel.configList[indexPath.row];
        return cell;
    }else if (indexPath.section == 1){
        ProductDetailWebCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductDetailWebCell];
        if (self.carModel) {
            [cell loadHeml:self.carDetailModel.detail];
        }
        return cell;
    }else if (indexPath.section == 2){
        ProductDetailOtherParamesCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductDetailOtherParamesCell];
        cell.noteModel = self.carModel.purchaseNotes[indexPath.row];
        return cell;
    }else if (indexPath.section == 3){
        ProductDetailOtherParamesCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductDetailOtherParamesCell];
        cell.threeModel = self.carModel.purchaseThree[indexPath.row];
        return cell;
    }else{
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCell];
        cell.model = self.carModel.lookproduct[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:kProductDetailParamesCell cacheByIndexPath:indexPath configuration:^(ProductDetailParamesCell *cell) {
            cell.model = self.carDetailModel.configList[indexPath.row];
        }];
    }else if (indexPath.section == 1){
        return self.mainWebView.frame.size.height;
    }else if (indexPath.section == 2){
        return [tableView fd_heightForCellWithIdentifier:kProductDetailOtherParamesCell cacheByIndexPath:indexPath configuration:^(ProductDetailOtherParamesCell *cell) {
            cell.noteModel = self.carModel.purchaseNotes[indexPath.row];
        }];
    }else if (indexPath.section == 3){
        return [tableView fd_heightForCellWithIdentifier:kProductDetailOtherParamesCell cacheByIndexPath:indexPath configuration:^(ProductDetailOtherParamesCell *cell) {
            cell.threeModel = self.carModel.purchaseThree[indexPath.row];
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:kProductCell cacheByIndexPath:indexPath configuration:^(ProductCell *cell) {
            cell.model = self.carModel.lookproduct[indexPath.row];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        ProductModel *model = self.carModel.lookproduct[indexPath.row];
        ProductDetailViewController *vc = [ProductDetailViewController new];
        vc.pid = model.pid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 设置网页内容
- (UIWebView *)mainWebView{
    if (!_mainWebView) {
        _mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
        _mainWebView.backgroundColor = [UIColor whiteColor];
        _mainWebView.delegate = self;
//        [(UIScrollView *)[[_mainWebView subviews] objectAtIndex:0] setScrollEnabled:NO];
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
        NSLog(@"------%f",webViewHeight);
        CGRect newFrame       = self.mainWebView.frame;
        newFrame.size.height  = webViewHeight;
        self.mainWebView.frame = newFrame;
        [self.tableView reloadData];
//        [self.tableView setTableFooterView:self.mainWebView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    CGFloat webViewHeight = [[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    NSLog(@"------+++++++%f",webViewHeight);
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
//    [self.tableView setTableFooterView:webView];
//    [self.tableView reloadData];
    [MBHUDHelper hideHUDView];
}
@end
