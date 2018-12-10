//
//  AppDelegate.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/20.
//

#import "AppDelegate.h"
#import "YXDTabBarController.h"
#import "GuidePageView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>



@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    YXDTabBarController *tabBar = [[YXDTabBarController alloc] init];
    self.window.rootViewController = tabBar;
//    if (@available(iOS 11.0, *)){//避免滚动视图顶部出现20的空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }
    /**
     *  由登录状态信息设置根视图控制器
     */
    //从沙盒中获取上次存储的版本号
    NSString *versionKey = @"CFBundleShortVersionString";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    if (![currentVersion isEqualToString:lastVersion]) {
        [self showGuidePage];
        /*
         *设置根视图控制器
         */
        //        YXDTabBaController *tabBar = [[YXDTabBarController alloc] init];
        //        self.window.rootViewController = tabBar;
        /*
         *判断是否需要检查
         */
        //        [self checkUpdateWithAppID];
    }else{
        /*
         *设置欢迎界面为根视图控制器
         */
        //        WelcomeController *welcome = [[WelcomeController alloc] init];
        //        self.window.rootViewController = welcome;
    }
    
    //1.微信支付
    [WXApi registerApp:@"wxddf04b0d3b40b91a"];
    
    //2.设置友盟分享得设置
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"5bf7a421b465f578f80002da" channel:@"App Store"];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    return YES;
}


- (void)showGuidePage{
    GuidePageView *guidePage = [GuidePageView new];
    guidePage.pageNumbers = 3;
    [self.window addSubview:guidePage];
    [self.window bringSubviewToFront:guidePage];
    
    [guidePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    guidePage.doneBlock = ^(){
        NSString *versionKey = @"CFBundleShortVersionString";
        // 获得当前打开软件的版本号
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
        [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        return [self openURL:url];
    }
    return result;
}

#pragma mark - 支付判断
- (BOOL)openURL:(NSURL *)url{
    if ([[url scheme] isEqualToString:@"wxddf04b0d3b40b91a"]) {//微信的跳转
        return [self weixinPay:url];
    }
    if ([[url scheme] isEqualToString:@"xxRhcApp"]) {//支付宝操作
        return [self Alipay:url];
    }
    return YES;
}
#pragma mark - 支付宝回调
-(BOOL)Alipay:(NSURL *)url{
    /*
     9000 订单支付成功
     8000 正在处理中
     4000 订单支付失败
     6001 用户中途取消
     6002 网络连接出错
     */
    if ([url.host isEqualToString:@"safepay"]) {
        //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [self AlipayWithResutl:resultDic];
        }];
        //跳转支付宝钱包进行支付，处理支付结果，这个只是辅佐订单支付结果回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self AlipayWithResutl:resultDic];
        }];
    }else if ([url.host isEqualToString:@"platformapi"]){
        //授权返回码
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self AlipayWithResutl:resultDic];
        }];
    }
    return YES;
}

-(void)AlipayWithResutl:(NSDictionary *)resultDic{
    NSString  *str = [resultDic objectForKey:@"resultStatus"];
    if (str.intValue == 9000)
    {
        // 支付成功
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResult" object:@"ali_success" userInfo:nil];
    }
    else
    {
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResult" object:@"fail" userInfo:nil];
    }
}

#pragma mark - 微信支付代理
- (BOOL)weixinPay:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
//回调中errCode值列表：
//名称    描述    解决方案
//0    成功    展示成功页面
//-1    错误    可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
//-2    用户取消    无需处理。发生场景：用户不支付了，点击取消，返回APP。
-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp * response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResult" object:@"ali_success" userInfo:nil];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResult" object:@"fail" userInfo:nil];
                break;
        }
    }
}




#pragma mark - 设置友盟分享
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxddf04b0d3b40b91a" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2320432819"  appSecret:nil redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}


@end
