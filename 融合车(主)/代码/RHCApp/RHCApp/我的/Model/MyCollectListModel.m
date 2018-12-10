//
//  MyCollectListModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/3.
//

#import "MyCollectListModel.h"

@implementation MyCollectListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"cid" : @"id"};
}
@end
