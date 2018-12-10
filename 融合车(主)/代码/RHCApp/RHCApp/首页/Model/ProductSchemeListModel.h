//
//  ProductSchemeListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface ProductSchemeListMCModel : BaseModel
@property (nonatomic,strong) NSString *monthly_coefficient;//月供系数
@property (nonatomic,strong) NSString *poundage;//手续费
@end

@interface ProductSchemeListModel : BaseModel
@property (nonatomic,strong) NSArray  *list;//
@end
@interface ProductSchemeModel : BaseModel
@property (nonatomic,strong) NSString *monthly_coefficient;//月供系数
@property (nonatomic,strong) NSString *number_of_periods;//分期期数
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *down_payment_rate;//首付比例 需要*0.01
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *down_payment;//
@property (nonatomic,strong) NSArray  *MCList;//

@end

NS_ASSUME_NONNULL_END
