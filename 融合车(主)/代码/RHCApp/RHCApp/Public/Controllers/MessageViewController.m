//
//  MessageViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/29.
//

#import "MessageViewController.h"
#import "MessageListModel.h"
#import "MessageViewCell.h"
#import "MessageDetailViewController.h"

static NSString *kMessageViewCell = @"MessageViewCell";

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MessageListModel *messageListmodel;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setupUI];
    [self setupLayout];
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_GetfirstNewsList parameters:parames successed:^(id json) {
        if (json) {
           Weakself.messageListmodel = [MessageListModel mj_objectWithKeyValues:json];
           [Weakself.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)setupUI{
    //1.设置tableView
    [self.view addSubview:self.tableView];
}
- (void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.top.offset = SafeTopSpace;
        make.bottom.offset = 0;
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[MessageViewCell class] forCellReuseIdentifier:kMessageViewCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageListmodel ? 4 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageViewCell];
    if (indexPath.row == 0) {
        cell.model = self.messageListmodel.SystemNotificatio;
    }
    if (indexPath.row == 1) {
        cell.model = self.messageListmodel.PreferentialActivities;
    }
    if (indexPath.row == 2) {
        cell.model = self.messageListmodel.OrderFeedback;
    }
    if (indexPath.row == 3) {
        cell.model = self.messageListmodel.CarCircleInteraction;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageDetailViewController *vc = [MessageDetailViewController new];
    if (indexPath.row == 0) {
        MessageListDetailModel *model = self.messageListmodel.SystemNotificatio;
        model.state = @"";
        vc.type = @"1";
    }
    if (indexPath.row == 1) {
        MessageListDetailModel *model = self.messageListmodel.PreferentialActivities;
        model.state = @"";
        vc.type = @"2";
    }
    if (indexPath.row == 2) {
        MessageListDetailModel *model = self.messageListmodel.OrderFeedback;
        model.state = @"";
        vc.type = @"3";
    }
    if (indexPath.row == 3) {
        MessageListDetailModel *model = self.messageListmodel.CarCircleInteraction;
        model.state = @"";
        vc.type = @"4";
    }
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView reloadData];
}

@end
