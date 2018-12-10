//
//  MessageListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/24.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListDetailModel : BaseModel

@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *mid;
@property (nonatomic,strong) NSString *update_time;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *create_time;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *orderId;

@end

@interface MessageListModel : BaseModel

//PreferentialActivities 优惠活动、 type = 2
//CarCircleInteraction 车圈互动、 type = 4
//OrderFeedback 订单反馈 、 type = 4
//SystemNotificatio 系统通知 type = 1
@property (nonatomic,strong) MessageListDetailModel *PreferentialActivities;
@property (nonatomic,strong) MessageListDetailModel *CarCircleInteraction;
@property (nonatomic,strong) MessageListDetailModel *OrderFeedback;
@property (nonatomic,strong) MessageListDetailModel *SystemNotificatio;

@end


NS_ASSUME_NONNULL_END
