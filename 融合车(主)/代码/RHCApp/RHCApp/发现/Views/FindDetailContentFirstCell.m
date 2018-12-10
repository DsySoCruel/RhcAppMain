//
//  FindDetailContentFirstCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/14.
//

#import "FindDetailContentFirstCell.h"


@interface FindDetailContentFirstCell()

@property (nonatomic,strong) YXDButton *rightbutton;
@property (nonatomic,strong) YXDButton *leftbutton;

@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *leftLabel;

@property (nonatomic,strong) UIView  *lineView;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UIView  *line;

@end

@implementation FindDetailContentFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    self.leftbutton = [[YXDButton alloc] init];
    [self.leftbutton setTitle:@"靠谱" forState:UIControlStateNormal];
    [self.leftbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.leftbutton setImage:IMAGECACHE(@"zixunxiangqing_01") forState:UIControlStateNormal];
    self.leftbutton.status = MoreStyleStatusTop;
    self.leftbutton.padding = 5;
    self.leftbutton.titleLabel.font = LPFFONT(16);
    [self.contentView addSubview:self.leftbutton];
    self.leftbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftbutton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightbutton = [[YXDButton alloc] init];
    [self.rightbutton setTitle:@"没用" forState:UIControlStateNormal];
    [self.rightbutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.rightbutton setImage:IMAGECACHE(@"zixunxiangqing_02") forState:UIControlStateNormal];
    self.rightbutton.status = MoreStyleStatusTop;
    self.rightbutton.titleLabel.font = LPFFONT(16);
    self.rightbutton.padding = 5;
    self.rightbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rightbutton];
    [self.rightbutton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftLabel = [UILabel new];
    self.leftLabel.textColor = [UIColor redColor];
    self.leftLabel.font = LPFFONT(12);
    [self.contentView addSubview:self.leftLabel];
    
    self.rightLabel = [UILabel new];
    self.rightLabel.textColor = [UIColor blueColor];
    self.rightLabel.font = LPFFONT(12);
    [self.contentView addSubview:self.rightLabel];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.lineView];
    
    self.typeLabel = [UILabel new];
    self.typeLabel.textColor = SMParatextColor;
    self.typeLabel.font = MFFONT(16);
    self.typeLabel.text = @"相关内容推荐";
    [self.contentView addSubview:self.typeLabel];
    
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.line];
}
- (void)setupLayout{
    
    [self.leftbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 30;
        make.left.offset = 0;
        make.width.equalTo(self.rightbutton);
        make.height.offset = 80;
        make.right.equalTo(self.rightbutton.mas_left);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftbutton);
        make.top.equalTo(self.leftbutton.mas_bottom).offset = 0;
    }];
    
    [self.rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 30;
        make.right.offset = 0;
        make.width.equalTo(self.leftbutton);
        make.height.offset = 80;
        make.left.equalTo(self.leftbutton.mas_right);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightbutton);
        make.top.equalTo(self.rightbutton.mas_bottom).offset = 0;
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 135;
        make.left.right.offset = 0;
        make.height.offset = 10;
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset = 0;
        make.left.offset = 15;
        make.right.offset = -15;
        make.height.offset = 45;
        make.bottom.offset = 0;
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 0.5;
    }];

}
- (void)setModel:(FindDetailModel *)model{
    _model = model;
    self.leftLabel.text = [NSString stringWithFormat:@"%@人",model.praise_number];
    self.rightLabel.text = [NSString stringWithFormat:@"%@人",model.no_number];
}

//靠谱
- (void)leftButtonAction:(UIButton *)sender{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"id"] = self.model.fid;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_updatePraiseNumber parameters:parames successed:^(id json) {
        if (json) {
            sender.userInteractionEnabled = NO;
            Weakself.model.praise_number = [NSString stringWithFormat:@"%tu",[Weakself.model.praise_number integerValue] + 1];
            self.leftLabel.text = [NSString stringWithFormat:@"%@人",Weakself.model.praise_number];
        }
    } failure:^(NSError *error) {
        
    }];
}
//没用
- (void)rightButtonAction:(UIButton *)sender{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"id"] = self.model.fid;
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_updateStepOnNumber parameters:parames successed:^(id json) {
        if (json) {
            sender.userInteractionEnabled = NO;
            Weakself.model.no_number = [NSString stringWithFormat:@"%tu",[Weakself.model.no_number integerValue] + 1];
            self.rightLabel.text = [NSString stringWithFormat:@"%@人",Weakself.model.no_number];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
