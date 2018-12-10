//
//  MyAddressController.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "MyAddressController.h"
#import "MyAddressControllerCell.h"
#import "EditAddressController.h"
#import "MyAddressModel.h"

static NSString * kMyAddressControllerCell = @"kMyAddressControllerCell";

@interface MyAddressController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *addAdressButton;


@end

@implementation MyAddressController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    [self loadData];
    [self setupUI];
    [self setupLayout];
    
//    AddressModel *model1 = [AddressModel new];
//    model1.city = @"北京";
//    model1.xiaoqu = @"西城区白纸坊东街";
//    model1.homeNum = @"8楼801";
//    model1.name = @"孙先生";
//    model1.phone = @"13233822520";
//    [self.dataArray addObject:model1];
//    [self.dataArray addObject:model1];
//    [self.dataArray addObject:model1];
//    [self.dataArray addObject:model1];
//    [self.dataArray addObject:model1];
//    [self.dataArray addObject:model1];
}
-(void)setupUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[MyAddressControllerCell class] forCellReuseIdentifier:kMyAddressControllerCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 190;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = SMViewBGColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.addAdressButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.addAdressButton setTitle:@"新建收货地址" forState:UIControlStateNormal];
    [self.addAdressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addAdressButton.backgroundColor = SMThemeColor;
    self.addAdressButton.titleLabel.font = MFFONT(14);
    [self.addAdressButton addTarget:self action:@selector(addAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addAdressButton];
}

- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset = 0;
        make.bottom.offset = -40 - SafeBottomSpace * 0.5;
    }];
    [self.addAdressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(self.tableView.mas_bottom);
        make.bottom.offset = - SafeBottomSpace * 0.5;
    }];
}

- (void)loadData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_myaddress parameters:parames successed:^(id json) {
        if (json) {
            NSArray *moreArray = [MyAddressModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:moreArray];
            [Weakself.tableView reloadData];
            if (Weakself.dataArray.count == 0) {
                [self showEmptyMessage:@"暂无收货地址"];
            }else{
                [self hideEmptyView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAddressControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyAddressControllerCell];
    MyAddressModel *model =  self.dataArray[indexPath.row];
    cell.model = model;
    WeakObj(self);
    cell.updataCell = ^(NSString *addressId) {
        for (MyAddressModel *model in Weakself.dataArray) {
            if ([model.addressId isEqualToString:addressId]) {
                model.isDefault = @"1";
            }else{
                model.isDefault = @"0";
            }
        }
        [Weakself.tableView reloadData];
    };
    cell.deleCellBlock = ^(NSString *addressId) {
        for (MyAddressModel *addressModel in Weakself.dataArray) {
            if ([addressModel.addressId isEqualToString:addressId]) {
                [Weakself.dataArray removeObject:addressModel];
                break;
            }
        }
        [Weakself.tableView reloadData];
        if (Weakself.dataArray.count == 0) {
            [Weakself showEmptyMessage:@"暂无收货地址"];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isNeedSelect) {
        //需要返回订单信息
        if (self.selectAddressBlock) {
            self.selectAddressBlock(self.dataArray[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 新建收货地址
- (void)addAddressAction:(UIButton *)sender{
    EditAddressController *controller = [EditAddressController new];
    WeakObj(self);
    controller.addSuccessBlock = ^{
        [Weakself.dataArray removeAllObjects];
        [Weakself loadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

@end
