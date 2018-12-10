//
//  KMHomePageView.m
//  Scimall
//
//  Created by daishaoyang on 2017/6/28.
//  Copyright © 2017年 贾培军. All rights reserved.
//

#define LEFT_SPACE 20
#define RIGHT_SPACE 20
#define MIN_SPACING 20
#define TAB_HEIGHT 44
#define LINEBOTTOM_WIDTH 20.0 //指示条的宽度
#define LINEBOTTOM_HEIGHT 0 //指示条的高度
#define TOPBOTTOMLINEBOTTOM_HEIGHT .5
#define SELECTED_COLOR [UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1.0]
#define UNSELECTED_COLOR [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]
#define TPOTABBOTTOMLINE_COLOR [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]

#import "KMHomePageView.h"
#import <objc/runtime.h>
//#import "TabNaviUpdateManager.h"
//#import "TabAndNavInfoManager.h"
#import "YXDButton.h"
//#import "HomeOrganizationController.h"

@interface KMHomePageView ()<UIScrollViewDelegate>
@property (nonatomic, assign) BOOL           isChangeColor;//是否改变导航栏颜色
@property (strong, nonatomic) UIImageView    *leftImage;
@property (strong, nonatomic) UIImageView    *rightImage;
@property (strong, nonatomic) UIImageView    *topTabView;
@property (strong, nonatomic) UIScrollView   *topTabScrollView;
@property (strong, nonatomic) UIScrollView   *scrollView;
@property (strong, nonatomic) NSMutableArray *strongArray;
@property (strong, nonatomic) UIViewController *viewController;//当前 view 添加到的 controller(在本页面获取)
@property (nonatomic, strong) YXDButton *firstButton;
@property (nonatomic, strong) YXDButton *OAButton;
@property (nonatomic, assign) BOOL isNeedRemove;//是否需要移除监听
@property (nonatomic, assign) BOOL isNeedAlert;
@property (nonatomic, assign) CGRect selfFrame;
@end


@implementation KMHomePageView
{
    
    NSInteger _topTabScrollViewWidth;
    
    NSArray        <NSString *> *_titles;
    NSMutableArray *_viewControllers;
    NSArray        *_parameters;
    UIView         *_lineBottom;
    NSMutableArray *_titleButtons;
    NSMutableArray *_titleSizeArray;
    NSMutableArray *_centerPoints;
    
    NSMutableArray *_width_k_array;
    NSMutableArray *_width_b_array;
    NSMutableArray *_point_k_array;
    NSMutableArray *_point_b_array;
}


#pragma mark - set Method

//设置选择颜色
- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor              = selectedColor;
    _lineBottom.backgroundColor = selectedColor;
    [self updateSelectedPage:0];
}

- (void)setUnselectedColor:(UIColor *)unselectedColor{
    _unselectedColor    = unselectedColor;
    [self updateSelectedPage:0];
}

#pragma mark - Initializes Method
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withViewControllers:(NSArray *)controllers withParameters:(NSArray *)parameters{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.scrollsToTop      = NO;
        _selfFrame             = frame;
        _selectedColor         = SELECTED_COLOR;
        _unselectedColor       = UNSELECTED_COLOR;
        _leftSpace             = LEFT_SPACE;
        _rightSpace            = RIGHT_SPACE;
        _minSpace              = MIN_SPACING;
        _topTabBottomLineColor = TPOTABBOTTOMLINE_COLOR;
        _titles                = titles;
        _viewControllers       = [NSMutableArray arrayWithArray:controllers];
        _parameters            = parameters;
        _topSpace              = SM_iPhoneX ? 44 : 20;
        _isAverage             = YES;
        _isTranslucent         = YES;
        _isAnimated            = NO;
        _isAdapteNavigationBar = YES;
        _isNeedAlert = YES;
        _bottomSpace           = 0;
        //接收提示加载数据数量的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewStatusCount:) name:@"kShowNewStatusCount" object:nil];
        //更新首页导航条背景色
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavigationBarColor:) name:UpdateNavigationBarColor object:nil];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _viewController = [self findViewController:self];
    if (_viewController.navigationController && !_viewController.navigationController.navigationBar.hidden && !_viewController.navigationController.navigationBarHidden) {
        _topSpace = 0;
    }
    _selectedFont = _selectedFont?_selectedFont:[UIFont systemFontOfSize:17];
    [self addSubview:self.scrollView];//内容区域
    [self addSubview:self.topTabView];//头部View
    [self.topTabView addSubview:self.topTabScrollView];
    
    //最后添加模糊效果
    if (self.leftButton) {
        [self.topTabView addSubview:self.leftImage];
    }
    if (self.rightButton) {
//        [self.topTabView addSubview:self.rightImage];
    }
    [self setLeftAndRightBlurWithIsDefault:!self.isChangeColor];
}

#pragma mark - lazy
- (UIImageView *)topTabView{
    if (!_topTabView){
        CGFloat y = 0;
        if (_viewController.navigationController && (_viewController.navigationController.navigationBar.hidden || _viewController.navigationController.navigationBarHidden)){
            y = 0;
        }
        if (_viewController.navigationController && !_viewController.navigationController.navigationBar.hidden && !_viewController.navigationController.navigationBarHidden && !_isAdapteNavigationBar) {
            y = -64;
        }
        CGRect frame = CGRectMake(0, y, _selfFrame.size.width, TAB_HEIGHT + _topSpace);
        _topTabView  = [[UIImageView alloc] initWithFrame:frame];
        _topTabView.userInteractionEnabled = YES;
        if (_isTranslucent) {
            //            UIToolbar *backView = [[UIToolbar alloc] initWithFrame:_topTabView.bounds];
            //            backView.barStyle   = UIBarStyleDefault;
            //            [_topTabView addSubview:backView];
            _topTabView.backgroundColor = [UIColor whiteColor];
        }else{
            if (self.isChangeColor) {
//                NSString *bgColor = [TabAndNavInfoManager sharedInstance].tabAndNaviInfoModel.navigation.bgColor;
//                _topTabView.backgroundColor = [UIColor colorWithHexString:bgColor];
//                _topTabView.image = nil;
            }else{
                _topTabView.image = IMAGECACHE(@"navigationbarBack_purple");
            }
        }
        if (self.leftButton) {
            self.leftButton.center = CGPointMake(self.leftButton.bounds.size.width / 2, TAB_HEIGHT / 2 + _topSpace);
            [_topTabView addSubview:self.leftButton];
        }
        if (self.rightButton) {
            self.rightButton.center = CGPointMake(_selfFrame.size.width - self.rightButton.bounds.size.width / 2, TAB_HEIGHT / 2 + _topSpace);
            [_topTabView addSubview:self.rightButton];
        }
        UIView *topTabBottomLine = [UIView new];
        topTabBottomLine.frame = CGRectMake(0, TAB_HEIGHT + _topSpace - TOPBOTTOMLINEBOTTOM_HEIGHT, _selfFrame.size.width, TOPBOTTOMLINEBOTTOM_HEIGHT);
        topTabBottomLine.backgroundColor = _topTabBottomLineColor;
        [_topTabView addSubview:topTabBottomLine];
    }
    return _topTabView;
}

//
- (UIScrollView *)topTabScrollView{
    if (!_topTabScrollView){
        CGFloat leftWidth  = 0;
        CGFloat rightWidth = 0;
        if (self.leftButton) {
            leftWidth = self.leftButton.bounds.size.width;
        }
        if (self.rightButton) {
            rightWidth = self.rightButton.bounds.size.width;
        }
        _topTabScrollViewWidth = _selfFrame.size.width - leftWidth - rightWidth;
        CGRect frame = CGRectMake(leftWidth, _topSpace + _topTabView.frame.origin.y, _topTabScrollViewWidth, TAB_HEIGHT);
        _topTabScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _topTabScrollView.showsHorizontalScrollIndicator = NO;
        _topTabScrollView.alwaysBounceHorizontal = YES;
        _topTabScrollView.scrollsToTop = NO;
        
        CGFloat totalWidth = 0;
        _titleSizeArray    = [NSMutableArray array];
        CGFloat equalX     = _leftSpace;
        NSMutableArray *equalIntervals = [NSMutableArray array];
        
        for (NSInteger i = 0; i<_titles.count; i++) {
            CGSize titleSize = [_titles[i] sizeWithAttributes:@{NSFontAttributeName:_selectedFont}];
            //加入字数不能超过一定宽度的验证2.11
            if (titleSize.width > 120) {
                titleSize.width = 120;
            }
            if (self.isHaveOA && i == 1) {
                titleSize.width += 12;//待改 增加的宽度是真实箭头图标的宽度
            }
            [_titleSizeArray addObject:[NSValue valueWithCGSize:titleSize]];
            totalWidth += titleSize.width;
            [equalIntervals addObject:[NSNumber numberWithFloat:(equalX + titleSize.width/2)]];
            equalX += _minSpace + titleSize.width;
        }
        CGFloat dividend = _titles.count>1?_titles.count-1:1;
        CGFloat minWidth = (_topTabScrollViewWidth - totalWidth - _leftSpace - _rightSpace) / dividend;
        CGFloat averageX = _leftSpace;
        if (_isAverage) {
            minWidth = (_topTabScrollViewWidth - totalWidth) / (_titles.count + 1);
            averageX = minWidth;
        }
        NSMutableArray *averageIntervals = [NSMutableArray array];
        for (NSInteger i=0; i<_titles.count; i++) {
            [averageIntervals addObject:[NSNumber numberWithDouble:(averageX + [_titleSizeArray[i] CGSizeValue].width/2)]];
            averageX += minWidth + [_titleSizeArray[i] CGSizeValue].width;
        }
        totalWidth += (_titles.count - 1) * _minSpace + _leftSpace + _rightSpace;
        NSMutableArray *centerPoints;
        if (totalWidth > _topTabScrollViewWidth){
            centerPoints = equalIntervals;
        }else{
            centerPoints = averageIntervals;
            totalWidth = _topTabScrollViewWidth;
        }
        _centerPoints = centerPoints;
        _width_k_array = [NSMutableArray array];
        _width_b_array = [NSMutableArray array];
        _point_k_array = [NSMutableArray array];
        _point_b_array = [NSMutableArray array];
        
        for (NSInteger i=0; i<_titles.count-1 && i + 1 < _centerPoints.count; i++) {
            CGFloat k = ([_centerPoints[i+1] floatValue] - [_centerPoints[i] floatValue])/_selfFrame.size.width;
            CGFloat b = [_centerPoints[i] floatValue] - k * i * _selfFrame.size.width;
            [_width_k_array addObject:[NSNumber numberWithFloat:k]];
            [_width_b_array addObject:[NSNumber numberWithFloat:b]];
        }
        for (NSInteger i=0; i<_titles.count-1 && i + 1 < _titleSizeArray.count; i++) {
            CGFloat k = ([_titleSizeArray[i+1] CGSizeValue].width - [_titleSizeArray[i] CGSizeValue].width)/_selfFrame.size.width;
            CGFloat b = [_titleSizeArray[i] CGSizeValue].width - k * i * _selfFrame.size.width;
            [_point_k_array addObject:[NSNumber numberWithFloat:k]];
            [_point_b_array addObject:[NSNumber numberWithFloat:b]];
        }
        
        _topTabScrollView.contentSize = CGSizeMake(totalWidth, 0);
        _titleButtons = [NSMutableArray array];
        for (NSInteger i=0; i<_titles.count; i++) {
            YXDButton *titleButton = [YXDButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag = i;
            [_titleButtons addObject:titleButton];
            //            titleButton.titleLabel.font = _selectedFont;
            [titleButton setTitle:_titles[i] forState:UIControlStateNormal];
            titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            CGFloat x = [_centerPoints[i] floatValue];
            CGFloat width = [_titleSizeArray[i] CGSizeValue].width;
            CGRect buttonFrame = CGRectMake(x - width/2, 0, width, TAB_HEIGHT);
            titleButton.frame = buttonFrame;
            [_topTabScrollView addSubview:titleButton];
            [titleButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.firstButton = titleButton;
            }
            if (self.isHaveOA && i == 1) {//列表里有组织OA的情况
                [titleButton setImage:IMAGECACHE(@"OA_jiantouW") forState:UIControlStateNormal];
                [titleButton setImage:IMAGECACHE(@"OA_jiantou") forState:UIControlStateSelected];
                titleButton.status = MoreStyleStatusCenter;
                titleButton.padding = 3;
                titleButton.selected = NO;
                self.OAButton = titleButton;
                if (self.defaultSubscript == i) {
                    titleButton.selected = YES;
                }else{
                    titleButton.selected = NO;
                }
                //设置OA titleButton （动画旋转）
//                for (NSInteger j = 0; j < self.strongArray.count; j++) {
//                    id obj = self.strongArray[j];
//                    if ([[obj class] isSubclassOfClass:[HomeOrganizationController class]]) {
//                        HomeOrganizationController *viewController = obj;
//                        [viewController setValue:self.OAButton forKey:@"titleButton"];
//                        break;
//                    }
//                }
            }
        }
        [self updateSelectedPage:self.defaultSubscript];
        [_scrollView setContentOffset:CGPointMake(_selfFrame.size.width * self.defaultSubscript, 0) animated:NO];
        
        UIView *topTabBottomLine = [UIView new];
        topTabBottomLine.frame = CGRectMake(-totalWidth, TAB_HEIGHT - TOPBOTTOMLINEBOTTOM_HEIGHT, totalWidth*3, TOPBOTTOMLINEBOTTOM_HEIGHT);
        topTabBottomLine.backgroundColor = _topTabBottomLineColor;
        [_topTabScrollView addSubview:topTabBottomLine];
        
        //_lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, TAB_HEIGHT - LINEBOTTOM_HEIGHT,[_titleSizeArray[self.defaultSubscript] CGSizeValue].width, LINEBOTTOM_HEIGHT)];
        _lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, TAB_HEIGHT - LINEBOTTOM_HEIGHT,LINEBOTTOM_WIDTH, LINEBOTTOM_HEIGHT)];//修改下划线的宽度
        if (self.defaultSubscript < centerPoints.count) {
            _lineBottom.center = CGPointMake([centerPoints[self.defaultSubscript] floatValue], _lineBottom.center.y);
        }
        _lineBottom.backgroundColor = _selectedColor;
        [_topTabScrollView addSubview:_lineBottom];
        
        NSInteger page = self.defaultSubscript;
        if (page < _centerPoints.count) {
            CGFloat offset = [_centerPoints[page] floatValue];
            if (offset < _topTabScrollViewWidth/2) {
                [_topTabScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }else if(offset+_topTabScrollViewWidth/2 <_topTabScrollView.contentSize.width) {
                [_topTabScrollView setContentOffset:CGPointMake(offset-_topTabScrollViewWidth/2, 0) animated:YES];
            }else{
                [_topTabScrollView setContentOffset:CGPointMake(_topTabScrollView.contentSize.width-_topTabScrollViewWidth, 0) animated:YES];
            }
        }
        
        
    }
    return _topTabScrollView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollsToTop = NO;
        
        CGFloat y = 0;
        if (_viewController.navigationController && !_viewController.navigationController.navigationBar.hidden && !_viewController.navigationController.navigationBarHidden) {
            y = -64;
        }else if (_viewController.navigationController && (_viewController.navigationController.navigationBar.hidden || _viewController.navigationController.navigationBarHidden)){
            y = 0;
        }
        
        _scrollView.frame = CGRectMake(0, y + _bottomSpace, _selfFrame.size.width, _selfFrame.size.height);
        _scrollView.delegate = self;
        _scrollView.backgroundColor = SMViewBGColor;
        _scrollView.contentSize = CGSizeMake(_selfFrame.size.width * _titles.count, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        [self addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionNew context:nil];
        self.isNeedRemove = YES;//需要移除监听
        self.currentPage = self.defaultSubscript;
    }
    return _scrollView;
}

- (NSMutableArray *)strongArray{
    if (!_strongArray){
        _strongArray = [NSMutableArray arrayWithArray:_viewControllers];
    }
    return _strongArray;
}

#pragma mark - Calculation Method

- (CGFloat)getTitleWidth:(CGFloat)offset{
    NSInteger index = (NSInteger)(offset / _selfFrame.size.width);
    CGFloat k = [_width_k_array[index] floatValue];
    CGFloat b = [_width_b_array[index] floatValue];
    CGFloat x = offset;
    return  k * x + b;
}

- (CGFloat)getTitlePoint:(CGFloat)offset{
    NSInteger index = (NSInteger)(offset / _selfFrame.size.width);
    CGFloat k = [_point_k_array[index] floatValue];
    CGFloat b = [_point_b_array[index] floatValue];
    CGFloat x = offset;
    return  k * x + b;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPage = (NSInteger)((scrollView.contentOffset.x + _selfFrame.size.width / 2) / _selfFrame.size.width);
    if (self.isHaveOA && self.currentPage != 1) {
        self.OAButton.selected = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.currentPage = (NSInteger)((scrollView.contentOffset.x + _selfFrame.size.width / 2) / _selfFrame.size.width);
    if (self.isHaveOA && self.currentPage != 1) {
        self.OAButton.selected = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x<=0 || scrollView.contentOffset.x >= _selfFrame.size.width * (_titles.count-1)) {
        return;
    }
    _lineBottom.center = CGPointMake([self getTitleWidth:scrollView.contentOffset.x], _lineBottom.center.y);
    //_lineBottom.bounds = CGRectMake(0, 0, [self getTitlePoint:scrollView.contentOffset.x], LINEBOTTOM_HEIGHT);
    _lineBottom.bounds = CGRectMake(0, 0, LINEBOTTOM_WIDTH, LINEBOTTOM_HEIGHT);//修改下划线的宽度
    CGFloat page = (NSInteger)((scrollView.contentOffset.x + _selfFrame.size.width / 2) / _selfFrame.size.width);
    [self updateSelectedPage:page];
}

#pragma mark - My Method

- (void)scrollToFirst {
    //[self performSelector:@selector(touchAction:)];
    [self touchAction:self.firstButton];
}

- (void)touchAction:(UIButton *)button {
    [_scrollView setContentOffset:CGPointMake(_selfFrame.size.width * button.tag, 0) animated:YES];
    //给组织OA界面发送通知
    if (self.isHaveOA && button.tag == 1) {
        if (button.selected) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeOrganizationControllerNotification" object:nil];
        }
        button.selected = YES;
    }else{
        self.OAButton.selected = NO;
    }
}

- (void)scrollToPageView:(NSInteger)index {
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.selfFrame.size.width * index, 0) animated:YES];
    }];
}

- (void)updateSelectedPage:(NSInteger)page{
    for (UIButton *button in _titleButtons) {
        if (button.tag == page) {
            [button setTitleColor:_selectedColor forState:UIControlStateNormal];
            button.titleLabel.font = _selectedFont;
            if (_isAnimated) {
                [UIView animateWithDuration:0.3 animations:^{
                    button.transform = CGAffineTransformMakeScale(1.0, 1.0);//缩放
                }];
            }
            if (self.isHaveOA && page == 1) {
                button.selected = YES;
            }
        }else{
            [button setTitleColor:_unselectedColor forState:UIControlStateNormal];
            button.titleLabel.font = _unselectedFont;
            if (_isAnimated) {
                [UIView animateWithDuration:0.3 animations:^{
                    button.transform = CGAffineTransformIdentity;
                }];
            }
        }
    }
}

- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target = sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

- (BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)name{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            free(ivars);
            return YES;
        }
    }
    free(ivars);
    return NO;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentPage"]) {
        NSInteger page = [change[@"new"] integerValue];
        CGFloat offset = [_centerPoints[page] floatValue];
        if (offset < _topTabScrollViewWidth/2) {
            [_topTabScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if(offset+_topTabScrollViewWidth/2 <_topTabScrollView.contentSize.width) {
            [_topTabScrollView setContentOffset:CGPointMake(offset-_topTabScrollViewWidth/2, 0) animated:YES];
        }else{
            [_topTabScrollView setContentOffset:CGPointMake(_topTabScrollView.contentSize.width-_topTabScrollViewWidth, 0) animated:YES];
        }
        for (NSInteger i = 0; i < _viewControllers.count; i++) {
            if (page == i) {
                NSString *className = _viewControllers[page];
                
                for (NSInteger j=0; j<self.strongArray.count; j++) {
                    id obj = self.strongArray[j];
                    if ([[obj class] isSubclassOfClass:[UIViewController class]]) {
                        UIViewController *viewController = obj;
                        if ([viewController.view.class isSubclassOfClass:[UIScrollView class]]) {
                            UIScrollView *view = (UIScrollView *)viewController.view;
                            if (j == page) {
                                view.scrollsToTop = YES;
                            }else{
                                view.scrollsToTop = NO;
                            }
                        }
                        if ([NSStringFromClass([viewController.view class]) isEqualToString:@"UICollectionViewControllerWrapperView"]) {
                            UIScrollView *view = (UIScrollView *)viewController.view.subviews[0];
                            if (j == page) {
                                view.scrollsToTop = YES;
                            }else{
                                view.scrollsToTop = NO;
                            }
                        }
                    }
                }
                
                //Create only once
                if ([className isEqualToString:@"HYPAGEVIEW_AlreadyCreated"]) {
                    return;
                }
                Class class = NSClassFromString(className);
                
                UIViewController *viewController = class.new;
                self.strongArray[i] = viewController;
                
                if (_parameters && _parameters.count > i && _parameters[i] && [self getVariableWithClass:viewController.class varName:@"parameter"]) {
                    [viewController setValue:_parameters[i] forKey:@"parameter"];
                }
                if (_parametersTwo && _parametersTwo.count > i && _parametersTwo[i] && [self getVariableWithClass:viewController.class varName:@"parameterTwo"]) {
                    [viewController setValue:_parametersTwo[i] forKey:@"parameterTwo"];
                }
                
                CGFloat offset = _topSpace + TAB_HEIGHT;
                if (_viewController.navigationController && !_viewController.navigationController.navigationBar.hidden && !_viewController.navigationController.navigationBarHidden && _isAdapteNavigationBar) {
                    offset += 64;
                }
                
                CGFloat ViewH = self.isTranslucent ? _scrollView.bounds.size.height - offset : _scrollView.bounds.size.height - offset - 44;
                
                CGRect frame = CGRectMake(_selfFrame.size.width * i, offset, _selfFrame.size.width, ViewH);
                
                if ([viewController.view.class isSubclassOfClass:[UIScrollView class]]) {
                    UIScrollView *view = (UIScrollView *)viewController.view;
                    view.contentInset = UIEdgeInsetsMake(offset, 0, 49, 0);
                    view.contentOffset = CGPointMake(0,-offset);
                    frame = CGRectMake(_selfFrame.size.width * i, 0, _selfFrame.size.width, _scrollView.bounds.size.height);
                }
                if ([NSStringFromClass([viewController.view class]) isEqualToString:@"UICollectionViewControllerWrapperView"]) {
                    UIScrollView *view = (UIScrollView *)viewController.view.subviews[0];
                    view.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
                    view.contentOffset = CGPointMake(0,-offset);
                    frame = CGRectMake(_selfFrame.size.width * i, 0, _selfFrame.size.width, _scrollView.bounds.size.height);
                }
                //组织OA
                if ([NSStringFromClass([viewController class]) isEqualToString:@"HomeOrganizationController"]) {
                    [viewController setValue:self.OAButton forKey:@"titleButton"];
                }
                viewController.view.frame = frame;
                [self.scrollView addSubview:viewController.view];
                _viewControllers[page] = @"HYPAGEVIEW_AlreadyCreated";
                
                [_viewController addChildViewController:viewController];
            }
        }
    }
}

/**
 *  提示最新资讯的数量
 */
- (void)showNewStatusCount:(NSNotification *)info
{
    if (self.isNeedAlert) {
        self.isNeedAlert = NO;
        // 添加一个label到导航控制器的view中
        // 1.创建label
        UIView *presentView = [UIView new];
        presentView.backgroundColor = RGBA(0x5659E0,.7);
        UIImageView *image = [[UIImageView alloc] initWithImage:IMAGECACHE(@"fill1")];
        image.contentMode = UIViewContentModeCenter;
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = LPFFONT(16);
        
        [self.scrollView addSubview:presentView];
        
        
        if (!(info.object)) {
            label.text = @"将减少推荐类似内容";
        }else{
            NSInteger count = [info.object integerValue];
            // 设置文字
            if (count) {
                label.text = [NSString stringWithFormat:@"新增%tu条资讯内容", count];
            } else {
                label.text = @"没有新的资讯数据";
            }
        }
        
        // 2.计算位置
        presentView.rcm_width = self.navigationController.view.rcm_width;
        presentView.rcm_height = 35;
        presentView.rcm_x = self.currentPage * self.scrollView.rcm_width;
        presentView.alpha = 0.0;
        presentView.rcm_y = self.isTranslucent ? self.topTabView.rcm_height + 64  - presentView.rcm_height : self.topTabView.rcm_height - presentView.rcm_height;
        
        [presentView addSubview:label];
        [label sizeToFit];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(presentView.mas_centerY);
            make.centerX.equalTo(presentView.mas_centerX).offset(10);
            
        }];
        
        [presentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label.mas_centerY);
            make.right.equalTo(label.mas_left).offset(-5);
        }];
        
        // 3.让label慢慢下来
        [UIView animateWithDuration:0.5 animations:^{
            // 往下移动一个label的高度
            presentView.transform = CGAffineTransformMakeTranslation(0, presentView.rcm_height);
            // 让透明度慢慢变为1
            presentView.alpha = 1.0;
        } completion:^(BOOL finished) { // 往下移动完毕就会调用
            // 延迟一段时间后, 让label慢慢回去
            self.isNeedAlert = YES;
            [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                // label回到原来的位置
                presentView.transform = CGAffineTransformIdentity;
                
                // 让透明度慢慢变为0
                presentView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 将label从内存中移除
                [presentView removeFromSuperview];
            }];
        }];
        
    }
    
}

-(void)setLeftAndRightBlurWithIsDefault:(BOOL)isDefaultColor{
//    UIColor* bgcolor = isDefaultColor ? RGB(0x5659e0) : [UIColor colorWithHexString:[TabAndNavInfoManager sharedInstance].tabAndNaviInfoModel.navigation.bgColor];
    
    UIColor* bgcolor = SMThemeColor;
    UIColor* clearColor = [UIColor clearColor];
    self.leftImage.backgroundColor = bgcolor;
    self.rightImage.backgroundColor = bgcolor;
    //模糊效果
    if (self.leftButton && self.leftImage) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.leftImage.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)bgcolor.CGColor,(id)clearColor.CGColor, nil];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 0);
        self.leftImage.layer.mask = gradient;
    }
    if (self.rightButton && self.rightImage) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.rightImage.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)clearColor.CGColor,(id)bgcolor.CGColor, nil];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 0);
        self.rightImage.layer.mask = gradient;
    }
}

-(UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] initWithImage:IMAGECACHE(@"shadowClearLeft")];
        self.leftImage.contentMode = UIViewContentModeScaleAspectFill;
        self.leftImage.mj_size = CGSizeMake(15, 40);
        self.leftImage.center = CGPointMake(self.leftButton.bounds.size.width - 2 , TAB_HEIGHT / 2 + _topSpace - 2);
    }
    return _leftImage;
}

-(UIImageView *)rightImage{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] initWithImage:IMAGECACHE(@"shadowClearRight")];
        _rightImage.contentMode = UIViewContentModeScaleAspectFill;
        _rightImage.mj_size = CGSizeMake(0, 0);
//        _rightImage.mj_size = CGSizeMake(15, 40);
        _rightImage.center = CGPointMake(_selfFrame.size.width - self.rightButton.bounds.size.width, TAB_HEIGHT / 2 + _topSpace - 2);
    }
    return _rightImage;
}

- (void)dealloc
{
    if (self.isNeedRemove) {
        [self removeObserver:self forKeyPath:@"currentPage"];
        self.isNeedRemove = NO;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
