//
//  HomeCateCollectionView2Cell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/14.
//

#import "HomeCateCollectionView2Cell.h"

@interface HomeCateCollectionView2Cell()
@property (nonatomic,strong) UILabel *label1;//爆款推荐
@property (nonatomic,strong) UILabel *label2;//型号
@property (nonatomic,strong) UILabel *label3;//首付
@property (nonatomic,strong) UILabel *label4;//现价
@property (nonatomic,strong) UIImageView *imageView;//图片
@end

@implementation HomeCateCollectionView2Cell

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
    self.label1 = [UILabel new];
    self.label1.font = BFONT(12);
    self.label1.backgroundColor = RGB(0xFFDC00);
    self.label1.textColor = SMTextColor;
    self.label1.layer.cornerRadius = 9;
    self.label1.layer.masksToBounds = YES;
    self.label1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label1];
    
    self.label2 = [UILabel new];
    self.label2.font = SFONT(15);
    self.label2.numberOfLines = 3;
    self.label2.textColor = SMTextColor;
    [self.contentView addSubview:self.label2];
    
    self.label3 = [UILabel new];
    self.label3.font = BFONT(16);
    self.label3.textColor = [UIColor redColor];
    [self.contentView addSubview:self.label3];
    
    self.label4 = [UILabel new];
    self.label4.font = LPFFONT(11);
    self.label4.textColor = SMTextColor;
    [self.contentView addSubview:self.label4];
    
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
}

- (void)setupLayout{
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.top.offset = 10;
        make.width.offset = 40;
        make.height.offset = 18;
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.label1.mas_right).offset = 5;
        make.left.offset = 20;
        make.top.offset = 10;
//        make.centerY.equalTo(self.label1);
        make.right.offset = -10;
    }];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.top.equalTo(self.label2.mas_bottom).offset = 5;
    }];
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.top.equalTo(self.label3.mas_bottom).offset = 2;
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.right.offset = -20;
        make.bottom.offset = -10;
//        make.top.equalTo(self.label4.mas_bottom).offset = 5;
        make.height.offset = 60 + 50;
    }];
}

- (void)setModel:(ProductModel *)model{
    _model = model;
    self.label1.text = model.showstate.length ? model.showstate : @"推荐";
    self.label2.text = [NSString stringWithFormat:@"            %@%@%@",model.brandName,model.typeName,model.title];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"首付 %@",[model.min_down_payment priceWithWan]]];
    UIFont *font = BPFFONT(12);
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,2)];
    [self.label3 setAttributedText:attrString];
    self.label4.text = [NSString stringWithFormat:@"现价 %@",[model.price priceWithWan]];
    [self.imageView sd_setImageWithURL:URLWithImageName(model.img) placeholderImage:IMAGECACHE(@"zhan_mid")];
}


@end
