//
//  SearchHistoryView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/11/6.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const SearchHistoryText;       // 搜索历史文本 默认为 @"搜索记录"
UIKIT_EXTERN NSString *const HotSearchText;           // 热门搜索文本 默认为 @"热门搜索"

typedef void (^ReturnKeyboardBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryView : UIView
@property (nonatomic,strong)  NSMutableArray     *item;//热门搜索记录
@property (nonatomic, strong) NSMutableArray     *dataSource;
@property (nonatomic, copy)   ReturnKeyboardBlock keyboardBlock;
#pragma makr -- 点击搜索记录和热门搜索
- (void)didSelectedTapBlock:(void(^)(id obj,NSInteger section))tapAction;
- (void)didTapCollectionViewBlock:(ReturnKeyboardBlock)tapAction;
- (void)loadDataView;
@end

NS_ASSUME_NONNULL_END
