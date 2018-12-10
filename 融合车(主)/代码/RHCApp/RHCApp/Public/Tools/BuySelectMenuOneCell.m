//
//  BuySelectMenuOneCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/24.
//

#import "BuySelectMenuOneCell.h"
#import "BuySelectMenuTagView.h"

@interface BuySelectMenuOneCell()
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) BuySelectMenuTagView *tagsView;

@end
@implementation BuySelectMenuOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.typeLabel = [UILabel new];
    self.typeLabel.textColor = SMTextColor;
    self.typeLabel.font = BFONT(15);
    [self.contentView addSubview:self.typeLabel];
    
    self.tagsView = [[BuySelectMenuTagView alloc] init];
    WeakObj(self);
    self.tagsView.selectBlock = ^(NSString * _Nonnull str) {
        if (Weakself.selectBlock) {
            Weakself.selectBlock(str);
        }
    };
    [self.contentView addSubview:self.tagsView];
}

- (void)setupLayout{
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.offset = 10;
        make.right.offset = -10;
        make.height.offset = 25;
    }];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.typeLabel.mas_bottom);
        make.bottom.mas_equalTo(-5);
    }];
}

- (void)config:(NSArray *)itemArray andTitle:(NSString *)title{
    [self.tagsView config:itemArray];
    self.typeLabel.text = title;
}

@end
