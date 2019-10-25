//
//  ScanView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanView : UIView
-(id)initWithFrame: (CGRect)frame rectSize: (CGSize)size offsetY: (CGFloat)offsetY;
-(void)startAnimation;
-(void)stopAnimation;
@end
