//
//  CircleCommendModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import "BaseModel.h"

@interface CircleCommendModel : BaseModel
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *reply_user_id;
@property (nonatomic,strong) NSString *headimg;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *user_id;

@end
