
//
//  PayViewController.m
//  YXDApp
//
//  Created by daishaoyang on 2018/1/2.
//  Copyright © 2018年 beijixing. All rights reserved.
//

#import "PayViewController.h"
#import "RequestManager.h"
#import "PayViewOrderModel.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "APOrderInfo.h"
#import "WXApi.h"
#import "WeiXinInfoModel.h"

@interface PayViewController ()<UINavigationControllerDelegate>{
    dispatch_source_t timer;
}

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *telButton;
@property (nonatomic,strong) UIImageView *imageTopView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UIView *firstOneView;
@property (nonatomic,strong) UIImageView *oneIconImageView;
//@property (nonatomic,strong) UILabel *oneLabel;
//@property (nonatomic,strong) UILabel *one0neLabel;
@property (nonatomic,strong) UIImageView *oneImageView;
@property (nonatomic,strong) UIView *firstTwoView;
@property (nonatomic,strong) UIImageView *twoIconImageView;
//@property (nonatomic,strong) UILabel *twoLabel;
//@property (nonatomic,strong) UILabel *twotwoLabel;
@property (nonatomic,strong) UIImageView *twoImageView;
//@property (nonatomic,strong) UIView *firstThreeView;
//@property (nonatomic,strong) UIImageView *threeIconImageView;
//@property (nonatomic,strong) UILabel *threeLabel;
//@property (nonatomic,strong) UILabel *threethreeLabel;
//@property (nonatomic,strong) UIImageView *threeImageView;

@property (nonatomic,strong) PayViewOrderModel *model;
@property (nonatomic,strong) UIButton *commintButton;//支付按钮-立即支付

@end

@implementation PayViewController

- (void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)telButtonAction{
    [[RequestManager sharedInstance] connectWithServer];
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SMViewBGColor;
    self.navigationController.delegate = self;

    [self setupUI];
    [self setupLayout];
    [self loadData];
    
    //注册支付宝回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"PayResult" object:nil];
}

- (void)setupUI{
    //1.设置头部
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:IMAGECACHE(@"backIcon") forState:UIControlStateNormal];
    self.backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.backButton];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = SMTextColor;
    self.titleLabel.text = @"支付订单";
    self.titleLabel.font = MFFONT(17);
    [self.topView addSubview:self.titleLabel];
    
    self.telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.telButton setImage:IMAGECACHE(@"home_02") forState:UIControlStateNormal];
    self.telButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [self.telButton addTarget:self action:@selector(telButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.telButton];
    
    self.imageTopView = [UIImageView new];
    self.imageTopView.image = IMAGECACHE(@"zwt2");
    [self.topView addSubview:self.imageTopView];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = SMParatextColor;
    self.timeLabel.font = LPFFONT(13);
    [self.topView addSubview:self.timeLabel];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = SMTextColor;
    self.priceLabel.font = LPFFONT(15);
    [self.topView addSubview:self.priceLabel];
    
    
    //微信支付
    self.firstOneView = [UIView new];
    self.firstOneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.firstOneView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstOneViewAction)];
    [self.firstOneView addGestureRecognizer:tap1];
    
    self.oneIconImageView  = [[UIImageView alloc] initWithImage:IMAGECACHE(@"pay_zhifubao")];
    [self.firstOneView addSubview:self.oneIconImageView];
    
    //    self.oneLabel = [UILabel new];
    //    self.oneLabel.textColor = SMTextColor;
    //    self.oneLabel.font = LPFFONT(15);
    //    self.oneLabel.text = @"微信支付";
    //    [self.firstOneView addSubview:self.oneLabel];
    //
    //    self.one0neLabel = [UILabel new];
    //    self.one0neLabel.textColor = SMParatextColor;
    //    self.one0neLabel.font = LPFFONT(12);
    //    self.one0neLabel.text = @"推荐使用最新版本支付";
    //    [self.firstOneView addSubview:self.one0neLabel];
    
    self.oneImageView = [[UIImageView alloc] initWithImage:IMAGECACHE(@"choose_l")];
    [self.firstOneView addSubview:self.oneImageView];
    
        //支付宝支付
        self.firstTwoView = [UIView new];
        self.firstTwoView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.firstTwoView];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstTwoViewAction)];
        [self.firstTwoView addGestureRecognizer:tap2];
    
        self.twoIconImageView  = [[UIImageView alloc] initWithImage:IMAGECACHE(@"pay_weixin")];
        [self.firstTwoView addSubview:self.twoIconImageView];
//
//        self.twoLabel = [UILabel new];
//        self.twoLabel.textColor = TEXTBlack_COLOR;
//        self.twoLabel.font = LPFFONT(15);
//        self.twoLabel.text = @"支付宝支付";
//        [self.firstTwoView addSubview:self.twoLabel];
//
//        self.twotwoLabel = [UILabel new];
//        self.twotwoLabel.textColor = TEXTGray_COLOR;
//        self.twotwoLabel.font = LPFFONT(12);
//        self.twotwoLabel.text = @"推荐使用最新版本支付";
//        [self.firstTwoView addSubview:self.twotwoLabel];
    
        self.twoImageView = [[UIImageView alloc] initWithImage:IMAGECACHE(@"choose_l")];
        [self.firstTwoView addSubview:self.twoImageView];
        self.twoImageView.hidden = YES;
    //
    //
    ////    余额支付
    //    self.firstThreeView = [UIView new];
    //    self.firstThreeView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:self.firstThreeView];
    //    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstThreeViewAction)];
    //    [self.firstThreeView addGestureRecognizer:tap3];
    //
    //
    //    self.threeIconImageView  = [[UIImageView alloc] initWithImage:IMAGECACHE(@"icon_61")];
    //    [self.firstThreeView addSubview:self.threeIconImageView];
    //
    //    self.threeLabel = [UILabel new];
    //    self.threeLabel.textColor = TEXTBlack_COLOR;
    //    self.threeLabel.font = LPFFONT(15);
    //    self.threeLabel.text = @"余额支付";
    //    [self.firstThreeView addSubview:self.threeLabel];
    //
    //    self.threethreeLabel = [UILabel new];
    //    self.threethreeLabel.textColor = TEXTGray_COLOR;
    //    self.threethreeLabel.font = LPFFONT(12);
    //    [self.firstThreeView addSubview:self.threethreeLabel];
    //
    //    self.threeImageView = [[UIImageView alloc] initWithImage:IMAGECACHE(@"icon_62")];
    //    [self.firstThreeView addSubview:self.threeImageView];
    //    self.threeImageView.hidden = YES;
    
    
    self.commintButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commintButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.commintButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commintButton.backgroundColor = SMThemeColor;
    [self.commintButton addTarget:self action:@selector(commintAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commintButton];
}

- (void)setupLayout{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 300;
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.top.offset = 20;
        make.height.offset = 44;
        make.width.offset = 50;
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.offset = 30;
    }];
    [self.telButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.top.offset = 20;
        make.height.offset = 44;
        make.width.offset = 50;
    }];
    
    [self.imageTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 64 + SafeTopSpace;
        make.left.right.offset = 0;
        make.height.offset = 150;
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.imageTopView.mas_bottom).offset = 20;
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.imageTopView.mas_bottom).offset = 50;
    }];
    
    [self.firstOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.height.offset = 70;
        make.width.offset = YXDScreenW;
        make.top.equalTo(self.topView.mas_bottom).offset = 10;
    }];
    
    [self.oneIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 20;
        //        make.width.height.offset = 50;
    }];
    
    //    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.oneIconImageView.mas_right).offset = 20;
    //        make.top.offset = 10;
    //    }];
    //    [self.one0neLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.oneIconImageView.mas_right).offset = 20;
    //        make.bottom.offset = -10;
    //    }];
    
    [self.oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.offset = -15;
    }];
    
    [self.firstTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.height.offset = 70;
        make.width.offset = YXDScreenW;
        make.top.equalTo(self.firstOneView.mas_bottom).offset = 1;
    }];

    [self.twoIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 28;
    }];
    //
    //    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.twoIconImageView.mas_right).offset = 20;
    //        make.top.offset = 10;
    //    }];
    //    [self.twotwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.twoIconImageView.mas_right).offset = 20;
    //        make.bottom.offset = -10;
    //    }];
    [self.twoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.offset = -15;
    }];
    //
    //
    //    [self.firstThreeView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.offset = 0;
    //        make.height.offset = 70;
    //        make.width.offset = YXDScreenW;
    //        make.top.equalTo(self.firstTwoView.mas_bottom).offset = 1;
    //    }];
    //
    //    [self.threeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.offset = 0;
    //        make.left.offset = 20;
    //        make.width.height.offset = 50;
    //    }];
    //
    //    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.threeIconImageView.mas_right).offset = 20;
    //        make.top.offset = 10;
    //    }];
    //    [self.threethreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.threeIconImageView.mas_right).offset = 20;
    //        make.bottom.offset = -10;
    //    }];
    //    [self.threeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.offset = 0;
    //        make.right.offset = -15;
    //    }];
    
    [self.commintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.height.offset = 50;
        make.bottom.offset = 0;
        //        make.top.equalTo(self.firstOneView.mas_bottom).offset = 60;
    }];
    
}

- (void)firstOneViewAction{
        self.twoImageView.hidden = YES;
//        self.threeImageView.hidden = YES;
        self.oneImageView.hidden = NO;
}

- (void)firstTwoViewAction{
    self.twoImageView.hidden = NO;
//    self.threeImageView.hidden = YES;
    self.oneImageView.hidden = YES;
}
//- (void)firstThreeViewAction{
//    self.twoImageView.hidden = YES;
//    self.oneImageView.hidden = YES;
//    self.threeImageView.hidden = NO;
//
//}


- (void)loadData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"orderId"] = self.orderId;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_GetOrderPayData parameters:parames successed:^(id json) {
        if (json) {
            Weakself.model = [PayViewOrderModel mj_objectWithKeyValues:json[@"order"]];
            NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",Weakself.model.price]];
            [titleString addAttribute:NSFontAttributeName value:LPFFONT(26) range:NSMakeRange(1, titleString.length-1)];
            [Weakself.priceLabel setAttributedText:titleString];
            
            NSMutableAttributedString *titlering = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"确认支付 ￥ %@",Weakself.model.price]];
            [titlering addAttribute:NSFontAttributeName value:LPFFONT(26) range:NSMakeRange(7, titlering.length-7)];
            [Weakself.commintButton setAttributedTitle:titlering forState:UIControlStateNormal];
            //开始倒计时
            [Weakself timeBeginWiht:Weakself.model.create_time];
        }
    } failure:^(NSError *error) {

    }];
}

- (void)commintAction:(UIButton *)sender{
    //判断是什么支付方式
    //1.余额支付
    //    if (!self.threeImageView.hidden) {
    //        if ([self.model.orderInfo.realTotalMoney floatValue] > [self.model.userMoney floatValue]) {
    //            [MBHUDHelper showError:@"余额不足,请更换支付方式"];
    //            return;
    //        }
    //
    //        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    //        parames[@"userId"] = [YXDUserInfoStore sharedInstance].userModel.userId;
    //        parames[@"accessToken"] = UserAccessToken;
    //        parames[@"orderId"] = self.orderId;
    //        parames[@"payType"] = @"3";
    //        WeakObj(self);
    //        [[NetWorkManager shareManager] POST:USER_toPayNotify parameters:parames successed:^(id json) {
    //            if (json) {
    //                [MBHUDHelper showSuccess:@"支付成功"];
    //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                    [Weakself.navigationController popToRootViewControllerAnimated:YES];
    //                });
    //            }
    //        } failure:^(NSError *error) {
    //
    //        }];
    //    }
    //支付宝支付
    if (!self.oneImageView.hidden) {
        //获取加签后的信息（从自己的服务器获取）
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"payType"] = @"alipay";
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
        parames[@"orderId"] = self.orderId;
        WeakObj(self);
        [[NetWorkManager shareManager] POST:USER_Pay parameters:parames successed:^(id json) {
            if (json) {
                [MBHUDHelper showSuccess:@"获取支付信息成功"];
                [[AlipaySDK defaultService] payOrder:json[@"payParamMap"][@"paramStr"] fromScheme:@"xxRhcApp" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);//没有安装支付宝的时候回调  ps:有支付宝app回调在appdelegate中  利用通知刷新界面
                    
                    NSString  *str = [resultDic objectForKey:@"resultStatus"];
                    if (str.intValue == 9000)
                    {
                        // 支付成功
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [Weakself.navigationController popToRootViewControllerAnimated:YES];
                        });
                    }
                    else
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //通过通知中心发送通知
                            [MBHUDHelper showSuccess:@"支付未完成"];                        });
                    }
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    //微信支付
    if (!self.twoImageView.hidden) {
        //获取加签后的信息（从自己的服务器获取）
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"payType"] = @"wx";
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
        parames[@"orderId"] = self.orderId;

//        WeakObj(self);
        [[NetWorkManager shareManager] POST:USER_Pay parameters:parames successed:^(id json) {
            if (json) {
                [MBHUDHelper showSuccess:@"获取支付信息成功"];
                WeiXinInfoModel *model = [WeiXinInfoModel mj_objectWithKeyValues:json[@"payParamMap"][@"wxparamStr"]];

                PayReq *request = [[PayReq alloc] init];

                request.partnerId = model.partnerid;//微信支付分配的商户号

                request.prepayId = model.prepayid;//微信返回的支付交易会话ID

                request.package = model.package;//暂填写固定值Sign=WXPay
//                request.package = model.trade_type;//暂填写固定值Sign=WXPay

                request.nonceStr = model.noncestr;//随机字符串，不长于32位。推荐随机数生成算法
                
//                NSDate *datenow = [NSDate date];
//                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
                UInt32 timeStamp = [model.timeStamp intValue];
            
                request.timeStamp = timeStamp;//时间戳，请见接口规则-参数规定

                request.sign= model.sign;//签名，详见签名生成算法注意：签名方式一定要与统一下单接口使用的一致

                [WXApi sendReq:request];
            }
        } failure:^(NSError *error) {

        }];
    }
}

//支付回调通知（支付宝）
- (void)InfoNotificationAction:(NSNotification *)notification{
    if ([notification.object isEqualToString:@"ali_success"]) {//支付成功
        [MBHUDHelper showSuccess:@"支付成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payPaySucceed" object:self.orderId userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }else{
        [MBHUDHelper showSuccess:@"支付未完成"];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  获取当天的字符串
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];//现在的时间
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}

- (void)timeBeginWiht:(NSString *)creatTime{
    //倒计时开始 ---------------------atart---------------------------------------------------------
    // 倒计时的时间 测试数据
    //    1540826939000
    
    long long start = [creatTime longLongValue];
    long long ondDay = 86400000;
    long long time = start + ondDay;
    
    NSTimeInterval interval    = time  / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *deadlineStr       = [formatter stringFromDate: date];
    
    //    NSString *deadlineStr = @"2018-10-26 12:00:00";
    // 当前时间的时间戳
    NSString *nowStr = [self getCurrentTimeyyyymmdd];
    // 计算时间差值
    NSInteger secondsCountDown = [self getDateDifferenceWithNowDateStr:nowStr deadlineStr:deadlineStr];
    
    
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __block NSInteger timeout = secondsCountDown; // 倒计时时间
    
    __weak __typeof(self) weakSelf = self;
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        
        if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
            dispatch_source_cancel(timer);
            timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.timeLabel.text = @"超出支付时间段,订单失效!";
                weakSelf.timeLabel.textColor = [UIColor redColor];
                //设置不可点击样式
                weakSelf.commintButton.backgroundColor = UNAble_color;
                weakSelf.commintButton.userInteractionEnabled = NO;
            });
        } else { // 倒计时重新计算 时/分/秒
            NSInteger days = (int)(timeout/(3600*24));
            NSInteger hours = (int)((timeout-days*24*3600)/3600);
            NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
            NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
            NSString *strTime = [NSString stringWithFormat:@"剩余支付时间 %02ld : %02ld : %02ld", hours, minute, second];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (days == 0) {
                    weakSelf.timeLabel.text = strTime;
                } else {
                    weakSelf.timeLabel.text = [NSString stringWithFormat:@"剩余支付时间        %ld天 %02ld : %02ld : %02ld", days, hours, minute, second];
                }
                
            });
            timeout--; // 递减 倒计时-1(总时间以秒来计算)
        }
    });
    dispatch_resume(timer);
}
@end
