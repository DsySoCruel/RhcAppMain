//
//  SelectBrandNameController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/19.
//

#import "SelectBrandNameController.h"
#import "BrandModel.h"
#import "BMChineseSort.h"
#import "SelectBrandNameCell.h"


static NSString *kSelectBrandNameCell = @"SelectBrandNameCell";

@interface SelectBrandNameController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *indexArray;//索引数组
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation SelectBrandNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self loadData];
}

- (void)loadData{
    WeakObj(self);
    [MBHUDHelper showLoadingHUDView:self.view];
    [[NetWorkManager shareManager] POST:USER_listBrand parameters:nil successed:^(id json) {
        if (json) {
            NSArray *tempArray = [BrandModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself refreshSort:tempArray];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)refreshSort:(NSArray *)datas {
    self.indexArray = [BMChineseSort IndexWithArray:datas Key:@"title"];
    self.dataArray = [BMChineseSort sortObjectArray:datas Key:@"title"];
    [self.tableView reloadData];
}


- (void)setupUI{
    self.title = @"选择品牌";
    self.dataArray = [NSMutableArray array];
    self.indexArray = [NSMutableArray array];
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
        [_tableView registerClass:[SelectBrandNameCell class] forCellReuseIdentifier:kSelectBrandNameCell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        //        _tableView.estimatedRowHeight = 150;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark -tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [self.dataArray[section - 1] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.00001 : 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UIView  *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewsection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20)];
    viewsection.backgroundColor = SMViewBGColor;
    UILabel *labelSection = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 20)];
    labelSection.font = SFONT(14);
    labelSection.textColor = SMParatextColor;
    if (section == 0) {
        labelSection.text = @"";
    }else{
        labelSection.text = self.indexArray[section - 1];;
    }
    [viewsection addSubview:labelSection];
    return viewsection;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"不限品牌";
        return cell;
    }else{
        SelectBrandNameCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectBrandNameCell];
        cell.model = self.dataArray[indexPath.section - 1][indexPath.row];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.selectCarBlock) {
            self.selectCarBlock(@"品牌",@"");
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    BrandModel *model = self.dataArray[indexPath.section - 1][indexPath.row];
    if (self.selectCarBlock) {
        self.selectCarBlock(model.title,model.bid);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
