//
//  BaseViewModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/2.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewModel.h"



@implementation BaseViewModel

#pragma 接收传过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
}

@end
