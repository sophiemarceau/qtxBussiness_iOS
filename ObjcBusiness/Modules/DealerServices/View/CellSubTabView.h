//
//  CellSubTabView.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/8/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceViewModel.h"

@interface CellSubTabView : UIView
-(instancetype)initWithTabConfigArray:(NSArray *)tabConfigArray;//tab页配置数组


-(void)setWithViewMoel:(ServiceViewModel *)viewModel WithSuperViewController:(UIViewController *)vc;
@end
