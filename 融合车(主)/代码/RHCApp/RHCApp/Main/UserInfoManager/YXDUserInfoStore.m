//
//  YXDUserInfoStore.m
//  YXDApp
//
//  Created by daishaoyang on 2017/12/8.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "YXDUserInfoStore.h"
#import "YXDUserInfoModel.h"

@implementation YXDUserInfoStore

//+ (YXDUserInfoModel *)account{
//
//    NSDictionary *dic = [UserDefaults objectForKey:@"userInfoKey"];
//
//    YXDUserInfoModel *account = [YXDUserInfoModel mj_objectWithKeyValues:dic];
//
//    return account;
//}

- (YXDUserInfoModel *)userModel{
    
    NSString *jsonStr = [UserDefaults objectForKey:@"userInfoKey"];
    
    if (jsonStr) {
    }
    
    YXDUserInfoModel *userModel = [[YXDUserInfoModel alloc] initWithString:jsonStr error:nil];
    
    NSLog(@"%@",jsonStr);
    NSLog(@"%@",userModel);
    NSLog(@"%@",userModel.userId);

    return userModel;
}

- (BOOL)loginStatus{
    if ([UserDefaults objectForKey:@"userInfoKey"]) {
        return YES;
    }
    return NO;
}


+ (YXDUserInfoStore *)sharedInstance {
    static dispatch_once_t once;
    static YXDUserInfoStore *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[YXDUserInfoStore alloc] init];
    });
    return sharedInstance;
}

@end
