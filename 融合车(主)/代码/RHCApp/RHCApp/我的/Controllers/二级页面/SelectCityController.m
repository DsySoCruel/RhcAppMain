//
//  SelectCityController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/26.
//

#import "SelectCityController.h"
#import "SelectCityModel.h"

static NSString * kSelectCityController = @"kSelectCityController";

@interface SelectCityController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger num;//1.省2.市3.县
@property (nonatomic,strong) NSString *one;//一级
@property (nonatomic,strong) NSString *two;//二级
@property (nonatomic,strong) NSString *three;//三级
@property (nonatomic,strong) NSString *saveId;

@end

@implementation SelectCityController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    self.num = 1;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSelectCityController];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = SMViewBGColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.bottom.top.offset = 0;
    }];
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectCityController];
    SelectCityModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCityModel *model = self.dataArray[indexPath.row];
    self.saveId = model.aid;
    if (self.num == 1) {
        self.one = model.name;
        [self loadData];
    }
    if (self.num == 2) {
        self.two = model.name;
        [self loadData];
    }
    if (self.num == 3) {
        self.three = model.name;
        if (self.selectCityBlock) {
//            self.selectCityBlock(model.area_name,model.aid);
            self.selectCityBlock([NSString stringWithFormat:@"%@,%@,%@",self.one,self.two,self.three]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    ++self.num;
}

- (void)loadData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    if (self.saveId.length) {
        parames[@"parent"] = self.saveId;
    }
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_AreaDataParam parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *moreTopics = [SelectCityModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:moreTopics];
            [Weakself.tableView reloadData];
            if (Weakself.num == 3 && !Weakself.dataArray.count) {
                if (self.selectCityBlock) {
                    //            self.selectCityBlock(model.area_name,model.aid);
                    self.selectCityBlock([NSString stringWithFormat:@"%@,%@",self.one,self.two]);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
