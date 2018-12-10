//
//  MyAddressController.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "BaseViewController.h"

@class MyAddressModel;

@interface MyAddressController : BaseViewController

@property (nonatomic,assign) BOOL isNeedSelect;//是否是从订单生成页面过来的

@property (nonatomic, copy) void(^selectAddressBlock)(MyAddressModel *addressModel);//选中的城市

@end
