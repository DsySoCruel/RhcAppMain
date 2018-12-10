//
//  ServiceStationSelectViewCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/8.
//

#import "ServiceStationSelectViewCell.h"
#import "ServiceStationViewCellModel.h"

@interface ServiceStationSelectViewCell()
@property (nonatomic,strong) UIButton    *selectButton;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *detailLabel;
@property (nonatomic,strong) UIView      *line;
@end


@implementation ServiceStationSelectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:IMAGECACHE(@"gouwuche_01") forState:UIControlStateNormal];
    [self.selectButton setImage:IMAGECACHE(@"gouwuche_02") forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];

    self.nameLabel = [UILabel new];
    self.nameLabel.font = BPFFONT(16);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = SMTextColor;
    self.nameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.nameLabel];
    
    self.detailLabel = [UILabel new];
    self.detailLabel.font = LPFFONT(14);
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.textColor = SMParatextColor;
    self.detailLabel.numberOfLines = 0;
    [self.contentView addSubview:self.detailLabel];
    
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.line];
}

- (void)setupLayout{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 50;
        make.right.offset = -10;
        make.top.offset = 15;
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 50;
        make.right.offset = -10;
        make.top.equalTo(self.nameLabel.mas_bottom).offset = 10;
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 10;
        make.width.height.offset = 30;
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 50;
        make.right.bottom.offset = 0;
        make.height.offset = 0.5;
        make.top.equalTo(self.detailLabel.mas_bottom).offset = 15;
    }];
}


- (void)configModel:(ServiceStationViewCellModel *)model with:(NSIndexPath *)indexPath{
    _model = model;
    self.selectButton.selected = [model.isSelect isEqualToString:@"1"];
    self.nameLabel.text = model.name;
    self.detailLabel.text = model.address;
    if (indexPath.section == 0) {
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.height.offset = 15;
        }];
    }else{
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 50;
            make.height.offset = 0.5;
        }];
    }
}

@end
