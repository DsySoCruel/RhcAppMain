//
//  CarDetailModel.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/2.
//

#import "CarDetailModel.h"
#import "ProductModel.h"

@implementation CarModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"purchaseNotes" : [PurchaseNotesModel class],@"purchaseThree" : [PurchaseThreeModel class],@"lookproduct" : [ProductModel class]};
}

@end

@implementation CarDetailModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"pid" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"configList" : [ParamesModel class],@"imgList" : [ImgListModel class],@"colortList" : [InColorModel class],@"inColorList" : [InColorModel class]};
}
@end
@implementation ParamesModel
@end
@implementation ImgListModel
@end
@implementation InColorModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"icid" : @"id"};
}
@end

@implementation PurchaseNotesModel
@end

@implementation PurchaseThreeModel
@end
