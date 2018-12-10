//
//  RequestManager.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/24.
//

#import "RequestManager.h"


@interface PhoneModel:BaseModel
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *name;
@end
@implementation PhoneModel
@end

@implementation RequestManager
+ (RequestManager *)sharedInstance {
    static dispatch_once_t once;
    static RequestManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[RequestManager alloc] init];
    });
    return sharedInstance;
}
//1.收藏 //2.取消收藏
+ (void)collectWithId:(NSString *)cid andWith:(CollectType)type  button:(UIButton *)button{
    //1.判断登录状态
    if (![YXDUserInfoStore sharedInstance].loginStatus) {
        [[BaseViewController topViewController] presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
        return;
    }
    button.userInteractionEnabled = NO;
    //
    NSString *collectType = @"";
    switch (type) {
        case 0:
            collectType = @"app_accessories";
            break;
        case 1:
            collectType = @"app_product";
            break;
        case 2:
            collectType = @"app_information";
            break;
        default:
            break;
    }
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"fromId"] = cid;
    parames[@"fromTable"] = collectType;
//    WeakObj(self);
    if (button.selected) {//已收藏 进行删除
        [[NetWorkManager shareManager] POST:USER_CollectionDelete parameters:parames successed:^(id json) {
            button.userInteractionEnabled = YES;
            if (json) {
                button.selected = NO;
                [MBHUDHelper showSuccess:@"取消收藏成功"];
            }
        } failure:^(NSError *error) {
            button.userInteractionEnabled = YES;

        }];
    }else{//未收藏 进行收藏
        [[NetWorkManager shareManager] POST:USER_CollectionAdd parameters:parames successed:^(id json) {
            button.userInteractionEnabled = YES;
            if (json) {
                button.selected = YES;
                [MBHUDHelper showSuccess:@"收藏成功"];
            }
        } failure:^(NSError *error) {
            button.userInteractionEnabled = YES;
        }];
    }
}

+ (void)collectWithId:(NSString *)cid andWith:(NSString *)type collectResultBlock:(CollectResultBlock)collectResultBlock{
    //1.判断登录状态
    if (![YXDUserInfoStore sharedInstance].loginStatus) {
        [[BaseViewController topViewController] presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
        return;
    }
    //
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"fromId"] = cid;
    parames[@"fromTable"] = type;
//    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_CollectionDelete parameters:parames successed:^(id json) {
        if (json) {
            [MBHUDHelper showSuccess:@"取消收藏成功"];
            collectResultBlock();
        }
    } failure:^(NSError *error) {
    }];
}

//咨询客服
- (void)connectWithServer{
    //判断本地没有存储客服手机号
    NSString *phonekey = @"serviceTelPhone";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phone = [defaults objectForKey:phonekey];
    if (phone.length) {
        
    }else{
        [[NetWorkManager shareManager] POST:USER_ServiceTel parameters:nil successed:^(id json) {
            if (json) {
//                [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:versionKey];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"拨打电话" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
                [alertController addAction:cancelAction];
                NSArray *moreArray = [PhoneModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
                for (PhoneModel *model in moreArray) {
                    if ([model.name isEqualToString:@"汽车客服"]) {
                        UIAlertAction *oneAction = [UIAlertAction actionWithTitle:@"呼叫汽车客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",model.phone]]];
                        }];
                        [alertController addAction:oneAction];

                    }
                    if ([model.name isEqualToString:@"卡车客服"]) {
                        UIAlertAction *twoAction = [UIAlertAction actionWithTitle:@"呼叫卡车客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",model.phone]]];
                        }];
                        [alertController addAction:twoAction];

                    }
                    if ([model.name isEqualToString:@"综合客服"]) {
                        UIAlertAction *threeAction = [UIAlertAction actionWithTitle:@"综合客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",model.phone]]];
                        }];
                        [alertController addAction:threeAction];
                    }
                }

                [[BaseViewController topViewController].navigationController presentViewController:alertController animated:YES completion:nil];
                
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
}



- (void)shareActionwith:(UMShareWebpageObject*)UMShareWebpageObject{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType with:UMShareWebpageObject];
    }];
}

#pragma mark - 分享内容
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType with:(UMShareWebpageObject *)UMShareWebpageObject
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    //分享消息对象设置分享内容对象
    messageObject.shareObject = UMShareWebpageObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[BaseViewController topViewController] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end
