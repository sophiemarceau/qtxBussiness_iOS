//
//  BaseViewModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/2.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ResopnseFlagState) {
    ResponseFailure,
    ResponseSuccess,
};
//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue,ResopnseFlagState returnFlag);
typedef void (^ErrorCodeBlock) (id errorCode);
@interface BaseViewModel : NSObject

@property (strong, nonatomic) ReturnValueBlock returnBlock;
@property (strong, nonatomic) ErrorCodeBlock errorBlock;


// 传入交互的Block块
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock;

@end
