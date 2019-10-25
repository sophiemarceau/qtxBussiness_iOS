//
//  MMNormalCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMNormalCell.h"
#import "MMComboBoxHeader.h"
static const CGFloat horizontalMargin = 15.0f;
@interface MMNormalCell ()

@property (nonatomic, strong) UILabel *subTitle;

@property (nonatomic, strong) CALayer *bottomLine;
@end

@implementation MMNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    self.bottomLine.frame = CGRectMake(0, self.height - 1.0/scale , self.width, 1.0/scale);
}

- (void)setItem:(MMItem *)item{
    _item = item;
    self.title.text = item.title;
    self.title.textColor = item.isSelected?[UIColor colorWithHexString:titleSelectedColor]:FontUIColorGray;
    if (item.subTitle != nil) {
    self.subTitle.text  = item.subTitle;
    }
//    self.backgroundColor = item.isSelected?[UIColor colorWithHexString:CellBGColor]:[UIColor colorWithHexString:UnselectedBGColor];
    self.selectedImageview.hidden = !item.isSelected;
    
    self.title.frame = CGRectMake(horizontalMargin, 0, 30, self.height);
    //    CGRectMake(self.selectedImageview.right + 20, 0, 100, self.height);
    
    self.selectedImageview.frame = CGRectMake(self.title.right+15, (self.height-13)/2, 13, 13);
    //    CGRectMake(horizontalMargin, (self.height -16)/2, 16, 16);
    
    if (_item.subTitle != nil) {
        self.subTitle.frame = CGRectMake(self.width - horizontalMargin - 100 , 0, 100, self.height);
    }
}

-(void)resetFrame{
    
    self.title.frame = CGRectMake(30, 0, self.width-30-60, self.height);
    self.selectedImageview.frame = CGRectMake(self.width-30-13, (self.height-13)/2, 13, 13);
}

#pragma mark - get
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = FontUIColorGray;
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = [UIFont systemFontOfSize:MainTitleFontSize];
        [self addSubview:_title];
    }
    return _title;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor blackColor];
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.font = [UIFont systemFontOfSize:SubTitleFontSize];
        [self addSubview:_subTitle];
    }
    return _subTitle;
}

- (UIImageView *)selectedImageview {
    if (!_selectedImageview) {
        _selectedImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar_icon_complete_selected"]];
        [self addSubview:_selectedImageview];
    }
    return _selectedImageview;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3].CGColor;
        [self.layer addSublayer:_bottomLine];
    }
    return _bottomLine;
}
@end
