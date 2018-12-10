//
//  NetWorkManager.m
//  YXDApp
//
//  Created by daishaoyang on 2017/12/8.
//  Copyright © 2017年 beijixing. All rights reserved.
//

#import "NetWorkManager.h"
#import "LoginViewController.h"

static NetWorkManager * _manager = nil;

@implementation NetWorkManager{
    AFHTTPSessionManager *_sessionManager;
}

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (id)init {
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc] init];
//        _sessionManager.responseSerializer  = [AFJSONResponseSerializer serializer];
//        _sessionManager.requestSerializer.timeoutInterval = 60;
        // 设置请求格式
//        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回格式
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

/**
 *  get请求
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters successed:(void (^)(id json))succeed failure:(void (^)(NSError *error))failure {
    
    
    [_sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (succeed) {
            succeed(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (failure) {
            failure(error);
        }
        [self alertTitleWith:error];
        [MBHUDHelper hideHUDView];
    }];
}
/**
 *  post请求
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters successed:(void (^)(id json))succeed failure:(void (^)(NSError *error))failure {
    [_sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [MBHUDHelper hideHUDView];
        if (succeed) {
//            NSDictionary *resultDic = dic[@"result"];
            if ([dic[@"status"] integerValue] == 0) {
//                if (dic[@"accessToken"]) {
//                    [[NSUserDefaults standardUserDefaults] setValue:dic[@"accessToken"] forKey:@"accessToken"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                }
                succeed(dic[@"data"]);
            }else{
                //判断是不是账户被顶掉的可能 code == 605
                if ([dic[@"code"] integerValue] == 605) {
//                    //1.清除数据
//                    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"userInfoKey"];
//                    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"accessToken"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//                    //2.更新我的界面（发通知）
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyUI" object:nil];
//                    //3.弹出登录框
//                    [[BaseViewController topViewController] presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
                    return ;
                }
                succeed(nil);
                if (dic[@"msg"]) {
                    [MBHUDHelper showWarningWithText:dic[@"msg"]];
                }else{
                    [MBHUDHelper showWarningWithText:@"网络错误,请稍后重试"];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        [MBHUDHelper hideHUDView];
        
        [self alertTitleWith:error];
    }];
    
}

- (void)alertTitleWith:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBHUDHelper hideHUDView];
    });
    
    if (error.code==-999) {
        //主动取消请求
    } else if (error.code==-1001) {
        // 请求超时
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBHUDHelper showWarningWithText:@"请求超时,请稍后重试"];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![YXDUserInfoStore sharedInstance].loginStatus) {
                [[BaseViewController topViewController].navigationController popViewControllerAnimated:YES];
                [[BaseViewController topViewController] presentViewController:[LoginViewController shareLoginVC] animated:YES completion:nil];
            }else{
                [MBHUDHelper showWarningWithText:@"网络异常"];
            }
        });
    }
}

/** post上传 图片 视频 文件 */
- (void)postFileWithUrl:(NSString *)URLString parameters:(id)parameters formDataArray:(NSArray *)formDataArray succssed:(void (^)(id))secceed failure:(void (^)(NSError *))failure uploadProgressBlock:(void (^)(float))uploadProgressBlock {
    
    
    [_sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull totalFormData) {
        // 拼接data到请求体， 这个block的参数是遵守AFMultipartFormData协议的。
        for (YXDFormData *formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        uploadProgressBlock(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功  解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        secceed(dict[@"data"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        if (failure) {
            failure(error);
        }
        
        [self alertTitleWith:error];
    }];
}

- (void)cancelCurrentRequest {
    [_sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

/** 网络状态 */
+ (void)networkReachabilityStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
            default:
                break;
        }
    }];
    [manager stopMonitoring];
    
}


- (void)downloadFileWithUrl:(NSString *)url successed:(void (^)(id filePath))succeed{
    __block NSString *file = @"";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //进度回调 downloadProgress
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //回调(目标位置) 有返回值 targetPath:临时文件路径 response:响应头信息
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        file = fullPath;
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        succeed(filePath);
        //下载完成之后 filePath:最终的文件路径
        NSLog(@"%@",filePath);
    }];
    //3.执行Task
    [downloadTask resume];
}

@end

@implementation YXDFormData



@end
