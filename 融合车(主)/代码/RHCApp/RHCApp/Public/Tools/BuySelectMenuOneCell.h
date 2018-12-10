//
//  BuySelectMenuOneCell.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuySelectMenuOneCell : UITableViewCell
@property (nonatomic, copy) void(^selectBlock)(NSString *str);//选中
- (void)config:(NSArray *)itemArray andTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
