//
//  SearchEngine.m
//  RHCApp
//
//  Created by daishaoyang on 2018/11/6.
//

#import "SearchEngine.h"


@interface SearchEngine ()
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSMutableArray *keywordsArray;
@end

@implementation SearchEngine

- (NSMutableArray *)keywordsArray{
    if (!_keywordsArray) {
        _keywordsArray = [NSMutableArray array];
    }
    return _keywordsArray;
}

+ (SearchEngine *)shareInstance {
    static SearchEngine *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSMutableArray *)getSearchEngineData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取沙盒路径下的document进行归档
    //获取地址
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentPath stringByAppendingPathComponent:@"serchKeyword.plist"];
    BOOL result = [fileManager fileExistsAtPath:path];
    if (!result) {
        //不包含
        NSString *path1 = [documentPath stringByAppendingPathComponent:@"serchKeyword.plist"];
        self.filePath = path1;
        return [NSMutableArray array];
    } else {
        //包含
        self.filePath = path;
        [self.keywordsArray removeAllObjects];
        [self.keywordsArray addObjectsFromArray:[NSMutableArray arrayWithContentsOfFile:self.filePath]];
        return self.keywordsArray;
    }
}

- (void)addSearchHistory:(NSString *)searchString{
    if(![self.keywordsArray containsObject:searchString]) {
        [self.keywordsArray addObject:searchString];
        /**
         *  超过五条删除
         */
        if (self.keywordsArray.count > 5) {
            [self.keywordsArray removeObjectAtIndex:0];
        }
        [self.keywordsArray writeToFile:self.filePath atomically:YES];
        [self.keywordsArray writeToFile:self.filePath atomically:YES];
    }
}
- (void)cleanAllSearchHistory{
    [self.keywordsArray removeAllObjects];
    [self.keywordsArray writeToFile:self.filePath atomically:YES];
}

//===========数据持久化================
//- (void)_writeStringToFile {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //获取沙盒路径下的document进行归档
//    //获取地址
//    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *path = [documentPath stringByAppendingPathComponent:@"serchKeyword.plist"];
//    BOOL result = [fileManager fileExistsAtPath:path];
//    if (!result) {
//        //不包含
//        NSString *path1 = [documentPath stringByAppendingPathComponent:@"serchKeyword.plist"];
//        self.filePath = path1;
//    } else {
//        //包含
//        self.filePath = path;
//        self.keywordsArray = [NSMutableArray arrayWithContentsOfFile:self.filePath];
//    }
//}

@end
