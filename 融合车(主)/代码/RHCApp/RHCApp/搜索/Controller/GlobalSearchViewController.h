//
//  GlobalSearchViewController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/11/5.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,GlobalSearchType) {
    GlobalSearchTypeProduct ,//产品
    GlobalSearchTypeNews,//资讯
};


NS_ASSUME_NONNULL_BEGIN

@interface GlobalSearchViewController : BaseViewController
@property (nonatomic,assign) GlobalSearchType globalSearchType;
@end

NS_ASSUME_NONNULL_END
