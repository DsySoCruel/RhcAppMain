//
//  MyCollectListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/3.
//

#import "BaseModel.h"

@interface MyCollectListModel : BaseModel
//公用
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *create_time;

//咨询
@property (nonatomic,strong) NSString *showtype1;
@property (nonatomic,strong) NSString *aicreateTime;
@property (nonatomic,strong) NSString *browse_number;

//汽车
@property (nonatomic,strong) NSString *reference_price;
@property (nonatomic,strong) NSString *brandName;
@property (nonatomic,strong) NSString *typeName;

//配件
@property (nonatomic,strong) NSString *price;

@end
