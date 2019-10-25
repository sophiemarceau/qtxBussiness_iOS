//
//  AddPolicyViewController.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
@protocol  SelectComingPolicyDelegate<NSObject>
- (void)SelectComingPolicyDelegateReturnPage:(NSDictionary *)returnDictionary;
@end
@interface AddPolicyViewController : BaseViewController
@property (nonatomic, weak)id <SelectComingPolicyDelegate>delegate;
@property (nonatomic,strong)NSDictionary *cooperDic;
@end
