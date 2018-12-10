//
//  MessageViewCell.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/24.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewCell : UITableViewCell
@property (nonatomic,strong) MessageListDetailModel *model;
@end

NS_ASSUME_NONNULL_END
