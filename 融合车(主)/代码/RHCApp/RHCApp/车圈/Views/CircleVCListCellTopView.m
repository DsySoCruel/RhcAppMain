//
//  CircleVCListCellTopView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "CircleVCListCellTopView.h"
#import "UserHomepageController.h"

@interface CircleVCListCellTopView()
@property (nonatomic,strong) UIButton *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) NSString *uid;//用户id
@property (nonatomic,strong) NSString *namestr;
@property (nonatomic,strong) NSString *headImage;

@end
@implementation CircleVCListCellTopView

- (instancetype)init{
    if (self == [super init]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.iconImage = [UIButton new];
    [self addSubview:self.iconImage];
    [self.iconImage addTarget:self action:@selector(iconImageAction) forControlEvents:UIControlEventTouchUpInside];
    self.iconImage.backgroundColor = [UIColor whiteColor];
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = YES;
    
    self.nameLabel = [UILabel new];
    [self addSubview:self.nameLabel];
    self.nameLabel.font = LPFFONT(14);
    self.nameLabel.textColor = SMTextColor;
    self.nameLabel.text = @"超大西瓜";
    
    self.timeLabel = [UILabel new];
    [self addSubview:self.timeLabel];
    self.timeLabel.font = LPFFONT(12);
    self.timeLabel.textColor = SMParatextColor;
    self.timeLabel.text = @"2018.10.15";
}
- (void)setupLayout{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 15;
        make.width.height.offset = 40;
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset = 5;
        make.right.offset = -15;
        make.top.equalTo(self.iconImage);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset = 5;
        make.right.offset = -15;
        make.bottom.equalTo(self.iconImage);
    }];
}

- (void)setModel:(CircleViewControllerListModel *)model{
    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.headimg] forState:UIControlStateNormal placeholderImage:IMAGECACHE(@"zhan_head")];
    self.nameLabel.text = model.nickname;
    self.timeLabel.text = [model.create_time timeTypeFromNow];
    self.uid = model.userID;
    self.namestr = model.nickname;
    self.headImage = model.headimg;
}

- (void)setCommodel:(CircleCommendModel *)commodel{
    _commodel = commodel;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:commodel.headimg] forState:UIControlStateNormal placeholderImage:IMAGECACHE(@"zhan_head")];
    self.nameLabel.text = commodel.nickname;
    self.timeLabel.text = [commodel.create_time timeTypeFromNow];
    self.uid = commodel.user_id;
    self.namestr = commodel.nickname;
    self.headImage = commodel.headimg;
}

- (void)setHomeModel:(HomeViewListModel *)homeModel{
    _homeModel = homeModel;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:homeModel.headimg] forState:UIControlStateNormal placeholderImage:IMAGECACHE(@"zhan_head")];
    self.nameLabel.text = homeModel.nickname;
    self.timeLabel.text = [homeModel.create_time timeTypeFromNow];
    self.uid = homeModel.userID;
    self.namestr = homeModel.nickname;
    self.headImage = homeModel.headimg;
}

- (void)iconImageAction{
    UserHomepageController *vc = [UserHomepageController new];
    if (!self.uid.length) {
        [MBHUDHelper showError:@"缺少uid"];
        return;
    }
    vc.uid = self.uid;
    vc.namestr = self.namestr;
    vc.headImage = self.headImage;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
