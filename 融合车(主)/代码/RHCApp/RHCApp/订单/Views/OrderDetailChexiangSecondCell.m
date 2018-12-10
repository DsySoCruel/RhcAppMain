//
//  OrderDetailChexiangSecondCell.m
//  RHCApp
//
//  Created by daishaoyang on 2018/10/14.
//

#import "OrderDetailChexiangSecondCell.h"
#import "OrderChexiangDetailModel.h"


@interface OrderDetailChexiangSecondCell ()
@property (nonatomic,strong) UILabel *a;//订单详情
@property (nonatomic,strong) UIView  *b;//line
@property (nonatomic,strong) UILabel *c;//
@property (nonatomic,strong) UILabel *d;//
@property (nonatomic,strong) UILabel *e;//
@property (nonatomic,strong) UILabel *f;//
@property (nonatomic,strong) UILabel *g;//
@property (nonatomic,strong) UILabel *h;//
@property (nonatomic,strong) UIView  *o;//line

@end

@implementation OrderDetailChexiangSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.a = [UILabel new];
    self.a.font = LPFFONT(16);
    self.a.textColor = SMTextColor;
    [self.contentView addSubview:self.a];
    
    self.b = [UIView new];
    self.b.backgroundColor = SMLineColor;
    [self.contentView addSubview:self.b];
    
    self.c = [UILabel new];
    self.c.font = LPFFONT(14);
    self.c.textColor = SMParatextColor;
    self.c.text = @"车型名称";
    [self.contentView addSubview:self.c];
    
    self.d = [UILabel new];
    self.d.font = LPFFONT(14);
    self.d.textColor = SMTextColor;
    [self.contentView addSubview:self.d];
    
    self.e = [UILabel new];
    self.e.font = LPFFONT(14);
    self.e.textColor = SMParatextColor;
    self.e.text = @"车厢类型";
    [self.contentView addSubview:self.e];
    
    self.f = [UILabel new];
    self.f.font = LPFFONT(14);
    self.f.textColor = SMTextColor;
    [self.contentView addSubview:self.f];
    
    self.g = [UILabel new];
    self.g.font = LPFFONT(14);
    self.g.textColor = SMParatextColor;
    self.g.text = @"备注";
    [self.contentView addSubview:self.g];
    
    self.h = [UILabel new];
    self.h.font = LPFFONT(14);
    self.h.textColor = SMTextColor;
    [self.contentView addSubview:self.h];

    self.o = [UIView new];
    self.o.backgroundColor = SMViewBGColor;
    [self.contentView addSubview:self.o];
}

- (void)setupLayout{
    [self.a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = -10;
        make.top.offset = 0;
        make.height.offset = 45;
    }];
    [self.b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 0.5;
        make.top.equalTo(self.a.mas_bottom).offset = 0;
    }];
    
    [self.c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.width.offset = 70;
//        make.right.offset = -10;
        make.top.equalTo(self.b.mas_bottom).offset = 15;
    }];
    [self.d mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.c.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.b.mas_bottom).offset = 15;
    }];
    [self.e mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.width.offset = 70;
        //        make.right.offset = -10;
        make.top.equalTo(self.d.mas_bottom).offset = 15;
    }];

    [self.f mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.c.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.d.mas_bottom).offset = 15;
    }];
    [self.g mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.width.offset = 70;
        //        make.right.offset = -10;
        make.top.equalTo(self.f.mas_bottom).offset = 15;
    }];
    [self.h mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.c.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.equalTo(self.f.mas_bottom).offset = 15;
    }];

    [self.o mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.equalTo(self.h.mas_bottom).offset = 15;
        make.bottom.offset = 0;
        make.height.offset = 10;
    }];
}

- (void)setModel:(OrderChexiangDetailModel *)model{
    _model = model;
    self.a.text = @"订单详情";

    self.d.text = model.name;
    self.f.text = model.type;
    self.h.text = model.remark;
}

@end
