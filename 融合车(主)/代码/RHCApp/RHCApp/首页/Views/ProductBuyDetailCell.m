//
//  ProductBuyDetailCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/27.
//

#import "ProductBuyDetailCell.h"
#import "SectionFooterView1.h"

@interface ProductBuyDetailCell()
@property (nonatomic,strong) SectionFooterView1 *firstView;
@property (nonatomic,strong) UILabel     *selectLabel;
@property (nonatomic,strong) UIImageView *jiantouImage;

@end

@implementation ProductBuyDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.firstView = [[SectionFooterView1 alloc] initWithTitle:@""];
    [self.contentView addSubview:self.firstView];
    self.jiantouImage = [UIImageView new];
    self.jiantouImage.userInteractionEnabled = YES;
    self.jiantouImage.image = IMAGECACHE(@"shangpinxiangqing_01");
    [self.contentView addSubview:self.jiantouImage];
    self.selectLabel = [UILabel new];
    self.selectLabel.font = LPFFONT(14);
    self.selectLabel.textAlignment = NSTextAlignmentRight;
    self.selectLabel.textColor = SMTextColor;
    self.selectLabel.numberOfLines = 0;
//    self.selectLabel.text = @"请选择属性";
    [self.contentView addSubview:self.selectLabel];
}

- (void)setupLayout{
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 0;
        make.height.offset = 40;
        make.width.offset = 120;
    }];
    [self.jiantouImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.offset = -15;
    }];
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.right.equalTo(self.jiantouImage.mas_left).offset = -10;
        make.left.offset = 150;
    }];
}

- (void)configCellWith:(NSString *)firstTitle andSubStr:(NSString *)str{
    self.firstView.label.text = firstTitle;
    self.selectLabel.text = str;
}

@end
