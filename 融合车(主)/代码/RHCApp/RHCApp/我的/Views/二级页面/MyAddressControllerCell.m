//
//  MyAddressControllerCell.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/17.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "MyAddressControllerCell.h"
#import "MyAddressModel.h"

@interface MyAddressControllerCell()

@property (nonatomic,strong) UILabel *personLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIButton *morenButton;
@property (nonatomic,strong) UIButton *deleButton;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation MyAddressControllerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.personLabel = [UILabel new];
    self.personLabel.textColor  = SMTextColor;
    self.personLabel.font = LPFFONT(12);
    [self.contentView addSubview:self.personLabel];
    
    self.addressLabel = [UILabel new];
    self.addressLabel.font = MFFONT(13);
    self.addressLabel.numberOfLines = 2;
    [self.contentView addSubview:self.addressLabel];
    
    self.morenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.morenButton.titleLabel.font = LPFFONT(11);
    [self.morenButton setTitle:@"设为默认" forState:UIControlStateNormal];
    [self.morenButton setTitle:@"默认" forState:UIControlStateSelected];
    [self.morenButton setTitleColor:SMThemeColor forState:UIControlStateSelected];
    [self.morenButton setTitleColor:SMParatextColor forState:UIControlStateNormal];
    [self.morenButton addTarget:self action:@selector(morenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.morenButton];
    
    self.deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleButton setImage:IMAGECACHE(@"icon_51") forState:UIControlStateNormal];
    [self.deleButton addTarget:self action:@selector(deleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleButton];
    [self.deleButton setContentHuggingPriority
     :UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.deleButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    self.lineView = [UILabel new];
    self.lineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.lineView];
    
}

- (void)setupLayout{
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 10;
        make.top.offset = 15;
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.personLabel.mas_bottom).offset = 10;
        make.left.offset = 10;
        make.right.equalTo(self.deleButton.mas_left).offset = -10;
        make.bottom.equalTo(self.contentView.mas_bottom).offset = -15;
    }];
    
    [self.morenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.personLabel);
        make.right.offset = -13;
    }];
    
    [self.deleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 10;
        make.right.offset = -15;
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

- (void)setModel:(MyAddressModel *)model{
    _model = model;
    self.morenButton.selected = [model.isDefault boolValue];
    self.personLabel.text = [NSString stringWithFormat:@"%@ %@",model.name,model.phone];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",model.area_names,model.address];
}

- (void)morenButtonAction:(UIButton *)sender{
    if (!sender.selected) {
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
        parames[@"addressName"] = self.model.area_names;
        parames[@"address"] = self.model.address;
        parames[@"name"] = self.model.name;
        parames[@"phone"] = self.model.phone;
        parames[@"isDefault"] = @"1";
        parames[@"id"] = self.model.addressId;
        WeakObj(self);
        [[NetWorkManager shareManager] POST:USER_updateAddress parameters:parames successed:^(id json) {
            if (json) {
                //刷新我的收货地址页面
                if (Weakself.updataCell) {
                    Weakself.updataCell(Weakself.model.addressId);
                }
            }
        } failure:^(NSError *error) {
            
        }];

    }
}

- (void)deleButtonAction:(UIButton *)sender{
//    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
//    parames[@"userId"] = [YXDUserInfoStore sharedInstance].userModel.userId;
//    parames[@"accessToken"] = UserAccessToken;
//    parames[@"id"] = _model.addressId;
//    WeakObj(self);
//    [[NetWorkManager shareManager] POST:USER_delAddress parameters:parames successed:^(id json) {
//        if (json) {
//            if (Weakself.deleCellBlock) {
//                Weakself.deleCellBlock(_model.addressId);
//            }
//        }
//    } failure:^(NSError *error) {
//        
//    }];
}

@end
