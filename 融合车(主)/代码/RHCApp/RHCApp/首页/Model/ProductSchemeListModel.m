//
//  ProductSchemeListModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/25.
//

#import "ProductSchemeListModel.h"
@implementation ProductSchemeListMCModel
@end

@implementation ProductSchemeListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [ProductSchemeModel class]};
}
@end
@implementation ProductSchemeModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"cid" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"MCList" : [ProductSchemeListMCModel class]};
}
@end
