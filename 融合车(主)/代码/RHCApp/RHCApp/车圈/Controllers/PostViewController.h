//
//  PostViewController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "BaseViewController.h"

@interface PostViewController : BaseViewController
@property (nonatomic, copy) void(^updateOrderBlock)(void);//已评价 进行刷新

@end
