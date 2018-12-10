//
//  ProductDetailViewBottomTool.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/3.
//

#import <UIKit/UIKit.h>
#import "CarDetailModel.h"
#import "AccessoriesStoreDetailModel.h"
#import "ProductSchemeListModel.h"//默认分期参数


typedef NS_ENUM(NSInteger,ProductDetailViewBottomToolType) {
    ProductDetailViewBottomToolTypeCarStore,//汽车超市
    ProductDetailViewBottomToolTypeTruckStore,//卡车超市
    ProductDetailViewBottomToolTypeAccessoriesStore,//配件超市
};

@interface ProductDetailViewBottomTool : UIView
- (instancetype)initWithType:(ProductDetailViewBottomToolType)type;
@property (nonatomic,copy  ) CarDetailModel *model;
@property (nonatomic,strong) ProductSchemeListModel *schemeListModel;
@property (nonatomic,strong) AccessoriesStoreDetailModel *accModel;

//选中的汽车的规格


//选中的配件的规格


//返回方法的执行
@property (nonatomic, copy) void(^firstButtonBlock)(void);//全款购  购物车执行
@property (nonatomic, copy) void(^secondButtonBlock)(void);//分期购  立即购买执行
@end
