//
//  GuidePageView.h
//  RHCApp
//
//  Created by daishaoyang on 2018/9/10.
//

#import <UIKit/UIKit.h>


typedef void(^TapDoneBlock)();

@interface GuidePageView : UIView
@property (nonatomic, copy)   TapDoneBlock doneBlock;
@property (nonatomic, assign) NSInteger pageNumbers;

@end
