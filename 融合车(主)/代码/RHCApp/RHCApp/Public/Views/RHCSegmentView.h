//
//  RHCSegmentView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/22.
//

#import <UIKit/UIKit.h>

@interface RHCSegmentView : UIView

//设置segment是否禁止点击
@property (nonatomic, assign) BOOL isneedForbidClick;//写在数组前边

@property (nonatomic, assign) CGFloat segTitleFont;//字号设置 默认18

@property (nonatomic, strong) UIColor *unselectColor;//未选中颜色 默认灰色
//是否需要底部的分隔线
@property (nonatomic, assign) BOOL needBlackLine;
//是否要下划线(默认要)
@property (nonatomic, assign) BOOL needHideBottomLine;//默认NO 不隐藏
//下划线的宽度
@property (nonatomic, assign) CGFloat blackLineWidth;
//下划线的高度
@property (nonatomic, assign) CGFloat blackLineHight;
//下划线到底部的距离
@property (nonatomic, assign) CGFloat blackLineToBottom;
//button中间是否需要分割线
@property (nonatomic, assign) BOOL needSeparatorLine;//默认NO
//提供的标题数组
@property (nonatomic ,strong) NSArray *titles;
//外部接收改变
@property (nonatomic, copy) void (^didSelectedAtIndex)(NSInteger index);
//内部介绍改变
- (void)changeSegmentedControlWithIndex:(NSInteger)index;

@end
