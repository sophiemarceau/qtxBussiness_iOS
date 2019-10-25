//
//  MMLeftCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/12.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMLeftCell.h"
#import "MMComboBoxHeader.h"
@interface MMLeftCell ()
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) CALayer *bottomLine;
@end

@implementation MMLeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xF8F8F8);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.infoLabel];
//        [self.layer addSublayer:self.bottomLine];
    }
    return self;
}

- (void)setItem:(MMItem *)item {
    _item = item;


    self.infoLabel.text = item.title;
    
    self.infoLabel.textColor = item.isSelected?[UIColor colorWithHexString:titleSelectedColor]:FontUIColorGray;
//    self.backgroundColor = item.isSelected?UIColorFromRGB(0xF8F8F8):[UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.infoLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.height);
    
//    CGRectMake(LeftCellHorizontalMargin, 0, self.width - 2 *LeftCellHorizontalMargin, self.height);
//    self.bottomLine.frame = CGRectMake(0, self.height - 1.0/scale , self.width, 1.0/scale);
}

- (void)setWhiteBackGround{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setGrayBackGround{
    self.backgroundColor = UIColorFromRGB(0xF8F8F8);
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:MainTitleFontSize];
    }
    return _infoLabel;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3].CGColor;
    }
    return _bottomLine;
}
@end
