//
//  ServiceViewModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/2.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//


#import "CyclePictureModel.h"
#import "HomeListModel.h"

#import "BaseViewModel.h"

@interface ServiceViewModel : BaseViewModel

//@property (strong,nonatomic) ServiceModel *serviceModel;


- (void)cyclleViewList;

- (void)getServiceList;
@end
