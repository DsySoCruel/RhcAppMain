//
//  FindViewDetailViewCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/16.
//

#import "FindViewDetailViewCell.h"

@interface FindViewDetailViewCell()
@property (nonatomic,strong) UIImageView *bigImageView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIView  *lineView;
@end


@implementation FindViewDetailViewCell
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
    [self.contentView addSubview:self.bigImageView];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = BFONT(14);
    self.contentLabel.textColor = SMTextColor;
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    
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
        make.right.offset(-10);
        make.top.offset(15).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(115, 76.5));
        make.bottom.offset = -15;
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.equalTo(self.bigImageView.mas_left).offset = -10;
        make.top.equalTo(self.bigImageView);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.bottom.equalTo(self.bigImageView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 1;
    }];
}

- (void)setModel:(FindViewListModel *)model{
    _model = model;
    [self.bigImageView sd_setImageWithURL:URLWithImageName(model.cover_url) placeholderImage:IMAGECACHE(@"zhan_mid")];
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
    self.numLabel.text = [NSString stringWithFormat:@"%@ · %@ · %@人看过",[model.create_time timeTypeFromNow],tempType,model.browse_number];
}

- (void)setHomeModel:(HomeViewListModel *)homeModel{
    _homeModel = homeModel;
    [self.bigImageView sd_setImageWithURL:URLWithImageName(homeModel.cover_url) placeholderImage:IMAGECACHE(@"zhan_mid")];
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
    self.numLabel.text = [NSString stringWithFormat:@"%@ · %@人看过",tempType,homeModel.browse_number];
}


@end
