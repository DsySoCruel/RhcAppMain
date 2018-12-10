//
//  EditHeadCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/20.
//

#import "EditHeadCell.h"

@interface EditHeadCell ()
@property (nonatomic,strong) UILabel       *titleLabel;
@property (nonatomic,strong) UIImageView   *headImageView;
@property (nonatomic,strong) UIImageView   *icon;
@property (nonatomic,strong) UIView        *lineView;
@end

@implementation EditHeadCell

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
    
    self.headImageView = [UIImageView new];
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.layer.masksToBounds = YES;
    
    
    self.icon = [UIImageView new];
    self.icon.image = IMAGECACHE(@"me_07");
    
    self.lineView = [UILabel new];
    self.lineView.backgroundColor = SMViewBGColor;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.headImageView];
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
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.icon.mas_left).offset = -10;
        make.centerY.offset = 0;
        make.width.height.offset = 60;
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

- (void)configWithTitle:(NSString *)keyword andSubstitle:(NSString *)image{
    self.titleLabel.text = keyword;
    [self.headImageView sd_setImageWithURL:URLWithImageName(image) placeholderImage:IMAGECACHE(@"zhan_head")];
}


@end
