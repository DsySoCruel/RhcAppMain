//
//  BuySelectMenuTagView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuySelectMenuTagView : UIView
@property (nonatomic, copy) void(^selectBlock)(NSString *str);//选中
- (void)config:(NSArray *)itemArray;
+ (CGFloat)cellHeightWithArray:(NSArray *)itemArray;
@end

NS_ASSUME_NONNULL_END
