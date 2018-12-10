//
//  ProductModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/16.
//

#import "ProductModel.h"

@implementation ProductModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"pid" : @"id"};
}
@end
