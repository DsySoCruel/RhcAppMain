//
//  MyAddressModel.m
//  YXDApp
//
//  Created by daishaoyang on 2017/12/12.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "MyAddressModel.h"

@implementation MyAddressModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"addressId" : @"id", @"isDefault": @"is_default"};
}
@end
