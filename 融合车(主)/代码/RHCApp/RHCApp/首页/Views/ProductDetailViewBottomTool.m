//
//  ProductDetailViewBottomTool.m
//  RHCApp
//
//  Created by daishaoyang on 2018/9/3.
//

#import "ProductDetailViewBottomTool.h"
#import "YXDButton.h"
#import "RequestManager.h"
#import "ProductBuyDetailController.h"
#import "PGYPopMenu.h"

@interface ProductDetailViewBottomTool()
@property (nonatomic,strong) UIView         *kefuView;
@property (nonatomic,strong) UIImageView    *phoneImageView;
@property (nonatomic,strong) UILabel        *label1;
@property (nonatomic,strong) UILabel        *label2;
@property (nonatomic,strong) UIView         *line;
@property (nonatomic,strong) YXDButton      *collectButton;
@property (nonatomic,strong) YXDButton      *buyBuyAllMoney;
@property (nonatomic,strong) YXDButton      *fenqiButton;

@property (nonatomic,assign) ProductDetailViewBottomToolType viewType;
@end

@implementation ProductDetailViewBottomTool

- (instancetype)initWithType:(ProductDetailViewBottomToolType)type{
    if (self = [super init]) {
        self.viewType = type;
        [self setupUI];
        [self setLayout];
    }
    return self;
}


- (void)setupUI{
    
    //1.
    self.kefuView = [UIView new];
    UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    r5.numberOfTapsRequired = 1;
    [self.kefuView addGestureRecognizer:r5];
    [self addSubview:self.kefuView];
    
    self.phoneImageView = [UIImageView new];
    self.phoneImageView.userInteractionEnabled = YES;
    self.phoneImageView.image = IMAGECACHE(@"shop_02");
    [self.kefuView addSubview:self.phoneImageView];
    
    self.label1 = [UILabel new];
    self.label1.text = @"咨询客服";
    self.label1.textColor = SMParatextColor;
    self.label1.font = LPFFONT(12);
    [self.kefuView addSubview:self.label1];
    
    self.label2 = [UILabel new];
    self.label2.text = @"9:00-21:00";
    self.label2.textColor = SMParatextColor;
    self.label2.font = LPFFONT(10);
    [self.kefuView addSubview:self.label2];
    
    self.line = [UIView new];
    self.line.backgroundColor = SMViewBGColor;
    [self addSubview:self.line];
    
    
    //2.
    self.collectButton = [YXDButton buttonWithType:UIButtonTypeCustom];;
//    [self.collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.collectButton setImage:IMAGECACHE(@"shangpinxiangqing_03") forState:UIControlStateNormal];
    [self.collectButton setImage:IMAGECACHE(@"shangpinxiangqing_03_f") forState:UIControlStateSelected];
    [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:SMTextColor forState:UIControlStateNormal];
    [self.collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.collectButton.titleLabel.font = LPFFONT(12);
    self.collectButton.status = MoreStyleStatusTop;
    self.collectButton.padding = 2;
    [self addSubview:self.collectButton];
    
    //3.
    self.buyBuyAllMoney = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.buyBuyAllMoney addTarget:self action:@selector(buyBuyAllMoneyAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.buyBuyAllMoney setImage:IMAGECACHE(@"me_05") forState:UIControlStateNormal];
    [self.buyBuyAllMoney setBackgroundImage:IMAGECACHE(@"shangpinxiangqing_04") forState:UIControlStateNormal];
    if (self.viewType == ProductDetailViewBottomToolTypeAccessoriesStore) {
        [self.buyBuyAllMoney setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    if (self.viewType == ProductDetailViewBottomToolTypeCarStore) {
        [self.buyBuyAllMoney setTitle:@"全款购" forState:UIControlStateNormal];
    }
    if (self.viewType == ProductDetailViewBottomToolTypeTruckStore) {
        [self.buyBuyAllMoney setTitle:@"全款购" forState:UIControlStateNormal];
    }
//    [self.buyBuyAllMoney setTitleColor:SMTextColor forState:UIControlStateNormal];
    self.buyBuyAllMoney.titleLabel.font = LPFFONT(13);
    [self addSubview:self.buyBuyAllMoney];
    
    //4.
    self.fenqiButton = [YXDButton buttonWithType:UIButtonTypeCustom];;
    [self.fenqiButton addTarget:self action:@selector(fenqiButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.fenqiButton setImage:IMAGECACHE(@"me_05") forState:UIControlStateNormal];
    [self.fenqiButton setBackgroundImage:IMAGECACHE(@"shangpinxiangqing_05") forState:UIControlStateNormal];
    [self.fenqiButton setTitle:@"立即购买" forState:UIControlStateNormal];
//    [self.fenqiButton setTitleColor:SMTextColor forState:UIControlStateNormal];
    self.fenqiButton.titleLabel.font = LPFFONT(13);
    [self addSubview:self.fenqiButton];

}

- (void)setLayout{
    [self.kefuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 90;
        make.top.bottom.offset = 0;
        make.left.offset = 10;
    }];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset = 0;
        make.left.offset = 5;
    }];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -5;
        make.top.offset = 5;
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -5;
        make.bottom.offset = -5;
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = 0.5;
        make.height.offset = 30;
        make.centerY.offset = 0;
        make.right.equalTo(self.kefuView.mas_right).offset = 1;
    }];
    
    [self.fenqiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -5;
        make.height.offset = 35;
        make.width.offset = 115;
        make.centerY.offset = 0;
    }];
    [self.buyBuyAllMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fenqiButton.mas_left).offset = -5;
        make.height.offset = 35;
        make.width.offset = 100;
        make.centerY.offset = 0;
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 35;
        make.centerY.offset = 0;
        make.right.equalTo(self.buyBuyAllMoney.mas_left).offset = -5;
        make.left.equalTo(self.line.mas_right).offset = 5;
    }];
    
}

- (void)setModel:(CarDetailModel *)model{
    _model = model;
    self.collectButton.selected = model.collectionId.length;
}

- (void)setSchemeListModel:(ProductSchemeListModel *)schemeListModel{
    _schemeListModel = schemeListModel;
    if (schemeListModel.list.count) {
        ProductSchemeModel *model = schemeListModel.list.firstObject;
        //1.设置首付
        CGFloat down_payment = [model.down_payment floatValue];
        //设置押金
        CGFloat yajin = 0.0;
        if ([self.model.price floatValue] <= 100000) {
            yajin = 2000;
        }else if ([self.model.price floatValue] <= 200000){
            yajin = 3000;
        }else if ([self.model.price floatValue] <= 400000){
            yajin = 5000;
        }else{
            yajin = 5000;
        }
        CGFloat real_down_payment = down_payment + [self.model.purchaseTax floatValue] + [self.model.onCards floatValue] + [self.model.poundage floatValue] + yajin;
        [self.fenqiButton setTitle:[NSString stringWithFormat:@"%@开回家",[[NSString stringWithFormat:@"%.2f",real_down_payment] priceWithWan]] forState:UIControlStateNormal];
    }
}

- (void)setAccModel:(AccessoriesStoreDetailModel *)accModel{
    _accModel = accModel;
    self.collectButton.selected = accModel.collectionId.length;
}

- (void)collectButtonAction:(UIButton *)sender{
      [RequestManager collectWithId:self.model.pid andWith:CollectTypeProduct button:sender];
}

- (void)buyBuyAllMoneyAction{
    //1.配件购买
    if (self.viewType == ProductDetailViewBottomToolTypeAccessoriesStore) {
        
        //判断是否满足完整购物条件
        //1.满足直接购买 2.不满足弹出选择参数框
        if (!self.accModel.isReadSelect) {
            if (self.firstButtonBlock) {
                self.firstButtonBlock();
            }
            return;
        }
    }
    //2.汽车的购买
    if (self.viewType == ProductDetailViewBottomToolTypeCarStore || self.viewType == ProductDetailViewBottomToolTypeTruckStore) {
        //分期购买
        ProductBuyDetailController *vc = [ProductBuyDetailController new];
        vc.buyType = BuyTypeAll;
        vc.carDetailModel = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

//第二个按钮执行方法
- (void)fenqiButtonAction{
    //1.配件购买
    if (self.viewType == ProductDetailViewBottomToolTypeAccessoriesStore) {
        //判断是否满足完整购物条件
        //1.满足直接购买 2.不满足弹出选择参数框
//        if (!self.accModel.isReadSelect) {
//
//            return;
//        }
        if (self.secondButtonBlock) {
            self.secondButtonBlock();
        }
    }
    //2.汽车的购买
    if (self.viewType == ProductDetailViewBottomToolTypeCarStore || self.viewType == ProductDetailViewBottomToolTypeTruckStore) {
        //分期购买
        ProductBuyDetailController *vc = [ProductBuyDetailController new];
        vc.buyType = BuyTypeAging;
        vc.carDetailModel = self.model;
        vc.productSchemeListModel = self.schemeListModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)doTapChange:(UITapGestureRecognizer *)sender{
    [[RequestManager sharedInstance] connectWithServer];
}

@end
