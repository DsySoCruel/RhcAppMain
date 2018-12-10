//
//  OrderCarDetailModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/13.
//

#import "BaseModel.h"
#import "CarDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderCarDetailModel : BaseModel

@property (nonatomic,strong) NSString *down_payment_snap;//
@property (nonatomic,strong) NSString *base_price;//
@property (nonatomic,strong) NSString *remark;//
@property (nonatomic,strong) NSString *monthlyList;//
@property (nonatomic,strong) NSArray  *priceList;//???
@property (nonatomic,strong) NSString *img;//
@property (nonatomic,strong) NSString *complete_time;//
@property (nonatomic,strong) NSString *pay_time;//
@property (nonatomic,strong) NSString *order_no;//
@property (nonatomic,strong) NSString *order_status;//
@property (nonatomic,strong) NSString *inColor;//
@property (nonatomic,strong) NSArray  *configList;//???
@property (nonatomic,strong) NSString *get_car_time;//
@property (nonatomic,strong) NSString *oid;//
@property (nonatomic,strong) NSString *title;//
@property (nonatomic,strong) NSString *price;//
@property (nonatomic,strong) NSString *listPrice;//
@property (nonatomic,strong) NSString *address;//
@property (nonatomic,strong) NSString *pay_type;//
@property (nonatomic,strong) NSString *color;//
@property (nonatomic,strong) NSString *create_time;//
@property (nonatomic,strong) NSString *scheme_id;//
@property (nonatomic,strong) NSString *productPrice;//

@end


//参数数据
@interface OrederParamesModel : BaseModel
@property (nonatomic,strong) NSString *value;
@property (nonatomic,strong) NSString *key;
@end

//价钱数据
@interface OrederPriceModel : BaseModel
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *name;
@end

NS_ASSUME_NONNULL_END
