//
//  FindViewDetailViewNoneCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/16.
//

#import "FindViewDetailViewNoneCell.h"

@interface FindViewDetailViewNoneCell()
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *typeLabel;//组织
@property (nonatomic,strong) UIView  *lineView;
@end


@implementation FindViewDetailViewNoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = BFONT(14);
    self.contentLabel.textColor = SMTextColor;
    self.contentLabel.numberOfLines = 3;
    [self.contentView addSubview:self.contentLabel];
    
    self.typeLabel = [UILabel new];
    self.typeLabel.font = LPFFONT(12);
    self.typeLabel.textColor = SMParatextColor;
    [self.contentView addSubview:self.typeLabel];
    
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.lineView];
}

- (void)setupLayout{

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset = 15;
        make.right.offset = -15;
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.height.offset = 40;
        make.bottom.right.offset = 0;
        make.top.equalTo(self.contentLabel.mas_bottom).offset = 5;
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 1;
    }];
}
- (void)setModel:(FindViewListModel *)model{
    _model = model;
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
    self.typeLabel.text = [NSString stringWithFormat:@"%@ · %@ · %@人看过",[model.create_time timeTypeFromNow],tempType,model.browse_number];
}

- (void)setHomeModel:(HomeViewListModel *)homeModel{
    _homeModel = homeModel;
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
    self.typeLabel.text = [NSString stringWithFormat:@"%@ · %@人看过",tempType,homeModel.browse_number];
}
@end
