//
//  SelectBrandNameController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/19.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectBrandNameController : BaseViewController
@property (nonatomic, copy) void(^selectCarBlock)(NSString *carName,NSString *carId);
@end

NS_ASSUME_NONNULL_END
