//
//  BaseModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "BaseModel.h"
#import "NSString+Extension.h"

@implementation BaseModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isBlankFromNetString:oldValue]) {// 以字符串类型为例
        return  @"";
    }
    return oldValue;
}

@end
