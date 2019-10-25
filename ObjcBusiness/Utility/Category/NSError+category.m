//  Created by Zing on 2/6/15.
//  Copyright (c) 2015 Zing. All rights reserved.
//

#import "NSError+category.h"

@implementation NSError (category)


-(NSString *)networkErrorInfo
{
    NSString * errorMsg = @"网络异常,请检查网络";
    switch ([self code])
    {
            
        case NSURLErrorCancelled:
            errorMsg = @"网络请求已经取消";
            break;
        case  NSURLErrorTimedOut:
            errorMsg = @"网络请求超时";
            break;
        case NSURLErrorBadServerResponse:
            errorMsg = @"数据服务暂不可用,请稍后再试";
            break;
//        case NSURLErrorCannotFindHost://主机名时返回一个URL不能解决
//            
//            break;
//        case NSURLErrorCannotConnectToHost://当试图连接到主机返回失败了。这可能发生在一个主机名解析,但主机或可能不会接受特定端口上的连接。
//            
//            break;
        case NSURLErrorNotConnectedToInternet:
            errorMsg = @"网络不可用,请检查网络";
            break;

        default:
            errorMsg = @"网络异常,请检查网络";
            break;
    }
    return errorMsg;
}

@end
