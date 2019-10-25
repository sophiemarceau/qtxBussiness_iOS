//
//  CommentMethod.h
//  IELTSStudent
//
//  Created by Hello酷狗 on 15/6/5.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentMethod : NSObject

#pragma mark - RGB颜色值
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;

#pragma mark - 解析Json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

#pragma mark 颜色转换为图片
+ (UIImage *) createImageWithColor: (UIColor*) color;

#pragma mark - 处理圆型图片
+ (void) circleImage:(UIImageView *)img;

#pragma mark - 处理圆形按钮
+ (void) circleButton:(UIButton *)buttons;

#pragma mark - 处理圆形图片
+ (void) circleView:(UIView *)view;

#pragma mark - 处理label
+ (void) circleLabel:(UILabel *)view;

#pragma mark --创建Label
+(UILabel*)createLabelWithFont:(int)font Text:(NSString*)text;

+(UILabel*)createLabelWithText:(NSString*)text  TextColor:(UIColor *)textcolor BgColor:(UIColor *)bgColor TextAlignment:(NSTextAlignment)alignment Font:(int )font;

+(UILabel*)initLabelWithText:(NSString*)text textAlignment:(NSTextAlignment)alignment font:(CGFloat)font TextColor:(UIColor *)textColor;

#pragma mark --创建imageView
+(UIImageView *)createImageViewWithImageName:(NSString*)imageName;

#pragma mark --创建button
+(UIButton *)createButtonWithImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title textLabelFont:(NSInteger)font;

#pragma mark  -- 背景图片＋按钮名称
+(UIButton *)createButtonWithBackgroundImage:(UIImage *)image Target:(id)target Action:(SEL)action Title:(NSString*)title textLabelFont:(NSInteger)font;
+(UIButton *)createButtonWithBackgroundColor:(UIColor *)BgColor Target:(id)target Action:(SEL)action Title:(NSString*)title FontColor:(UIColor *)FontColor FontSize:(float)fontsize
;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithPlaceholder:(NSString*)placeholder passWord:(BOOL)YESorNO Font:(float)font;

//+(UITextField *)createTextFieldWithPlaceholder:(NSString*)placeholder Font:(float)font;

+(UITextField *)createTextFieldWithPlaceholder:(NSString*)placeholder TextColor:(UIColor *)textcolor Font:(float)font KeyboardType:(UIKeyboardType)keyboardType;

#pragma mark - 
+(CGSize)widthForNickName:(NSString *)nickName testLablWidth:(NSInteger)width textLabelFont:(NSInteger)font;
+(UIFont *)textLabelFont:(NSInteger)font;
#pragma mark - view 添加虚线边框
+(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
#pragma uitextfield 设置文字的 左边边距
+(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth;
#pragma uitextfield 设置文字的 右边边距
+(void)setTextFieldRightPadding:(UITextField *)textField forWidth:(CGFloat)rightWidth;
//1、判断输入的字符串是否全是中文
+(BOOL)IsChinese:(NSString *)str;
@end
