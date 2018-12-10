//
//  BuyCarMenuView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/27.
//

#import <UIKit/UIKit.h>
#import "CarDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuyCarMenuView : UIView
@property (nonatomic, copy) void(^selectColorBlock)(NSString *colorName,NSString *colorId,NSString *inClorName,NSString *inColorId);

//1.购买配件的选择
-(id)initWithDataSource:(CarDetailModel *)model;

/** controller传nil 遮盖物是keyWindow */
- (void)showInView:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
