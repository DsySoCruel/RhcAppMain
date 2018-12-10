//
//  OrderChexiangDetailModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/14.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderChexiangDetailModel : BaseModel
@property (nonatomic,strong) NSString *remark;//车厢专用
@property (nonatomic,strong) NSString *type;//车厢专用
@property (nonatomic,strong) NSString *name;//车厢专用
@property (nonatomic,strong) NSString *create_time;//车厢专用
@property (nonatomic,strong) NSString *order_no;//
@property (nonatomic,strong) NSString *order_status;//wait_pending:待审核,wait_pay:待支付,fail:失败
@end

NS_ASSUME_NONNULL_END
