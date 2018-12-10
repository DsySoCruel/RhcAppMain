//
//  OrganizationTagsView.h
//  Scimall
//
//  Created by daishaoyang on 2018/6/20.
//  Copyright © 2018年 贾培军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationTagsView : UIView
- (void)config:(NSArray *)itemArray;
+ (CGFloat)cellHeightWithArray:(NSArray *)itemArray;
@property (nonatomic, copy) void(^deleteTagsBlock)(NSString *tagsName);//删除选中的tag
@property (nonatomic, copy) void(^deleteAllBlock)(void);//删除全部tag
@end
