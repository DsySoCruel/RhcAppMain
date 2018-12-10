//
//  KMHomePageView.h
//  Scimall
//
//  Created by daishaoyang on 2017/6/28.
//  Copyright © 2017年 贾培军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMHomePageView : UIScrollView

@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *unselectedFont;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *unselectedColor;
@property (nonatomic, strong) UIColor *topTabBottomLineColor;
@property (nonatomic, assign) CGFloat leftSpace;
@property (nonatomic, assign) CGFloat rightSpace;
@property (nonatomic, assign) CGFloat minSpace;
@property (nonatomic, assign) CGFloat bottomSpace;//下边的间距
@property (nonatomic, assign) NSInteger defaultSubscript;//手动设置偏移页数

/**
 default 20.
 For translucent status bar
 */
@property (nonatomic, assign) CGFloat topSpace;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

/**
 default YES.
 */
@property (nonatomic, assign) BOOL isAdapteNavigationBar;
/**
 default NO. 文字选中动画
 */
@property (nonatomic, assign) BOOL isAnimated;
/**
 default YES. 工具条是否显示图片或者背景颜色（YES：为白色 NO：为主题色）
 */
@property (nonatomic, assign) BOOL isTranslucent;
/**
 default YES
 */
@property (nonatomic, assign) BOOL isAverage;
/**
 default NO
 */
@property (nonatomic, assign) BOOL isHaveOA;//是否有我的组织(设置带箭头的OAtitleButton)
/**
 第二参数数组（需要的时候进行赋值）
 */
@property (nonatomic, strong) NSArray *parametersTwo;//第二参数属性


//以下为外部调用说明
/**
 用于外部获取当前偏移的location
 */
@property (assign, nonatomic) NSInteger currentPage;//当前滑动的页数

/**
 *
 *重点必考
 *1.传入的控制器想要获取传入的parameter 只需要在.m文件中声明 @property (nonatomic,copy) NSString *parameter;就可以使用此parameter
 *2.当前的控制器 view 刷新数据之后 如果需要提示刷新数据的数量 只需要发送提示的通知 例如：
 *  [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowNewStatusCount" object:@5];
 */

/**
 
 @param frame       ...
 @param titles      展示的分类 title
 @param controllers 每个 title对应的控制器
 @param parameters  每个控制器对应的 type （需要在控制器中设置(NSString *)parameter属性）用于请求不同的页面数据 
 
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withViewControllers:(NSArray *)controllers withParameters:(NSArray *)parameters;

- (void)scrollToFirst;

- (void)scrollToPageView:(NSInteger)index;

@end
