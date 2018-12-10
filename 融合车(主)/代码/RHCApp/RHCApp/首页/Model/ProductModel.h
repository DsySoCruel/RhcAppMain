//
//  ProductModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/16.
//  1.首页限时秒杀 左右用到

#import "BaseModel.h"

@interface ProductModel : BaseModel
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSString *title;//车型（详细）
@property (nonatomic,strong) NSString *price;//价格(秒杀价,活动价,实际价都是该值,根据不同的活动类型变化名字)
@property (nonatomic,strong) NSString *showstate;//爆款 推荐
@property (nonatomic,strong) NSString *collectionId;//收藏ID,若为null则未收藏
@property (nonatomic,strong) NSString *reference_price;//厂商参考价
@property (nonatomic,strong) NSString *min_down_payment;//最低首付
@property (nonatomic,strong) NSString *inventory;//库存
@property (nonatomic,strong) NSString *img;//图片
@property (nonatomic,strong) NSString *reference_price_max;//价格上限
@property (nonatomic,strong) NSString *reference_price_min;//价格下限

//秒杀缺少
//总量 库存 缺少一个
//型号
//超值优惠 限购几台 （非必须字段）
@property (nonatomic,strong) NSString *aparType;// 5 : 猜你喜欢 ,
@property (nonatomic,strong) NSString *brandName;//车名
@property (nonatomic,strong) NSString *typeName;//车系

//秒杀列表新增
@property (nonatomic,strong) NSString *apinventory;//总库存
@property (nonatomic,strong) NSString *aparinventory;//剩余库存

//list列表独有


//自增 字段 （区别 秒杀 还是 非秒杀 cell 不同）
@property (nonatomic,assign) BOOL isSkill;//是否是秒杀

@end
