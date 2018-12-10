//
//  MIngxiController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/11/8.
//

#import "BaseViewController.h"
#import "CarDetailModel.h"
#import "ProductSchemeListModel.h"//默认分期参数
NS_ASSUME_NONNULL_BEGIN

@interface MIngxiController : BaseViewController
@property (nonatomic,strong) CarDetailModel *model;
@property (nonatomic,strong) ProductSchemeListModel *productSchemeListModel;
@end

NS_ASSUME_NONNULL_END
