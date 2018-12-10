//
//  YXDUserInfoStore.h
//  YXDApp
//
//  Created by daishaoyang on 2017/12/8.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YXDUserInfoModel;

@interface YXDUserInfoStore : NSObject

@property (nonatomic, strong) YXDUserInfoModel *userModel;
@property (nonatomic, assign) BOOL loginStatus;

//+ (YXDUserInfoModel *)sharedInstance;
+ (YXDUserInfoStore *)sharedInstance;
@end
