//
//  MyHeaderUserInfoView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/6/25.
//

#import <UIKit/UIKit.h>
typedef void(^ModifyUserInfoBlock)(void);

@interface MyHeaderUserInfoView : UIView
@property (nonatomic, copy) ModifyUserInfoBlock modifyInfoBlock;
-(void)setCellWithUserModel:(YXDUserInfoModel *)model;//登录成功
-(void)quitSuccess;
- (void)adustHeaderView:(CGFloat)offset;
@end
