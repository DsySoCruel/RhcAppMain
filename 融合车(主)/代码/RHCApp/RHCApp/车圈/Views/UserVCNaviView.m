//
//  UserVCNaviView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "UserVCNaviView.h"

@interface UserVCNaviView ()
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
@end


@implementation UserVCNaviView

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
    
    
    self.backButton = [[UIButton alloc] init];
    //    self.settingButton.hitTestEdgeInsets = UIEdgeInsetsMake(0, -10, 0, -15);
    [self.backButton setImage:IMAGECACHE(@"backIcon") forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton = [[UIButton alloc] init];
    //    self.messageButton.hitTestEdgeInsets = UIEdgeInsetsMake(0, -20, 0, -5);
    [self.shareButton setImage:IMAGECACHE(@"chequan_9") forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(messageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = BPFFONT(18);
    self.titleLabel.hidden = YES;
}

#pragma mark - Layout
- (void)setupLayout {
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    [self addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.centerY.equalTo(self.shareButton.mas_centerY);
    }];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(self.shareButton.mas_centerY);
    }];
}

- (void)changeAlphaWithOffset:(CGFloat)offset {
    if (offset < 0) {
        return;
    }
    CGFloat delta = self.headerHeight - NAVI_H;
    CGFloat alpha = MIN(1, 1 - (delta - offset) / delta);
    self.bottomView.alpha = -alpha;
    if (_bottomView.alpha > 0.8) {
        self.titleLabel.hidden = NO;
    }else{
        self.titleLabel.hidden = YES;
    }
    //    NSLog(@"11111(%f",offset);
    //    NSLog(@"22222(%f",delta);
    //    NSLog(@"33333(%f",alpha);
}

- (void)settingButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)messageButtonAction:(UIButton *)sender{
    //    [MineHomePageActionManager didQRcodeButtonAction];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = [NSString stringWithFormat:@"%@的主页",titleStr];
}

@end
