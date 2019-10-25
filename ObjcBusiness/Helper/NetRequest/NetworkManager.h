//
//  NetworkManager.h
//  MedicineTrace
//
//  Created by sophiemarceau_qu on 13-9-18.
//  Copyright (c) 2013年 pfizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface NetworkManager : NSObject
@property (nonatomic,assign) BOOL hasNetWork;

+(NetworkManager*) SharedNetworkManager;

- (void)cancelAllRequest;

- (void)monitorNetwork;

- (void)requestGetWithParameters:(NSDictionary *)parameters
                        ApiPath:(NSString*)path
                        WithHeader:(NSDictionary*)headers
                        onTarget:(UIViewController *)target
                        success:(void (^)(NSDictionary *result))success
                        failure:(void (^)(NSError *error))failure;

- (void)requestPostWithParameters:(NSDictionary *)parameters
                         ApiPath:(NSString*)path
                      WithHeader:(NSDictionary*)headers
                        onTarget:(UIViewController *)target
                         success:(void (^)(NSDictionary *result))success
                         failure:(void (^)(NSError *error))failure;

- (void)requestUploadImageWithParameters:(NSDictionary *)parameters
                                               SendImageData:(NSData *)sendData
                                                    FileName:(NSString *)filename
                                                     ApiPath:(NSString*)path
                                                  WithHeader:(NSDictionary*)headers
                                                    onTarget:(UIViewController *)target
                                                     success:(void (^)(NSDictionary *result))success
                                                     failure:(void (^)(NSError *error))failure;

@end
