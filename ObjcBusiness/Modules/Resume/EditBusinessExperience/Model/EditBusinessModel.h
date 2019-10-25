//
//  EditBusinessModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditBusinessModel : NSObject
@property(nonatomic,strong)NSString *functionnameStr;
@property(nonatomic,copy)NSString *placenameStr;

@property(nonatomic,copy)NSString *contentStr;

@property(nonatomic,assign)BOOL isEditTextField;//0不可以 1可以

@end
