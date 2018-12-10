//
//  MyCollectionViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/22.
//

#import "MyCollectionViewController.h"
#import "MyCollectionViewDetailController.h"
#import "RHCSegmentView.h"

@interface MyCollectionViewController ()
<UIScrollViewDelegate>
@property (nonatomic, strong) RHCSegmentView *segmentViewTitle;
@property (nonatomic, weak)   UIScrollView  *scrollView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) NSInteger saveIndex;
@end

@implementation MyCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置titleView
    [self createSegmentView];
    [self setUpUI];
    [self setupChildViewControllers];
    self.saveIndex = 0;
}

- (void)createSegmentView{
    _segmentViewTitle = [[RHCSegmentView alloc] initWithFrame:CGRectMake(0, 0, 145, 44)];
    _segmentViewTitle.segTitleFont = 17;
    _segmentViewTitle.unselectColor = SMParatextColor;
    _segmentViewTitle.blackLineWidth = 20;
    _segmentViewTitle.needBlackLine = NO;
    _segmentViewTitle.titles = @[@"汽车", @"资讯",@"配件"];
    _segmentViewTitle.backgroundColor = [UIColor clearColor];
    WeakObj(self);
    _segmentViewTitle.didSelectedAtIndex = ^(NSInteger index) {
        //先移动再赋值
        [Weakself resetStatus];
        Weakself.saveIndex = index;
        // 让UIScrollView滚动到对应位置
        CGPoint offset = Weakself.scrollView.contentOffset;
        offset.x = index * Weakself.scrollView.mj_w;
        [Weakself.scrollView setContentOffset:offset animated:YES];
    };
    self.navigationItem.titleView = _segmentViewTitle;
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.btn setTitle:@"取消" forState:UIControlStateSelected];
    [self.btn setTitleColor:SMTextColor forState:UIControlStateNormal];
    [self.btn sizeToFit];
    [self.btn addTarget:self action:@selector(rightBarButtonLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    //待添加详情的收藏状态
    UIView *containView = [[UIView alloc] initWithFrame:self.btn.bounds];
    [containView addSubview:self.btn];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:containView];
    self.navigationItem.rightBarButtonItem = buttonItem;
}
- (void)setUpUI{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 100)];
    scrollView.contentSize = CGSizeMake(self.view.mj_w * _segmentViewTitle.titles.count, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.top.offset = 0;
    }];
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)setupChildViewControllers
{
//    fromTable （app_accessories:汽配,app_product:商品,app_information:文章）
    MyCollectionViewDetailController *vcOne = [MyCollectionViewDetailController new];
    vcOne.type = @"app_product";
    [self addChildViewController:vcOne];
    
    MyCollectionViewDetailController *vcTwo = [MyCollectionViewDetailController new];
    vcTwo.type = @"app_information";
    [self addChildViewController:vcTwo];
    
    MyCollectionViewDetailController *vcThree = [MyCollectionViewDetailController new];
    vcThree.type = @"app_accessories";
    [self addChildViewController:vcThree];

    [self addChildVcView];
}


#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 选中\点击对应的按钮
    [self resetStatus];
    NSUInteger index = scrollView.contentOffset.x / scrollView.mj_w;
    [_segmentViewTitle changeSegmentedControlWithIndex:index];
    self.saveIndex = index;
    // 添加子控制器的view
    [self addChildVcView];
    // 当index == 0时, viewWithTag:方法返回的就是self.titlesView
    //    XMGTitleButton *titleButton = (XMGTitleButton *)[self.titlesView viewWithTag:index];
}

#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    // 子控制器的索引
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.mj_w;
    
    // 取出子控制器
    MyCollectionViewDetailController *childVc = (MyCollectionViewDetailController *)self.childViewControllers[index];

    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

- (void)rightBarButtonLikeAction:(UIButton *)sender{
    self.btn.selected = YES;
    MyCollectionViewDetailController *childVc = (MyCollectionViewDetailController *)self.childViewControllers[self.saveIndex];
    [childVc.tableView setEditing:YES animated:NO];
}

- (void)resetStatus{
    self.btn.selected = NO;
    MyCollectionViewDetailController *childVc = (MyCollectionViewDetailController *)self.childViewControllers[self.saveIndex];
    [childVc.tableView setEditing:NO animated:NO];
}

@end
