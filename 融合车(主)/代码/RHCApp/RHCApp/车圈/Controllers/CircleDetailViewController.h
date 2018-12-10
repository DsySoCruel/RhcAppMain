//
//  CircleDetailViewController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "BaseViewController.h"
#import "CircleViewControllerListModel.h"

@interface CircleDetailViewController : BaseViewController
@property (nonatomic,strong) CircleViewControllerListModel *model;
@property (nonatomic,strong) NSString *cid;
@end
