//
//  ServiceStationViewCellModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/7/19.
//

#import "ServiceStationViewCellModel.h"

@implementation ServiceStationViewCellModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"sid" : @"id"};
}
@end
