//
//  AccessoriesListModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/2.
//

#import "AccessoriesListModel.h"

@implementation AccessoriesListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"hid" : @"id"};
}
@end
