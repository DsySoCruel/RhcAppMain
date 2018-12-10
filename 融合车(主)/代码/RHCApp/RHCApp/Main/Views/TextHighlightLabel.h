//
//  TextHighlightLabel.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import <UIKit/UIKit.h>

@interface TextHighlightLabel : UILabel
/**
 新增关键字自动匹配高亮（根据关键字两边的<#@>关键字<**>来确认）
 @param text 原text
 */
- (void)setAttributedTextAuto:(NSString *)text withHighFont:(UIFont *)font;
@end
