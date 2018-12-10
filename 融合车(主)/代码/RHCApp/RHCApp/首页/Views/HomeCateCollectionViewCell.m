//
//  HomeCateCollectionViewCell.m
//  YXDApp
//
//  Created by daishaoyang on 2017/11/15.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "HomeCateCollectionViewCell.h"
#import "HomeCollectionCellModel.h"

@interface HomeCateCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HomeCateCollectionViewCell

#pragma mark- UI
- (void)setupUI{
    self.titleLabel = [UILabel new];
    self.titleLabel.font = LPFFONT(13);
    [self.contentView addSubview:self.titleLabel];
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
}

- (void)setupLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 10;
        make.width.offset = 40;
        make.height.offset = 38;
        make.centerX.offset = 0;
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset = 0;
        make.bottom.offset = -8;
        make.height.offset = 20;
    }];
    
}

#pragma mark-
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setModel:(HomeCollectionCellModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.imageView.image = IMAGECACHE(model.imageName);
}


@end
