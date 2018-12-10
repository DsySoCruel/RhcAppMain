//
//  FindViewDetailViewBigCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/16.
//

#import "FindViewDetailViewBigCell.h"
@interface FindViewDetailViewBigCell()
@property (nonatomic,strong) UIImageView *bigImageView;
@property (nonatomic,strong) UILabel *numForImage;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *typeLabel;//组织
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIView  *lineView;
@end


@implementation FindViewDetailViewBigCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    
    self.bigImageView = [UIImageView new];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bigImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bigImageView];
    
    self.numForImage = [UILabel new];
    self.numForImage.backgroundColor = YXDBlockColor(1, 1, 1, 0.3);
    self.numForImage.layer.cornerRadius = 12.5;
    self.numForImage.layer.masksToBounds = YES;
    self.numForImage.font = LPFFONT(12);
    self.numForImage.textAlignment = NSTextAlignmentCenter;
    self.numForImage.textColor = [UIColor whiteColor];
    self.numForImage.hidden = YES;
    [self.bigImageView addSubview:self.numForImage];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = BFONT(14);
    self.contentLabel.textColor = SMTextColor;
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    
    self.typeLabel = [UILabel new];
    self.typeLabel.font = LPFFONT(12);
    self.typeLabel.textColor = SMParatextColor;
    [self.contentView addSubview:self.typeLabel];
    
    self.numLabel = [UILabel new];
    self.numLabel.font = LPFFONT(12);
    self.numLabel.textColor = SMParatextColor;
    self.numLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.numLabel];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.lineView];
}

- (void)setupLayout{
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset = 15;
        make.right.offset = -15;
        make.height.offset = (Screen_W * 280) / 750;
    }];
    [self.numForImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 25;
        make.bottom.right.offset = -7;
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.bigImageView.mas_bottom).offset = 10;
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.height.offset = 40;
        make.width.offset = Screen_W * 0.5;
        make.bottom.offset = 0;
        make.top.equalTo(self.contentLabel.mas_bottom).offset = 5;
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.height.offset = 40;
        make.width.offset = Screen_W * 0.5 - 30;
        make.top.equalTo(self.contentLabel.mas_bottom).offset = 5;
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 1;
    }];
}
- (void)setModel:(FindViewListModel *)model{
    _model = model;
    [self.bigImageView sd_setImageWithURL:URLWithImageName(model.cover_url) placeholderImage:IMAGECACHE(@"zhan_big")];
    self.contentLabel.text = model.title;
    NSString *tempType = @"";
    switch ([model.showtype1 integerValue]) {
        case 1:
            tempType = @"购车攻略";
            break;
        case 2:
            tempType = @"爆款推荐";
            
            break;
        case 3:
            tempType = @"对比优选";
            
            break;
        case 4:
            tempType = @"养车技巧";
            break;
            
        default:
            break;
    }
    self.typeLabel.text = [NSString stringWithFormat:@"%@ · %@",[model.create_time timeTypeFromNow],tempType];
    self.numLabel.text = [NSString stringWithFormat:@"%@人看过",model.browse_number];
}
- (void)setHomeModel:(HomeViewListModel *)homeModel{
    _homeModel = homeModel;
    [self.bigImageView sd_setImageWithURL:URLWithImageName(homeModel.cover_url) placeholderImage:IMAGECACHE(@"zhan_big")];
    self.contentLabel.text = homeModel.title;
    NSString *tempType = @"";
    switch ([homeModel.showtype integerValue]) {
        case 1:
            tempType = @"购车攻略";
            break;
        case 2:
            tempType = @"爆款推荐";
            
            break;
        case 3:
            tempType = @"对比优选";
            
            break;
        case 4:
            tempType = @"养车技巧";
            break;
            
        default:
            break;
    }
    self.typeLabel.text = [NSString stringWithFormat:@"%@",tempType];
    self.numLabel.text = [NSString stringWithFormat:@"%@人看过",homeModel.browse_number];
}
@end
