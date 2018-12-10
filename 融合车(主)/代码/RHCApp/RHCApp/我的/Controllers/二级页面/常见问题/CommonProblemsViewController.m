//
//  CommonProblemsViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/29.
//

#import "CommonProblemsViewController.h"
#import "ExpandTableViewCell.h"
#import "ListModel.h"
#import "ListFrameModel.h"

static NSString *kExpandTableViewCell = @"ExpandTableViewCell";

@interface CommonProblemsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString    *type;
@property (nonatomic,strong) UIView      *headerView;
@end

@implementation CommonProblemsViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    [self setupUI];
    [self setupLayout];
    [self loadData];
}

#pragma mark UI
-(void)setupUI{
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ExpandTableViewCell class] forCellReuseIdentifier:kExpandTableViewCell];
    [self.view addSubview:self.tableView];
    [self adjustInsetWithScrollView:self.tableView];
    //设置头部选择权
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 100)];
    self.headerView.backgroundColor = SMViewBGColor;
    self.tableView.tableHeaderView = self.headerView;
    NSArray *typeArray = @[@"购车说明",@"费用说明",@"还款说明",@"提车说明",@"发布说明",@"其他说明"];
    
    NSUInteger count = typeArray.count;
    CGFloat titleButtonW = (Screen_W - 40) / 3;
    CGFloat titleButtonH = 35;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i + 1;
        [titleButton setTitleColor:SMParatextColor forState:UIControlStateNormal];
        [titleButton setTitleColor:SMThemeColor forState:UIControlStateSelected];
        titleButton.backgroundColor = [UIColor whiteColor];
        titleButton.titleLabel.font = LPFFONT(14);
        if (i == 0) {
            titleButton.selected = YES;
            self.type = @"1";
        }
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:titleButton];
        // 设置数据
        [titleButton setTitle:typeArray[i] forState:UIControlStateNormal];
        // 设置frame
        CGFloat padding = 10;
        if (i > 2) {
            padding = 10 + 35 + 10;
        }
        titleButton.frame = CGRectMake(i % 3 * (titleButtonW + 10) + 10, padding, titleButtonW, titleButtonH);
    }
    
}

- (void)titleClick:(UIButton *)sender{
    //获取头部view全部按钮
    for (UIView *view in self.headerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.selected = NO;
        }
    }
    sender.selected = YES;
    self.type = [NSString stringWithFormat:@"%tu",sender.tag];
    [self loadData];

}

-(void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.top.offset = 64 + SafeTopSpace;
    }];
}
#pragma mark UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExpandTableViewCell forIndexPath:indexPath];
//    [cell configModel:self.dataArray[indexPath.section] with:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ListFrameModel  *frameModel = self.dataArray[indexPath.row];
    if (frameModel.listModel.isSelected) {
        cell.answerLB.hidden = NO;
        cell.line1.hidden    = NO;
    }else{
        cell.answerLB.hidden = YES;
        cell.line1.hidden    = YES;
    }
    cell.frameModel = frameModel;
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListFrameModel  *frameModel = self.dataArray[indexPath.row];
    if (frameModel.listModel.isSelected) {
        return [self.dataArray[indexPath.row] expandCellHeight];
    }else{
        return [self.dataArray[indexPath.row] unExpandCellHeight];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListFrameModel  *frameModel = self.dataArray[indexPath.row];
    frameModel.listModel.isSelected = !frameModel.listModel.isSelected;
    [self.tableView reloadData];
}

- (void)loadData{
    NSMutableDictionary *paremes = [NSMutableDictionary dictionary];
    paremes[@"pageNo"] = @"1";
    paremes[@"pageSize"] = @"20";
    paremes[@"type"] = self.type;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_FaqList parameters:paremes successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [ListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            for (ListModel *model in array) {
                model.isSelected = NO;
                ListFrameModel *frameModel = [[ListFrameModel alloc]init];
                frameModel.listModel = model;
                [Weakself.dataArray addObject:frameModel];
            }
            [Weakself.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
