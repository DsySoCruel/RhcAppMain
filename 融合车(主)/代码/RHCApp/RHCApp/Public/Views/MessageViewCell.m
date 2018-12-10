//
//  MessageViewCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/24.
//

#import "MessageViewCell.h"

@interface MessageViewCell ()
@property (nonatomic,strong) UIImageView   *headImageView;
@property (nonatomic,strong) UILabel       *mainTitleLabel;
@property (nonatomic,strong) UILabel       *subTitleLabel;
@property (nonatomic,strong) UILabel       *timeLabel;
@property (nonatomic,strong) UIView        *redDianView;
@property (nonatomic,strong) UIView        *lineView;
@end


@implementation MessageViewCell

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
    
    self.mainTitleLabel = [UILabel new];
    self.mainTitleLabel.font = SFONT(17);
    self.mainTitleLabel.textColor = SMTextColor;
    self.mainTitleLabel.numberOfLines = 1;
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.font = LPFFONT(12);
    self.subTitleLabel.textColor = SMParatextColor;
    self.subTitleLabel.numberOfLines = 1;
    
    self.redDianView = [UIView new];
    self.redDianView.backgroundColor = [UIColor redColor];
    self.redDianView.layer.cornerRadius = 3;
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = LPFFONT(10);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = SMParatextColor;
    
    self.lineView = [UILabel new];
    self.lineView.backgroundColor = SMViewBGColor;
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.mainTitleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.redDianView];
    [self.contentView addSubview:self.lineView];
    
}

-(void)setupLayout{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
//        make.top.offset(15).priorityHigh();
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerY.offset = 0;
//        make.bottom.offset = -15;
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -80;
        make.top.equalTo(self.headImageView);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset = 10;
        make.right.offset = -80;
        make.top.equalTo(self.mainTitleLabel.mas_bottom).offset = 10;
    }];
    
    [self.redDianView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset = -10;
        make.centerY.equalTo(self.subTitleLabel);
        make.centerX.equalTo(self.timeLabel);
        make.width.height.offset = 6;
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainTitleLabel.mas_right).offset = 10;
        make.right.offset = -10;
        make.centerY.equalTo(self.mainTitleLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}

- (void)setModel:(MessageListDetailModel *)model{
    _model = model;
    if ([model.type integerValue] == 1) {
        self.mainTitleLabel.text = @"系统通知";
        self.headImageView.image = IMAGECACHE(@"message_01");
    }
    if ([model.type integerValue] == 2) {
        self.mainTitleLabel.text = @"优惠活动";
        self.headImageView.image = IMAGECACHE(@"message_02");
    }
    if ([model.type integerValue] == 3) {
        self.mainTitleLabel.text = @"订单反馈";
        self.headImageView.image = IMAGECACHE(@"message_03");
    }
    if ([model.type integerValue] == 4) {
        self.mainTitleLabel.text = @"车圈互动";
        self.headImageView.image = IMAGECACHE(@"message_04");
    }
    if ([model.state isEqualToString:@"ADD"]) {
        self.redDianView.hidden = NO;
    }else{
        self.redDianView.hidden = YES;
    }
    self.subTitleLabel.text = model.content;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[model.create_time timeTypeFromNow]];
}

@end
