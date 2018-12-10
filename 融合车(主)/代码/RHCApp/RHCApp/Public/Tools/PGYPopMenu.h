//
//  PGYPopMenu.h
//  Pugongying
//
//  Created by app on 16/3/15.
//  Copyright © 2016年 新乡市蒲公英网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PGYPopMenu : UIView

/**
 *  创建一个弹出下拉控件
 *
 *  @param frame      尺寸
 *  @param selectData 选择控件的数据源
 *  @param action     点击回调方法
 *  @param animate    是否动画弹出
 */
+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate;
/**
 *  手动隐藏
 */
+ (void)hiden;




@end