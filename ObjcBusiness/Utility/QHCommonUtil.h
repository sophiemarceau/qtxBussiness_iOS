//
//  QHCommonUtil.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHCommonUtil : NSObject

//将view转为image
+ (UIImage *)getImageFromView:(UIView *)view;

//获取随机颜色color
+ (UIColor *)getRandomColor;

//根据比例（0...1）在min和max中取值
+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax;
@end
