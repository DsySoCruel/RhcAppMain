//
//  ServiceStationSelectViewController.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/8.
//

#import "ServiceStationSelectViewController.h"
#import "ServiceStationSelectViewCell.h"
#import "ServiceStationViewCellModel.h"
#import "SectionFooterView1.h"
#import <CoreLocation/CoreLocation.h>


static NSString *kServiceStationSelectViewCell = @"ServiceStationSelectViewCell";

@interface ServiceStationSelectViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger cape;//分页筛选（上提加载）
@property (nonatomic,strong) NSString *modelName;
@property (nonatomic,strong) NSString *modelId;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLGeocoder *geoC;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lon;

//h设置地址选择
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *aaa;
@property (nonatomic,strong) UILabel *bbb;
@end

@implementation ServiceStationSelectViewController

/** 地理编码管理器 */
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地址";
    self.view.backgroundColor = SMViewBGColor;
    
    self.topView = [UIView new];
    self.topView.backgroundColor = SMViewBGColor;
    [self.view addSubview:self.topView];
    
    self.aaa = [UILabel new];
    self.aaa.textColor = SMTextColor;
    self.aaa.text = @"当前定位";
    self.aaa.font = LPFFONT(14);
    [self.topView addSubview:self.aaa];
    
    self.bbb = [UILabel new];
    self.bbb.textColor = [UIColor greenColor];
    self.bbb.font = PFFONT(14);
    [self.topView addSubview:self.bbb];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 40;
        make.top.offset = 64;
    }];
    [self.aaa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 15;
    }];
    [self.bbb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.equalTo(self.aaa.mas_right).offset = 10;
    }];

    //获取坐标
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self startLocating];
}


-(void)startLocating{
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];   //开始定位
}

/* 定位完成后 回调 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    //  经纬度
    NSLog(@"---x:%f---y:%f",coordinate.latitude,coordinate.longitude);
    self.lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    self.lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [self setupUI];
    [self setupLayout];
    [self reverseGeoCodewith:coordinate.latitude and:coordinate.longitude];
    [manager stopUpdatingLocation];   //停止定位
}

/* 定位失败后 回调 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错
    }
    [self setupUI];
    [self setupLayout];
    [manager stopUpdatingLocation];   //停止定位
}

- (void)reverseGeoCodewith:(CGFloat)latitude and:(CGFloat)longitude;
{
//    double latitude = [latitude doubleValue];
//    double longitude = [longitude doubleValue];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *pl = [placemarks firstObject];
        
        if(error == nil)
        {
            NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
            NSLog(@"%@", pl.locality);
            self.bbb.text = pl.locality;
        }
    }];
}

#pragma mark UI
-(void)setupUI{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemtitle:@"确认" target:self action:@selector(rightBarButtonItemAction)];

    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SMViewBGColor;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerClass:[ServiceStationSelectViewCell class] forCellReuseIdentifier:kServiceStationSelectViewCell];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self loadNewsData];
    }];
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer = footer;
    [self.view addSubview:self.tableView];
    [self loadNewsData];
    [self adjustInsetWithScrollView:self.tableView];
    
}

-(void)setupLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.top.offset = 64 + 40;
    }];
}
#pragma mark UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionFooterView1 *view = [[SectionFooterView1 alloc] initWithTitle:@""];
    view.frame = CGRectMake(0, 0, Screen_W, 35);
    if (self.dataArray.count > 1) {
        if (section == 0) {
            view.label.text = @"离我最近";
        }else{
            view.label.text = @"其他店面";
        }
    }else{
        view.label.text = @"离我最近";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceStationSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceStationSelectViewCell forIndexPath:indexPath];
    if (self.dataArray.count > 1) {
        if (indexPath.section == 0) {
            [cell configModel:self.dataArray[0] with:indexPath];
        }else{
            [cell configModel:self.dataArray[indexPath.row + 1] with:indexPath];
        }
    }else{
        [cell configModel:self.dataArray[indexPath.row] with:indexPath];
    }
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count > 1) {
        return 2;
    }
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count > 1) {
        if (section == 0) {
            return 1;
        }else{
            return self.dataArray.count - 1;
        }
    }
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (ServiceStationViewCellModel *model in self.dataArray) {
        model.isSelect = @"0";
    }
    if (self.dataArray.count > 1) {
        if (indexPath.section == 0) {
            ServiceStationViewCellModel *model = self.dataArray[indexPath.section];
            self.modelName = model.name;
            self.modelId = model.sid;
            model.isSelect = @"1";
        }else{
            ServiceStationViewCellModel *model = self.dataArray[indexPath.row + 1];
            self.modelName = model.name;
            self.modelId = model.sid;
            model.isSelect = @"1";
        }
    }else{
        ServiceStationViewCellModel *model = self.dataArray[indexPath.section];
        self.modelName = model.name;
        self.modelId = model.sid;
        model.isSelect = @"1";
    }
    [self.tableView reloadData];
}


- (void)loadNewsData{
    self.cape = 1;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    //    parames[@"areaId2"] = model.areaId2;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    if (self.lat.length) {
        parames[@"lon"] = self.lon;
        parames[@"lat"] = self.lat;
    }
    //    parames[@"addressId"] = @"1";
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ScreentoneList parameters:parames successed:^(id json) {
        if (json) {
            [Weakself.dataArray removeAllObjects];
            NSArray *array = [ServiceStationViewCellModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.dataArray addObjectsFromArray:array];
            
            [Weakself.tableView reloadData];
            if (Weakself.dataArray.count == 0) {
                [Weakself showEmptyMessage:@"暂无服务网点"];
            }else{
                [Weakself hideEmptyView];
            }
        }
        [Weakself.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [Weakself.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    self.cape++;
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    //    parames[@"areaId2"] = model.areaId2;
    parames[@"pageSize"] = @"10";
    parames[@"pageNo"] = [NSString stringWithFormat:@"%tu",self.cape];
    if (self.lat.length) {
        parames[@"lon"] = self.lon;
        parames[@"lat"] = self.lat;
    }
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ScreentoneList parameters:parames successed:^(id json) {
        [Weakself.tableView.mj_footer endRefreshing];
        if (json) {
            NSArray *array = [ServiceStationViewCellModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            if (array.count == 0) {//没有数据、
                [Weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [Weakself.dataArray addObjectsFromArray:array];
                [Weakself.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [Weakself.tableView.mj_footer endRefreshing];
    }];
}

- (void)rightBarButtonItemAction{
    if (self.modelName.length) {
        if (self.selectCarShopBlock) {
            self.selectCarShopBlock(self.modelName, self.modelId);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [MBHUDHelper showError:@"请选择取车点"];
    }
}


@end
