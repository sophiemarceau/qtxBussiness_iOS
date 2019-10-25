//
//  NSString+textStringToSize.m
//  logisticsInfo
//
//  Created by My Mac on 2017/6/8.
//  Copyright © 2017年 MyMac. All rights reserved.
//

#import "NSString+textStringToSize.h"

@implementation NSString (textStringToSize)

//对象方法
-(CGSize) sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont *)font{
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    //属性字典根据字体大小
//
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paraStyle.alignment = NSTextAlignmentLeft;
//
//    NSDictionary *dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,
//                          };
//
    //The specified origin is the line fragment origin, not the base line origin
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,
                          };
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:dict context:nil].size;
//    UILabel *test = [[UILabel alloc] init];
//    test.font = font;
//    test.textAlignment = NSTextAlignmentLeft;
//    test.lineBreakMode = NSLineBreakByWordWrapping
    
    
    return size;
}
//类方法
+(CGSize) sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    return [text sizeOfTextWithMaxSize:maxSize font:font];
}


@end
