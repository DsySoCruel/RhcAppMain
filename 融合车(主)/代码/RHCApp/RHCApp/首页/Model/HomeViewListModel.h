//
//  HomeViewListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/19.
//

#import "BaseModel.h"
@interface HomeViewListSmall : BaseModel
@property (nonatomic,strong) NSString *reference_price;
@property (nonatomic,strong) NSString *collectionId;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *reference_price_max;
@property (nonatomic,strong) NSString *reference_price_min;
@property (nonatomic,strong) NSString *aparType;
@property (nonatomic,strong) NSString *brandName;
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *hid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *showstate;
@property (nonatomic,strong) NSString *min_down_payment;
@property (nonatomic,strong) NSString *inventory;
@end

@interface HomeViewListModel : BaseModel
@property (nonatomic,strong) NSString *userID;//userID 有值是车圈 发现  否则是发现
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *cover_url;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *headimg;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *showtype;//购车攻略 爆款推荐 等类别
@property (nonatomic,strong) NSString *browse_number;//观看数
@property (nonatomic,strong) NSString *count;//回帖数
@property (nonatomic,strong) NSString *showway;//1小图2大图3没图
@property (nonatomic,strong) NSString *hid;//
@property (nonatomic,strong) NSArray  *list;//品牌专用
@property (nonatomic,strong) NSString *brand;//品牌专用
@end

@interface HomeViewListBigModel : BaseModel
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) HomeViewListModel *data;
@end
