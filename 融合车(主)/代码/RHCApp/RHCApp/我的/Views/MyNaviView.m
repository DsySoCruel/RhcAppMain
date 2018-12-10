//
//  MyNaviView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/25.
//

#import "MyNaviView.h"
#import "SettingViewController.h"
#import "MessageViewController.h"

@interface MyNaviView ()
@property (nonatomic, strong) UIView *bottomView;
//@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *messageButton;

@end

@implementation MyNaviView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.alpha = 0;
    
    
    self.settingButton = [[UIButton alloc] init];
//    self.settingButton.hitTestEdgeInsets = UIEdgeInsetsMake(0, -10, 0, -15);
    [self.settingButton setImage:IMAGECACHE(@"me_01") forState:UIControlStateNormal];
    [self.settingButton addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.messageButton = [[UIButton alloc] init];
//    self.messageButton.hitTestEdgeInsets = UIEdgeInsetsMake(0, -20, 0, -5);
    [self.messageButton setImage:IMAGECACHE(@"me_02") forState:UIControlStateNormal];
    [self.messageButton addTarget:self action:@selector(messageButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - Layout
- (void)setupLayout {
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
//    [self addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//    }];
    
    [self addSubview:self.messageButton];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    [self addSubview:self.settingButton];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageButton.mas_left).offset = -20;
        make.centerY.equalTo(self.messageButton.mas_centerY);
    }];
}

- (void)changeAlphaWithOffset:(CGFloat)offset {
    if (offset < 0) {
        return;
    }
    CGFloat delta = self.headerHeight - NAVI_H;
    CGFloat alpha = MIN(1, 1 - (delta - offset) / delta);
    self.bottomView.alpha = -alpha;
//    NSLog(@"11111(%f",offset);
//    NSLog(@"22222(%f",delta);
//    NSLog(@"33333(%f",alpha);
}

- (void)settingButtonAction:(UIButton *)sender{
    SettingViewController *vc = [SettingViewController new];
    [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
}
- (void)messageButtonAction:(UIButton *)sender{
    //    [MineHomePageActionManager didQRcodeButtonAction];
    MessageViewController *vc = [MessageViewController new];
    [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
}
@end
