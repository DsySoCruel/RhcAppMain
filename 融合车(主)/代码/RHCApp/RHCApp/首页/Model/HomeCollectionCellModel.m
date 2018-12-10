//
//  HomeCollectionCellModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/26.
//

#import "HomeCollectionCellModel.h"

@implementation HomeCollectionCellModel
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    HomeCollectionCellModel *item = [[self alloc] init];
    item.title = title;
    item.imageName = icon;
    return item;
}


@end
