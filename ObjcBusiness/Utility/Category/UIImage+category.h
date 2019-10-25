//
//  UIImage+category.h
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface UIImage (category)

//转灰度图片
- (UIImage *)imageWithGrayScaleImage:(UIImage *)inputImg;
+ (UIImage *)createImageWithBgColor:(UIColor *)color size:(CGSize)size cornerRadius:(float)corner;
//图片压缩
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;


//模糊
- (UIImage*)gaussBlur:(CGFloat)blurLevel;

+ (void)saveImageToAlbum:(UIImage *)image;

@end
