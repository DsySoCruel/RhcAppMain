//
//  HomeHeadView.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "HomeHeadView.h"
#import "SDCycleScrollView.h"
#import "HomeCateCollectionViewCell.h"
#import "HomeCollectionCellModel.h"
#import "HomeHeadViewBannerModel.h"
#import "HomeSeckillController.h"
#import "CarSuperStoreController.h"
#import "TruckSuperStoreController.h"
#import "AccessoriesStoreController.h"
#import "CustomMadeViewController.h"
#import "ProductDetailViewController.h"
#import "HomeCateCollectionView2Cell.h"

static NSString *homeCateCollectionViewCell = @"homeCateCollectionViewCell";
static NSString *homeCateCollectionView2Cell = @"homeCateCollectionView2Cell";

@interface HomeHeadView ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource
>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView2;

@property (nonatomic, strong) UIView *adView;//定制分期
@property (nonatomic, strong) UIImageView *adImageView;//定制分期

@property (nonatomic, strong) UIView *adView3;//限时秒杀
@property (nonatomic, strong) UIImageView *image3;
@property (nonatomic, strong) UILabel *bigTitleLabel;
@property (nonatomic, strong) UILabel *smallTitleLabel;
@property (nonatomic, strong) UIImageView *qiang;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *bannerModelDataArray;


@end

@implementation HomeHeadView

- (NSMutableArray *)bannerModelDataArray{
    if (!_bannerModelDataArray) {
        _bannerModelDataArray = [NSMutableArray array];
    }
    return _bannerModelDataArray;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        [self setupLayout];
        [self loadData];
    }
    return self;
}

#pragma mark- UI
- (void)setupUI{
    self.backgroundColor = SMViewBGColor;
    
    //1.添加轮播图
    self.cycleScrollView = [SDCycleScrollView new];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.placeholderImage = IMAGECACHE(@"zhan_big");
    [self addSubview:self.cycleScrollView];
    self.cycleScrollView.localizationImageNamesGroup = @[@"zwt1",@"zwt2",@"zwt3",@"zwt4"];
    self.cycleScrollView.currentPageDotColor = SMThemeColor;
//    WeakObj(self)
    [self.cycleScrollView setClickItemOperationBlock:^(NSInteger index){
        
    }];
    //2.添加功能区
    self.dataArray = [NSMutableArray array];
    
    HomeCollectionCellModel *mode1 = [HomeCollectionCellModel itemWithTitle:@"汽车超市" icon:@"home_05"];
    [self.dataArray addObject:mode1];
    HomeCollectionCellModel *mode2 = [HomeCollectionCellModel itemWithTitle:@"卡车中心" icon:@"home_06"];
    [self.dataArray addObject:mode2];
    HomeCollectionCellModel *mode3 = [HomeCollectionCellModel itemWithTitle:@"汽配商城" icon:@"home_07"];
    [self.dataArray addObject:mode3];
    
    
    UICollectionViewFlowLayout *layout=[UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 17.5, 0, 17.5);
    layout.itemSize = CGSizeMake((YXDScreenW - 35) / 3, 93-13);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[HomeCateCollectionViewCell class] forCellWithReuseIdentifier:homeCateCollectionViewCell];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
    //3.广告条
//    self.announceView = [AnnounceView new];
//    [self addSubview:self.announceView];
    self.adView = [UIView new];
    self.adView.backgroundColor = [UIColor whiteColor];
//    self.adView.image = IMAGECACHE(@"home_08");
    self.adView.userInteractionEnabled = YES;
//    self.adView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.adView];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adViewAction)];
    [self.adView addGestureRecognizer:tap];
    
    self.adImageView = [[UIImageView alloc] initWithImage:IMAGECACHE(@"home_08")];
    self.adImageView.backgroundColor = [UIColor whiteColor];
    self.adImageView.userInteractionEnabled = YES;
    self.adImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.adView addSubview:self.adImageView];
    
    //4.添加秒杀
    self.adView3 = [UIView new];
    self.adView3.backgroundColor = [UIColor whiteColor];
    self.adView3.userInteractionEnabled = YES;
    [self addSubview:self.adView3];
    //添加手势
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adView3Action)];
    [self.adView3 addGestureRecognizer:tap3];
    
    self.image3 = [UIImageView new];
    self.image3.image = IMAGECACHE(@"home_21");
    self.image3.contentMode = UIViewContentModeScaleAspectFit;
    [self.adView3 addSubview:self.image3];
    
    self.bigTitleLabel = [UILabel new];
    self.bigTitleLabel.text = @"限时秒杀";
    self.bigTitleLabel.font = SFONT(19);
    self.bigTitleLabel.textColor = SMTextColor;
    [self.adView3 addSubview:self.bigTitleLabel];
    
    self.smallTitleLabel = [UILabel new];
    self.smallTitleLabel.text = @"超人气车型,超低优惠";
    self.smallTitleLabel.font = LPFFONT(10);
    self.smallTitleLabel.textColor = SMParatextColor;
    [self.adView3 addSubview:self.smallTitleLabel];
    
    self.qiang = [UIImageView new];
    self.qiang.image = IMAGECACHE(@"home_23");
    [self.adView3 addSubview:self.qiang];

    
    //建议使用组信息
    //加载轮播图
    //加载行业分类
    //加载中部广告
    UICollectionViewFlowLayout *layout2=[UICollectionViewFlowLayout new];
    layout2.minimumLineSpacing = 1;
    layout2.minimumInteritemSpacing = 1;
    layout2.itemSize = CGSizeMake((YXDScreenW - 1) / 2, 240);
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout2.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
    self.collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout2];
    [self.collectionView2 registerClass:[HomeCateCollectionView2Cell class] forCellWithReuseIdentifier:homeCateCollectionView2Cell];
    self.collectionView2.backgroundColor = SMViewBGColor;
    self.collectionView2.delegate = self;
    self.collectionView2.dataSource = self;
    self.collectionView2.scrollEnabled = NO;
    [self addSubview:self.collectionView2];

}
- (void)adViewAction{
    CustomMadeViewController *customMadeViewController = [CustomMadeViewController new];
    [self.navigationController pushViewController:customMadeViewController animated:YES];
}

- (void)adView3Action{
    HomeSeckillController *seckillControllerCell = [HomeSeckillController new];
    [self.navigationController pushViewController:seckillControllerCell animated:YES];
}

- (void)setupLayout{
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset = 0;
        make.height.offset = YXDScreenW/1.84;
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom);
        make.left.right.offset = 0;
        make.height.offset = 74;
    }];
    
    [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset = 10;
        make.left.right.offset = 0;
        make.height.offset = 78 + 10;
    }];
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.left.offset =   10;
        make.top.offset =    10;
        make.bottom.offset =  0;

    }];
    
    [self.adView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adView.mas_bottom).offset = 0;
        make.left.right.offset = 0;
        make.height.offset = 70 + 20;
    }];
    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset = 0;
        make.width.mas_equalTo(self.adView3.mas_width).multipliedBy(0.5);
    }];
    
    [self.bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.top.offset = 10;
    }];
    [self.smallTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.top.equalTo(self.bigTitleLabel.mas_bottom).offset = 0;
    }];
    [self.qiang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.bottom.offset = -10;
    }];
    
    [self.collectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adView3.mas_bottom).offset = 0;
        make.left.right.offset = 0;
        make.bottom.offset = 0;
    }];
    
//    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.adView3.mas_bottom).offset = 1;
//        make.left.offset = 0;
//        make.height.offset = 100 + 50 + 50;
//        make.width.mas_equalTo(YXDScreenW*0.5 - 0.5);
//    }];
//
//    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.adView3.mas_bottom).offset = 1;
//        make.right.offset = 0;
//        make.height.offset = 100 + 50 + 50;
//        make.width.mas_equalTo(YXDScreenW*0.5 - 0.5);
//    }];
    
}

#pragma mark- UICollectionViewDatasource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        HomeCateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCateCollectionViewCell forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    HomeCateCollectionView2Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCateCollectionView2Cell forIndexPath:indexPath];
    cell.model = self.miaoshaArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return self.dataArray.count;
    }
    return self.miaoshaArray.count;
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    HomeIndustryModel *model = self.dataArray[indexPath.row];
//    HomeCategoryDetailController *vc = [HomeCategoryDetailController new];
//    vc.catId = model.catId;
//    vc.title = model.catName;
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (collectionView == self.collectionView2) {
        ProductDetailViewController *vc = [ProductDetailViewController new];
        ProductModel *model = self.miaoshaArray[indexPath.item];
        vc.pid = model.pid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (indexPath.item == 0) {//汽车超市
            CarSuperStoreController *vc = [CarSuperStoreController new];
            [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.item == 1) {//卡车超市
            TruckSuperStoreController *vc = [TruckSuperStoreController new];
            [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.item == 2) {//配件超市
            AccessoriesStoreController *vc = [AccessoriesStoreController new];
            [[BaseViewController topViewController].navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark-获取首页数据
- (void)loadData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @"1";
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_BannerList parameters:dic successed:^(id json) {
        if (json) {
            NSArray *array = [HomeHeadViewBannerModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            [Weakself.bannerModelDataArray removeAllObjects];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (HomeHeadViewBannerModel *model in array) {
                [Weakself.bannerModelDataArray addObject:model];
                [tempArray addObject:model.url];
            }
            //待打开
            Weakself.cycleScrollView.imageURLStringsGroup = tempArray;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setMiaoshaArray:(NSMutableArray *)miaoshaArray{
    _miaoshaArray = miaoshaArray;
    [self.collectionView2 reloadData];
}

@end
