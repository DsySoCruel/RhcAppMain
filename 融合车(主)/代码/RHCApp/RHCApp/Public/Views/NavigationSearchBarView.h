//
//  NavigationSearchBarView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/6/21.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,NavigationSearchBarType) {
    NavigationSearchBarTypeHome ,//首页
    NavigationSearchBarTypeFind,//发现
    NavigationSearchBarTypeCarStore,//汽车超市
    NavigationSearchBarTypeTruckStore,//卡车超市
    NavigationSearchBarTypeAccessoriesStore,//配件超市
    NavigationSearchBarTypeSearchView,//配件超市
};

@class NavigationSearchBarView;
@protocol NavigationSearchBarViewDelegate<NSObject>
@optional
- (void)searchViewReturnButtonClicked:(UITextField *)searchBar;
- (void)searchViewTextDidBeginEditing:(UITextField *)searchBar;
- (void)searchBar:(UITextField *)searchBar textDidChange:(NSString *)searchText;
@end

@interface NavigationSearchBarView : UIView

@property (nonatomic, assign) CGFloat headerHeight;
- (void)changeAlphaWithOffset:(CGFloat)offset;
- (instancetype)initWithType:(NavigationSearchBarType)type;

//输入搜索设置
@property (nonatomic, weak)   id<NavigationSearchBarViewDelegate> searchDelegate;
@property (nonatomic, strong) UITextField *searchField;//搜索界面

- (void)didCloseTapBlock:(void(^)(UITextField *obj))tapAction;
- (void)searchShouldChangeText:(void(^)(UITextField *obj,NSRange range,NSString *string))block;
@end
