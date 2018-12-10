//
//  CircleVClistCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "CircleVClistCell.h"
#import "CircleVCListCellTopView.h"
@interface CircleVClistCell()
@property (nonatomic,strong) UIView  *toplineView;
@property (nonatomic,strong) CircleVCListCellTopView *topView;
@property (nonatomic,strong) UIImageView *bigImageView;
@property (nonatomic,strong) UILabel *numForImage;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *typeLabel;//组织
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIView  *lineView;
@end
@implementation CircleVClistCell

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
    
    self.bigImageView = [UIImageView new];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bigImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bigImageView];
    
    self.numForImage = [UILabel new];
    self.numForImage.backgroundColor = YXDBlockColor(1, 1, 1, 0.3);
    self.numForImage.layer.cornerRadius = 12.5;
    self.numForImage.layer.masksToBounds = YES;
    self.numForImage.font = LPFFONT(12);
    self.numForImage.textAlignment = NSTextAlignmentCenter;
    self.numForImage.textColor = [UIColor whiteColor];
    [self.bigImageView addSubview:self.numForImage];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = MFFONT(14);
    self.contentLabel.textColor = SMTextColor;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.typeLabel = [UILabel new];
    self.typeLabel.font = LPFFONT(12);
    self.typeLabel.textColor = SMTextColor;
    [self.contentView addSubview:self.typeLabel];
    
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
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 1;
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.offset = 15;
        make.height.offset = 50;
    }];
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(self.topView.mas_bottom);
        make.height.offset = (Screen_W * 280) / 750;
    }];
    [self.numForImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 25;
        make.bottom.right.offset = -7;
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.top.equalTo(self.bigImageView.mas_bottom).offset = 10;
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.height.offset = 40;
        make.width.offset = Screen_W * 0.5;
        make.bottom.offset = -15;
        make.top.equalTo(self.contentLabel.mas_bottom).offset = 5;
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.height.offset = 40;
        make.width.offset = Screen_W * 0.5 - 30;
        make.top.equalTo(self.contentLabel.mas_bottom).offset = 5;
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 15;
    }];
}

- (void)setModel:(CircleViewControllerListModel *)model{
    _model = model;
    self.topView.model = model;
    self.contentLabel.text = model.content;
    self.numLabel.text = [NSString stringWithFormat:@"%@人看过 · %@回帖",model.looks,model.count];
    self.typeLabel.text = model.showlabel;
    if (!model.imgs.length) {//没有照片
        [self.bigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset = 10;
        }];
        self.numForImage.hidden = YES;
    }else{
        [self.bigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = (Screen_W * 280) / 750;
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bigImageView.mas_bottom).offset = 10;
        }];
        //把照片以,为分隔为数组
        NSArray *tempArray = [model.imgs componentsSeparatedByString:@","];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:tempArray.firstObject] placeholderImage:IMAGECACHE(@"zhan_big")];
        if (tempArray.count > 1) {
            self.numForImage.hidden = NO;
            self. numForImage.text = [NSString stringWithFormat:@"%tu",tempArray.count];
        }else{
            self.numForImage.hidden = YES;
        }
    }
}

- (void)setHomeModel:(HomeViewListModel *)homeModel{
    _homeModel = homeModel;
    self.topView.homeModel = homeModel;
    self.contentLabel.text = homeModel.title;
    self.numLabel.text = [NSString stringWithFormat:@"%@人看过 · %@回帖",homeModel.browse_number,homeModel.count];
    self.typeLabel.text = @"车随我心";
    if (!homeModel.cover_url.length) {//没有照片
        [self.bigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = 0;
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset = 10;
        }];
        self.numForImage.hidden = YES;
    }else{
        [self.bigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset = (Screen_W * 280) / 750;
        }];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bigImageView.mas_bottom).offset = 10;
        }];
        //把照片以,为分隔为数组
        NSArray *tempArray = [homeModel.cover_url componentsSeparatedByString:@","];
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:tempArray.firstObject] placeholderImage:IMAGECACHE(@"zhan_big")];
        if (tempArray.count > 1) {
            self.numForImage.hidden = NO;
            self. numForImage.text = [NSString stringWithFormat:@"%tu",tempArray.count];
        }else{
            self.numForImage.hidden = YES;
        }
    }
}
@end
