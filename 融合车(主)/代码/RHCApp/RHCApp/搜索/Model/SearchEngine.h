//
//  SearchEngine.h
//  RHCApp
//
//  Created by daishaoyang on 2018/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchEngine : NSObject

+ (SearchEngine *)shareInstance;
- (NSMutableArray *)getSearchEngineData;
- (void)addSearchHistory:(NSString *)searchString;
- (void)cleanAllSearchHistory;

@end

NS_ASSUME_NONNULL_END
