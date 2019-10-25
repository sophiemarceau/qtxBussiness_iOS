//
//  CreateProjectViewController.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,ViewType) {
    CreateProject = 0,
    EditProject,
};
@interface CreateProjectViewController : BaseViewController
@property (nonatomic,assign) ViewType viewType;
@end
