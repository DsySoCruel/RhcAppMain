//
//  PayViewOrderModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/29.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayViewOrderModel : BaseModel
@property (nonatomic,strong) NSString *oid;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *order_no;
@end

NS_ASSUME_NONNULL_END
