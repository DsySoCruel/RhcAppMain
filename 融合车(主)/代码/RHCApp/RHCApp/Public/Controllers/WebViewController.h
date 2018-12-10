//
//  WebViewController.h
//  RHCApp
//
//  Created by daishaoyang on 2018/10/12.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : BaseViewController
- (void)loadWebWithUrl:(NSString *)url;
- (void)loadWebWithHtml:(NSString *)html;

@end

NS_ASSUME_NONNULL_END
