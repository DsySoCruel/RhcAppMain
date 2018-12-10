//
//  EditAddressController.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/17.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "EditAddressController.h"
#import "AddAdressCellView.h"
#import "SelectCityController.h"

@interface EditAddressController ()

@property (nonatomic,strong) AddAdressCellView *city;
@property (nonatomic,strong) AddAdressCellView *xiaoqu;
//@property (nonatomic,strong) AddAdressCellView *address;
@property (nonatomic,strong) AddAdressCellView *name;
@property (nonatomic,strong) AddAdressCellView *phone;

@property (nonatomic,strong) UIButton *commintButton;
//@property (nonatomic,strong) NSString *cityId;//存储选择的城市ID
//@property (nonatomic,strong) NSString *longitude;
//@property (nonatomic,strong) NSString *latitude;

@end

@implementation EditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.model == nil) {
        self.title = @"新增收货地址";
    }else{
        self.title = @"编辑收货地址";
    }
    [self setupUI];
    [self setupLayout];
    
    //获取坐标位置信息
//    GetCoordinateTool *getCoordinate = [GetCoordinateTool getCoordinateTool];
//    WeakObj(self);
//    [getCoordinate getCoordinateToolActionWith:^(GetCoordinateModel *model) {
//        Weakself.longitude = [NSString stringWithFormat:@"%f",model.coord2D.longitude];
//        Weakself.latitude = [NSString stringWithFormat:@"%f",model.coord2D.latitude];
//    }];
    
}

- (void)setupUI{
    self.view.backgroundColor = SMViewBGColor;
    self.city = [[AddAdressCellView alloc] initWithTitle:@"所在城市：" placeholder:@"请选择城市" isNeedPush:YES];
    WeakObj(self)
    self.city.needPushBlock = ^{
        SelectCityController *vc = [SelectCityController new];
        StrongObj(Weakself)
        vc.selectCityBlock = ^(NSString *cityName) {
            strongWeakself.city.textField.text = cityName;
//            strongWeakself.cityId = cityId;
        };
        [Weakself.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:self.city];

    self.xiaoqu = [[AddAdressCellView alloc] initWithTitle:@"小区/单元/门牌号" placeholder:@"例如：阳光小区" isNeedPush:NO];
//    self.xiaoqu.needPushBlock = ^{
//        if (!Weakself.city.textField.text.length) {
//            [MBHUDHelper showSuccess:@"请先选择城市"];
//            return ;
//        }
//        SelecuXiaoquController *vc = [SelecuXiaoquController new];
//        vc.city = Weakself.city.textField.text;
//        vc.areaId2 = Weakself.cityId;
//        StrongObj(Weakself);
////        vc.selectCityBlock = ^(NSString *cityName, NSString *cityId) {
////            strongWeakself.city.textField.text = cityName;
////            strongWeakself.cityId = cityId;
////        };
//        vc.selectXiaoquBlock = ^(NSString *cityName, NSString *cityId, NSString *la, NSString *lo) {
//            strongWeakself.xiaoqu.textField.text = [NSString stringWithFormat:@"%@%@",cityName,cityId];
////            strongWeakself.cityId = cityId;
//            strongWeakself.latitude = la;
//            strongWeakself.longitude = lo;
//        };
//        [Weakself.navigationController pushViewController:vc animated:YES];
//    };
    [self.view addSubview:self.xiaoqu];

//    self.address = [[AddAdressCellView alloc] initWithTitle:@"楼号-门牌号：" placeholder:@"例如：A座905室" isNeedPush:NO];
//    [self.view addSubview:self.address];
    self.name = [[AddAdressCellView alloc] initWithTitle:@"收货人：" placeholder:@"请填写收货人姓名" isNeedPush:NO];
    [self.view addSubview:self.name];
    self.phone = [[AddAdressCellView alloc] initWithTitle:@"联系电话：" placeholder:@"请填写收货手机号" isNeedPush:NO];
    [self.view addSubview:self.phone];

    self.commintButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commintButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.commintButton addTarget:self action:@selector(commintButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.commintButton.backgroundColor = SMThemeColor;
    [self.view addSubview:self.commintButton];
    
}

- (void)setupLayout{
    [self.city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 74 + SafeTopSpace;
        make.left.right.offset = 0;
        make.height.offset = 50;
    }];
    [self.xiaoqu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.city.mas_bottom).offset = 1;
        make.left.right.offset = 0;
        make.height.offset = 50;
    }];
//    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.xiaoqu.mas_bottom).offset = 1;
//        make.left.right.offset = 0;
//        make.height.offset = 50;
//    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xiaoqu.mas_bottom).offset = 1;
        make.left.right.offset = 0;
        make.height.offset = 50;
    }];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset = 1;
        make.left.right.offset = 0;
        make.height.offset = 50;
    }];

    [self.commintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.phone.mas_bottom).offset = 40;
        make.height.offset = 35;
    }];
}

- (void)commintButtonAction:(UIButton *)sender{
    
    //进行数据验证
    if (!self.city.textField.text.length) {
        [MBHUDHelper showError:@"请选择城市"];
        return;
    }
    if (!self.xiaoqu.textField.text.length) {
        [MBHUDHelper showError:@"请输入小区"];
        return;
    }
//    if (!self.address.textField.text.length) {
//        [MBHUDHelper showError:@"请输入详细信息"];
//        return;
//    }
    if (!self.name.textField.text.length) {
        [MBHUDHelper showError:@"请输入联系人信息"];
        return;
    }
    if (![NSString isMobileNumber:self.phone.textField.text]) {
        [MBHUDHelper showWarningWithText:@"手机号码格式不对"];
        return;
    }
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"addressName"] = self.city.textField.text;
    parames[@"address"] = self.xiaoqu.textField.text;
    parames[@"name"] = self.name.textField.text;
    parames[@"phone"] = self.phone.textField.text;
    parames[@"isDefault"] = @"1";
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_addAddress parameters:parames successed:^(id json) {
        if (json) {
            [MBHUDHelper showSuccess:@"新增收货地址成功"];
            if (self.addSuccessBlock) {
                self.addSuccessBlock();
            }
            [Weakself.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
