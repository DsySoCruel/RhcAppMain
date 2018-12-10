//
//  YXDUserInfoModel.m
//  YXDApp
//
//  Created by daishaoyang on 2017/12/8.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "YXDUserInfoModel.h"

@implementation YXDUserInfoModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"userId" : @"id"};
}
//+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userId":@"id",
//                                                                 }];
//}

@end
