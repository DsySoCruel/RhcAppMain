//
//  HomeViewListModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/19.
//

#import "HomeViewListModel.h"

@implementation HomeViewListSmall
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"hid" : @"id"};
}
@end

@implementation HomeViewListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"hid" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [HomeViewListSmall class]};
}
@end


@implementation HomeViewListBigModel
@end
