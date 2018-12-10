//
//  HomeBrandCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/14.
//

#import "HomeBrandCell.h"
#import "HomeBrandCellCollectionCell.h"
#import "ProductDetailViewController.h"

static NSString *kHomeBrandCellCollectionCell = @"HomeBrandCellCollectionCell";

@interface HomeBrandCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIView               *brandImageView;
@property (nonatomic,strong) UILabel              *brandTitle;
@property (nonatomic,strong) UILabel              *brandsubTitle;
@property (nonatomic,strong) UICollectionView     *collectionView;
@property (nonatomic,strong) UIView               *line;
@property (nonatomic,strong) NSMutableArray       *datasourceArray;
@end

@implementation HomeBrandCell

- (NSMutableArray *)datasourceArray{
    if (!_datasourceArray) {
        _datasourceArray = [NSMutableArray array];
    }
    return _datasourceArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    //1.
    self.brandImageView = [UIView new];
    self.brandImageView.backgroundColor = RGB(0xDAA520);
    [self.contentView addSubview:self.brandImageView];
    self.brandTitle = [UILabel new];
    self.brandTitle.font = BFONT(24);
    self.brandTitle.textColor = SMTextColor;
    self.brandTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.brandTitle];
    self.brandsubTitle = [UILabel new];
    self.brandsubTitle.font = BFONT(15);
    self.brandsubTitle.text = @"高端舒适佳选";
    self.brandsubTitle.textColor = [UIColor redColor];
    self.brandsubTitle.layer.cornerRadius = 10;
    self.brandsubTitle.layer.masksToBounds = YES;
    self.brandsubTitle.backgroundColor = [UIColor blackColor];
    self.brandsubTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.brandsubTitle];
    //2.
    UICollectionViewFlowLayout *layout=[UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.sectionInset = UIEdgeInsetsMake(0, 17.5, 0, 17.5);
    layout.itemSize = CGSizeMake((YXDScreenW) / 3, 170);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[HomeBrandCellCollectionCell class] forCellWithReuseIdentifier:kHomeBrandCellCollectionCell];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    //3.
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.line];
}

- (void)setupLayout{
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset = 0;
        make.height.offset = 100;
    }];
    
    [self.brandTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.offset = 20;
    }];
    [self.brandsubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.top.equalTo(self.brandTitle.mas_bottom).offset = 15;
        make.width.offset = 150;
        make.height.offset = 20;
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.top.equalTo(self.brandImageView.mas_bottom).offset = 0;
        make.height.offset = 170;
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 10;
        make.top.equalTo(self.collectionView.mas_bottom).offset = 0;
    }];
}


#pragma mark- UICollectionViewDatasource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeBrandCellCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeBrandCellCollectionCell forIndexPath:indexPath];
    cell.model = self.datasourceArray[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datasourceArray.count;
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        ProductDetailViewController *vc = [ProductDetailViewController new];
        HomeViewListSmall *model = self.datasourceArray[indexPath.item];
        vc.pid = model.hid;
        [self.navigationController pushViewController:vc animated:YES];
}

- (void)setModel:(HomeViewListModel *)model{
    _model = model;
    [self.datasourceArray removeAllObjects];
    [self.datasourceArray addObjectsFromArray:model.list];
    self.brandTitle.text = [NSString stringWithFormat:@"%@专区",model.brand];
}
@end
