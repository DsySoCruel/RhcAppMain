//
//  SaoQRcodeViewController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/23.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaoQRcodeViewController : BaseViewController

/**
 扫一扫url
 */
@property (nonatomic, copy) void(^releaseContentBlock)(NSString *url);
/**
 扫一扫获取名片
 */
@property (nonatomic, copy) void(^getCardMessageBlock)(NSString *message);


@end

NS_ASSUME_NONNULL_END
