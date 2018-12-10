//
//  AccessoriesStoreController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/30.
//

#import "AccessoriesStoreController.h"
#import "NavigationSearchBarView.h"
#import "DOPDropDownMenu.h"
#import "ProductDetailViewController.h"
#import "AccessoriesStoreCell.h"
#import "AccessoriesListModel.h"
#import "AccessoriesTypeModel.h"
#import "AccessoriesStoreDetailController.h"
#import "OrganizationTagsView.h"

static NSString *kAccessoriesStoreCell = @"AccessoriesStoreCell";

@interface AccessoriesStoreController ()<UINavigationControllerDelegate,DOPDropDownMenuDelegate, DOPDropDownMenuDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NavigationSearchBarView *naviView;
@property (nonatomic,strong) DOPDropDownMenu *menu;
@property (nonatomic,strong) OrganizationTagsView *tagsView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSArray *array1;//默认排序
@property (nonatomic,strong) NSMutableArray *array2;//
@property (nonatomic,strong) NSMutableArray *array2Real;//
@property (nonatomic,strong) NSMutableArray *array3;//
@property (nonatomic,strong) NSMutableArray *array3Real;//
@property (nonatomic,strong) NSMutableArray *array4;//
@property (nonatomic,strong) NSMutableArray *array4Real;//

@property (nonatomic,strong) NSString *parames1;
@property (nonatomic,strong) NSString *parames2;
@property (nonatomic,strong) NSString *parames3;
@property (nonatomic,strong) NSString *parames4;

//记录参数  为了展示
@property (nonatomic,strong) NSString *select1;
@property (nonatomic,strong) NSString *select2;
@property (nonatomic,strong) NSString *select3;
@property (nonatomic,strong) NSString *select4;

@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）

@end

@implementation AccessoriesStoreController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    //1.设置导航条
    self.naviView = [[NavigationSearchBarView alloc] initWithType:NavigationSearchBarTypeAccessoriesStore];
    self.naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.naviView];
    self.view.backgroundColor = SMViewBGColor;

    //    NSMutableArray *tempArray = [NSMutableArray array];
    //    [tempArray addObject:@"全部"];
    //    for (CategoryModel *model in self.itemTypeArray) {
    //        [tempArray addObject:model.title];
    //    }
    //     [tempArray addObject:@"1234"];
    
//    self.array1 = [NSMutableArray array];
    self.array2Real = [NSMutableArray array];
    self.array3Real = [NSMutableArray array];
    self.array4Real = [NSMutableArray array];

    self.array2 = [NSMutableArray array];
    self.array3 = [NSMutableArray array];
    self.array4 = [NSMutableArray array];

    self.array1 = @[@"默认排序",@"价格最高",@"价格最低",@"销量最高",@"销量最低"];
    
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:30];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    self.menu.textSelectedColor = SMThemeColor;
    [self.view addSubview:self.menu];
    
    self.tagsView = [[OrganizationTagsView alloc] init];
    WeakObj(self);
    //删除部分选中的
    self.tagsView.deleteTagsBlock = ^(NSString *tagsName) {
        if ([tagsName isEqualToString:Weakself.select1]) {
            Weakself.parames1 = @"";
            Weakself.select1 = @"";
        }
        if ([tagsName isEqualToString:Weakself.select2]) {
            Weakself.parames2 = @"";
            Weakself.select2 = @"";
        }
        if ([tagsName isEqualToString:Weakself.select3]) {
            Weakself.parames3 = @"";
            Weakself.select3 = @"";
        }
        if ([tagsName isEqualToString:Weakself.select4]) {
            Weakself.parames4 = @"";
            Weakself.select4 = @"";
        }
        [Weakself.menu reloadData];
        [Weakself loadNewsData];
    };
    //删除全部
    self.tagsView.deleteAllBlock = ^{
        Weakself.parames1 = @"";
        Weakself.select1 = @"";
        //        [Weakself.array2 removeAllObjects];
        //        [Weakself.array2 addObject:@"品牌"];
        Weakself.parames2 = @"";
        Weakself.select2 = @"";
        Weakself.parames3 = @"";
        Weakself.select3 = @"";
        Weakself.parames4 = @"";
        Weakself.select4 = @"";
        [Weakself.menu reloadData];
        [Weakself loadNewsData];
    };
    [self.view addSubview:self.tagsView];
    
    self.dataArray = [NSMutableArray array];
    [self configCollectionViewHere];
    [self loadNewsData];
    [self loadTypeList];

}
- (void)loadTypeList{//获取配件类型
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_AccessoriesTypelist parameters:parames successed:^(id json) {
            NSArray *array = [AccessoriesTypeModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        AccessoriesTypeModel *model2 = array[0];
        AccessoriesTypeModel *model3 = array[1];
        AccessoriesTypeModel *model4 = array[2];
        [Weakself.array2 addObject:model2.name];
        [Weakself.array3 addObject:model3.name];
        [Weakself.array4 addObject:model4.name];
        //请求对应的数据
        dispatch_group_t requestGroup = dispatch_group_create();

        NSMutableDictionary *parames2 = [NSMutableDictionary dictionary];
        parames2[@"type"] = model2.pid;
        dispatch_group_enter(requestGroup);
        [[NetWorkManager shareManager] POST:USER_AccessoriesTypelist parameters:parames2 successed:^(id json) {
            NSArray *array = [AccessoriesTypeModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [self.array2Real addObjectsFromArray:array];
            for (AccessoriesTypeModel *model in array) {
                [Weakself.array2 addObject:model.name];
            }
            dispatch_group_leave(requestGroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(requestGroup);
        }];
        
        NSMutableDictionary *parames3 = [NSMutableDictionary dictionary];
        parames3[@"type"] = model3.pid;
        dispatch_group_enter(requestGroup);
        [[NetWorkManager shareManager] POST:USER_AccessoriesTypelist parameters:parames3 successed:^(id json) {
            NSArray *array = [AccessoriesTypeModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [self.array3Real addObjectsFromArray:array];
            for (AccessoriesTypeModel *model in array) {
                [Weakself.array3 addObject:model.name];
            }
            dispatch_group_leave(requestGroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(requestGroup);
        }];
        
        NSMutableDictionary *parames4 = [NSMutableDictionary dictionary];
        parames4[@"type"] = model4.pid;
        dispatch_group_enter(requestGroup);
        [[NetWorkManager shareManager] POST:USER_AccessoriesTypelist parameters:parames4 successed:^(id json) {
            NSArray *array = [AccessoriesTypeModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [self.array4Real addObjectsFromArray:array];
            for (AccessoriesTypeModel *model in array) {
                [Weakself.array4 addObject:model.name];
            }
            dispatch_group_leave(requestGroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(requestGroup);
        }];
        dispatch_group_notify(requestGroup, dispatch_get_main_queue(), ^{
            [Weakself.menu reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)configCollectionViewHere{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 5;
    CGFloat itemWH = 0;

    itemWH = (self.view.mj_w - 3 * margin) / 2;
    layout.itemSize = CGSizeMake(itemWH, itemWH + 70);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    //    layout.footerReferenceSize = CGSizeMake(0, _itemWH + _margin*2);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = SMViewBGColor;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[AccessoriesStoreCell class] forCellWithReuseIdentifier:kAccessoriesStoreCell];
    //        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //        header.lastUpdatedTimeLabel.hidden = YES;
    //        header.stateLabel.font = LPFFONT(13);
    //        header.ignoredScrollViewContentInsetTop = NAVI_H;
    //        _tableView.mj_header = header;
    _collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self.collectionView.mj_footer resetNoMoreData];
        [self loadNewsData];
    }];
    //
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    _collectionView.mj_footer = footer;

}


- (void)setupLayout{
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset = 0;
        make.height.offset = 64 + SafeTopSpace;
    }];
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(self.naviView.mas_bottom);
        make.height.offset = 30;
    }];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.offset = 0;
        make.top.equalTo(self.menu.mas_bottom);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.offset = 0;
        make.top.equalTo(self.menu.mas_bottom);
    }];
}

#pragma mark -- DOPDropDownMenu 代理方法
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.array1.count;
    }else if (column == 1){
        return self.array2.count;
    }else if (column == 2){
        return self.array3.count;
    }else{
        return self.array4.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.array1[indexPath.row];
    }else if (indexPath.column == 1){
        if (self.array2.count) {
            return self.array2[indexPath.row];
        }else{
            return @"";
        }
    }else if (indexPath.column == 2){
        if (self.array3.count) {
            return self.array3[indexPath.row];
        }else{
            return @"";
        }
        
    }else{
        if (self.array4.count) {
            return self.array4[indexPath.row];
        }else{
            return @"";
        }
    }
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 4;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"%ld, %ld, %ld", indexPath.column, indexPath.row, indexPath.item);
    
    if (indexPath.column == 0) {//第一列
        //筛选出项目ID
        if (indexPath.row == 0) {
            self.parames1 = @"";
            self.select1 = @"";
        }else{
            self.parames1 = [NSString stringWithFormat:@"%tu",indexPath.row];
            self.select1 = self.array1[indexPath.row];
        }
        [self loadNewsData];
    }else if (indexPath.column == 1){//第二列
        if (indexPath.row == 0) {
            self.parames2 = @"";
            self.select2 = @"";
        }else{
            NSString *str = self.array2[indexPath.row];
            self.select2 = self.array2[indexPath.row];
            for (AccessoriesTypeModel *model in self.array2Real) {
                if ([str isEqualToString:model.name]) {
                    self.parames2 = model.pid;
                    break;
                }
            }
        }
        [self loadNewsData];
        
    }else if (indexPath.column == 2){//第二列
        if (indexPath.row == 0) {
            self.parames3 = @"";
            self.select3 = @"";
        }else{
            NSString *str = self.array3[indexPath.row];
            self.select3 = self.array3[indexPath.row];
            for (AccessoriesTypeModel *model in self.array3Real) {
                if ([str isEqualToString:model.name]) {
                    self.parames3 = model.pid;
                    break;
                }
            }
        }
        [self loadNewsData];
        
    }else if (indexPath.column == 3){//第二列
        if (indexPath.row == 0) {
            self.parames4 = @"";
            self.select4 = @"";
        }else{
            NSString *str = self.array4[indexPath.row];
            self.select4 = self.array4[indexPath.row];
            for (AccessoriesTypeModel *model in self.array4Real) {
                if ([str isEqualToString:model.name]) {
                    self.parames4 = model.pid;
                    break;
                }
            }
        }
        [self loadNewsData];
    }
    
}
#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AccessoriesStoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAccessoriesStoreCell forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AccessoriesListModel *model = self.dataArray[indexPath.item];
    AccessoriesStoreDetailController *vc = [AccessoriesStoreDetailController new];
    vc.pid = model.hid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadNewsData{
    //判断是否有参数并组成数组
    NSMutableArray *tempArray = [NSMutableArray array];
    if (self.select1.length) {
        [tempArray addObject:self.select1];
    }
    if (self.select2.length) {
        [tempArray addObject:self.select2];
    }
    if (self.select3.length) {
        [tempArray addObject:self.select3];
    }
    if (self.select4.length) {
        [tempArray addObject:self.select4];
    }
    
    [self.tagsView config:tempArray];
    CGFloat tagsViewH = [OrganizationTagsView cellHeightWithArray:tempArray];
    [self.tagsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.menu.mas_bottom);
        make.height.mas_equalTo(tempArray.count ? tagsViewH: 0);
    }];
    if (self.parames1.length || self.parames2.length || self.parames3.length || self.parames4.length ) {//说明是刷选 不应有秒杀的数据
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset = 0;
            make.top.equalTo(self.menu.mas_bottom).offset = tempArray.count ? tagsViewH : 0;
        }];
    }else{
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset = 0;
            make.top.equalTo(self.menu.mas_bottom);
        }];
    }
    WeakObj(self);
    self.cape = 1;
    //2.设置发现与车圈
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    ;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    if (self.parames2.length) {
        parames[@"type"] = self.parames2;
    }
    if (self.parames1.length) {
        if ([self.parames1 integerValue] == 1) {
            parames[@"sortType"] = @"0";
        }
        if ([self.parames1 integerValue] == 2) {
            parames[@"sortType"] = @"1";
        }
        if ([self.parames1 integerValue] == 3) {
            parames[@"sort"] = @"0";
        }
        if ([self.parames1 integerValue] == 4) {
            parames[@"sort"] = @"1";
        }
    }
 
    [[NetWorkManager shareManager] POST:USER_AccessoriesList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [AccessoriesListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:array];
            if (!array.count) {
                [self showEmptyMessage:@"暂无数据"];
            }else{
                [self hideEmptyView];
            }
            [Weakself.collectionView reloadData];
        }
        [Weakself.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [Weakself.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    self.cape++;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    if (self.parames2.length) {
        parames[@"type"] = self.parames2;
    }
    if (self.parames1.length) {
        if ([self.parames1 integerValue] == 1) {
            parames[@"sortType"] = @"0";
        }
        if ([self.parames1 integerValue] == 2) {
            parames[@"sortType"] = @"1";
        }
        if ([self.parames1 integerValue] == 3) {
            parames[@"sort"] = @"0";
        }
        if ([self.parames1 integerValue] == 4) {
            parames[@"sort"] = @"1";
        }
    }
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_AccessoriesList parameters:parames successed:^(id json) {
        [Weakself.collectionView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [AccessoriesListModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            if (array.count == 0) {//没有数据、
                [Weakself.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [Weakself.dataArray addObjectsFromArray:array];
                [Weakself.collectionView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [Weakself.collectionView.mj_footer endRefreshing];
    }];
}




@end
