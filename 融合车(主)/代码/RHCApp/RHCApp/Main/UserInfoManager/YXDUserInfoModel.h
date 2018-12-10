//
//  YXDUserInfoModel.h
//  YXDApp
//
//  Created by daishaoyang on 2017/12/8.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <JSONModel.h>
//#import "BaseModel.h"
//@protocol YXDUserInfoModel <NSObject>
//
//@end
@interface YXDUserInfoModel : JSONModel

@property (nonatomic, copy) NSString *userId;//用户id
@property (nonatomic, copy) NSString *state;//
@property (nonatomic, copy) NSString *name;//xing'min
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *sex;//用户性别
@property (nonatomic, copy) NSString *phone;//
@property (nonatomic, copy) NSString *numberCard;//
@property (nonatomic, copy) NSString *headimg;//图像
@property (nonatomic, copy) NSString *oldPhone;//
@property (nonatomic, copy) NSString *token;

@end
