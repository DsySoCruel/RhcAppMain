//
//  SearchHistoryView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/6.
//

#import "SearchHistoryView.h"
#import "SelfSizingCollectCell.h"
#import "SearchInfoHeaderView.h"
#import "HotSearchListModel.h"
#import "NSString+Extension.h"
#import "SearchEngine.h"


static NSString *kTagCollectionViewCell = @"SelfSizingCollectCell";
static NSString *kSearchInfoHeaderView = @"SearchInfoHeaderView";
static NSString *kSearchInfofootView = @"SearchInfofootView";

NSString *const SearchHistoryText = @"搜索记录";          // 搜索历史文本 默认为 @"搜索记录"
NSString *const HotSearchText = @"热门搜索";              // 热门搜索文本 默认为 @"热门搜索"

@interface SearchHistoryView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *tagCollectionView;
@property (nonatomic, copy) void(^tapAction)(id,NSInteger);
@end

@implementation SearchHistoryView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupLayout];
        //NSLog(@"%@",[[SearchEngine shareInstance] getSearchEngineData]);
        self.dataSource = [[SearchEngine shareInstance] getSearchEngineData];
        [self loadDataView];
    }
    return self;
}

-(void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = layout = [[UICollectionViewFlowLayout alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 10) {
//        layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    }
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    layout.headerReferenceSize = CGSizeMake(Screen_W, 40);
    layout.footerReferenceSize = CGSizeMake(Screen_W, 15);
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        // 当前组如果还在可视范围时让头部视图停留
        layout.sectionHeadersPinToVisibleBounds = YES;
    }
    
    self.tagCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.tagCollectionView.showsHorizontalScrollIndicator = NO;
    self.tagCollectionView.showsVerticalScrollIndicator = NO;
    self.tagCollectionView.scrollEnabled = NO;
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    self.tagCollectionView.backgroundColor = [UIColor whiteColor];
    self.tagCollectionView.clipsToBounds = YES;
    self.tagCollectionView.scrollsToTop = NO;
    self.tagCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tagCollectionView registerClass:[SelfSizingCollectCell class] forCellWithReuseIdentifier:kTagCollectionViewCell];
    [self.tagCollectionView registerClass:[SearchInfoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSearchInfoHeaderView];
    [self.tagCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSearchInfofootView];
    
    [self addSubview:self.tagCollectionView];
}

- (void)setupLayout {
    [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count > 0 ? 2 : 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource.count == 0) {
        //[collectionView.collectionViewLayout invalidateLayout];
        return self.item.count;
    } else {
        return section == 0 ? self.dataSource.count : self.item.count;
    }
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelfSizingCollectCell *cell = (SelfSizingCollectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kTagCollectionViewCell forIndexPath:indexPath];
    if (self.dataSource.count == 0) {
        HotSearchListModel *model = self.item[indexPath.item];
        cell.textLabel.text = model.content;
    } else {
        if (indexPath.section == 0) {
            cell.textLabel.text = self.dataSource[indexPath.item];
        } else {
            HotSearchListModel *model = self.item[indexPath.item];
            cell.textLabel.text = model.content;
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        
        SearchInfoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSearchInfoHeaderView forIndexPath:indexPath];
        /**
         *
         * 注意:虽然这里没有看到明显的initWithFrame方法,但是在获取重用视图的时候,系统会自动调用initWithFrame方法的.所以在initWithFrame里面进行初始化操作,是没有问题的!
         */
        if (self.dataSource.count > 0) {
            NSArray *sections = @[SearchHistoryText,HotSearchText];
            headerView.section = indexPath.section;
            [headerView loadHeadDataSource:sections[indexPath.section]];
            WeakObj(self);
            [headerView didSelectedTapBlock:^(id obj, NSInteger section) {
                [[SearchEngine shareInstance] cleanAllSearchHistory];//要的
                [Weakself loadDataView];
            }];
        } else {
            headerView.section = indexPath.section;
            [headerView loadHeadDataSource:HotSearchText];
        }
        return headerView;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSearchInfofootView forIndexPath:indexPath];
        return footerView;
    }
    
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tapAction) {
        if (self.dataSource.count == 0) {//点击热门搜索
            HotSearchListModel *model = self.item[indexPath.item];
            self.tapAction(model.content, indexPath.item);
            [[SearchEngine shareInstance] addSearchHistory:model.content];
        } else {
            if (indexPath.section == 0) {
                self.tapAction(self.dataSource[indexPath.item], indexPath.item);
            } else {
                HotSearchListModel *model = self.item[indexPath.item];
                self.tapAction(model.content, indexPath.item);
                [[SearchEngine shareInstance] addSearchHistory:model.content];
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = @"";
    CGSize cellSize;
    if (self.dataSource.count == 0) {
        HotSearchListModel *model = self.item[indexPath.item];
        text = model.content;
        cellSize = [NSString boundingRectWithSize:CGSizeMake(Screen_W - 30, 30) font:LPFFONT(15) text:text];
    } else {
        if (indexPath.section == 0) {
            text = self.dataSource[indexPath.item];
            cellSize = [NSString boundingRectWithSize:CGSizeMake(Screen_W - 30, 30) font:LPFFONT(15) text:text];
        } else {
            HotSearchListModel *model = self.item[indexPath.item];
            text = model.content;
            cellSize = [NSString boundingRectWithSize:CGSizeMake(Screen_W - 30, 30) font:LPFFONT(15) text:text];
        }
    }
    //167:最多不超过9个字
    return CGSizeMake(MAX(60, MIN(cellSize.width + 20, 167)), 30);
}

- (void)didSelectedTapBlock:(void (^)(id, NSInteger))tapAction{
    self.tapAction = tapAction;
}

- (void)loadDataView {
    //NSLog(@"当前系统版本%@", [[UIDevice currentDevice] systemVersion]);
    self.dataSource = [[SearchEngine shareInstance] getSearchEngineData];
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tagCollectionView reloadData];
        [weakSelf.tagCollectionView.collectionViewLayout invalidateLayout];
        [weakSelf.tagCollectionView.collectionViewLayout prepareLayout];
        
    });
    
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [super hitTest:point withEvent:event];
    if (__tmpView == self) {
        return nil;
    }
    if (self.keyboardBlock) {
        self.keyboardBlock();
    }
    return __tmpView;
}

- (void)didTapCollectionViewBlock:(ReturnKeyboardBlock)tapAction{
    self.keyboardBlock = tapAction;
}

@end
