//
//  UserVCNaviView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/8/15.
//

#import <UIKit/UIKit.h>

@interface UserVCNaviView : UIView
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) NSString *titleStr;
- (void)changeAlphaWithOffset:(CGFloat)offset;
@end
