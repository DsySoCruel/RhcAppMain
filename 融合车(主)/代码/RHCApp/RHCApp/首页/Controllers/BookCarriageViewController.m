//
//  BookCarriageViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/1.
//

#import "BookCarriageViewController.h"
#import "SectionFooterView1.h"
#import "KemaoTextView.h"
#import "BookCarriageViewCell.h"

#import "YLAwesomeData.h"
#import "YLDataConfiguration.h"
#import "YLAwesomeSheetController.h"
#import "RequestManager.h"

static NSString *kBookCarriageViewCell = @"BookCarriageViewCell";

@interface BookCarriageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *textField;//输入的车型
@property (nonatomic,strong) UILabel     *secondLabel;//车厢类型
@property (nonatomic,strong) UIView      *footView;
@property (nonatomic,strong) KemaoTextView *textView;
@property (nonatomic,strong) UIButton    *senderButton;

//提交成功之后的代码
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel     *label1;
@property (nonatomic,strong) UILabel     *label2;
@property (nonatomic,strong) UIButton    *baceButton;
@property (nonatomic,strong) UIButton    *orderButton;

@end

@implementation BookCarriageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订购车厢";
    self.view.backgroundColor = SMViewBGColor;
    [self setupUI];
    [self setupLayout];
}
- (void)rightBarButtonItemAction{
    [[RequestManager sharedInstance] connectWithServer];
}
- (void)setupUI{
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
    
    UIBarButtonItem *message = [UIBarButtonItem itemWithimage:IMAGECACHE(@"home_02") highImage:IMAGECACHE(@"home_02") target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = message;
    
    self.footView = [UIView new];
    self.footView.frame = CGRectMake(0, 0, Screen_W, 150);
    self.footView.backgroundColor = SMViewBGColor;
    
    self.textView = [KemaoTextView new];
    self.textView.font = PFFONT(14);
    self.textView.textColor = SMTextColor;
    self.textView.placeholderColor = SMParatextColor;
//    self.textView.delegate = self;
    self.textView.placeholder = @"还有什么想给我们说的吗";
    [self.footView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.right.offset = -5;
        make.top.offset = 0;
        make.bottom.offset = -50;
    }];
    
    self.senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.senderButton setTitle:@"提交车厢订购信息" forState:UIControlStateNormal];
    self.senderButton.layer.cornerRadius = 4;
    self.senderButton.layer.masksToBounds = YES;
    self.senderButton.backgroundColor = [UIColor redColor];
    self.senderButton.titleLabel.font = LPFFONT(15);
    [self.footView addSubview:self.senderButton];
    [self.senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = 0;
        make.right.equalTo(self.footView.mas_right).offset = -30;
        make.left.equalTo(self.footView.mas_left).offset = 30;
        make.height.offset = 35;
    }];
    self.tableView.tableFooterView = self.footView;
    [self.senderButton addTarget:self action:@selector(senderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 64 + 10 + SafeTopSpace;
        make.left.right.bottom.offset = 0;
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[BookCarriageViewCell class] forCellReuseIdentifier:kBookCarriageViewCell];
//        [_tableView registerClass:[FindViewDetailViewCell class] forCellReuseIdentifier:hFindViewDetailViewCell];
//        [_tableView registerClass:[FindViewDetailViewBigCell class] forCellReuseIdentifier:hFindViewDetailViewBigCell];
//        [_tableView registerClass:[CircleVClistCell class] forCellReuseIdentifier:hCircleVClistCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = SMViewBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCarriageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBookCarriageViewCell];
    if (indexPath.row == 0) {
        cell.label1.text = @"车型名称";
        self.textField = [UITextField new];
        self.textField.placeholder = @"请输入适配的车型";
        self.textField.font = LPFFONT(13);
        [cell.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 100;
            make.right.offset = -10;
            make.height.offset = 35;
            make.centerY.offset = 0;
        }];
    }
    if (indexPath.row == 1) {
        cell.label1.text = @"车厢类型";
        UIImageView *image = [UIImageView new];
        image.image = IMAGECACHE(@"tijiaodongdan_03");
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.centerY.offset = 0;
        }];
        self.secondLabel = [UILabel new];
        self.secondLabel.text = @"平板式";
        self.secondLabel.font = LPFFONT(12);
        self.secondLabel.textColor = SMTextColor;
        [cell.contentView addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.left.offset = 100;
            make.right.offset = -30;
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionFooterView1 *view = [[SectionFooterView1 alloc] initWithTitle:@"车厢信息"];
    view.frame = CGRectMake(0, 0, 0, 40);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.row == 1) {
        //弹框选择平板样式的鬼
        YLDataConfiguration *config = [[YLDataConfiguration alloc] initWithType:YLDataConfigTypeChexiang selectedData:@[]];
        WeakObj(self)
        [[[YLAwesomeSheetController alloc] initWithTitle:nil
                                                  config:config
                                                callBack:^(NSArray *selectedData) {
                                                    
                                                    YLAwesomeData *data = [selectedData firstObject];
                                                    Weakself.secondLabel.text = data.name;
                                                    
                                                }] showInController:self];
    }
}

- (void)senderButtonAction{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    }else{
        //弹出登录框
        [self presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
        return;
    }
    parames[@"type"] = self.secondLabel.text;
    if (self.textField.text.length) {
        parames[@"name"] = self.textField.text;
    }else{
        [MBHUDHelper showError:@"请输入车型名称"];
        return;
    }
    if (self.textView.text.length) {
        parames[@"remark"] = self.textView.text;
    }
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_AddCarriageOrder parameters:parames successed:^(id json) {
        if (json) {
            [Weakself seccess];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)seccess{
    //成功之后执行布局
    //1.
    [self.tableView removeFromSuperview];
    //2.
    self.iconImage = [UIImageView new];
    self.iconImage.image = IMAGECACHE(@"tijiaochenggong_02");
    [self.view addSubview:self.iconImage];
    
    self.label1 = [UILabel new];
    self.label1.text = @"订单提交成功！";
    self.label1.textColor = [UIColor redColor];
    self.label1.font = MFFONT(16);
    [self.view addSubview:self.label1];
    
    self.label2 = [UILabel new];
    self.label2.text = @"您提交的订单后台正在审核中,预计1-30分钟后,审核i结果将推送到您手机,请在订单界面查收";
    self.label2.numberOfLines = 0;
    self.label2.textColor = SMParatextColor;
    self.label2.font = LPFFONT(12);
    [self.view addSubview:self.label2];
    
    
    self.orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.orderButton setTitle:@"前往订单中心" forState:UIControlStateNormal];
    self.orderButton.backgroundColor = [UIColor redColor];
    self.orderButton.layer.cornerRadius = 4;
    self.orderButton.layer.masksToBounds = YES;
    [self.orderButton addTarget:self action:@selector(orderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.orderButton.titleLabel.font = LPFFONT(15);
    [self.view addSubview:self.orderButton];
    
    self.baceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.baceButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [self.baceButton setTitleColor:SMTextColor forState:UIControlStateNormal];
    self.baceButton.backgroundColor = [UIColor whiteColor];
    self.baceButton.layer.cornerRadius = 4;
    self.baceButton.layer.masksToBounds = YES;
    [self.baceButton addTarget:self action:@selector(baceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.baceButton.titleLabel.font = LPFFONT(15);
    [self.view addSubview:self.baceButton];

    
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.offset = 100;
        make.width.height.offset = 100;
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.iconImage.mas_bottom).offset = 15;
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.label1.mas_bottom).offset = 15;
        make.right.offset = -20;
        make.left.offset = 20;
    }];
     
     [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.offset = 15;
         make.right.offset = -15;
         make.bottom.offset = -40 - 10 - 35;
         make.height.offset = 35;
     }];
    
    [self.baceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.bottom.offset = -40;
        make.height.offset = 35;
    }];
}

- (void)baceButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orderButtonAction{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootVC;
        tab.selectedIndex = 3;
    }
}

@end
