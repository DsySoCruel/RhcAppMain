//
//  OrderLisetModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/21.
//

#import "BaseModel.h"

@interface OrderLisetModel : BaseModel

@property (nonatomic,strong) NSString *oid;//订单id
@property (nonatomic,strong) NSString *base_price;//
@property (nonatomic,strong) NSString *title;//
@property (nonatomic,strong) NSString *price;//
@property (nonatomic,strong) NSString *reason;//
@property (nonatomic,strong) NSString *img;//
@property (nonatomic,strong) NSString *scheme_id;//没有值为全款  否则是分期付款  
@property (nonatomic,strong) NSString *brandName;//
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *order_status;//wait_pending:待审核,wait_pay:待支付,fail:失败,wait_shipments:完成
@property (nonatomic,strong) NSString *order_no;//
@property (nonatomic,strong) NSString *isCuicu;

@property (nonatomic,strong) NSString *name;//车厢专用
@property (nonatomic,strong) NSString *type;//车厢专用

@end
