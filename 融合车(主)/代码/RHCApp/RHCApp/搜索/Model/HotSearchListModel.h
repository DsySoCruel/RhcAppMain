//
//  HotSearchListModel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/11/6.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HotSearchListModel : BaseModel
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *hid;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *note;
@end

NS_ASSUME_NONNULL_END
