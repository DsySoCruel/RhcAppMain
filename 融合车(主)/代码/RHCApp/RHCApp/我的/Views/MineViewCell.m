//
//  MineViewCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/6/25.
//

#import "MineViewCell.h"

@interface MineViewCell ()
@property (nonatomic,strong) UILabel       *titleLabel;
@property (nonatomic,strong) UILabel       *subsTitleLabel;
@property (nonatomic,strong) UIImageView   *icon;
@property (nonatomic,strong) UIView        *lineView;
@end

@implementation MineViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

-(void)setupUI{
    self.titleLabel = [UILabel new];
    self.titleLabel.font = SFONT(17);
    self.titleLabel.textColor = SMTextColor;
    self.titleLabel.numberOfLines = 1;
    
    self.subsTitleLabel = [UILabel new];
    self.subsTitleLabel.font = PFFONT(14);
    self.subsTitleLabel.textColor = SMParatextColor;
    self.subsTitleLabel.numberOfLines = 1;
    
    
    self.icon = [UIImageView new];
    self.icon.image = IMAGECACHE(@"me_07");
    
    self.lineView = [UILabel new];
    self.lineView.backgroundColor = SMViewBGColor;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.subsTitleLabel];
    [self.contentView addSubview:self.lineView];
    
}

-(void)setupLayout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -50;
        make.centerY.offset = 0;
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.centerY.offset = 0;
    }];
    
    [self.subsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.icon.mas_left).offset = -10;
        make.centerY.offset = 0;
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

- (void)configWithTitle:(NSString *)keyword andSubstitle:(NSString *)subsTitle{
    self.titleLabel.text = keyword;
    if (subsTitle.length) {
        self.subsTitleLabel.text = subsTitle;
        self.subsTitleLabel.hidden = NO;
    }else{
        self.subsTitleLabel.hidden = YES;
    }
}


@end
