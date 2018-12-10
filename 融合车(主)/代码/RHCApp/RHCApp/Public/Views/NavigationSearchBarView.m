//
//  NavigationSearchBarView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/21.
//

#import "NavigationSearchBarView.h"
#import "YXDButton.h"
#import "MessageViewController.h"
#import "BookCarriageViewController.h"
#import "RequestManager.h"
#import "SaoQRcodeViewController.h"//扫码控制器
#import "WebViewController.h"
#import "GlobalSearchViewController.h"


@interface NavigationSearchBarView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView    *bottomView;
@property (nonatomic, strong) UIButton  *backButton;
@property (nonatomic, strong) UIButton  *saoButton;
@property (nonatomic, strong) YXDButton *searchButton;
@property (nonatomic, strong) UIButton  *serviceButton;
@property (nonatomic, strong) UIButton  *messageButton;
@property (nonatomic, strong) UIButton  *bookForCarriageButton;//订购车厢

@property (nonatomic,assign) NavigationSearchBarType viewType;

@property (nonatomic, copy) void(^tapAction)(UITextField*);
@property (nonatomic, copy) void (^searchBlock)(UITextField *, NSRange, NSString *);
@end

@implementation NavigationSearchBarView

-(instancetype)initWithType:(NavigationSearchBarType)type{
    if (self = [super init]) {
        self.viewType = type;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}


- (void)setupUI{    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = SMThemeColor;
    self.bottomView.alpha = 0;
    [self addSubview:self.bottomView];
    
    self.saoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saoButton addTarget:self action:@selector(saoButtonButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.saoButton];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:IMAGECACHE(@"backIcon") forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    
    self.searchButton = [YXDButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButton setImage:IMAGECACHE(@"home_04") forState:UIControlStateNormal];
    [self.searchButton setTitle:@"搜索你想要的车" forState:UIControlStateNormal];
    [self.searchButton setTitleColor:RGB(0x989898) forState:UIControlStateNormal];
    self.searchButton.titleLabel.font = LPFFONT(13);
    self.searchButton.backgroundColor = RGB(0xECECEC);
    self.searchButton.padding = 5;
    self.searchButton.layer.cornerRadius = 15;
    self.searchButton.layer.masksToBounds = YES;
    [self addSubview:self.searchButton];
    
    if (self.viewType == NavigationSearchBarTypeSearchView) {
        //设置搜索真实输入框
        [self setupSearchBar];
        self.searchButton.hidden = YES;
    }
    
    self.serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.serviceButton addTarget:self action:@selector(serviceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.serviceButton];
    
    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.messageButton addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.messageButton];
    
    self.bookForCarriageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bookForCarriageButton addTarget:self action:@selector(bookForCarriageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bookForCarriageButton setTitle:@"订购车厢" forState:UIControlStateNormal];
    self.bookForCarriageButton.titleLabel.font = LPFFONT(12);
    self.bookForCarriageButton.layer.cornerRadius = 3;
    self.bookForCarriageButton.backgroundColor = SMThemeColor;
    [self addSubview:self.bookForCarriageButton];
    
    if (self.viewType == NavigationSearchBarTypeTruckStore) {
        self.bookForCarriageButton.hidden = NO;
        self.serviceButton.hidden = YES;
        self.messageButton.hidden = YES;
    }else{
        self.bookForCarriageButton.hidden = YES;
        self.serviceButton.hidden = NO;
        self.messageButton.hidden = NO;
    }
    

    if (self.viewType == NavigationSearchBarTypeHome) {
        [self.saoButton setImage:IMAGECACHE(@"home_01_white") forState:UIControlStateNormal];
        [self.serviceButton setImage:IMAGECACHE(@"home_02_white") forState:UIControlStateNormal];
        [self.messageButton setImage:IMAGECACHE(@"home_03_white") forState:UIControlStateNormal];
    }else{
        [self.saoButton setImage:IMAGECACHE(@"home_01") forState:UIControlStateNormal];
        [self.serviceButton setImage:IMAGECACHE(@"home_02") forState:UIControlStateNormal];
        [self.messageButton setImage:IMAGECACHE(@"home_03") forState:UIControlStateNormal];
    }
    if (self.viewType == NavigationSearchBarTypeHome || self.viewType == NavigationSearchBarTypeFind) {
        self.backButton.hidden = YES;
        self.saoButton.hidden = NO;
    }else{
        self.backButton.hidden = NO;
        self.saoButton.hidden = YES;
        
    }
}

- (void)setupLayout{
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    CGFloat height = 30;
    
    [self.saoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.offset = 28 + SafeTopSpace;
        make.width.height.offset = height;
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.top.offset = 28 + SafeTopSpace;
        make.height.offset = height;
        make.width.offset = 50;
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.saoButton.mas_right).offset = 10;
        make.right.equalTo(self.serviceButton.mas_left).offset = -10;
        make.height.offset = height;
        make.centerY.equalTo(self.saoButton);
    }];
    
    if (self.viewType == NavigationSearchBarTypeSearchView) {
        [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.saoButton.mas_right).offset = 10;
            make.right.equalTo(self.serviceButton.mas_left).offset = -10;
            make.height.offset = 30;
            make.centerY.equalTo(self.saoButton);
        }];
    }

    [self.serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageButton.mas_left).offset = -5;
        make.centerY.equalTo(self.saoButton);
        make.width.height.offset = height;
    }];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.centerY.equalTo(self.saoButton);
        make.width.height.offset = height;
    }];
    
    [self.bookForCarriageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.centerY.equalTo(self.saoButton);
        make.height.offset = 25;
        make.width.offset = 65;
    }];
    
}


#pragma mark -- 方法执行

- (void)changeAlphaWithOffset:(CGFloat)offset {
    if (offset < 0) {
        CGFloat delta = self.headerHeight - NAVI_H;
        CGFloat alpha = MIN(1, 1 - (delta + offset) / delta);
        self.bottomView.alpha = -alpha;
        return;
    }
    CGFloat delta = self.headerHeight - NAVI_H;
    CGFloat alpha = MIN(1, 1 - (delta - offset) / delta);
    self.bottomView.alpha = -alpha;
//        NSLog(@"11111(%f",offset);
//        NSLog(@"22222(%f",delta);
//        NSLog(@"33333(%f",alpha);
}


- (void)saoButtonButtonAction{
    SaoQRcodeViewController *vc = [[SaoQRcodeViewController alloc] init];
    vc.releaseContentBlock = ^(NSString * _Nonnull url) {
        //打开网页
        WebViewController *webView = [WebViewController new];
        webView.title = @"网页";
        [webView loadWebWithUrl:url];
        [self.navigationController pushViewController:webView animated:YES];
    };
    YXDNavigationController *meetVC = [[YXDNavigationController alloc] initWithRootViewController:vc];
    [[BaseViewController topViewController] presentViewController:meetVC animated:YES completion:nil];
}

- (void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//进行真正的搜索
- (void)searchButtonAction{
    GlobalSearchViewController *vc = [GlobalSearchViewController new];
    if (self.viewType == NavigationSearchBarTypeFind) {
        vc.globalSearchType = GlobalSearchTypeNews;
    }else{
        vc.globalSearchType = GlobalSearchTypeProduct;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//联系客服
- (void)serviceButtonAction{
    [[RequestManager sharedInstance] connectWithServer];
}
- (void)bookForCarriageButtonAction{
    BookCarriageViewController *vc = [BookCarriageViewController new];
    [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)messageButtonAction{
    MessageViewController *vc = [MessageViewController new];
    [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 设置搜索界面的输入条件

- (void)setupSearchBar{
    self.searchField = [UITextField new];
    [self addSubview:self.searchField];

    [self.searchField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.font = PFFONT(17);
    //        self.placeholder = self.searchPlaceholder;
    self.searchField.delegate = self;
    self.searchField.layer.cornerRadius = 15;
    self.searchField.layer.masksToBounds = YES;
    self.searchField.placeholder = @"搜索";
    UIImage *image = IMAGECACHE(@"home_04");
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 15, image.size.height)];
    UIImageView *paddinfView = [[UIImageView alloc] initWithImage:image];
    paddinfView.frame = CGRectMake(10, 5, image.size.width, image.size.height);
    CGPoint rectFrame = paddinfView.center;
    rectFrame.y = View.center.y;
    paddinfView.center = rectFrame;
    [View addSubview:paddinfView];
    self.searchField.leftView = View;
    self.searchField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    UIImage *rImage = IMAGECACHE(@"clear");
    UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rImage.size.width+10, rImage.size.height)];
    UIImageView *rImageView = [[UIImageView alloc] initWithImage:rImage];
    rImageView.frame = CGRectMake(5, 5, rImage.size.width, rImage.size.height);
    rImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rImagetapAction)];
//    [[tap rac_gestureSignal] subscribeNext:^(id x) {
//        STRONG_SELF
//        self.text = @"";
//        if (self.tapAction) {
//            self.tapAction(x);
//        }
//    }];
    rImageView.userInteractionEnabled = YES;
    [rImageView addGestureRecognizer:tap];
    CGPoint point = rImageView.center;
    point.y = rightVeiw.center.y;
    rImageView.center = point;
    
    [rightVeiw addSubview:rImageView];
    self.searchField.rightView = rightVeiw;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.font = [UIFont systemFontOfSize:17];
    self.searchField.tintColor = SMTextColor;
    self.searchField.textColor = SMTextColor;
    [self.searchField setValue:SMParatextColor forKeyPath:@"_placeholderLabel.textColor"];
    self.searchField.backgroundColor = SMViewBGColor;
    [self.searchField setClearButtonMode:UITextFieldViewModeAlways];
    [self.searchField becomeFirstResponder];
    
}

- (void)rImagetapAction{
    self.searchField.text = @"";
    if (self.tapAction) {
        self.tapAction(self.searchField);
    }
}
- (void)didCloseTapBlock:(void (^)(UITextField *))tapAction {
    self.tapAction = tapAction;
}


-(void)textFieldTextChange:(UITextField *)textField{
    if (self.searchDelegate || [self.searchDelegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.searchDelegate searchBar:(UITextField *)textField textDidChange:textField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        if (self.searchBlock) {
            self.searchBlock(textField, range, string);
        }
        [self resignFirstResponder];
    }
    return YES;
}
- (void)searchShouldChangeText:(void (^)(UITextField *, NSRange, NSString *))block {
    self.searchBlock = block;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.searchDelegate || [self.searchDelegate respondsToSelector:@selector(searchViewTextDidBeginEditing:)]) {
        [self.searchDelegate searchViewTextDidBeginEditing:(UITextField *)textField];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.searchDelegate || [self.searchDelegate respondsToSelector:@selector(searchViewReturnButtonClicked:)]) {
        [self.searchDelegate searchViewReturnButtonClicked:(UITextField *)textField];
    }
    return YES;
}


@end
