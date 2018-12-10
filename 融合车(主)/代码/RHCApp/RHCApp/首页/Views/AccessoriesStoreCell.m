//
//  AccessoriesStoreCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/2.
//

#import "AccessoriesStoreCell.h"

static CGSize const kSize = {30, 12};

@interface AccessoriesStoreCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *type;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation AccessoriesStoreCell

#pragma mark- UI
- (void)setupUI{
    self.imageView = [UIImageView new];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];

    self.titleLabel = [UILabel new];
    self.titleLabel.font = LPFFONT(15);
    [self.contentView addSubview:self.titleLabel];
    
    self.type = [UILabel new];
    self.type.font = LPFFONT(8);
    self.type.textColor = [UIColor redColor];
    self.type.layer.cornerRadius = 6;
    self.type.layer.borderColor = [UIColor redColor].CGColor;
    self.type.layer.borderWidth = 0.5;
    self.type.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.type];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.font = LPFFONT(13);
    self.priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:self.priceLabel];
    
}

- (void)setupLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.equalTo(self.imageView.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.equalTo(self.imageView.mas_bottom).offset = 5;
        make.right.offset= -10;
    }];
    
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.equalTo(self.titleLabel.mas_bottom).offset = 2;
        make.size.mas_equalTo(kSize);

    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.equalTo(self.type.mas_bottom).offset = 3;
        make.right.offset=-10;
        make.bottom.offset = -5;
    }];
}

#pragma mark-

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(AccessoriesListModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:URLWithImageName(model.imgs) placeholderImage:IMAGECACHE(@"zhan_mid")];
    self.titleLabel.text = model.title;
    self.type.text = model.typeName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    [self.type mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.type.intrinsicContentSize.width + 10, 12));
    }];
}

@end
