//
//  FindViewListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/19.
//

#import "BaseModel.h"

@interface FindViewListModel : BaseModel
@property (nonatomic,strong) NSString *showtype1;//类别
@property (nonatomic,strong) NSString *fid;//
@property (nonatomic,strong) NSString *title;//
@property (nonatomic,strong) NSString *cover_url;//
@property (nonatomic,strong) NSString *collectionId;//
@property (nonatomic,strong) NSString *create_time;//
@property (nonatomic,strong) NSString *showway;//1小图2大图3没图
@property (nonatomic,strong) NSString *browse_number;//
@property (nonatomic,strong) NSString *comment_number;//

@end
