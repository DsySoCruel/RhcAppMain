//
//  AllConfigurationController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/4.
//

#import "AllConfigurationController.h"
#import "ProductDetailParamesCell.h"

static NSString *kProductDetailParamesCell = @"ProductDetailParamesCell";

@interface AllConfigurationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation AllConfigurationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    self.title = @"配置详情";
    self.dataArray = [NSMutableArray array];
    //1.设置tableView
    [self.view addSubview:self.tableView];
    //    [self adjustInsetWithScrollView:self.tableView];
    //    [self loadNewsData];
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
        [_tableView registerClass:[ProductDetailParamesCell class] forCellReuseIdentifier:kProductDetailParamesCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        //        _tableView.estimatedRowHeight = 150;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paramesArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *a = [UILabel new];
    a.text = @"--产品配置--";
    a.textColor = SMParatextColor;
    a.font = LPFFONT(12);
    a.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:a];
    [a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset = 0;
    }];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailParamesCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductDetailParamesCell];
    cell.model = self.paramesArray[indexPath.row];
    return cell;
}



@end
