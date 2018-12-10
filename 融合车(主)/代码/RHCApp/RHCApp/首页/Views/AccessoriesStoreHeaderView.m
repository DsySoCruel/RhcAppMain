//
//  AccessoriesStoreHeaderView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/24.
//

#import "AccessoriesStoreHeaderView.h"
#import "SDCycleScrollView.h"

@interface AccessoriesStoreHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UIView  *line;
@end


@implementation AccessoriesStoreHeaderView
- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark- UI
- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    
    //1.添加轮播图
    self.cycleScrollView = [SDCycleScrollView new];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.placeholderImage = IMAGECACHE(@"zhan_big");
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cycleScrollView];
    self.cycleScrollView.currentPageDotColor = SMThemeColor;
    //    self.cycleScrollView.localizationImageNamesGroup = @[@"zwt1",@"zwt2",@"zwt3",@"zwt4"];
    //    WeakObj(self)
    [self.cycleScrollView setClickItemOperationBlock:^(NSInteger index){
        
    }];
    
    self.label1 = [UILabel new];
    self.label1.textColor = SMTextColor;
    self.label1.font = BFONT(16);
    [self addSubview:self.label1];
    
    self.label2 = [UILabel new];
    self.label2.textColor = SMParatextColor;
    self.label2.font = LPFFONT(14);
    [self addSubview:self.label2];
    
    self.label3 = [UILabel new];
    self.label3.textColor = [UIColor redColor];
    self.label3.font = MFFONT(16);
    [self addSubview:self.label3];
    
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self addSubview:self.line];
    
}

- (void)setupLayout{
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset = 0;
        make.bottom.offset = -110;
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset = 10;
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.label1.mas_bottom).offset = 5;
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.label2.mas_bottom).offset = 5;
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.offset = 0;
        make.height.offset = 10;
    }];
    
}

- (void)setAccModel:(AccessoriesStoreDetailModel *)accModel{
    _accModel = accModel;
    self.label1.text = accModel.title;
    self.label2.text = accModel.typeName;
    self.label3.text = [NSString stringWithFormat:@"活动价%@",[accModel.price priceWithWan]];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (ImgListModel *model in accModel.imgList) {
        [tempArray addObject:model.url];
    }
    //待打开
    self.cycleScrollView.imageURLStringsGroup = tempArray;
}


@end
