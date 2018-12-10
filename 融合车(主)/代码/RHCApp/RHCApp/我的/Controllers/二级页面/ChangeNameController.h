//
//  ChangeNameController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/20.
//

#import "BaseViewController.h"

@interface ChangeNameController : BaseViewController
@property (nonatomic, copy) void(^block)(void);
@end
