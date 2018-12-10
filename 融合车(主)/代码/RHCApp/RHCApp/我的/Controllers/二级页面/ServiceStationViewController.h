//
//  ServiceStationViewController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/6/28.
//

#import "BaseViewController.h"

@interface ServiceStationViewController : BaseViewController
//返回选择的服务网点地址和id
@property (nonatomic, copy) void(^selectCarShopBlock)(NSString *carshopName,NSString *carshopId);//选中的城市
@end
