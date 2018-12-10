//
//  CircleVCListCellTopView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import <UIKit/UIKit.h>
#import "CircleViewControllerListModel.h"
#import "CircleCommendModel.h"
#import "HomeViewListModel.h"

@interface CircleVCListCellTopView : UIView

@property (nonatomic,strong) CircleViewControllerListModel *model;//
@property (nonatomic,strong) CircleCommendModel *commodel;//评论头部
@property (nonatomic,strong) HomeViewListModel *homeModel;
@end
