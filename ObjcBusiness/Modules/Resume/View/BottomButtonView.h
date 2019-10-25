//
//  BottomButtonView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomButtonView : UIView

@property(nonatomic,strong)UIButton *bottomPostButton;

-(instancetype)initWithFrame:(CGRect)frame target:(id)target
                      action:(SEL)action Title:(NSString *)title;
@end
