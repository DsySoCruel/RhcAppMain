//
//  ShopCarListModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/8.
//

#import "ShopCarListModel.h"

@implementation ShopCarListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"goodsId" : @"id",@"goodsImage" : @"imgs",@"goodsName" : @"title",@"cnt" : @"number"};
}
@end
