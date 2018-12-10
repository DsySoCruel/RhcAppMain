//
//  CircleDetailViewTopCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "CircleDetailViewTopCell.h"
#import "CircleVCListCellTopView.h"
#import "SDPhotoBrowser.h"

@interface CircleDetailViewTopCell()<SDPhotoBrowserDelegate>
@property (nonatomic,strong) UIView  *toplineView;
@property (nonatomic,strong) CircleVCListCellTopView *topView;
@property (nonatomic,strong) UIImageView *bigImageView;
@property (nonatomic,strong) UILabel *numForImage;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIView  *lineView;
@property (nonatomic,strong) NSMutableArray *imageArray;
@end

@implementation CircleDetailViewTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    self.imageArray = [NSMutableArray array];
    
    self.toplineView = [UIView new];
    self.toplineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.toplineView];
    
    self.topView = [CircleVCListCellTopView new];
    [self.contentView addSubview:self.topView];
    
    self.bigImageView = [UIImageView new];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bigImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bigImageView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageViewAction)];
    self.bigImageView.userInteractionEnabled = YES;
    [self.bigImageView addGestureRecognizer:tap1];
    
    self.numForImage = [UILabel new];
    self.numForImage.backgroundColor = YXDBlockColor(1, 1, 1, 0.8);
    self.numForImage.layer.cornerRadius = 12.5;
    self.numForImage.layer.masksToBounds = YES;
    self.numForImage.font = LPFFONT(12);
    self.numForImage.textAlignment = NSTextAlignmentCenter;
    self.numForImage.textColor = [UIColor whiteColor];
    [self.bigImageView addSubview:self.numForImage];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = MFFONT(14);
    self.contentLabel.textColor = SMTextColor;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.numLabel = [UILabel new];
    self.numLabel.font = LPFFONT(12);
    self.numLabel.textColor = SMParatextColor;
    self.numLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.numLabel];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.lineView];
}

- (void)setupLayout{
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 10;
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.offset = 25;
        make.height.offset = 50;
    }];
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(self.topView.mas_bottom);
        make.height.offset = (Screen_W * 280) / 750;
    }];
    [self.numForImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 25;
        make.bottom.right.offset = -7;
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.bigImageView.mas_bottom).offset = 5;
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.height.offset = 40;
        make.width.offset = Screen_W * 0.5;
        make.bottom.offset = -10;
        make.top.equalTo(self.contentLabel.mas_bottom).offset = 5;
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 10;
    }];
}

- (void)setModel:(CircleViewControllerListModel *)model{
    _model = model;
    self.topView.model = model;
    self.contentLabel.text = model.content;
    self.numLabel.text = [NSString stringWithFormat:@"%@人看过",model.looks];
    if (!model.imgs.length) {//没有照片
        [self.bigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset = 10;
        }];
        self.numForImage.hidden = YES;
        [self.imageArray removeAllObjects];
    }else{
        [self.bigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = (Screen_W * 280) / 750;
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bigImageView.mas_bottom).offset = 10;
        }];
        //把照片以,为分隔为数组
        NSArray *tempArray = [model.imgs componentsSeparatedByString:@","];
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:tempArray];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:tempArray.firstObject] placeholderImage:IMAGECACHE(@"zhan_big")];
        if (tempArray.count > 1) {
            self.numForImage.hidden = NO;
            self. numForImage.text = [NSString stringWithFormat:@"%tu",tempArray.count];
        }else{
            self.numForImage.hidden = YES;
        }
    }
}

- (void)bigImageViewAction{
    if (!self.numForImage.hidden) {
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = 0;
        photoBrowser.imageCount = self.imageArray.count;
        photoBrowser.sourceImagesContainerView = self;
        [photoBrowser show];
    }
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
//
//    DSYPhotoModel *photoModel = _selectedPhotos[index];
//
//    if (photoModel.url.length) {
//
//        TZTestCell *cell = (TZTestCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//
//        return cell.imageView.image;
//    }else{
//        return photoModel.photo;
//    }
//
//    return self.imageArray[index];
//
//}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
//    DSYPhotoModel *photoModel = _selectedPhotos[index];
//
//    if (photoModel.url.length) {
//        return [NSURL URLWithString:photoModel.url];
//    }else{
//        return nil;
//    }
    return URLWithImageName(self.imageArray[index]);
}

@end
