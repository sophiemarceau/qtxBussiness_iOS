//
//  MMDropDownBox.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMDropDownBox.h"
#import "MMComboBoxHeader.h"
@interface MMDropDownBox ()

@end

@implementation MMDropDownBox
- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.isSelected = NO;
        self.userInteractionEnabled = YES;
        
        //add recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapAction:)];
        [self addGestureRecognizer:tap];
        
        //add subView
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar_icon_down-1"]];
        self.arrow.frame = CGRectMake(self.width - ArrowSide - ArrowToRight,(self.height - 4*AUTO_SIZE_SCALE_X)/2  , 6*AUTO_SIZE_SCALE_X , 4*AUTO_SIZE_SCALE_X);
//        self.arrow.frame = CGRectMake(self.width - ArrowSide - ArrowToRight,(self.height - Arrowheight*AUTO_SIZE_SCALE_X)/2  , ArrowSide*AUTO_SIZE_SCALE_X , Arrowheight*AUTO_SIZE_SCALE_X);
        [self addSubview:self.arrow];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:DropDownBoxFontSize];
        self.titleLabel.text = self.title;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.textColor = FontUIColorBlack;
        self.titleLabel.frame = CGRectMake(DropDownBoxTitleHorizontalToLeft, 0 ,self.arrow.left - DropDownBoxTitleHorizontalToArrow - DropDownBoxTitleHorizontalToLeft  , self.height);
        [self addSubview:self.titleLabel];
        
//        UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
//        UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
//        NSArray *colors = @[(id)[UIColor colorWithHexString:@"e8e8e8"].CGColor,(id)[UIColor colorWithHexString:@"e8e8e8"].CGColor, (id)[UIColor colorWithHexString:@"e8e8e8"].CGColor];
////  @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
//        NSArray *locations =@[@1.0, @1.0, @1.0];
////        @[@0.2, @0.5, @0.8];
//        self.line = [CAGradientLayer layer];
//        self.line.colors = colors;
//        self.line.locations = locations;
//        self.line.startPoint = CGPointMake(0, 0);
//        self.line.endPoint = CGPointMake(0, 1);
//        self.line.frame = CGRectMake(self.arrow.right + ArrowToRight - 1.0/scale , 0, 1.0/scale, self.height);
//        [self.layer addSublayer:self.line];
    }
    return self;

}

- (void)updateTitleState:(BOOL)isSelected {
    if (isSelected) {
        self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
//        self.arrow.image = [UIImage imageNamed:@"topbar_icon_up"];
        
        self.arrow.image = [UIImage imageNamed:@"topbar_icon_up-1"];
    } else{
        self.titleLabel.textColor = FontUIColorGray;
//        self.arrow.image = [UIImage imageNamed:@"topbar_icon_down"];
        
        self.arrow.image = [UIImage imageNamed:@"topbar_icon_down-1"];
    }
}

- (void)updateTitleContent:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)respondToTapAction:(UITapGestureRecognizer *)gesture {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SCROLL_TOP object:nil];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(didTapDropDownBox:atIndex:)]) {
            [self.delegate didTapDropDownBox:self atIndex:self.tag];
        }
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
