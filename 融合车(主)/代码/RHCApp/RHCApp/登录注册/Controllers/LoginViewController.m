//
//  LoginViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/27.
//

#import "LoginViewController.h"
#import "GetCodeViewController.h"

@interface LoginViewController ()<UINavigationControllerDelegate>

@property (nonatomic,strong) UIButton *backButton;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UITextField *phoneNumTF;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation LoginViewController

+ (YXDNavigationController *)shareLoginVC{
    LoginViewController *login = [[LoginViewController alloc] init];
    YXDNavigationController *nav = [[YXDNavigationController alloc] initWithRootViewController:login];
    return nav;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = SMViewBGColor;
    self.navigationController.delegate = self;
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    
    //1.设置返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:IMAGECACHE(@"entry_01") forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    //2.设置标题
    self.titleLabel = [UILabel new];
    self.titleLabel.font = PFFONT(30);
    self.titleLabel.textColor = SMTextColor;
    self.titleLabel.text = @"欢迎来到豆芽";
    [self.view addSubview:self.titleLabel];
    
    //3.设置输入手机号
    self.phoneNumTF = [UITextField new];
    self.phoneNumTF.placeholder = @"请输入手机号";
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTF.font = MFFONT(15);
    [self.view addSubview:self.phoneNumTF];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMLineColor;
    [self.view addSubview:self.lineView];
    
    //4.设置登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = LPFFONT(20);
    self.loginButton.backgroundColor = RGB(0xFA3B00);
    self.loginButton.layer.cornerRadius = 20;
    [self.view addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupLayout{
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 30 + SafeTopSpace;
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 25;
        make.right.offset = -25;
        make.top.equalTo(self.backButton.mas_bottom).offset = 60;
    }];
    [self.phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset = 30;
        make.height.offset = 30;
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.phoneNumTF.mas_bottom).offset = 0;
        make.height.offset = 0.5;
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.lineView.mas_bottom).offset = 70;
        make.height.offset = 40;
    }];
}
//返回
- (void)backButtonAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loginButtonAction:(UIButton *)sender{
    //判断手机号
    if (![NSString isMobileNumber:self.phoneNumTF.text]) {
        [MBHUDHelper showWarningWithText:@"手机号格式不对"];
        return;
    }
    //请求
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = self.phoneNumTF.text;
    dic[@"type"] = @"3";
    WeakObj(self)
    [[NetWorkManager shareManager] POST:USER_SendCodeURL parameters:dic successed:^(id json) {
        
        //获取验证码成功之后
        GetCodeViewController *getCodeViewController = [GetCodeViewController new];
        getCodeViewController.phoneNum = Weakself.phoneNumTF.text;
        [Weakself.navigationController pushViewController:getCodeViewController animated:YES];
    } failure:^(NSError *error) {
        
    }];
}

@end
