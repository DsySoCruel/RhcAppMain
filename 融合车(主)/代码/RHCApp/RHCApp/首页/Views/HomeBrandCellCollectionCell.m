//
//  HomeBrandCellCollectionCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/14.
//

#import "HomeBrandCellCollectionCell.h"

@interface HomeBrandCellCollectionCell()
@property (nonatomic,strong) UIImageView *imageView;//图片
@property (nonatomic,strong) UILabel *label2;//型号
@property (nonatomic,strong) UILabel *label3;//首付
@property (nonatomic,strong) UILabel *label4;//现价
@end


@implementation HomeBrandCellCollectionCell

#pragma mark-
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}


- (void)setupUI{
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
    
    self.label2 = [UILabel new];
    self.label2.font = SFONT(13);
    self.label2.numberOfLines = 2;
    self.label2.textColor = SMTextColor;
    self.label2.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label2];
    
    self.label3 = [UILabel new];
    self.label3.font = BFONT(16);
    self.label3.textColor = [UIColor redColor];
    self.label3.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label3];
    
    self.label4 = [UILabel new];
    self.label4.font = LPFFONT(11);
    self.label4.textAlignment = NSTextAlignmentCenter;
    self.label4.textColor = SMTextColor;
    [self.contentView addSubview:self.label4];
}

- (void)setupLayout{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.top.offset = 10;
        make.height.offset = 90;
    }];

    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset = 5;
        make.right.offset = - 5;
        make.left.offset = 5;
    }];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.right.offset = -5;
        make.top.equalTo(self.label2.mas_bottom).offset = 5;
    }];
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.right.offset = -5;
        make.top.equalTo(self.label3.mas_bottom).offset = 2;
    }];
}
- (void)setModel:(HomeViewListSmall *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:URLWithImageName(model.img) placeholderImage:IMAGECACHE(@"zhan_mid")];
    self.label2.text = [NSString stringWithFormat:@"%@%@",model.brandName,model.typeName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"首付 %@",[model.min_down_payment priceWithWan]]];
    UIFont *font = BPFFONT(12);
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,2)];
    [self.label3 setAttributedText:attrString];
    self.label4.text = [NSString stringWithFormat:@"现价 %@",[model.price priceWithWan]];
}
@end
