//
//  ProductDetailViewHeaderView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/3.
//

#import <UIKit/UIKit.h>
#import "CarDetailModel.h"
#import "ProductSchemeListModel.h"//默认分期参数

@interface ProductDetailViewHeaderView : UIView
@property (nonatomic,strong) CarDetailModel *model;
@property (nonatomic,strong) ProductSchemeListModel *productSchemeListModel;
@end
