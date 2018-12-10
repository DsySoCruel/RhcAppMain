//
//  AccessoriesStoreDetailModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/4.
//

#import "AccessoriesStoreDetailModel.h"

@implementation AccessoriesStoreDetailModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"pid" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"colorList" : [ColorModel class],@"imgList" : [ImgModel class],@"styleList" : [StyleModel class]};
}

@end
@implementation ColorModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"cid" : @"id"};
}
@end
@implementation StyleModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"cid" : @"id"};
}
@end
@implementation ImgModel
@end
