//
//  CircleViewControllerHeaderView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/9.
//

#import "CircleViewControllerHeaderView.h"
#import "UserHomepageController.h"
#import "PostViewController.h"

@interface CircleViewControllerHeaderView()
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *iconImage;
@property (nonatomic,strong) UILabel *subTitle;
@property (nonatomic,strong) UIButton *bigImage;
@end

@implementation CircleViewControllerHeaderView




- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = SMViewBGColor;
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = MFFONT(30);
    self.titleLabel.textColor = SMTextColor;
    self.titleLabel.text = @"吐槽";
    [self addSubview:self.titleLabel];
    
    self.iconImage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = YES;
    [self.iconImage addTarget:self action:@selector(iconImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.iconImage];
    
    self.subTitle = [UILabel new];
    self.subTitle.font = LPFFONT(13);
    self.subTitle.textColor = SMParatextColor;
    self.subTitle.numberOfLines = 0;
    self.subTitle.text = @"TA的脾气总是太古怪？看到美景就走不动？别生气!来这里我们一起来吐槽“它”！";
    [self addSubview:self.subTitle];
    
    self.bigImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bigImage setImage:IMAGECACHE(@"chequan_1") forState:UIControlStateNormal];
    [self.bigImage setImage:IMAGECACHE(@"chequan_1") forState:UIControlStateHighlighted];
    [self.bigImage addTarget:self action:@selector(bigImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bigImage];
    
}
- (void)setupLayout{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.bottom.offset = -10;
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 40;
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.centerY.equalTo(self.titleLabel);
        make.width.height.offset = 40;
    }];
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -55;
        make.top.equalTo(self.titleLabel.mas_bottom).offset = 15;
    }];
    [self.bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 75;
        make.left.offset = 15;
        make.right.offset = -15;
        make.bottom.offset = -25;
    }];    
}

- (void)updateIcon{
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        YXDUserInfoModel *userModel = [YXDUserInfoStore sharedInstance].userModel;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:userModel.headimg] forState:UIControlStateNormal placeholderImage:IMAGECACHE(@"zhan_head")];
    }else{
        [self.iconImage setImage:IMAGECACHE(@"zhan_head") forState:UIControlStateNormal];
    }
}


- (void)iconImageAction{
    if (![YXDUserInfoStore sharedInstance].loginStatus) {
        [self.navigationController presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
        return;
    }
    YXDUserInfoModel *userModel = [YXDUserInfoStore sharedInstance].userModel;
    UserHomepageController *vc = [UserHomepageController new];
    vc.uid = userModel.userId;
    vc.headImage = userModel.headimg;
    vc.namestr = userModel.nickname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bigImageAction{
    PostViewController *vc = [PostViewController new];
    WeakObj(self);
    vc.updateOrderBlock = ^{
        if (Weakself.updateOrderBlock) {
            Weakself.updateOrderBlock();
        }
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

@end
