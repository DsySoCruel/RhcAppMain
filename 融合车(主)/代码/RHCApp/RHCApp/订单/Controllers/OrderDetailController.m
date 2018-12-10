//
//  OrderDetailController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/9.
//

#import "OrderDetailController.h"
#import "OrderCarDetailModel.h"
#import "OrderDetailFIrstCell.h"
#import "OrderDetailSecondCell.h"
#import "PayViewController.h"
#import "RequestManager.h"

static NSString *kOrderDetailFIrstCell = @"OrderDetailFIrstCell";
static NSString *kOrderDetailSecondCell = @"OrderDetailSecondCell";

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) OrderCarDetailModel *detailModel;
//创建头部提示条
@property (nonatomic,strong) UIView      *headerView1;
@property (nonatomic,strong) UIImageView *image1;
@property (nonatomic,strong) UILabel     *label01;

@property (nonatomic,strong) UIView      *headerView2;
@property (nonatomic,strong) UIView      *topBackView;
@property (nonatomic,strong) UIImageView *image2;
@property (nonatomic,strong) UILabel     *label02;
@property (nonatomic,strong) UILabel     *label03;
@property (nonatomic,strong) UIView      *line01;
@property (nonatomic,strong) UILabel     *label04;
@property (nonatomic,strong) UIView      *line02;

@property (nonatomic,strong) UIView      *headerView3;
@property (nonatomic,strong) UIView      *topBackView3;
@property (nonatomic,strong) UIImageView *image23;
@property (nonatomic,strong) UILabel     *label023;
@property (nonatomic,strong) UILabel     *label033;
@property (nonatomic,strong) UIView      *line013;
@property (nonatomic,strong) UILabel     *label043;
@property (nonatomic,strong) UIView      *line023;

//创建底部提示条
@property (nonatomic,strong) UIView      *footerView;
@property (nonatomic,strong) UIView      *backView;
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel     *label1;
@property (nonatomic,strong) UILabel     *label2;
@property (nonatomic,strong) UIButton    *commitButton;
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self loadData];
}
- (void)rightBarButtonItemAction{
    [[RequestManager sharedInstance] connectWithServer];
}

- (void)setupUI{
    self.view.backgroundColor = SMViewBGColor;
    
    UIBarButtonItem *message = [UIBarButtonItem itemWithimage:IMAGECACHE(@"home_02") highImage:IMAGECACHE(@"home_02") target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = message;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = SMViewBGColor;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[OrderDetailFIrstCell class] forCellReuseIdentifier:kOrderDetailFIrstCell];
    [self.tableView registerClass:[OrderDetailSecondCell class] forCellReuseIdentifier:kOrderDetailSecondCell];
    [self.view addSubview:self.tableView];

    //设置底部工具条
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 180)];
    self.footerView.backgroundColor = SMViewBGColor;
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.footerView addSubview:self.backView];
    self.iconImage = [UIImageView new];
    self.iconImage.image = IMAGECACHE(@"digndanxiangqing_02");
    [self.backView addSubview:self.iconImage];
    self.label1 = [UILabel new];
    self.label1.textColor = SMTextColor;
    self.label1.font = LPFFONT(14);
    self.label1.text = @"提车地址:";
    [self.backView addSubview:self.label1];
    self.label2 = [UILabel new];
    self.label2.numberOfLines = 0;
    self.label2.textColor = SMParatextColor;
    self.label2.font = LPFFONT(14);
    [self.backView addSubview:self.label2];
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitButton.layer.cornerRadius = 5;
    self.commitButton.layer.masksToBounds = YES;
    self.commitButton.backgroundColor = [UIColor orangeColor];
    [self.footerView addSubview:self.commitButton];
    [self.commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = self.footerView;

}

- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset = 0;
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset = 0;
        make.height.offset = 70;
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 15;
    }];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.equalTo(self.iconImage.mas_right).offset = 5;
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label1.mas_right).offset = 0;
        make.right.offset = -10;
        make.top.bottom.offset = 0;
    }];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = -30;
        make.left.offset = 15;
        make.right.offset = -15;
        make.height.offset = 40;
    }];
}

- (void)loadData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"orderId"] = self.orderId;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductOrderDetail parameters:parames successed:^(id json) {
        if (json) {
            Weakself.detailModel = [OrderCarDetailModel mj_objectWithKeyValues:json[@"productOrderDetail"]];
            [Weakself.tableView reloadData];
            Weakself.label2.text = Weakself.detailModel.address;
            //判断订单状态设置不用的提示
            NSString *orderStatus = @"";
            if ([Weakself.detailModel.order_status isEqualToString:@"wait_pending"]) {//待审核
                orderStatus = @"催促审核";
            }else if ([Weakself.detailModel.order_status isEqualToString:@"wait_pay"]){//待支付
                orderStatus = @"支付";
                [self setHeader1];
            }else if ([Weakself.detailModel.order_status isEqualToString:@"fail"]){//失败
                orderStatus = @"查看原因";
                [self setHeader2];
            }else if ([Weakself.detailModel.order_status isEqualToString:@"wait_shipments"]){//支付成功
                orderStatus = @"下一步资料审核";
                [self setHeader3];
            }
            [self.commitButton setTitle:orderStatus forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        OrderDetailFIrstCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailFIrstCell];
        cell.model = self.detailModel;
        return cell;
    }else{
        OrderDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailSecondCell];
        cell.model = self.detailModel;
        return cell;
    }
}

- (void)commitButtonAction:(UIButton *)sender{
    if ([self.detailModel.order_status isEqualToString:@"wait_pending"]) {//待审核
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
        parames[@"orderId"] = self.orderId;
        [[NetWorkManager shareManager] POST:USER_AddOrderUrge parameters:parames successed:^(id json) {
            if (json) {
                sender.userInteractionEnabled = NO;
                sender.backgroundColor = UNAble_color;
                [MBHUDHelper showSuccess:@"催促成功,请耐心等待!"];
            }
        } failure:^(NSError *error) {
            
        }];
    }else if ([self.detailModel.order_status isEqualToString:@"wait_pay"]){//待支付
        PayViewController *vc = [PayViewController new];
        vc.orderId = self.orderId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.detailModel.order_status isEqualToString:@"fail"]){//失败
        
    }else if ([self.detailModel.order_status isEqualToString:@"wait_shipments"]){//支付成功
        
    }
    
}

- (void)setHeader1{
    
    self.headerView1 = [UIView new];
    self.headerView1.backgroundColor = SMViewBGColor;
    self.headerView1.frame = CGRectMake(0, 0, Screen_W, 60);
    self.label01 = [UILabel new];
    self.label01.textColor = SMThemeColor;
    self.label01.font = BFONT(14);
    self.label01.text = @"审核通过,请在两天内完成购车流程";
    [self.headerView1 addSubview:self.label01];
    self.image1 = [UIImageView new];
    self.image1.image = IMAGECACHE(@"digndanxiangqing_01");
    [self.headerView1 addSubview:self.image1];
    self.tableView.tableHeaderView = self.headerView1;
    
    [self.label01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.offset = 0;
    }];
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.equalTo(self.label01.mas_left).offset = -10;
    }];
}

- (void)setHeader2{
    
    self.headerView2 = [UIView new];
    self.headerView2.backgroundColor = [UIColor whiteColor];
    self.headerView2.frame = CGRectMake(0, 0, Screen_W, 60 + 45 + 45 + 10);
    self.topBackView = [UIView new];
    self.topBackView.backgroundColor = SMViewBGColor;
    [self.headerView2 addSubview:self.topBackView];
    self.label02 = [UILabel new];
    self.label02.textColor = SMTextColor;
    self.label02.font = BFONT(16);
    self.label02.text = @"审核失败！";
    [self.topBackView addSubview:self.label02];
    self.image2 = [UIImageView new];
    self.image2.image = IMAGECACHE(@"");
    [self.topBackView addSubview:self.image2];
    
    self.label03 = [UILabel new];
    self.label03.textColor = SMTextColor;
    self.label03.font = LPFFONT(15);
    self.label03.text = @"审核失败原因";
    [self.headerView2 addSubview:self.label03];
    
    self.line01 = [UIView new];
    self.line01.backgroundColor = SMViewBGColor;
    [self.headerView2 addSubview:self.line01];
    
    self.label04 = [UILabel new];
    self.label04.textColor = SMParatextColor;
    self.label04.font = LPFFONT(14);
    self.label04.text = @"审核失败原因";
    self.label04.numberOfLines = 0;
    [self.headerView2 addSubview:self.label04];
    
    self.line02 = [UIView new];
    self.line02.backgroundColor = SMViewBGColor;
    [self.headerView2 addSubview:self.line02];

    self.tableView.tableHeaderView = self.headerView2;
    
    [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset = 0;
        make.height.offset = 60;
    }];
    
    [self.label02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.offset = 0;
    }];
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.equalTo(self.label02.mas_left).offset = -10;
    }];
    [self.label03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.topBackView.mas_bottom).offset = 0;
        make.height.offset = 45;
    }];
    [self.line01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.height.offset =0.5;
        make.top.equalTo(self.label03.mas_bottom).offset = -0.5;
    }];
    [self.label04 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.label03.mas_bottom).offset = 0;
        make.height.offset = 45;
    }];
    [self.line02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.height.offset =10;
        make.top.equalTo(self.label04.mas_bottom).offset = 0;
    }];
}

- (void)setHeader3{
    
    self.headerView3 = [UIView new];
    self.headerView3.backgroundColor = [UIColor whiteColor];
    self.headerView3.frame = CGRectMake(0, 0, Screen_W, 60 + 45 + 45 + 10);
    self.topBackView3 = [UIView new];
    self.topBackView3.backgroundColor = SMViewBGColor;
    [self.headerView3 addSubview:self.topBackView3];
    self.label023 = [UILabel new];
    self.label023.textColor = [UIColor redColor];
    self.label023.font = BFONT(16);
    self.label023.text = @"支付完成";
    [self.topBackView3 addSubview:self.label023];
    self.image23 = [UIImageView new];
    self.image23.image = IMAGECACHE(@"digndanxiangqing_01");
    [self.topBackView3 addSubview:self.image23];
    
    self.label033 = [UILabel new];
    self.label033.textColor = SMTextColor;
    self.label033.font = LPFFONT(15);
    self.label033.text = @"支付订单完成";
    [self.headerView3 addSubview:self.label033];
    
    self.line013 = [UIView new];
    self.line013.backgroundColor = SMViewBGColor;
    [self.headerView3 addSubview:self.line013];
    
    self.label043 = [UILabel new];
    self.label043.textColor = SMParatextColor;
    self.label043.font = LPFFONT(14);
    self.label043.text = @"稍后将有工作人员与您取得联系,进行资料审核";
    self.label043.numberOfLines = 0;
    [self.headerView3 addSubview:self.label043];
    
    self.line023 = [UIView new];
    self.line023.backgroundColor = SMViewBGColor;
    [self.headerView3 addSubview:self.line023];
    
    self.tableView.tableHeaderView = self.headerView3;
    
    [self.topBackView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset = 0;
        make.height.offset = 60;
    }];
    
    [self.label023 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.offset = 0;
    }];
    [self.image23 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.equalTo(self.label023.mas_left).offset = -10;
    }];
    [self.label033 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.topBackView3.mas_bottom).offset = 0;
        make.height.offset = 45;
    }];
    [self.line013 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.height.offset =0.5;
        make.top.equalTo(self.label033.mas_bottom).offset = -0.5;
    }];
    [self.label043 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.label033.mas_bottom).offset = 0;
        make.height.offset = 45;
    }];
    [self.line023 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.height.offset =10;
        make.top.equalTo(self.label043.mas_bottom).offset = 0;
    }];
    
}
@end
