//
//  ProductBuyDetailController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/14.
//

#import "BaseViewController.h"
#import "CarDetailModel.h"
#import "ProductSchemeListModel.h"

typedef NS_ENUM(NSInteger,BuyType) {
    BuyTypeAging,//分期购买
    BuyTypeAll,//全款购买
    BuyTypeFreedom,//自由计算
};

@interface ProductBuyDetailController : BaseViewController
@property (nonatomic,assign) BuyType buyType;
@property (nonatomic,strong) CarDetailModel *carDetailModel;
@property (nonatomic,strong) ProductSchemeListModel *productSchemeListModel;

@end
