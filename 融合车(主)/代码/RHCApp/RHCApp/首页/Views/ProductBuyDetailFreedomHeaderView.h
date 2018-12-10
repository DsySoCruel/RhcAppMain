//
//  ProductBuyDetailFreedomHeaderView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/23.
//

#import <UIKit/UIKit.h>
#import "CarDetailModel.h"
#import "ProductSchemeListModel.h"//默认分期参数
NS_ASSUME_NONNULL_BEGIN

@interface ProductBuyDetailFreedomHeaderView : UIView
@property (nonatomic,strong) CarDetailModel *model;
@property (nonatomic,strong) ProductSchemeListModel *productSchemeListModel;
@end

NS_ASSUME_NONNULL_END
