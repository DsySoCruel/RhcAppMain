//
//  AboutUsViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/28.
//

#import "AboutUsViewController.h"
#import "AboutUsView.h"

@interface AboutUsViewController ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *versions;
@property (nonatomic,strong) UIButton *checkVersions;
@property (nonatomic,strong) AboutUsView *view1;
@property (nonatomic,strong) AboutUsView *view2;
@property (nonatomic,strong) AboutUsView *view3;
@property (nonatomic,strong) AboutUsView *view4;
@property (nonatomic,strong) UILabel *introducesLabel;


@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = SMViewBGColor;
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    self.iconImageView = [UIImageView new];
    self.iconImageView.backgroundColor = SMThemeColor;
    self.iconImageView.layer.cornerRadius = 35;
    self.iconImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.iconImageView];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDictionary));
    //app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //    self.versionLabel.text = [NSString stringWithFormat:@"版本号 %@",app_Version];
    self.versions = [UILabel new];
    self.versions.text = app_Version;
    self.versions.font = LPFFONT(16);
    self.versions.textColor = SMParatextColor;
    [self.view addSubview:self.versions];
    
    self.checkVersions = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkVersions setTitle:@"检查版本" forState:UIControlStateNormal];
    self.checkVersions.backgroundColor = RGB(0x40A9DE);
    self.checkVersions.titleLabel.font = LPFFONT(14);
    self.checkVersions.layer.cornerRadius = 5;
    [self.view addSubview:self.checkVersions];
    
    self.view1 = [[AboutUsView alloc] initWith:@"电话" andSubsTitle:@"00000000" subTitleColor:RGB(0xE84B05)];
    [self.view addSubview:self.view1];
    
    self.view2 = [[AboutUsView alloc] initWith:@"微博" andSubsTitle:@"00000000" subTitleColor:SMParatextColor];
    [self.view addSubview:self.view2];
    
    self.view3 = [[AboutUsView alloc] initWith:@"微信" andSubsTitle:@"wxoooq" subTitleColor:SMParatextColor];
    [self.view addSubview:self.view3];
    
    self.view4 = [[AboutUsView alloc] initWith:@"官方网址" andSubsTitle:@"00000000" subTitleColor:RGB(0xE84B05)];
    [self.view addSubview:self.view4];
    
    self.introducesLabel = [UILabel new];
    self.introducesLabel.textAlignment = NSTextAlignmentCenter;
    self.introducesLabel.textColor = SMParatextColor;
    self.introducesLabel.font = LPFFONT(11);
    self.introducesLabel.text = @"***网络科技有限公司\n版权所有\nCopyrigjt  @  2018——hjffkfkkfkfkfkf";
    self.introducesLabel.numberOfLines = 0;
    [self.view addSubview:self.introducesLabel];
    
}

- (void)setupLayout{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.offset = 50 + 64;
        make.width.height.offset = 70;
    }];
    [self.versions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.iconImageView.mas_bottom).offset = 15;
    }];
    [self.checkVersions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.versions.mas_bottom).offset = 15;
        make.width.offset = 100;
        make.height.offset = 30;
    }];
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkVersions.mas_bottom).offset = 70;
        make.left.offset = 30;
        make.right.offset = -30;
        make.height.offset = 40;
    }];
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view1.mas_bottom).offset = 5;
        make.left.offset = 30;
        make.right.offset = -30;
        make.height.offset = 40;
    }];
    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view2.mas_bottom).offset = 5;
        make.left.offset = 30;
        make.right.offset = -30;
        make.height.offset = 40;
    }];
    [self.view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view3.mas_bottom).offset = 5;
        make.left.offset = 30;
        make.right.offset = -30;
        make.height.offset = 40;
    }];
    [self.introducesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.bottom.offset = -30;
    }];
    
}



@end
