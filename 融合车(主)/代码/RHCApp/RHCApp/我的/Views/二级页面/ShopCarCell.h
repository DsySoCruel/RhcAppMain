//
//  ShopCarCell.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/8.
//

#import <UIKit/UIKit.h>
@class ShopCarListModel;

@interface ShopCarCell : UITableViewCell

@property (nonatomic,strong) ShopCarListModel *goodModel;
//改变商品数量后需要更新总价
@property (nonatomic, copy) void(^needContTotalPriceBlock)(void);
//选择按钮点击执行
@property (nonatomic, copy) void(^selectButtonActionBlock)(void);
//商品数量减少到0之后 重新加载购物车
@property (nonatomic, copy) void(^needUpdataBlock)(void);



@end
