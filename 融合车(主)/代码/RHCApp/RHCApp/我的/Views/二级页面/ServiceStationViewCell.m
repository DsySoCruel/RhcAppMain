//
//  ServiceStationViewCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/28.
//

#import "ServiceStationViewCell.h"
#import "UIButton+ImagePositionAndHitArea.h"
#import "ServiceStationViewCellModel.h"

@interface ServiceStationViewCell()

@property (nonatomic,strong) UIView *topLineView;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *bigImageView;
@property (nonatomic,strong) UIButton *addresssButton;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *phoneButton;

@end

@implementation ServiceStationViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.topLineView = [UIView new];
    self.topLineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.topLineView];
    
    self.numLabel = [UILabel new];
    self.numLabel.backgroundColor = RGB(0x40A9DE);
    self.numLabel.textColor = [UIColor whiteColor];
    self.numLabel.font = BPFFONT(22);
    self.numLabel.text = @"1";
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.layer.cornerRadius = 15;
    self.numLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.numLabel];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = SMTextColor;
    self.titleLabel.font = BPFFONT(20);
    self.titleLabel.numberOfLines = 2;
//    self.titleLabel.text = @"东风风神红升专营店";
    [self.contentView addSubview:self.titleLabel];
    
    self.bigImageView = [UIImageView new];
    self.bigImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.bigImageView];
    
    self.addresssButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [self.addresssButton addTarget:self action:@selector(addresssButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addresssButton setImage:IMAGECACHE(@"shop_01") forState:UIControlStateNormal];
    self.addresssButton.titleLabel.numberOfLines = 2;
//    [self.addresssButton setTitle:@"河南省新乡市和平大道与南环路交叉口向西200米路北" forState:UIControlStateNormal];
    [self.addresssButton setTitleColor:SMParatextColor forState:UIControlStateNormal];
    self.addresssButton.titleLabel.font = LPFFONT(13);
    [self.addresssButton setImagePosition:ImagePositionLeft spacing:15];
    [self.contentView addSubview:self.addresssButton];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMLineColor;
    [self.contentView addSubview:self.lineView];
    
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [self.phoneButton addTarget:self action:@selector(phoneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneButton setImage:IMAGECACHE(@"shop_02") forState:UIControlStateNormal];
//    [self.phoneButton setTitle:@"03735816120/03735817566" forState:UIControlStateNormal];
    [self.phoneButton setTitleColor:RGB(0x40A9DE) forState:UIControlStateNormal];
    self.phoneButton.titleLabel.font = LPFFONT(13);
    [self.phoneButton setImagePosition:ImagePositionLeft spacing:15];
    [self.contentView addSubview:self.phoneButton];

}

- (void)setupLayout{
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 10;
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.width.height.offset = 30;
        make.right.equalTo(self.titleLabel.mas_left).offset = -15;
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 60;
        make.top.equalTo(self.topLineView.mas_bottom).offset = 0;
        make.left.offset = 60;
        make.right.offset = -10;
    }];
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.offset = 150;
    }];
    [self.addresssButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset = -15;
        make.top.equalTo(self.bigImageView.mas_bottom);
        make.height.offset = 50;
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.addresssButton.mas_bottom);
        make.height.offset = 0.5;
    }];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset = -15;
        make.top.equalTo(self.addresssButton.mas_bottom);
        make.height.offset = 50;
    }];
}

- (void)addresssButtonAction{
    
}

- (void)phoneButtonAction{
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"10086"];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self.contentView addSubview:callWebview];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.phone];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"拨打电话" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
  [alertController addAction:cancelAction];
  [alertController addAction:otherAction];
  [[BaseViewController topViewController].navigationController presentViewController:alertController animated:YES completion:nil];
}


- (void)configModel:(ServiceStationViewCellModel *)model with:(NSIndexPath *)indexPath{
    _model = model;
    self.numLabel.text = [NSString stringWithFormat:@"%tu",indexPath.section + 1];
    self.titleLabel.text = model.name;
    [self.addresssButton setTitle:model.address forState:UIControlStateNormal];
    [self.phoneButton setTitle:model.phone forState:UIControlStateNormal];
    [self.bigImageView sd_setImageWithURL:URLWithImageName(model.url) placeholderImage:IMAGECACHE(@"zhan_big")];
}

@end
