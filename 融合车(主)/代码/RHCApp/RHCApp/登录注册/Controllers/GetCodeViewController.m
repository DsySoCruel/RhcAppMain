//
//  GetCodeViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/27.
//

#import "GetCodeViewController.h"
#import "YN_PassWordView.h"

@interface GetCodeViewController ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) YN_PassWordView *passView;
@property (nonatomic,strong) UIButton *getCodeButton;//重获验证码
@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation GetCodeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SMViewBGColor;
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    
    //2.设置标题
    self.titleLabel = [UILabel new];
    self.titleLabel.font = PFFONT(30);
    self.titleLabel.textColor = SMTextColor;
    self.titleLabel.text = @"输入验证码";
    [self.view addSubview:self.titleLabel];
    
    //3.设置已输入手机号
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.font = MFFONT(15);
    self.subTitleLabel.textColor = SMLineColor;
    self.subTitleLabel.text = [NSString stringWithFormat:@"验证码已发送至 %@",self.phoneNum];
    [self.view addSubview:self.subTitleLabel];
    
    
    //4.
    self.passView = [[YN_PassWordView alloc] init];
    self.passView.frame = CGRectMake(0, 0, Screen_W - 50, 60);
    self.passView.textBlock = ^(NSString *str) {//返回的内容
        NSLog(@"%@",str);
    };
    [self.view addSubview:_passView];
    self.passView.showType = 5;//五种样式
    self.passView.num = 4;//框框个数
    self.passView.tintColor = SMLineColor;//主题色
    [self.passView show];
    
    //5.设置重复验证码
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getCodeButton setTitleColor:SMParatextColor forState:UIControlStateNormal];
    self.getCodeButton.titleLabel.font = LPFFONT(15);
    self.getCodeButton.userInteractionEnabled = NO;
    [self.view addSubview:self.getCodeButton];
    [self.getCodeButton addTarget:self action:@selector(getCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    
    //6.设置登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = LPFFONT(20);
    self.loginButton.backgroundColor = RGB(0xFA3B00);
    self.loginButton.layer.cornerRadius = 20;
    [self.view addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self clickButton:self.getCodeButton];
}


- (void)setupLayout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 25;
        make.right.offset = -25;
        make.top.offset = 100;
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset = 0;
        make.height.offset = 30;
    }];
    [self.passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset = 30;
        make.height.offset = 60;
    }];
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.passView.mas_bottom).offset = 5;
        make.height.offset = 30;
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.passView.mas_bottom).offset = 80;
        make.height.offset = 40;
    }];
}



- (void)getCodeButtonAction:(UIButton *)sender{
    //请求验证码成功
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = self.phoneNum;
    dic[@"type"] = @"3";
    WeakObj(self)
    [[NetWorkManager shareManager] POST:USER_SendCodeURL parameters:dic successed:^(id json) {
        //获取验证码成功之后
        [Weakself clickButton:sender];
    } failure:^(NSError *error) {
        
    }];
}

- (void)clickButton:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [sender setTitleColor:SMParatextColor forState:UIControlStateNormal];
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时结束后,重新设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
                [sender setTitleColor:SMThemeColor forState:UIControlStateNormal];
            });
        }else{
            NSString * strTime = [NSString stringWithFormat:@"%.2ds后重发",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
//进行登录
- (void)loginButtonAction:(UIButton *)sender{
    //1.判断有没有验证码
    if (self.passView.textF.text.length != 4) {
        [MBHUDHelper showError:@"请输入正确验证码"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = self.phoneNum;
    dic[@"vcode"] = self.passView.textF.text;
    [MBHUDHelper showLoadingHUDView:[BaseViewController topViewController].view withText:@"登录中"];
    WeakObj(self)
    [[NetWorkManager shareManager] POST:USER_login parameters:dic successed:^(id json) {
        //获取验证码成功之后
        [MBHUDHelper showSuccess:@"登录成功！"];
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:json[@"user"]];
        YXDUserInfoModel *account = [YXDUserInfoModel mj_objectWithKeyValues:mutableDic];
        NSString *jsonstr = [account toJSONString];
        [[NSUserDefaults standardUserDefaults]setValue:jsonstr forKey:@"userInfoKey"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyUI" object:nil];
        [Weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        
    }];
}
@end
