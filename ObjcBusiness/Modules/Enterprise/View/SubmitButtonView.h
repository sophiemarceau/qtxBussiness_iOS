//
//  SubmitButtonView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitButtonView : UIView
@property(nonatomic,strong)UIButton *bottomPostButton;

-(instancetype)initWithFrame:(CGRect)frame target:(id)target
                      action:(SEL)action Title:(NSString *)title;
@end
