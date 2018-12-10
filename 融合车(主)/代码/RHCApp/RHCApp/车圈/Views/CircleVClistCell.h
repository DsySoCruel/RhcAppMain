//
//  CircleVClistCell.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import <UIKit/UIKit.h>
#import "CircleViewControllerListModel.h"
#import "HomeViewListModel.h"
@interface CircleVClistCell : UITableViewCell
@property (nonatomic,strong) CircleViewControllerListModel *model;
@property (nonatomic,strong) HomeViewListModel *homeModel;
@end
