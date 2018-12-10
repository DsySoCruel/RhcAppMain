//
//  WeiXinInfoModel.h
//  YXDApp
//
//  Created by daishaoyang on 2018/3/19.
//  Copyright © 2018年 beijixing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiXinInfoModel : NSObject
//
//@property (nonatomic,strong) NSString *appid;
//@property (nonatomic,strong) NSString *partnerid;
//@property (nonatomic,strong) NSString *prepayid;
//@property (nonatomic,strong) NSString *package;
//@property (nonatomic,strong) NSString *noncestr;
//@property (nonatomic,strong) NSString *timestamp;

@property (nonatomic,strong) NSString *sign;
@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic,strong) NSString *noncestr;
@property (nonatomic,strong) NSString *partnerid;
@property (nonatomic,strong) NSString *prepayid;
@property (nonatomic,strong) NSString *package;

@end
