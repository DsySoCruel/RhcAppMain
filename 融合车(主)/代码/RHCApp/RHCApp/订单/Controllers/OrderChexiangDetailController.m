//
//  OrderChexiangDetailController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/14.
//

#import "OrderChexiangDetailController.h"
#import "OrderChexiangDetailModel.h"
#import "OrderDetailChexiangFirstCell.h"
#import "OrderDetailChexiangSecondCell.h"
#import "OrderDetailChexiangThirdCell.h"
#import "RequestManager.h"

static NSString *kOrderDetailChexiangFirstCell = @"OrderDetailChexiangFirstCell";
static NSString *kOrderDetailChexiangSecondCell = @"OrderDetailChexiangSecondCell";
static NSString *kOrderDetailChexiangThirdCell = @"OrderDetailChexiangThirdCell";


@interface OrderChexiangDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) OrderChexiangDetailModel *detailModel;
//创建头部提示条
@property (nonatomic,strong) UIView      *headerView1;
@property (nonatomic,strong) UIImageView *image1;
@property (nonatomic,strong) UILabel     *label01;

//@property (nonatomic,strong) UIView      *headerView2;
//@property (nonatomic,strong) UIView      *topBackView;
//@property (nonatomic,strong) UIImageView *image2;
//@property (nonatomic,strong) UILabel     *label02;
//@property (nonatomic,strong) UILabel     *label03;
//@property (nonatomic,strong) UIView      *line01;
//@property (nonatomic,strong) UILabel     *label04;
//@property (nonatomic,strong) UIView      *line02;

//创建底部提示条
@property (nonatomic,strong) UIView      *footerView;
//@property (nonatomic,strong) UIView      *backView;
//@property (nonatomic,strong) UIImageView *iconImage;
//@property (nonatomic,strong) UILabel     *label1;
//@property (nonatomic,strong) UILabel     *label2;
@property (nonatomic,strong) UIButton    *commitButton;

@end

@implementation OrderChexiangDetailController


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
    [self.tableView registerClass:[OrderDetailChexiangFirstCell class] forCellReuseIdentifier:kOrderDetailChexiangFirstCell];
    [self.tableView registerClass:[OrderDetailChexiangSecondCell class] forCellReuseIdentifier:kOrderDetailChexiangSecondCell];
     [self.tableView registerClass:[OrderDetailChexiangThirdCell class] forCellReuseIdentifier:kOrderDetailChexiangThirdCell];
    [self.view addSubview:self.tableView];
    
    //设置底部工具条
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
    self.footerView.backgroundColor = SMViewBGColor;
//    self.backView = [UIView new];
//    self.backView.backgroundColor = [UIColor whiteColor];
//    [self.footerView addSubview:self.backView];
//    self.iconImage = [UIImageView new];
//    self.iconImage.image = IMAGECACHE(@"digndanxiangqing_02");
//    [self.backView addSubview:self.iconImage];
//    self.label1 = [UILabel new];
//    self.label1.textColor = SMTextColor;
//    self.label1.font = LPFFONT(14);
//    self.label1.text = @"提车地址:";
//    [self.backView addSubview:self.label1];
//    self.label2 = [UILabel new];
//    self.label2.numberOfLines = 0;
//    self.label2.textColor = SMParatextColor;
//    self.label2.font = LPFFONT(14);
//    [self.backView addSubview:self.label2];
    
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
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.offset = 0;
//        make.height.offset = 70;
//    }];
//    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.offset = 0;
//        make.left.offset = 15;
//    }];
//    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.offset = 0;
//        make.left.equalTo(self.iconImage.mas_right).offset = 5;
//    }];
//    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.label1.mas_right).offset = 0;
//        make.right.offset = -10;
//        make.top.bottom.offset = 0;
//    }];
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
    [[NetWorkManager shareManager] POST:USER_CarriageOrderDetail parameters:parames successed:^(id json) {
        if (json) {
            Weakself.detailModel = [OrderChexiangDetailModel mj_objectWithKeyValues:json];
            [Weakself.tableView reloadData];
            //判断订单状态设置不用的提示
            NSString *orderStatus = @"";
            if ([Weakself.detailModel.order_status isEqualToString:@"wait_pending"]) {//待审核
                orderStatus = @"催促审核";
                [self setHeader1:@"1"];
            }else if ([Weakself.detailModel.order_status isEqualToString:@"wait_pay"]){//待支付
                orderStatus = @"支付";
                [self setHeader1:@"2"];
            }else if ([Weakself.detailModel.order_status isEqualToString:@"fail"]){//失败
                orderStatus = @"查看原因";
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
        OrderDetailChexiangFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailChexiangFirstCell];
        cell.model = self.detailModel;
        return cell;
    }else if(indexPath.row == 1){
        OrderDetailChexiangSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailChexiangSecondCell];
        cell.model = self.detailModel;
        return cell;
    }else{//车厢详情 待定
        OrderDetailChexiangThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderDetailChexiangThirdCell];
//        cell.model = self.detailModel;
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
        
    }else if ([self.detailModel.order_status isEqualToString:@"fail"]){//失败

    }
    
}

- (void)setHeader1:(NSString *)str{
    
    self.headerView1 = [UIView new];
    self.headerView1.backgroundColor = SMViewBGColor;
    self.headerView1.frame = CGRectMake(0, 0, Screen_W, 80);
    self.label01 = [UILabel new];
    self.label01.textColor = SMThemeColor;
    self.label01.font = BFONT(14);
    self.label01.textAlignment = NSTextAlignmentLeft;
    self.label01.numberOfLines = 0;
    if ([str isEqualToString:@"1"]) {
        self.label01.text = @"您的需求我们已经接收\n稍后将有专业人员与您取得联系";
    }else{
        self.label01.text = @"订单信息已审核返回\n如无问题请在24小时内支付定金";
    }
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

@end
