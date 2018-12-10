//
//  SelectCityController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/26.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectCityController : BaseViewController

@property (nonatomic, copy) void(^selectCityBlock)(NSString *cityName);//选中的城市

@end

NS_ASSUME_NONNULL_END
