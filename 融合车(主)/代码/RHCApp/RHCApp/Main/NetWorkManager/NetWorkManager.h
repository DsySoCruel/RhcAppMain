//
//  NetWorkManager.h
//  YXDApp
//
//  Created by daishaoyang on 2017/12/8.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@interface NetWorkManager : NSObject

+ (instancetype)shareManager;

/** get */
- (void)GET:(NSString *)URLString parameters:(id)parameters successed:(void (^)(id json))succeed failure:(void (^)(NSError *error))failure;

/** post */
- (void)POST:(NSString *)URLString parameters:(id)parameters successed:(void (^)(id json))succeed failure:(void (^)(NSError *error))failure;

/** 文件上传 post */
- (void)postFileWithUrl:(NSString *)URLString parameters:(id)parameters formDataArray:(NSArray *)formDataArray succssed:(void (^)(id json))secceed failure:(void (^)(NSError *error))failure uploadProgressBlock:(void(^)(float uploadProgress))uploadProgressBlock;

/** 下载附件 */
- (void)downloadFileWithUrl:(NSString *)url successed:(void (^)(id filePath))succeed;

/** 取消当前请求 */
- (void)cancelCurrentRequest;

@end

@interface YXDFormData : NSObject

/** 文件数据流 */
@property (nonatomic ,strong) NSData    *data;
/** 参数名 */
@property (nonatomic ,copy)   NSString  *name;
/** 文件名 */
@property (nonatomic ,copy)   NSString  *filename;
/** 文件类型 */
@property (nonatomic ,copy)   NSString  *mimeType;

@end

