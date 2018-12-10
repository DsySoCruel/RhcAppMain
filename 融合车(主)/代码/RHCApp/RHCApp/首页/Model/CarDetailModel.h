//
//  CarDetailModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/2.
//  车辆详情

#import "BaseModel.h"
@class CarDetailModel;

@interface CarModel : BaseModel //汽车详情大model
@property (nonatomic,strong) CarDetailModel *product;
@property (nonatomic,strong) NSArray  *purchaseNotes;//
@property (nonatomic,strong) NSArray  *purchaseThree;//
@property (nonatomic,strong) NSArray  *lookproduct;//
@end

@interface CarDetailModel : BaseModel
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *claz;
@property (nonatomic,strong) NSString *countDown;
@property (nonatomic,strong) NSString *collectionId;
@property (nonatomic,strong) NSString *reference_price;//厂商参考价
@property (nonatomic,strong) NSString *reference_price_max;//价格上限
@property (nonatomic,strong) NSString *reference_price_min;//价格下限
@property (nonatomic,strong) NSString *commentCount;
@property (nonatomic,strong) NSString *brandName;//品牌名称
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSString *title;//标题
@property (nonatomic,strong) NSString *price;//真实价格
@property (nonatomic,strong) NSString *inventory;//总库存

@property (nonatomic,strong) NSString *down_payment;//最低首付-------
@property (nonatomic,strong) NSString *poundage;//手续费------
@property (nonatomic,strong) NSString *onCards;//上牌费------300
@property (nonatomic,strong) NSString *purchaseTax;//购置税------对的


@property (nonatomic,strong) NSArray  *priceList;//
@property (nonatomic,strong) NSArray  *colortList;//
@property (nonatomic,strong) NSArray  *orderList;//
@property (nonatomic,strong) NSArray  *configList;//参数数组
@property (nonatomic,strong) NSArray  *inColorList;
@property (nonatomic,strong) NSArray  *imgList;//图片数组

@end

//参数数据
@interface ParamesModel : BaseModel
@property (nonatomic,strong) NSString *value;
@property (nonatomic,strong) NSString *key;
@end
//图片数据
@interface ImgListModel : BaseModel
@property (nonatomic,strong) NSString *url;
@end

//车身颜色 | 内饰 数据
@interface InColorModel : BaseModel
@property (nonatomic,strong) NSString *icid;
@property (nonatomic,strong) NSString *color;
@end


//购车须知
@interface PurchaseNotesModel : BaseModel
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *type;//type = 1 : 有链接   type = 2 : 无连接
@property (nonatomic,strong) NSString *urlname;
@property (nonatomic,strong) NSString *url;
@end


//购车三步
@interface PurchaseThreeModel : BaseModel
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *remark;
@end

