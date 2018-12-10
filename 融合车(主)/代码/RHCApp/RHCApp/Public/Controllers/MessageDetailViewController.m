//
//  MessageDetailViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/24.
//

#import "MessageDetailViewController.h"
#import "MessageListModel.h"
#import "MessageViewCell.h"

static NSString *kMessageViewCell = @"MessageViewCell";

@interface MessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datasource;
@end

@implementation MessageDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setupUI];
    [self setupLayout];
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    parames[@"type"] = self.type;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_GetNewsList parameters:parames successed:^(id json) {
        if (json) {
            Weakself.datasource = [MessageListDetailModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.tableView reloadData];
            if (!Weakself.datasource.count) {
                [self showEmptyMessage:@"暂无消息"];
            }else{
                [self hideEmptyView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)setupUI{
    self.datasource = [NSMutableArray array];
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
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageViewCell];
    cell.model = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        MessageListDetailModel *model = self.messageListmodel.SystemNotificatio;
//        model.state = @"";
//    }
//    if (indexPath.row == 1) {
//        MessageListDetailModel *model = self.messageListmodel.PreferentialActivities;
//        model.state = @"";
//    }
//    if (indexPath.row == 2) {
//        MessageListDetailModel *model = self.messageListmodel.OrderFeedback;
//        model.state = @"";
//    }
//    if (indexPath.row == 3) {
//        MessageListDetailModel *model = self.messageListmodel.CarCircleInteraction;
//        model.state = @"";
//    }
    [self.tableView reloadData];
}


@end
