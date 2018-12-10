//
//  PayViewOrderModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/29.
//

#import "PayViewOrderModel.h"

@implementation PayViewOrderModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"oid" : @"id"};
}

- (NSString *)price{
    if ([_price isEqualToString:@""]) {
        _price = @"0";
    }
    return _price;
}

@end
