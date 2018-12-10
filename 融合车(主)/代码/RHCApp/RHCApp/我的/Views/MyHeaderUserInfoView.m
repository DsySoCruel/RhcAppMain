//
//  MyHeaderUserInfoView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/25.
//

#import "MyHeaderUserInfoView.h"
#import "EditMessageViewController.h"
#import "MyCollectionViewController.h"
#import "MyShopCarViewController.h"
#import "RequestManager.h"


@interface MyHeaderUserInfoView ()
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) YXDButton   *nameButton;
@property (nonatomic, strong) UILabel     *personIdLabel;
@property (nonatomic, strong) YXDButton   *orderButton;
@property (nonatomic, strong) YXDButton   *collectButton;
@property (nonatomic, strong) YXDButton   *afterSaleButton;
@property (nonatomic, strong) YXDUserInfoModel *model;
@end

@implementation MyHeaderUserInfoView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    
//    self.backImg = [UIImageView new];
//    self.backImg.contentMode = UIViewContentModeScaleAspectFill;
//    self.backImg.clipsToBounds = YES;
    
//    self.matteView = [UIImageView new];
//    self.matteView.image = IMAGECACHE(@"gradientMap");
//    self.matteView.alpha = 0.95;
    
    self.headerImg = [UIImageView new];
    self.headerImg.clipsToBounds = YES;
    self.headerImg.backgroundColor = [UIColor whiteColor];
    self.headerImg.layer.cornerRadius = 70/2.0;
    
    
    self.nameButton = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.nameButton addTarget:self action:@selector(nameButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nameButton setImage:IMAGECACHE(@"me_03") forState:UIControlStateNormal];
    [self.nameButton setTitle:@"请登录" forState:UIControlStateNormal];
    [self.nameButton setTitleColor:SMTextColor forState:UIControlStateNormal];
    self.nameButton.titleLabel.font = MFFONT(17);
    self.nameButton.status =  MoreStyleStatusCenter;
    self.nameButton.padding = 10;
    
    self.personIdLabel = [UILabel new];
    self.personIdLabel.font = LPFFONT(15);
    self.personIdLabel.textColor = SMParatextColor;
    
    
    self.orderButton = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.orderButton addTarget:self action:@selector(orderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.orderButton setImage:IMAGECACHE(@"me_04") forState:UIControlStateNormal];
    [self.orderButton setTitle:@"购物车" forState:UIControlStateNormal];
    [self.orderButton setTitleColor:SMTextColor forState:UIControlStateNormal];
    self.orderButton.titleLabel.font = LPFFONT(13);
    self.orderButton.status = MoreStyleStatusTop;
    self.orderButton.padding = 5;
    
    self.collectButton = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.collectButton setImage:IMAGECACHE(@"me_05") forState:UIControlStateNormal];
    [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:SMTextColor forState:UIControlStateNormal];
    self.collectButton.titleLabel.font = LPFFONT(13);
    self.collectButton.status = MoreStyleStatusTop;
    self.collectButton.padding = 5;
    
    self.afterSaleButton = [YXDButton buttonWithType:UIButtonTypeCustom];
    [self.afterSaleButton addTarget:self action:@selector(afterSaleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.afterSaleButton setImage:IMAGECACHE(@"me_06") forState:UIControlStateNormal];
    [self.afterSaleButton setTitle:@"售后" forState:UIControlStateNormal];
    [self.afterSaleButton setTitleColor:SMTextColor forState:UIControlStateNormal];
    self.afterSaleButton.titleLabel.font = LPFFONT(13);
    self.afterSaleButton.status = MoreStyleStatusTop;
    self.afterSaleButton.padding = 5;
    
    [self addSubview:self.headerImg];
    [self addSubview:self.nameButton];
    [self addSubview:self.personIdLabel];
    [self addSubview:self.orderButton];
    [self addSubview:self.collectButton];
    [self addSubview:self.afterSaleButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
    [self addGestureRecognizer:tap];
    
    //设置初始值
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        YXDUserInfoModel *userModel = [YXDUserInfoStore sharedInstance].userModel;
        [self setCellWithUserModel:userModel];
    }
}

-(void)setupLayout{
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(70);
        make.left.priorityHigh().offset(10);
        make.top.offset(74 + SafeTopSpace);
    }];
    [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImg.mas_right).offset(10);
        make.top.equalTo(self.headerImg.mas_top).mas_equalTo(11);
    }];
    [self.personIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImg.mas_right).offset(5);
        make.top.equalTo(self.nameButton.mas_bottom).mas_equalTo(5);
        make.right.offset = -10;
    }];
    
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.bottom.offset = 0;
        make.height.offset = 80;
        make.width.equalTo(@[self.collectButton,self.afterSaleButton]);
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderButton.mas_right).offset = 20;
        make.right.equalTo(self.afterSaleButton.mas_left).offset = -20;
        make.centerX.offset = 0;
        make.height.offset = 80;
        make.width.equalTo(@[self.afterSaleButton,self.orderButton]);
        make.bottom.offset = 0;
    }];
    [self.afterSaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -20;
        make.height.offset = 80;
        make.width.equalTo(@[self.collectButton,self.orderButton]);
        make.bottom.offset = 0;
    }];    
    
}


-(void)action{
    if (self.modifyInfoBlock) {
        self.modifyInfoBlock();
    }
}

- (void)adustHeaderView:(CGFloat)offset {
//    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    rect.origin.y += offset;
//    rect.size.height -= offset;
//    [self.backImg mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(rect.origin.y);
//        make.height.mas_equalTo(rect.size.height);
//        make.width.mas_equalTo(Screen_W);
//        make.left.mas_equalTo(0);
//    }];
}

#pragma mark -- 方法执行

- (void)orderButtonAction{
    if ([YXDUserInfoStore sharedInstance].loginStatus) {//跳转到购物车
//        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//        if ([rootVC isKindOfClass:[UITabBarController class]]) {
//            UITabBarController *tab = (UITabBarController *)rootVC;
//            tab.selectedIndex = 3;
//        }
        MyShopCarViewController *vc = [MyShopCarViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
    }
}

- (void)collectButtonAction{
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        MyCollectionViewController *vc = [MyCollectionViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
    }
}

- (void)afterSaleButtonAction{
    [[RequestManager sharedInstance] connectWithServer];
}

- (void)nameButtonAction{
    if (![YXDUserInfoStore sharedInstance].loginStatus) {
        [self.navigationController presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
    }else{
        EditMessageViewController *vc = [EditMessageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)setCellWithUserModel:(YXDUserInfoModel *)model{
    _model = model;
    [self.headerImg sd_setImageWithURL:URLWithImageName(model.headimg) placeholderImage:IMAGECACHE(@"zhan_head")];
    [self.nameButton setTitle:model.nickname forState:UIControlStateNormal];
    self.personIdLabel.text = model.phone;
}
-(void)quitSuccess{
    [self.headerImg sd_setImageWithURL:URLWithImageName(@"") placeholderImage:IMAGECACHE(@"zhan_head")];
    [self.nameButton setTitle:@"请登录" forState:UIControlStateNormal];
    self.personIdLabel.text = @"";
}

@end
