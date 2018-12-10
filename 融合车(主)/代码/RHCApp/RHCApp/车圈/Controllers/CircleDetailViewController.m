//
//  CircleDetailViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "CircleDetailViewController.h"
#import "CircleDetailViewTopCell.h"
#import "CircleDetailViewCommentCell.h"
#import "CircleCommendModel.h"
#import "UserHomepageController.h"
#import "RelyBottomView.h"
#import <UShareUI/UShareUI.h>
#import "RequestManager.h"


static NSString *kCircleDetailViewTopCell = @"CircleDetailViewTopCell";
static NSString *kCircleDetailViewCommentCell = @"CircleDetailViewCommentCell";

@interface CircleDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) RelyBottomView *bottomToolView;

@end

@implementation CircleDetailViewController

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
    [self loadData];//请求详情数据
}

- (void)loadData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    if (self.cid.length) {
        parames[@"id"] = self.cid;
    }else{
        parames[@"id"] = self.model.cid;
    }
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    }
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_Postdetail parameters:parames successed:^(id json) {
        if (json) {
            Weakself.model = [CircleViewControllerListModel mj_objectWithKeyValues:json[@"detail"]];
            [Weakself.tableView reloadData];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)setupUI{
    self.dataArray = [NSMutableArray array];
    //1.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:IMAGECACHE(@"chequan_9") highImage:IMAGECACHE(@"chequan_9") target:self action:@selector(rightBarButtonItemAction)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //2.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[CircleDetailViewTopCell class] forCellReuseIdentifier:kCircleDetailViewTopCell];
    [self.tableView registerClass:[CircleDetailViewCommentCell class] forCellReuseIdentifier:kCircleDetailViewCommentCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = SMViewBGColor;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self loadNewsData];
    }];
    
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];
    
    self.bottomToolView = [[RelyBottomView alloc] initDetailBottomView];
    self.bottomToolView.requsetType = CommentRequestTypeCircle;
    self.bottomToolView.mainId = self.model.cid;
    WeakObj(self);
    self.bottomToolView.requestCompletionBlock = ^{
        [Weakself loadNewsData];
    };
    [self.view addSubview:self.bottomToolView];
    [self loadNewsData];
}

- (void)rightBarButtonItemAction {
    //显示分享面板
    //创建网页内容对象
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
        make.bottom.mas_equalTo(- (50+SafeBottomSpace*0.5));
    }];
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.bottom.offset = - SafeBottomSpace * 0.5;
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [UIView new];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel new];
        label.text = @"评论";
        label.textColor = SMTextColor;
        label.font = MFFONT(14);
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.left.offset = 15;
        }];
        return headerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0000001;
    }
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CircleDetailViewTopCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleDetailViewTopCell];
        cell.model = self.model;
        return cell;
    }
    CircleDetailViewCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleDetailViewCommentCell];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CircleCommendModel *model = self.dataArray[indexPath.row];
    //对user_id进行回复
//    if (model.reply_user_id.length) {
//        UserHomepageController *vc = [UserHomepageController new];
//        vc.uid = model.reply_user_id;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"id"] = self.model.cid;
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_CommentList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [CircleCommendModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
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
    parames[@"id"] = self.model.cid;
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_CommentList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [CircleCommendModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
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

#pragma mark - 监听键盘通知
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    CGFloat keyboardY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    // 执行动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (keyboardY == Screen_H) {//键盘回收
        [self.bottomToolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = - SafeBottomSpace * 0.5;
        }];
        [self.bottomToolView keyBoardWillHide];
    }else{//键盘弹起
        [self.bottomToolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = keyboardY - Screen_H;
        }];
        [self.bottomToolView keyBoardWillShow];
    }
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end
