//
//  ListModel.h
//  ExpandFrameModel
//
//  Created by 栗子 on 2017/12/6.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ListModel : BaseModel

//@property (nonatomic, copy) NSString *question;
//@property (nonatomic, copy) NSString *answer;
//@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *question;
@property (nonatomic,strong) NSString *answer;
@property (nonatomic,strong) NSString *clickCount;
@property (nonatomic,strong) NSString *type;
@property (nonatomic, assign) BOOL isSelected;

@end
