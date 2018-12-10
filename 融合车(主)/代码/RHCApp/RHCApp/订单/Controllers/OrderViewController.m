//
//  OrderViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/20.
//

#import "OrderViewController.h"
#import "KMHomePageView.h"
#import "MessageViewController.h"

@interface OrderViewController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) KMHomePageView *pageView;
//claz 类目[1:汽车,2:卡车,3:微卡车厢,4:汽配]
@end

@implementation OrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //判断登录状态
    if (![YXDUserInfoStore sharedInstance].loginStatus) {
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)rootVC;
            tab.selectedIndex = 4;
            [MBHUDHelper showSuccess:@"请登录"];
        }
    }

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;//必须写
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    //1.
    NSArray *tempArray = @[@"汽车订单",@"卡车订单",@"车厢订单",@"汽配订单"];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:tempArray.count];
    NSMutableArray *paramesArray = [NSMutableArray array];
    NSMutableArray *controllersArray = [NSMutableArray arrayWithCapacity:tempArray.count];

    for (int i = 0; i < tempArray.count; i++) {
        [titleArray addObject:tempArray[i]];
        [paramesArray addObject:[NSString stringWithFormat:@"%tu",i + 1]];
        if (i == 2) {//车厢
            [controllersArray addObject:@"OrderListViewCheXiangControllerView"];
        }else if (i == 3){//配件
            [controllersArray addObject:@"OrderListViewPeijianControllerViewController"];
        }else{
            [controllersArray addObject:@"OrderLisetViewController"];
        }
    }
    
    _pageView = [[KMHomePageView alloc] initWithFrame:CGRectMake(0, SafeTopSpace, Screen_W, Screen_H - SafeTopSpace) withTitles:titleArray withViewControllers:controllersArray  withParameters:paramesArray];
    _pageView.isAnimated = YES;
    _pageView.isTranslucent = YES;
    _pageView.selectedColor = SMThemeColor;
    _pageView.unselectedColor = SMTextColor;
    _pageView.topTabBottomLineColor = [UIColor clearColor];
    _pageView.unselectedFont = LPFFONT(15);
    _pageView.selectedFont = MFFONT(15);
    _pageView.rightSpace = 5;
    _pageView.defaultSubscript = 0;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:IMAGECACHE(@"home_03")forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 39, 40);
    [rightButton setTintColor:[UIColor blackColor]];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _pageView.rightButton = rightButton;
    [self.view addSubview:self.pageView];

}
- (void)setupLayout{
}

#pragma mark -- 方法执行
- (void)rightButtonAction{
    MessageViewController *vc = [MessageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
