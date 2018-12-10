//
//  SendWantCarView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/6.
//

#import "SendWantCarView.h"
#import "SectionFooterView1.h"
#import "KemaoTextView.h"
#import "BookCarriageViewCell.h"

#import "SelectBrandNameController.h"
#import "SelectCityController.h"


static NSString *kBookCarriageViewCell = @"BookCarriageViewCell";

@interface SendWantCarView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView      *footView;
@property (nonatomic,strong) UIButton    *senderButton;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel     *secondLabel;
@property (nonatomic,strong) UILabel     *thiredLabel;

@end

@implementation SendWantCarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    
    [self addSubview:self.tableView];
    
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, 0, 180);
    self.tableView.tableHeaderView = headView;
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = IMAGECACHE(@"search_01");
    [headView addSubview:imageView];
    UILabel *label1 = [UILabel new];
    label1.text = @"无搜索结果";
    label1.textColor = SMParatextColor;
    label1.font = LPFFONT(14);
    [headView addSubview:label1];
    UILabel *label2 = [UILabel new];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = SMParatextColor;
    label2.font = LPFFONT(14);
    label2.text = @"告诉我们您的要求，有符合条件的\n新车将第一时间通知您";
    [headView addSubview:label2];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 60;
        make.centerX.offset = 0;
        make.top.offset = 10;
    }];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(imageView.mas_bottom).offset = 10;
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(label1.mas_bottom).offset = 10;
    }];
        
    self.footView = [UIView new];
    self.footView.backgroundColor = SMViewBGColor;
    
    self.senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.senderButton setTitle:@"发送" forState:UIControlStateNormal];
    self.senderButton.layer.cornerRadius = 20;
    self.senderButton.layer.masksToBounds = YES;
    self.senderButton.backgroundColor = SMThemeColor;
    self.senderButton.titleLabel.font = LPFFONT(15);
    [self.senderButton addTarget:self action:@selector(senderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:self.senderButton];
    [self.senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = 0;
        make.right.offset = -30;
        make.left.offset = 30;
        make.height.offset = 40;
    }];
    self.footView.frame = CGRectMake(0, 0, 0, 70);
    self.tableView.tableFooterView = self.footView;
    
}
- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 44;
        make.left.right.bottom.offset = 0;
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[BookCarriageViewCell class] forCellReuseIdentifier:kBookCarriageViewCell];
        //        [_tableView registerClass:[FindViewDetailViewCell class] forCellReuseIdentifier:hFindViewDetailViewCell];
        //        [_tableView registerClass:[FindViewDetailViewBigCell class] forCellReuseIdentifier:hFindViewDetailViewBigCell];
        //        [_tableView registerClass:[CircleVClistCell class] forCellReuseIdentifier:hCircleVClistCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = SMViewBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCarriageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBookCarriageViewCell];
    if (indexPath.row == 2) {
        cell.label1.text = @"手机号";
        self.textField = [UITextField new];
        self.textField.placeholder = @"请输入手机号";
        self.textField.font = LPFFONT(13);
        [cell.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 100;
            make.right.offset = -10;
            make.height.offset = 35;
            make.centerY.offset = 0;
        }];
    }
    if (indexPath.row == 0) {
        cell.label1.text = @"品牌车系";
        UIImageView *image = [UIImageView new];
        image.image = IMAGECACHE(@"search_02");
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.centerY.offset = 0;
        }];
        self.secondLabel = [UILabel new];
        self.secondLabel.text = @"请选择";
        self.secondLabel.font = LPFFONT(12);
        self.secondLabel.textColor = SMTextColor;
        [cell.contentView addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.left.offset = 100;
            make.right.offset = -30;
        }];
    }
    if (indexPath.row == 1) {
        cell.label1.text = @"城市";
        UIImageView *image = [UIImageView new];
        image.image = IMAGECACHE(@"search_02");
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.centerY.offset = 0;
        }];
        self.thiredLabel = [UILabel new];
        self.thiredLabel.text = @"请选择";
        self.thiredLabel.font = LPFFONT(12);
        self.thiredLabel.textColor = SMTextColor;
        [cell.contentView addSubview:self.thiredLabel];
        [self.thiredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.left.offset = 100;
            make.right.offset = -30;
        }];
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    if (indexPath.row == 0) {
        SelectBrandNameController *vc = [SelectBrandNameController new];
        WeakObj(self);
        vc.selectCarBlock = ^(NSString * _Nonnull carName, NSString * _Nonnull carId) {
            Weakself.secondLabel.text = carName;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        SelectCityController *vc = [SelectCityController new];
        WeakObj(self);
        vc.selectCityBlock = ^(NSString *cityName) {
            Weakself.thiredLabel.text = cityName;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)senderButtonAction:(UIButton *)sender{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    if ([self.secondLabel.text isEqualToString:@"请选择"]) {
        [MBHUDHelper showError:@"请选择品牌"];
        return;
    }
    if ([self.thiredLabel.text isEqualToString:@"请选择"]) {
        [MBHUDHelper showError:@"请选择城市"];
        return;
    }
    parames[@"title"] = self.secondLabel.text;
    parames[@"city"]  = self.thiredLabel.text;
    if (self.textField.text.length) {
        parames[@"phone"] = self.textField.text;
    }else{
        [MBHUDHelper showError:@"请输入手机号"];
        return;
    }
    WeakObj(self)
    [[NetWorkManager shareManager] POST:USER_AddSubmitData parameters:parames successed:^(id json) {
        if (json) {
            [Weakself seccess];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)seccess{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
