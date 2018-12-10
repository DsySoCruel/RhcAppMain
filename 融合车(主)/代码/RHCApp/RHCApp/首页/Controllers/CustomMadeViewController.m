//
//  CustomMadeViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/1.
//

#import "CustomMadeViewController.h"
#import "SectionFooterView1.h"
#import "KemaoTextView.h"
#import "BookCarriageViewCell.h"

#import "YLAwesomeData.h"
#import "YLDataConfiguration.h"
#import "YLAwesomeSheetController.h"
#import "RequestManager.h"

static NSString *kBookCarriageViewCell = @"BookCarriageViewCell";

@interface CustomMadeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView      *footView;
@property (nonatomic,strong) KemaoTextView *textView;
@property (nonatomic,strong) UIButton    *senderButton;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel     *secondLabel;

//提交成功之后的代码
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel     *label1;
@property (nonatomic,strong) UILabel     *label2;
@property (nonatomic,strong) UIButton    *baceButton;
@end

@implementation CustomMadeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专属定制";
    self.view.backgroundColor = SMViewBGColor;
    [self setupUI];
    [self setupLayout];
}

- (void)rightBarButtonItemAction{
    [[RequestManager sharedInstance] connectWithServer];
}

- (void)setupUI{
    UIBarButtonItem *message = [UIBarButtonItem itemWithimage:IMAGECACHE(@"home_02") highImage:IMAGECACHE(@"home_02") target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = message;
    
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
    
    UIImageView *headView = [UIImageView new];
    headView.image = IMAGECACHE(@"book_01");
    headView.frame = CGRectMake(0, 0, 0, 150);
    self.tableView.tableHeaderView = headView;
    self.footView = [UIView new];
    self.footView.backgroundColor = SMViewBGColor;
    
    self.textView = [KemaoTextView new];
    self.textView.font = PFFONT(14);
    self.textView.textColor = SMTextColor;
    self.textView.placeholderColor = SMParatextColor;
    //    self.textView.delegate = self;
    self.textView.placeholder = @"什么都可以给我们说哟";
    [self.footView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.right.offset = -5;
        make.top.offset = 0;
        make.bottom.offset = -50;
    }];
    
    self.senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.senderButton setTitle:@"提交意向车型信息" forState:UIControlStateNormal];
    self.senderButton.layer.cornerRadius = 4;
    self.senderButton.layer.masksToBounds = YES;
    self.senderButton.backgroundColor = [UIColor redColor];
    self.senderButton.titleLabel.font = LPFFONT(15);
    [self.senderButton addTarget:self action:@selector(senderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:self.senderButton];
    [self.senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = 0;
        make.right.offset = -30;
        make.left.offset = 30;
        make.height.offset = 35;
    }];
    self.footView.frame = CGRectMake(0, 0, 0, 150);
    self.tableView.tableFooterView = self.footView;
    
}
- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 64 + SafeTopSpace;
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookCarriageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBookCarriageViewCell];
    if (indexPath.row == 0) {
        cell.label1.text = @"意向车型";
        self.textField = [UITextField new];
        self.textField.placeholder = @"您看中了哪辆车";
        self.textField.font = LPFFONT(13);
        [cell.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 100;
            make.right.offset = -10;
            make.height.offset = 35;
            make.centerY.offset = 0;
        }];
    }
    if (indexPath.row == 1) {
        cell.label1.text = @"购车方式";
        UIImageView *image = [UIImageView new];
        image.image = IMAGECACHE(@"tijiaodongdan_03");
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.centerY.offset = 0;
        }];
        self.secondLabel = [UILabel new];
        self.secondLabel.text = @"固定分期";
        self.secondLabel.font = LPFFONT(12);
        self.secondLabel.textColor = SMTextColor;
        [cell.contentView addSubview:self.secondLabel];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset = 0;
            make.left.offset = 100;
            make.right.offset = -30;
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionFooterView1 *view = [[SectionFooterView1 alloc] initWithTitle:@"意向信息"];
    view.frame = CGRectMake(0, 0, 0, 45);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.row == 1) {
        //弹框选择平板样式的鬼
        YLDataConfiguration *config = [[YLDataConfiguration alloc] initWithType:YLDataConfigTypeFengqi selectedData:@[]];
        WeakObj(self)
        [[[YLAwesomeSheetController alloc] initWithTitle:nil
                                                  config:config
                                                callBack:^(NSArray *selectedData) {
                                                    
                                                    YLAwesomeData *data = [selectedData firstObject];
                                                    Weakself.secondLabel.text = data.name;
                                                    
                                                }] showInController:self];
    }
}


- (void)senderButtonAction:(UIButton *)sender{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    if ([YXDUserInfoStore sharedInstance].loginStatus) {
        parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    }else{
        //弹出登录框
        [self presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
        return;
    }
    parames[@"payType"] = self.secondLabel.text;
    if (self.textField.text.length) {
        parames[@"carIntention"] = self.textField.text;
    }else{
        [MBHUDHelper showError:@"请输入车型名称"];
        return;
    }
    if (self.textView.text.length) {
        parames[@"remark"] = self.textView.text;
    }
    WeakObj(self)
    [[NetWorkManager shareManager] POST:USER_AddPrivateCustomization parameters:parames successed:^(id json) {
        if (json) {
            [Weakself seccess];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)seccess{
    
    //成功之后执行布局
    //1.
    [self.tableView removeFromSuperview];
    //2.
    self.iconImage = [UIImageView new];
    self.iconImage.image = IMAGECACHE(@"tijiaochenggong_02");
    [self.view addSubview:self.iconImage];
    
    self.label1 = [UILabel new];
    self.label1.text = @"我们已经收到！";
    self.label1.textColor = [UIColor redColor];
    self.label1.font = MFFONT(16);
    [self.view addSubview:self.label1];
    
    self.label2 = [UILabel new];
    self.label2.text = @"稍后，我们的专业服务人员会根据您的需求，为您制定最适合您的购车方案 , 之后订单方式推送，请注意查收";
    self.label2.numberOfLines = 0;
    self.label2.textColor = SMParatextColor;
    self.label2.font = LPFFONT(12);
    [self.view addSubview:self.label2];
    
    self.baceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.baceButton setTitle:@"返回首页" forState:UIControlStateNormal];
    self.baceButton.backgroundColor = [UIColor redColor];
    self.baceButton.layer.cornerRadius = 4;
    self.baceButton.layer.masksToBounds = YES;
    [self.baceButton addTarget:self action:@selector(baceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.baceButton.titleLabel.font = LPFFONT(15);
    [self.view addSubview:self.baceButton];
    
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.offset = 100;
        make.width.height.offset = 100;
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.iconImage.mas_bottom).offset = 15;
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.label1.mas_bottom).offset = 15;
        make.right.offset = -20;
        make.left.offset = 20;
    }];
    
    [self.baceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.bottom.offset = -40;
        make.height.offset = 35;
    }];
}

- (void)baceButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
