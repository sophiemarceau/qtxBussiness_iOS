//
//  EnterpriseItem.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EnterpriseItem.h"
#import "EnterpriseInfoCell.h"
#import "EnterpriseUploadPictureCell.h"
#import "EnterpriseTextViewIntroduceCell.h"
#import "EnterpriseTextFieldSendMessageCell.h"
@implementation EnterpriseItem
- (NSString *)cellIdentifier
{

    if (_showtype == EnterpriseLabel) {
        return NSStringFromClass([EnterpriseInfoCell class]);
    }else if (_showtype == EnterpriseTextFieldSendMessage){
        return NSStringFromClass([EnterpriseTextFieldSendMessageCell class]);
    }else if(_showtype == EnterpriseTextViewIntroduce){
        return NSStringFromClass([EnterpriseTextViewIntroduceCell class]);
    }else {
        return NSStringFromClass([EnterpriseUploadPictureCell class]);
    }
}
@end
