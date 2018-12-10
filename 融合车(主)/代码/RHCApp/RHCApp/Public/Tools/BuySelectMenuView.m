//
//  BuySelectMenuView.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/24.
//

#import "BuySelectMenuView.h"
#import "BuySelectMenuOneCell.h"
#import "BuySelectMenuTagView.h"

static NSString *kBuySelectMenuOneCell = @"BuySelectMenuOneCell";
//static NSString *kBuySelectMenuTwoCell = @"BuySelectMenuTwoCell";

@interface BuySelectMenuView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

//0.
@property (nonatomic , strong) UIView *customerView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) BuySelectMenuViewType buytype;
@property (nonatomic , strong) AccessoriesStoreDetailModel *model;//配件详细数据

//1.商品 和 已选择的信息
@property (nonatomic , strong) UIView      *goodImageBackgroundView;
@property (nonatomic , strong) UIImageView *goodImageView;
@property (nonatomic , strong) UILabel     *goodsPriceLabel;
@property (nonatomic , strong) UILabel     *availableNumLa;//库存
@property (nonatomic , strong) UILabel     *selectStateLabel;
@property (nonatomic , strong) UIView      *line1;

//2.选择参数的信息
@property (nonatomic , strong) UITableView *tableView;

//3.底部工具条的信息
@property (nonatomic , strong) UIButton    *addShopCarButton;//加入购物车
@property (nonatomic , strong) UIButton    *buyButton;//直接购买
@property (nonatomic , strong) UIButton    *sureButton;//确定


//4.tableViewFooterView
@property (nonatomic , strong) UIButton    *jian;
@property (nonatomic , strong) UILabel     *num;
@property (nonatomic , strong) UIButton    *jia;

//5.自增判断参数
@property (nonatomic , strong) NSString    *styleStr;//保存的样式信息
@property (nonatomic , strong) NSString    *colorStr;//保存的颜色信息
@end


@implementation BuySelectMenuView

-(id)initWithDataSource:(AccessoriesStoreDetailModel *)model withType:(BuySelectMenuViewType)type{
    if (self = [super init]) {
        //0.设置数据
        _dataArray = [NSMutableArray array];
//        [_dataArray addObjectsFromArray:array];
        _model = model;
        _buytype = type;
        //1.设置黑色蒙版
        self.frame = CGRectMake(0, 0, Screen_W, Screen_H);
        
        CGFloat H = Screen_H * 0.7;
        //2.设置自定义模板
        self.customerView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_H, Screen_W, H)];
        self.customerView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.customerView];
        
//        self.selectData = self.dataArray[0];
//        //对数据进行整理
//        for (MeetingGetTicketData *data in self.dataArray) {
//            if (!([data.ticketNumber isEqualToString:@"无票"] || [data.ticketNumber isEqualToString:@"0"])) {
//                data.isSelect = @"1";
//                self.ticketId = data.ticketId;
//                self.introStr = data.ticketExplain;
//                break;
//            }
//        }
        
        //1.设置工具条
        [self setUI];
        
        [self setLayout];
    }
    return self;
}

- (void)setUI{
    
//    WEAK_SELF
//    self.titleLabel = [UILabel new];
//    self.titleLabel.text = @"门票信息";
//    self.titleLabel.textColor = SMTextColor;
//    self.titleLabel.font = MFFONT(17);
//    [self.customerView addSubview:self.titleLabel];
//
//    self.lineView = [UIView new];
//    self.lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [self.customerView addSubview:self.lineView];
    
    
    //1.
    self.goodImageBackgroundView = [UIView new];
    self.goodImageBackgroundView.backgroundColor = [UIColor whiteColor];
    self.goodImageBackgroundView.layer.cornerRadius = 5;
    self.goodImageBackgroundView.layer.masksToBounds = YES;
    [self.customerView addSubview:self.goodImageBackgroundView];
    
    self.goodImageView = [UIImageView new];
    NSString *imageStr = @"";
    if (self.model.imgList.count) {
        ImgModel *model = self.model.imgList.firstObject;
        imageStr = model.url;
    }
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMAGECACHE(@"zhan_mid")];
    [self.goodImageBackgroundView addSubview:self.goodImageView];
    
    self.goodsPriceLabel = [UILabel new];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.price];
    self.goodsPriceLabel.textColor = [UIColor redColor];
    self.goodsPriceLabel.font = LPFFONT(14);
    [self.customerView addSubview:self.goodsPriceLabel];
    
    self.availableNumLa = [UILabel new];
    self.availableNumLa.text = [NSString stringWithFormat:@"库存%@件",self.model.orderCount];
    self.availableNumLa.textColor = SMParatextColor;
    self.availableNumLa.font = LPFFONT(14);
    [self.customerView addSubview:self.availableNumLa];
    
    self.selectStateLabel = [UILabel new];
    self.selectStateLabel.text = @"请选择 属性";
    self.selectStateLabel.textColor = SMParatextColor;
    self.selectStateLabel.font = LPFFONT(14);
    [self.customerView addSubview:self.selectStateLabel];

    self.line1 = [UIView new];
    self.line1.backgroundColor = SMLineColor;
    [self.customerView addSubview:self.line1];

    //2.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BuySelectMenuOneCell class] forCellReuseIdentifier:kBuySelectMenuOneCell];
//    [self.tableView registerClass:[BuyTicketMenuTwoCell class] forCellReuseIdentifier:kBuyTicketMenuTwoCell];
//    self.tableView.estimatedRowHeight = 40;
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.backgroundColor = SMViewBGColor;// SMViewBGColor;
//    self.tableView.separatorColor = SMViewBGColor;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    self.tableView.sectionIndexColor = SMTextColor;
    [self.customerView addSubview:self.tableView];
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.frame = CGRectMake(0, 0, 0, 50);
    self.tableView.tableFooterView = footerView;
    UILabel *label1 = [UILabel new];
    label1.text = @"数量";
    label1.textColor = SMTextColor;
    label1.font = BFONT(15);
    [footerView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 15;
    }];
    
    self.jian = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.jian setImage:IMAGECACHE(@"icon_52") forState:UIControlStateNormal];
    [footerView addSubview:self.jian];
    [self.jian addTarget:self action:@selector(jianButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.num = [UILabel new];
    self.num.textColor = SMParatextColor;
    self.num.font = LPFFONT(13);
    self.num.text = @"1";
    self.num.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:self.num];
    
    self.jia = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.jia setImage:IMAGECACHE(@"icon_53") forState:UIControlStateNormal];
    [footerView addSubview:self.jia];
    [self.jia addTarget:self action:@selector(jiaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.jia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.centerY.equalTo(label1);
        make.width.height.offset = 25;
    }];
    
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jia.mas_left).offset = -10;
        make.width.height.offset = 30;
        make.centerY.equalTo(self.jia).offset = 0;
    }];
    
    [self.jian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.num.mas_left).offset = -10;
        make.centerY.equalTo(self.jia).offset = 0;
        make.width.height.offset = 25;
    }];
    
    
    
    
//    self.joinButton = [UIButton new];
//    [self.joinButton setTitle:self.joinButtonTitle forState:UIControlStateNormal];
//    self.joinButton.titleLabel.font = BPFFONT(17);
//    [self.joinButton setTitleColor:RGB(0xFFFFFF) forState:UIControlStateNormal];
//    self.joinButton.backgroundColor = SMButtonBGColor;
//    [self.customerView addSubview:self.joinButton];
//    [[self.joinButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        STRONG_SELF
//
//        if (self.type == JoinButtonStatuLocalUnJoined || self.type == JoinButtonStatuLiveUnJoined) {//确实是买票的
//            if (self.ticketId.length) {
//                [self tappedCancel];
//                if (self.delegate && [self.delegate respondsToSelector:@selector(presentControllerWithMessage:ticketPrice:)]) {
//                    [self.delegate presentControllerWithMessage:self.ticketId ticketPrice:self.selectData.ticketPrice];
//                }
//            }else{
//                [self tappedCancel];
//                [[BaseViewController topViewController] showToast:@"请选择门票"];
//            }
//        }else{
//            [self tappedCancel];
//
//            if (self.type == JoinButtonStatuLocalEnd || self.type == JoinButtonStatuLiveJoined) {
//            }else{
//                if (self.delegate && [self.delegate respondsToSelector:@selector(pushViewController:animated:)]) {
//                    [self.delegate pushControllerWithMessage:self.type];
//                }
//            }
//        }
//    }];
    //3.
    if (self.buytype == BuySelectMenuViewTypeCell) {
        self.addShopCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addShopCarButton.backgroundColor = SMThemeColor;
        [self.addShopCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [self.addShopCarButton addTarget:self action:@selector(addShopCarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.customerView addSubview:self.addShopCarButton];
        
        self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buyButton.backgroundColor = [UIColor redColor];
        [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [self.buyButton addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.customerView addSubview:self.buyButton];
    }
    if (self.buytype == BuySelectMenuViewTypeAdd || self.buytype == BuySelectMenuViewTypeBuy) {
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureButton.backgroundColor = [UIColor redColor];
        [self.sureButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [self.sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.customerView addSubview:self.sureButton];
    }
}

- (void)setLayout{
    
    [self.goodImageBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset = 100;
        make.left.offset = 15;
        make.top.offset = -20;
    }];
     
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.offset = 0;
        make.width.height.offset = 90;
    }];
     
     [self.goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.goodImageBackgroundView.mas_right).offset = 15;
         make.top.offset = 5;
     }];
    
    [self.availableNumLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsPriceLabel.mas_bottom).offset = 2;
        make.left.equalTo(self.goodImageBackgroundView.mas_right).offset = 15;
    }];
    
    [self.selectStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.availableNumLa.mas_bottom).offset = 2;
        make.left.equalTo(self.goodImageBackgroundView.mas_right).offset = 15;
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(self.goodImageBackgroundView.mas_bottom).offset = 5;
        make.height.offset = 0.5;
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.top.equalTo(self.line1.mas_bottom).offset = 0;
        make.bottom.offset = -60;
    }];
    
    if (self.buytype == BuySelectMenuViewTypeCell) {
        [self.addShopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.height.offset = 50;
            make.right.equalTo(self.buyButton.mas_left).offset = 0;
            make.width.equalTo(self.buyButton);
            make.bottom.offset = -10;
        }];
        [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = 0;
            make.height.offset = 50;
            make.left.equalTo(self.addShopCarButton.mas_right).offset = 0;
            make.width.equalTo(self.addShopCarButton);
            make.bottom.offset = -10;
        }];
    }
    if (self.buytype == BuySelectMenuViewTypeAdd || self.buytype == BuySelectMenuViewTypeBuy) {
        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.height.offset = 50;
            make.bottom.offset = -10;
        }];
    }
}

- (void)showInView:(UIViewController *)controller {
    !controller?[[UIApplication sharedApplication].keyWindow addSubview:self]:[controller.view addSubview:self];
    [self animeData];
}

- (void)animeData {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundColor = RGBA(0x000000, 0.5);
        CGRect originRect = self.customerView.frame;
        originRect.origin.y = Screen_H - originRect.size.height;
        self.customerView.frame = originRect;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.1 animations:^{
            CGRect originRect = self.customerView.frame;
            originRect.origin.y = Screen_H - originRect.size.height + 10;
            self.customerView.frame = originRect;
        }];
    }];
}

- (void)tappedCancel{
    self.model.selectNum = 1;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
        CGRect originRect = self.customerView.frame;
        originRect.origin.y = Screen_H;
        self.customerView.frame = originRect;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.customerView removeFromSuperview];
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuySelectMenuOneCell *cell = [tableView dequeueReusableCellWithIdentifier:kBuySelectMenuOneCell];
    NSMutableArray *tempArray = [NSMutableArray array];
    if (indexPath.row == 0) {
        for (StyleModel *model in self.model.styleList) {
            [tempArray addObject:model.style];
        }
        [cell config:tempArray andTitle:@"样式"];
        WeakObj(self);
        cell.selectBlock = ^(NSString * _Nonnull str) {
            Weakself.styleStr = str;
            [self presentSelecResult];
        };
    }
    if (indexPath.row == 1) {
        for (ColorModel *model in self.model.colorList) {
            [tempArray addObject:model.name];
        }
        [cell config:tempArray andTitle:@"颜色"];
        WeakObj(self);
        cell.selectBlock = ^(NSString * _Nonnull str) {
            Weakself.colorStr = str;
            [self presentSelecResult];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempArray = [NSMutableArray array];

    if (indexPath.row == 0) {
        for (StyleModel *model in self.model.styleList) {
            [tempArray addObject:model.style];
        }
    }
    if (indexPath.row == 1) {
        for (ColorModel *model in self.model.colorList) {
            [tempArray addObject:model.name];
        }
    }
    return [BuySelectMenuTagView cellHeightWithArray:tempArray] + 40;
}

- (void)presentSelecResult{
    if (self.styleStr.length && self.colorStr.length) {
        self.selectStateLabel.text = [NSString stringWithFormat:@"已选择 %@ %@",self.styleStr,self.colorStr];
    }else{
        self.selectStateLabel.text = @"请选择 属性";
    }
}

- (void)jianButtonAction:(UIButton *)sender{
    if ([self.num.text integerValue] <= 1) {
        [MBHUDHelper showSuccess:@"亲,真的不能再少了"];
        return;
    }
    --self.model.selectNum;
    self.num.text = [NSString stringWithFormat:@"%tu",self.model.selectNum];
}

- (void)jiaButtonAction:(UIButton *)sender{
    if (self.model.selectNum >= [self.model.orderCount integerValue]) {
        [MBHUDHelper showSuccess:@"亲,超出最大库存"];
        return;
    }
    ++self.model.selectNum;
    self.num.text = [NSString stringWithFormat:@"%tu",self.model.selectNum];
}

- (void)addShopCarButtonAction{
    if ([self.selectStateLabel.text isEqualToString:@"请选择 属性"]) {
        [MBHUDHelper showSuccess:@"亲,请选择参数"];
        return;
    }
    //获取参数id
    NSString *styleId = @"";
    for (StyleModel *model in self.model.styleList) {
        if ([model.style isEqualToString:self.styleStr ]) {
            styleId = model.cid;
            break;
        }
    }
    NSString *colorId = @"";
    for (ColorModel *model in self.model.colorList) {
        if ([model.name isEqualToString:self.colorStr ]) {
            colorId = model.cid;
            break;
        }
    }
    //测试数据
    NSMutableDictionary *paremes = [NSMutableDictionary dictionary];
    paremes[@"token"] = [YXDUserInfoStore sharedInstance].userModel.token;
    paremes[@"id"] = self.model.pid;
    paremes[@"styleId"] = styleId;
    paremes[@"colorId"] = colorId;
    paremes[@"number"] = [NSString stringWithFormat:@"%tu",self.model.selectNum];
    WeakObj(self);
    [[NetWorkManager shareManager] POST:USER_ProductAddCar parameters:paremes successed:^(id json) {
        if (json) {
            Weakself.model.selectNum = 1;
            [MBHUDHelper showWarningWithText:@"成功加入购物车"];
            [self tappedCancel];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)buyButtonAction{
    
}
- (void)sureButtonAction{
    if (self.buytype == BuySelectMenuViewTypeAdd ) {
        [self addShopCarButtonAction];
    }
    if (self.buytype == BuySelectMenuViewTypeBuy ) {
        
    }
}

@end
