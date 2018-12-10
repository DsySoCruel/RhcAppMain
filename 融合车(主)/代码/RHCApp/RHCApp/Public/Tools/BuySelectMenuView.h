//
//  BuySelectMenuView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/24.
//

#import <UIKit/UIKit.h>
#import "AccessoriesStoreDetailModel.h"
#import "CarDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BuySelectMenuViewType) {
    BuySelectMenuViewTypeCell ,//选择属性
    BuySelectMenuViewTypeAdd,//加入购物车
    BuySelectMenuViewTypeBuy,//直接购买
};


@interface BuySelectMenuView : UIView

//1.购买配件的选择
-(id)initWithDataSource:(AccessoriesStoreDetailModel *)model withType:(BuySelectMenuViewType)type;

/** controller传nil 遮盖物是keyWindow */
- (void)showInView:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
