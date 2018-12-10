//
//  FindViewDetailViewNoneCell.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/16.
//

#import <UIKit/UIKit.h>
#import "FindViewListModel.h"
#import "HomeViewListModel.h"
@interface FindViewDetailViewNoneCell : UITableViewCell
@property (nonatomic,strong) FindViewListModel *model;
@property (nonatomic,strong) HomeViewListModel *homeModel;
@end
