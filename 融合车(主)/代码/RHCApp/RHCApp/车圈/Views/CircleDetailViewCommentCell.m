//
//  CircleDetailViewCommentCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "CircleDetailViewCommentCell.h"
#import "CircleVCListCellTopView.h"
#import "TextHighlightLabel.h"

@interface CircleDetailViewCommentCell()
@property (nonatomic,strong) UIView  *toplineView;
@property (nonatomic,strong) CircleVCListCellTopView *topView;
@property (nonatomic,strong) TextHighlightLabel *contentLabel;
@end

@implementation CircleDetailViewCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    self.toplineView = [UIView new];
    self.toplineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.toplineView];
    
    self.topView = [CircleVCListCellTopView new];
    [self.contentView addSubview:self.topView];
    
    self.contentLabel = [TextHighlightLabel new];
    self.contentLabel.font = LPFFONT(12);
    self.contentLabel.textColor = SMTextColor;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
}

- (void)setupLayout{
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 1;
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.offset = 10;
        make.height.offset = 50;
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 60;
        make.right.offset = -15;
        make.top.equalTo(self.topView.mas_bottom).offset = 5;
        make.bottom.offset = -15;
    }];
}

- (void)setModel:(CircleCommendModel *)model{
    _model = model;
    self.topView.commodel = model;
    [self.contentLabel setAttributedTextAuto:model.content withHighFont:LPFFONT(12)];
}


@end
