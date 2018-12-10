//
//  MyAddressControllerCell.h
//  YXDApp
//
//  Created by daishaoyang on 2017/11/17.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAddressModel;

@interface MyAddressControllerCell : UITableViewCell

@property (nonatomic,strong)  MyAddressModel *model;

@property (nonatomic, copy) void(^updataCell)(NSString *addressId);

@property (nonatomic, copy) void(^deleCellBlock)(NSString *addressId);

@end
