//
//  OrderCarDetailModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/13.
//

#import "OrderCarDetailModel.h"


@implementation OrderCarDetailModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"oid" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"configList" : [ParamesModel class],@"priceList" : [OrederPriceModel class]};
}
@end

@implementation OrederParamesModel

@end
@implementation OrederPriceModel

@end
