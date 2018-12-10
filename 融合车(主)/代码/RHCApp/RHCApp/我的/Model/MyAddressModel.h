//
//  MyAddressModel.h
//  YXDApp
//
//  Created by daishaoyang on 2017/12/12.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAddressModel : NSObject

@property (nonatomic,strong) NSString *addressId;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *isDefault;//是否是默认地址
@property (nonatomic,strong) NSString *area_names;

@property (nonatomic,strong) NSString *areaId1;
@property (nonatomic,strong) NSString *areaId2;
@property (nonatomic,strong) NSString *areaId3;
@property (nonatomic,strong) NSString *communityId;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *xiaoqu;
@property (nonatomic,strong) NSString *postCode;
@property (nonatomic,strong) NSString *addressFlag;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *areaName1;
@property (nonatomic,strong) NSString *areaName2;
@end
