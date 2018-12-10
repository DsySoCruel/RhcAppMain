//
//  CircleViewControllerListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

//#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface CircleViewControllerListModel : BaseModel
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *imgs;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *looks;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *headimg;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *showlabel;
@end
