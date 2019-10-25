//
//  NetworkManager.m
//  MedicineTrace
//
//  Created by melp on 13-9-18.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import "NetworkManager.h"
//#import "CacheManage.h"

static NetworkManager *_sharedNetworkManager;

@interface NetworkManager ()
@property(nonatomic ,strong) AFHTTPSessionManager *requestManager;
@property (nonatomic) BOOL NetworkStatus;
@end

@implementation NetworkManager
+(NetworkManager*) SharedNetworkManager
{
    static NetworkManager *shareResult;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareResult = [[self alloc]init];
    });
    return shareResult;
}


- (void)requestGetWithParameters:(NSDictionary *)parameters
                                           ApiPath:(NSString*)path
                                        WithHeader:(NSDictionary*)headers
                                          onTarget:(UIViewController *)target
                                           success:(void (^)(NSDictionary *result))success
                                           failure:(void (^)(NSError *error))failure;
{
    //    if(!_NetworkStatus)
    //    {
    //        NSDictionary *cacheData = [[CacheManage SharedCacheManages] CachedResponse:path];
    //        NSString *cached = [cacheData objectForKey:@"cache"];
    //        if([cached isEqualToString:@"YES"])
    //        {
    //            id jObj = [cacheData objectForKey:@"json"];
    //            success(jObj,nil);
    //            return;
    //        }else
    //        {
    //            [[RusultManage shareRusultManage]tipAlert:@"请检查网络状态"];
    //            return;
    //        }
    //    }
    NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    path = [NSString stringWithFormat:@"%@%@",BaseURLString,path];
//    NSLog(@"path-----------%@",path);
    self.requestManager = [AFHTTPSessionManager manager];
    self.requestManager.requestSerializer.timeoutInterval = 45;
    if (headers != nil) {
        self.requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues=YES;
        self.requestManager.responseSerializer = response;
        
        [self.requestManager.requestSerializer setValue:[headers objectForKey:@"Authentication"] forHTTPHeaderField:@"Authentication"];
        //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //    self.requestManager.securityPolicy = securityPolicy;
        //    // 2.设置证书模式
        //    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"admin" ofType:@"cer"];
        //    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
        //    self.requestManager.securityPolicy.pinnedCertificates = [[NSArray alloc] initWithObjects:cerData, nil];
        //    // 客户端是否信任非法证书
        //    self.requestManager.securityPolicy.allowInvalidCertificates = YES;
        //    // 是否在证书域字段中验证域名
        //    [self.requestManager.securityPolicy setValidatesDomainName:NO];
    }

    [self.requestManager GET:path parameters:hrParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

- (void)requestPostWithParameters:(NSDictionary *)parameters
                                              ApiPath:(NSString*)path
                                           WithHeader:(NSDictionary*)headers
                                             onTarget:(UIViewController *)target
                                              success:(void (^)(NSDictionary *result))success
                                              failure:(void (^)(NSError *error))failure
{
    //     if(!_NetworkStatus)
    //     {
    //         NSDictionary *cacheData = [[CacheManage SharedCacheManages] CachedResponse:path];
    //         NSString *cached = [cacheData objectForKey:@"cache"];
    //         if([cached isEqualToString:@"YES"])
    //         {
    //             id jObj = [cacheData objectForKey:@"json"];
    //             success(jObj,nil);
    //             return;
    //         }else
    //         {
    //             [[RusultManage shareRusultManage]tipAlert:@"请检查网络状态"];
    //             return;
    //         }
    //     }
    NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    path = [NSString stringWithFormat:@"%@%@",BaseURLString,path];
    
    
    
//    NSLog(@"path----Post-------%@",path);
    self.requestManager = [AFHTTPSessionManager manager];

    // 设置超时时间
//    [self.requestManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    self.requestManager.requestSerializer.timeoutInterval = 3.0f;
//    [self.requestManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    self.requestManager.securityPolicy = securityPolicy;
//    // 2.设置证书模式
//    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"admin" ofType:@"cer"];
//    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
//    self.requestManager.securityPolicy.pinnedCertificates = [[NSArray alloc] initWithObjects:cerData, nil];
//    // 客户端是否信任非法证书
//    self.requestManager.securityPolicy.allowInvalidCertificates = YES;
//    // 是否在证书域字段中验证域名
//    [self.requestManager.securityPolicy setValidatesDomainName:NO];
    if (headers != nil) {
        self.requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestManager.requestSerializer setValue:[headers objectForKey:@"Authentication"] forHTTPHeaderField:@"Authentication"];
        [self.requestManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    }

    [self.requestManager POST:path parameters:hrParameters progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"上传的进度");
//        NSLog(@"上传的进度--->%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"post请求成功%@", responseObject);
        //缓存数据
        //         [[CacheManage SharedCacheManages] CacheWebAPI:apiPath AndResponse:[operation responseString]];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
//        NSLog(@"post请求失败:%@", error);
        failure(error);
    }];
}



- (void)requestUploadImageWithParameters:(NSDictionary *)parameters
                                                   SendImageData:(NSData *)sendData
                                                    FileName:(NSString *)filename
                                                     ApiPath:(NSString*)path
                                                  WithHeader:(NSDictionary*)headers
                                                    onTarget:(UIViewController *)target
                                                     success:(void (^)(NSDictionary *result))success
                                                     failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *hrParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    path = [NSString stringWithFormat:@"%@%@",BaseURLString,path];
//    NSLog(@"\n\n\n\npath= %@\n\n\n", path);
    
    self.requestManager = [AFHTTPSessionManager manager];
    
    // 设置超时时间
    [self.requestManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestManager.requestSerializer.timeoutInterval = 10.f;
    [self.requestManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                     @"text/html",
                                                                     @"image/jpeg",
                                                                     @"image/png",
                                                                     @"application/octet-stream",
                                                                     @"text/json",
                                                                     nil];
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    self.requestManager.securityPolicy = securityPolicy;
    //    // 2.设置证书模式
    //    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"admin" ofType:@"cer"];
    //    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    //    self.requestManager.securityPolicy.pinnedCertificates = [[NSArray alloc] initWithObjects:cerData, nil];
    //    // 客户端是否信任非法证书
    //    self.requestManager.securityPolicy.allowInvalidCertificates = YES;
    //    // 是否在证书域字段中验证域名
    //    [self.requestManager.securityPolicy setValidatesDomainName:NO];
    if (headers != nil) {
        self.requestManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues=YES;
        self.requestManager.responseSerializer = response;
        [self.requestManager.requestSerializer setValue:[headers objectForKey:@"qtx_auth"] forHTTPHeaderField:@"Authentication"];
        [self.requestManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        
    }

    [self.requestManager POST:path parameters:hrParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传的参数(上传图片，以文件流的格式)
        if (sendData != nil) {
            [formData appendPartWithFileData:sendData name:@"upload_file" fileName:filename mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);

    }];
}


- (void)monitorNetwork
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable ||
            status ==AFNetworkReachabilityStatusUnknown) {
            //没网
            [RequestManager shareRequestManager].hasNetWork = NO;
            _NetworkStatus = NO;
//            UIViewController *keyWindow =[UIApplication sharedApplication].keyWindow.rootViewController;
//            [keyWindow showHint:@"请检测网络状态"];
        }else{
            //有网
//            UIViewController *keyWindow =[UIApplication sharedApplication].keyWindow.rootViewController;
            [RequestManager shareRequestManager].hasNetWork = YES;
            _NetworkStatus = YES;
//            [keyWindow showHint:@"网络连接正常"];
        }
    }];
}

- (void)cancelAllRequest
{
    [self.requestManager.operationQueue cancelAllOperations];
}
@end
