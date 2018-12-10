//
//  SearchInfoHeaderView.h
//  Scimall
//
//  Created by Draven on 2017/7/14.
//  Copyright © 2017年 贾培军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchInfoHeaderView : UICollectionReusableView
@property (nonatomic,strong) id data;
@property (nonatomic,assign) NSInteger section;
- (void)loadHeadDataSource:(NSString *)text;
- (void)setHeaderBackgroundColor:(UIColor *)color;
- (void)didSelectedTapBlock:(void(^)(id obj,NSInteger section))tapAction;
@end
