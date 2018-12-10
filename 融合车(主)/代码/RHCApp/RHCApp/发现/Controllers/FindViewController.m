//
//  FindViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/20.
//

#import "FindViewController.h"
#import "NavigationSearchBarView.h"
#import "KMHomePageView.h"

@interface FindViewController ()<UINavigationControllerDelegate>
@property (nonatomic,strong) NavigationSearchBarView *naviView;
@property (nonatomic,strong) KMHomePageView *pageView;
@end

@implementation FindViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    //1.
    NSArray *tempArray = @[@"全部资讯",@"购车攻略",@"爆款推荐",@"对比优选",@"养车技巧"];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *paramesArray = [NSMutableArray array];
    NSMutableArray *controllersArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < tempArray.count; i++) {
        [titleArray addObject:tempArray[i]];
        [paramesArray addObject:[NSString stringWithFormat:@"%tu",i]];
        [controllersArray addObject:@"FindViewDetailViewController"];
    }
    _pageView = [[KMHomePageView alloc] initWithFrame:CGRectMake(0, 44 + SafeTopSpace, Screen_W, Screen_H - 44 - SafeTopSpace) withTitles:titleArray withViewControllers:controllersArray  withParameters:paramesArray];
    _pageView.isAnimated = NO;
    _pageView.selectedColor = SMThemeColor;
    _pageView.unselectedColor = SMTextColor;
    _pageView.topTabBottomLineColor = [UIColor clearColor];
    _pageView.unselectedFont = LPFFONT(13);
    _pageView.selectedFont = MFFONT(13);
    _pageView.defaultSubscript = 0;
    [self.view addSubview:self.pageView];
    //2.设置导航条
    self.naviView = [[NavigationSearchBarView alloc] initWithType:NavigationSearchBarTypeFind];
    [self.view addSubview:self.naviView];
}
- (void)setupLayout{
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset = 0;
        make.height.offset = 64 + SafeTopSpace;
    }];
}

@end
