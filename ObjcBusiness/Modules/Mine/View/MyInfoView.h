//
//  MyInfoView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoView : UIView
@property(nonatomic,strong)UILabel *expertLabel;
@property(nonatomic,strong)UILabel *jobLabel;

-(void)addExpertString:(NSString *)expertString addJobIdentify:(NSString *)jobStr;
@end
