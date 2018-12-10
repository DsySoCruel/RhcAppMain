//
//  ServiceStationSelectViewController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/11/8.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceStationSelectViewController : BaseViewController
//返回选择的服务网点地址和id
@property (nonatomic, copy) void(^selectCarShopBlock)(NSString *carshopName,NSString *carshopId);//选中的城市
@end

NS_ASSUME_NONNULL_END
