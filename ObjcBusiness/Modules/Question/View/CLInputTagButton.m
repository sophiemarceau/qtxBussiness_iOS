//
//  CLInputTagButton.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CLInputTagButton.h"
#import "CLTools.h"
@implementation CLInputTagButton {
    UIMenuController *_menuController;
}

- (instancetype)initWithTextField:(UITextField *)textField {
    if (self = [super initWithFrame:textField.frame]) {
        [self initializeAttributeWithTextField:textField];
    }
    return self;
}

- (void)initializeAttributeWithTextField:(UITextField *)textField {
    [self setTitle:textField.text forState:UIControlStateNormal];
    
    [self setTitleColor:kCLTag_Normal_TextColor forState:UIControlStateNormal];
    [self setTitleColor:kCLTag_Selected_TextColor forState:UIControlStateSelected];
    
    [self attributeRadius:textField.layer.cornerRadius borderWidth:kCLDashesBorderWidth borderColor:kCLTag_Normal_BorderColor contentMode:UIViewContentModeCenter font:textField.font];
    [self addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

+ (instancetype)initWithTagDesc:(NSString *)tagStr {
    CLInputTagButton *tagBtn = [[CLInputTagButton alloc] init];
    [tagBtn setTitle:tagStr forState:UIControlStateNormal];
    [tagBtn setTitleColor:kCLRecentTag_Normal_TextColor forState:UIControlStateNormal];
    tagBtn.titleLabel.font = [UIFont systemFontOfSize:kCLTagFont];
    
    CGSize size = [tagStr sizeWithAttributes:@{NSFontAttributeName:tagBtn.titleLabel.font}];
    
    CGFloat height = size.height + kCLTextFieldGap;
    [tagBtn attributeRadius:[CLTools sharedTools].cornerRadius borderWidth:kCLDashesBorderWidth borderColor:kCLRecentTag_Normal_BorderColor contentMode:UIViewContentModeCenter font:tagBtn.titleLabel.font];
    CGFloat width = size.width + height;
    tagBtn.frame = CGRectMake(kCLTagViewHorizontaGap, kCLDistance, width, height);
    [tagBtn addTarget:tagBtn action:@selector(recentTagClick:) forControlEvents:UIControlEventTouchUpInside];
    return tagBtn;
}

- (void)attributeRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor contentMode:(UIViewContentMode)contentMode font:(UIFont *)font{
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.titleLabel.contentMode = contentMode;
    self.titleLabel.font = font;
}
@end
