//
//  MineCollectionHeaderView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeView.h"
#import "HeaderView.h"
#import "TabListbarView.h"
@interface MineCollectionHeaderView : UICollectionReusableView
@property (nonatomic,strong) ResumeView *resumeView;
@property (nonatomic,strong) HeaderView *headerView;
@property (nonatomic,strong) TabListbarView *tabbarView;
@end
