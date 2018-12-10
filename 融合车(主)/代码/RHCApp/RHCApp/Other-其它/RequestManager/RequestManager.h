//
//  RequestManager.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/24.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>

typedef void (^CollectResultBlock)(void);

//收藏的类型
typedef NS_ENUM(NSInteger, CollectType) {
    CollectTypeAccessories = 0,//汽配
    CollectTypeProduct = 1,//商品
    CollectTypeArticle = 2,//文章
};

@interface RequestManager : NSObject
+ (RequestManager *)sharedInstance;

//1.收藏 //2.取消收藏
+ (void)collectWithId:(NSString *)cid andWith:(CollectType)type button:(UIButton *)button;
//用于收藏列表的取消
+ (void)collectWithId:(NSString *)cid andWith:(NSString *)type collectResultBlock:(CollectResultBlock)collectResultBlock;

//+ (void)collectWithId:(NSString *)cid button:(UIButton *)button; attentionResultBlock:(AttentionResultBlock)attentionResultBlock;

//咨询客服
- (void)connectWithServer;

//进行分享
- (void)shareActionwith:(UMShareWebpageObject *)UMShareWebpageObject;



@end
