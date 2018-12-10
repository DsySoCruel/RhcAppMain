//
//  CollectArticalListCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/3.
//

#import "CollectArticalListCell.h"

@interface CollectArticalListCell ()
@property (nonatomic,strong) UIImageView   *headImageView;
@property (nonatomic,strong) UILabel       *titlLabel;
@property (nonatomic,strong) UILabel       *priceLabel;
@property (nonatomic,strong) UILabel       *timeLabel;
@property (nonatomic,strong) UIView        *lineView;
@end


@implementation CollectArticalListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

-(void)setupUI{
    
    self.headImageView = [UIImageView new];
    
    self.titlLabel = [UILabel new];
    self.titlLabel.font = SFONT(15);
    self.titlLabel.textColor = SMTextColor;
    self.titlLabel.numberOfLines = 2;
    
    self.priceLabel = [UILabel new];
    self.priceLabel.font = LPFFONT(10);
    self.priceLabel.textColor = SMParatextColor;
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = LPFFONT(10);
    self.timeLabel.textColor = SMParatextColor;
    
    self.lineView = [UILabel new];
    self.lineView.backgroundColor = SMViewBGColor;
    
    [self.contentView addSubview:self.titlLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineView];
}


-(void)setupLayout{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(15).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(115, 76.5));
        make.bottom.offset = -15;
    }];
    
    [self.titlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.headImageView);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.bottom.equalTo(self.timeLabel.mas_top).offset = -2;
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -10;
        make.bottom.equalTo(self.headImageView.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

- (void)setModel:(MyCollectListModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:URLWithImageName(model.url) placeholderImage:IMAGECACHE(@"zhan_mid")];
    self.titlLabel.text = model.title;
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

    self.priceLabel.text = [NSString stringWithFormat:@"%@ · %@ · %@人看过",[model.aicreateTime timeTypeFromNow],tempType,model.browse_number];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 收藏",[model.create_time timeTypeFromNow]];
}
@end
