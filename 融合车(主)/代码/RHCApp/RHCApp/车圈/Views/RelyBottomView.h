//
//  RelyBottomView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CommentRequestType) {
    CommentRequestTypeCircle,//车圈
    CommentRequestTypeNews,//咨询
};

@interface RelyBottomView : UIView

- (instancetype)initDetailBottomView;//详情里 的bottomView

//数据交互类型
@property (nonatomic, assign) CommentRequestType requsetType;

@property (nonatomic, strong) NSString *mainId;//需要评论的id

//1.键盘弹起
- (void)keyBoardWillShow;
//2.键盘收回
- (void)keyBoardWillHide;

/**
 评论 || 回复 完成回调
 */
@property (nonatomic, copy) void (^requestCompletionBlock) (void);

@end
