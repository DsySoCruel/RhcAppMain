//
//  ShopCarListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/8.
//

#import <Foundation/Foundation.h>

@interface ShopCarListModel : NSObject

@property (nonatomic,strong) NSString *goodsId;
@property (nonatomic,strong) NSString *goodsImage;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,strong) NSString *price;
//@property (nonatomic,strong) NSString *goodsType;
@property (nonatomic,strong) NSString *style;
@property (nonatomic,strong) NSString *color;
@property (nonatomic,strong) NSString *inventory;
@property (nonatomic,strong) NSString *cnt;


//自定义有没有被选中 默认没有
@property (nonatomic,assign) BOOL isSelect;//有没有选中
@end
