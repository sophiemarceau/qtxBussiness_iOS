//
//  BossProjectListViewController.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"


@interface BossProjectListViewController : BaseViewController{
    
    noContent * nocontent;
}
@property (nonatomic,copy) void(^DidScrollBlock)(CGFloat scrollY);
@property (nonatomic,assign)NSInteger user_id;
@property (nonatomic,strong)NSString *reqeustURLStr;

@end
