//
//  EnterpriseItem.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, EnterpriseShowType) {
    EnterpriseLabel,
    
    EnterpriseTextFieldSendMessage,
    EnterpriseTextViewIntroduce,
    EnterpriseUploadPicture
};
@interface EnterpriseItem : NSObject
@property (nonatomic, assign) EnterpriseShowType showtype;

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) NSString *cellIdentifier;

@property (nonatomic, copy)   NSString *functionValue;
@property (nonatomic, copy)   NSString *placeholder;
@property (nonatomic, assign) Boolean UserInteractive;
@property (nonatomic, assign) Boolean isHiddenLine;
@property (nonatomic, assign) Boolean issetNumberKeyboard;
@end
