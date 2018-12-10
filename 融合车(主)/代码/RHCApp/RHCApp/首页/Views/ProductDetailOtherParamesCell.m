//
//  ProductDetailOtherParamesCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/12.
//

#import "ProductDetailOtherParamesCell.h"

@interface ProductDetailOtherParamesCell()
@property (nonatomic,strong) UILabel *keyLabel;
@property (nonatomic,strong) UILabel *valueLabel;//组织
@property (nonatomic,strong) UIButton *urlButton;//有链接的时候显示比如 查看赔付方案：
@property (nonatomic,strong) UIView  *lineView;
@end

@implementation ProductDetailOtherParamesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI{
    
    self.keyLabel = [UILabel new];
    self.keyLabel.font = BFONT(18);
    self.keyLabel.textColor = SMTextColor;
    self.keyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.keyLabel];
    
    self.valueLabel = [UILabel new];
    self.valueLabel.font = LPFFONT(16);
    self.valueLabel.textColor = SMParatextColor;
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.numberOfLines = 0;
    [self.contentView addSubview:self.valueLabel];
    
    self.urlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.urlButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.urlButton.titleLabel.font = LPFFONT(15);
    [self.urlButton addTarget:self action:@selector(urlButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.urlButton];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.lineView];
}

- (void)setupLayout{
    
    [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.offset =10;
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.left.offset = 10;
        make.top.equalTo(self.keyLabel.mas_bottom).offset = 15;
        make.bottom.offset = -10;
    }];
    
    [self.urlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.bottom.offset = -10;
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 1;
    }];

}
- (void)setNoteModel:(PurchaseNotesModel *)noteModel {
    _noteModel = noteModel;
    self.keyLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.keyLabel.text = noteModel.content;
    self.valueLabel.text = noteModel.remark;
    self.urlButton.hidden = !([noteModel.type integerValue] == 1);
    if ([noteModel.type integerValue] == 1) {
        [self.valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = -45;
        }];
        [self.urlButton setTitle:noteModel.urlname forState:UIControlStateNormal];
    }else{
        [self.valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = -10;
        }];
    }
}

- (void)setThreeModel:(PurchaseThreeModel *)threeModel{
    _threeModel = threeModel;
    self.keyLabel.textAlignment = NSTextAlignmentLeft;
    self.valueLabel.textAlignment = NSTextAlignmentLeft;
    self.keyLabel.text = threeModel.content;
    self.valueLabel.text = threeModel.remark;
    self.urlButton.hidden = YES;
}

- (void)urlButtonAction{
    //跳转到网页界面
    WebViewController *webView = [WebViewController new];
    webView.title = @"赔付方案";
    [webView loadWebWithUrl:self.noteModel.url];
    [self.navigationController pushViewController:webView animated:YES];
}


@end
