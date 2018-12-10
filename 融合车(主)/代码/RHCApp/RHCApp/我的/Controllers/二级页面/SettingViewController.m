//
//  SettingViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/28.
//

#import "SettingViewController.h"
#import "MineViewCell.h"
#import "RequestManager.h"

static NSString *kMineViewCell = @"MineViewCell";

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView  *tableViewFooterView;
@property (nonatomic,strong) UIButton *quitButton;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIView   *line;
@property (nonatomic,strong) UIButton *button2;

@property (nonatomic,strong) NSString *saveCache;//缓存的数量

@end

@implementation SettingViewController

/**
 *  因为每次进来都要计算缓存，所有要放到这个方法里
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    self.saveCache = [NSString stringWithFormat:@"%.2fMB",[self folderSizeAtPath:cachPath]];
    [self.tableView reloadData];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = SMViewBGColor;
    [self setupData];
    [self setupUI];
    [self setupLayout];
}

- (void)setupData{
    self.dataArray = @[@"分享豆芽App",@"清除缓存"];
}


#pragma mark UI
-(void)setupUI{
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SMViewBGColor;
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:kMineViewCell];
    [self.view addSubview:self.tableView];
    //设置底部view
    self.tableViewFooterView = [UIView new];
    self.tableViewFooterView.backgroundColor = SMViewBGColor;
    self.tableViewFooterView.frame = CGRectMake(0, 0, 0, 150);
    
    self.quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.quitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.quitButton.backgroundColor = [UIColor whiteColor];
    [self.tableViewFooterView addSubview:self.quitButton];
    [self.quitButton addTarget:self action:@selector(quitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.offset = 20;
        make.height.offset = 55;
    }];
    
    self.quitButton.hidden = ![YXDUserInfoStore sharedInstance].loginStatus;

    self.line = [UIView new];
    self.line.backgroundColor = SMLineColor;
    [self.tableViewFooterView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -20;
        make.centerX.offset = 0;
        make.width.offset = 0.5;
        make.height.offset = 20;
    }];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button1 setTitle:@"用户服务协议" forState:UIControlStateNormal];
    [self.tableViewFooterView addSubview:self.button1];
    [self.button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button2 setTitle:@"隐私权条款" forState:UIControlStateNormal];
    [self.tableViewFooterView addSubview:self.button2];
    [self.button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.line);
        make.right.equalTo(self.line.mas_left).offset = -10;
    }];
    
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.line);
        make.left.equalTo(self.line.mas_right).offset = 10;
    }];
    
    self.tableView.tableFooterView = self.tableViewFooterView;
}

-(void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
}


#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineViewCell forIndexPath:indexPath];
    [cell configWithTitle:self.dataArray[indexPath.row] andSubstitle:indexPath.row == 1 ? self.saveCache:@""];
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
    if (indexPath.row == 0) {
        //分享
        NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = @"http://mobile.umeng.com/social";
        [[RequestManager sharedInstance] shareActionwith:shareObject];
    }
    if (indexPath.row == 1) {
        //清楚缓存
        [self showOptionMenu];
    }

}
-(void)showOptionMenu{
    
    if (IS_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要清除缓存吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"清除缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clearCatch];
        }];
        [alert addAction:cancelAction];
        [alert addAction:clearAction];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}


/**
 *  清理缓存
 */
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (void)clearCatch{
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   });
    
}

-(void)clearCacheSuccess
{
    [MBHUDHelper showSuccess:@"清除缓存成功"];
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    self.saveCache = [NSString stringWithFormat:@"%.2fMB",[self folderSizeAtPath:cachPath]];
    [self.tableView reloadData];
}

- (void)quitButtonAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要退出吗" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        YXDUserInfoModel *userModel = [YXDUserInfoStore sharedInstance].userModel;
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"token"] = userModel.token;
        [MBHUDHelper showLoadingHUDView:[BaseViewController topViewController].view withText:@"退出中..."];
        WeakObj(self)
        [[NetWorkManager shareManager] POST:USER_logout parameters:dic successed:^(id json) {
            //获取验证码成功之后
            [MBHUDHelper showSuccess:@"退出成功！"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"userInfoKey"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyUI" object:nil];
            Weakself.quitButton.hidden = YES;
        } failure:^(NSError *error) {
            
        }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)button1Action:(UIButton *)sender{
    //跳转到网页界面
    WebViewController *webView = [WebViewController new];
    webView.title = @"用户服务协议";
    [webView loadWebWithUrl:@"http://106.15.103.137/zycartrade-app/resources/yhfwxy.html"];
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)button2Action:(UIButton *)sender{
    //跳转到网页界面
    WebViewController *webView = [WebViewController new];
    webView.title = @"隐私权条款";
    [webView loadWebWithUrl:@"http://106.15.103.137/zycartrade-app/resources/ysqtk.html"];
    [self.navigationController pushViewController:webView animated:YES];
}
@end
