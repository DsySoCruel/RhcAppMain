//
//  EditAddressController.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/17.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "BaseViewController.h"

@class AddressModel;

@interface EditAddressController : BaseViewController

@property (nonatomic,strong) AddressModel *model;//编辑和新增

@property (nonatomic, copy) void(^addSuccessBlock)(void);//新增成功 就行刷新

@end
