//
//  MineViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/20.
//

#import "MineViewController.h"
#import "MyNaviView.h"
#import "MyHeaderUserInfoView.h"
#import "MineViewCell.h"
#import "LoginViewController.h"//登录
#import "AboutUsViewController.h"//关于
#import "IdearBackViewController.h"//意见反馈
#import "ServiceStationViewController.h"//服务网点
#import "CommonProblemsViewController.h"//常见问题
#import "MyAddressController.h"
#import "RequestManager.h"

static NSString *kMineViewCell = @"MineViewCell";

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic,strong) MyNaviView *myNaviView;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) MyHeaderUserInfoView *userInfoView;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MineViewController

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
    /*
     接收通知 来自修改密码的通知 当修改完成密码后需要在次界面重新用新密码登录
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyUIaction) name:@"updateMyUI" object:nil];
    [self setupData];
    [self setupUI];
    [self setupLayout];
    [self updateMyUIaction];
}

- (void)setupData{
    self.dataArray = @[@[@"联系客服",@"服务网点"],@[@"意见反馈",@"常见问题",@"我的地址",@"了解豆芽",@"邀请加入"]];
}

#pragma mark UI
-(void)setupUI{
    CGFloat height = 169.0 + SafeTopSpace + 70;
    self.userInfoView = [MyHeaderUserInfoView new];
    self.userInfoView.frame = CGRectMake(0, 0, Screen_W, height);
    self.myNaviView.headerHeight = height;
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SMViewBGColor;
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:kMineViewCell];
    self.tableView.tableHeaderView = self.userInfoView;
    [self.view addSubview:self.tableView];
    self.myNaviView = [[MyNaviView alloc] init];
    [self adjustInsetWithScrollView:self.tableView];
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
        [self.userInfoView adustHeaderView:offsetY];
    }
    [self.myNaviView changeAlphaWithOffset:scrollView.contentOffset.y];
}

#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineViewCell forIndexPath:indexPath];
    NSArray *tempArray = self.dataArray[indexPath.section];
    [cell configWithTitle:tempArray[indexPath.row] andSubstitle:@""];
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 5;
}
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //联系客服
            if (![YXDUserInfoStore sharedInstance].loginStatus) {
                [self presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
            }else{
                [[RequestManager sharedInstance] connectWithServer];
            }
            return;
        }
        if (indexPath.row == 1) {
            //服务网店
            ServiceStationViewController *vc = [ServiceStationViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            return;

        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //意见反馈
            IdearBackViewController *vc = [IdearBackViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            return;

        }
        if (indexPath.row == 1) {
            //常见问题
            CommonProblemsViewController *vc = [CommonProblemsViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (indexPath.row == 2) {
            //我的地址
            MyAddressController *vc = [MyAddressController new];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (indexPath.row == 3) {
            //了解豆芽
            AboutUsViewController *vc = [AboutUsViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (indexPath.row == 4) {
            //邀请有礼
            NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
            //设置网页地址
            shareObject.webpageUrl = @"http://mobile.umeng.com/social";
            [[RequestManager sharedInstance] shareActionwith:shareObject];
            return;
        }
    }
}

- (void)updateMyUIaction{
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        //已经登录
        YXDUserInfoModel *userModel = [YXDUserInfoStore sharedInstance].userModel;
        [self.userInfoView setCellWithUserModel:userModel];
    }else{
        [self.userInfoView quitSuccess];
    }
}


@end
