//
//  FindHeadView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/19.
//

#import "FindHeadView.h"
#import "SDCycleScrollView.h"
#import "HomeHeadViewBannerModel.h"

@interface FindHeadView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation FindHeadView

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        [self setupLayout];
        [self loadData];
    }
    return self;
}
- (void)setupUI{
    self.backgroundColor = RGB(0xE4EDFF);
    //1.添加轮播图
    self.cycleScrollView = [SDCycleScrollView new];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.placeholderImage = IMAGECACHE(@"zhan_big");
    [self addSubview:self.cycleScrollView];
    self.cycleScrollView.currentPageDotColor = SMThemeColor;
//    self.cycleScrollView.localizationImageNamesGroup = @[@"zwt1",@"zwt2",@"zwt3",@"zwt4"];
//    WeakObj(self)
    [self.cycleScrollView setClickItemOperationBlock:^(NSInteger index){
        
    }];
}

- (void)setupLayout{
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset = 0;
        make.bottom.offset = 0;
    }];
}

#pragma mark-获取首页数据
- (void)loadData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @"9";
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_BannerList parameters:dic successed:^(id json) {
        if (json) {
            NSArray *array = [HomeHeadViewBannerModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
//            [Weakself.bannerModelDataArray removeAllObjects];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (HomeHeadViewBannerModel *model in array) {
//                [Weakself.bannerModelDataArray addObject:model];
                [tempArray addObject:model.url];
            }
            //待打开
            Weakself.cycleScrollView.imageURLStringsGroup = tempArray;
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
