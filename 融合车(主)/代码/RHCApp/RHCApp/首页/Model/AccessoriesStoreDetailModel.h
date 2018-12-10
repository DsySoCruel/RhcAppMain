//
//  AccessoriesStoreDetailModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/4.
//

#import "BaseModel.h"

@interface AccessoriesStoreDetailModel : BaseModel
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *title;//标题
@property (nonatomic,strong) NSString *price;//真实价格
@property (nonatomic,strong) NSString *commentCount;
@property (nonatomic,strong) NSString *collectionId;
@property (nonatomic,strong) NSString *orderCount;//库存数量

@property (nonatomic,strong) NSArray  *imgList;//图片数组
@property (nonatomic,strong) NSArray  *colorList;//
@property (nonatomic,strong) NSArray  *styleList;//

@property (nonatomic,assign) NSInteger selectNum;//选中的数量（默认为1） 自增
@property (nonatomic,assign) BOOL      isReadSelect;//是否符合选中的标准 自增
@end

//参数数据（颜色）
@interface ColorModel : BaseModel
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) BOOL     isSelect;//有没有选中 自增
@end
//参数数据（型号）
@interface StyleModel : BaseModel
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *style;
@property (nonatomic,assign) BOOL     isSelect;//有没有选中 自增
@end

//图片数据
@interface ImgModel : BaseModel
@property (nonatomic,strong) NSString *url;
@end
