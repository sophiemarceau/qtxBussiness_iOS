//
//  ChooseCollectionViewCell.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/12/6.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ChooseCollectionViewCell.h"

@implementation ChooseCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return  self;
}

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconButton];
    [self.iconButton addSubview:self.functionNamelabel];
    [self.contentView addSubview:self.duigouButton];
}

-(UIButton *)iconButton{
    if (_iconButton == nil) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.userInteractionEnabled = NO;
        _iconButton.frame = CGRectMake(0, 0, 70*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X);
        [_iconButton setImage:[UIImage imageNamed:@"label_icon_color_gray"] forState:UIControlStateNormal];
        [_iconButton setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
    }
    return _iconButton;
}

-(UIButton *)duigouButton{
    if (_duigouButton == nil) {
        _duigouButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _duigouButton.userInteractionEnabled = NO;
        _duigouButton.frame = CGRectMake(50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
        [_duigouButton setImage:[UIImage imageNamed:@"label_icon_not_selected"]forState:UIControlStateNormal];
        [_duigouButton setImage:[UIImage imageNamed:@"label_icon_selected"] forState:UIControlStateSelected];
    }
    return _duigouButton;
}

-(void)setSelectBgView:(NSInteger)indexpathRow WithContentName:(NSString *)contentStr{
    if (indexpathRow % 6 == 0) {
        [_iconButton setImage:[UIImage imageNamed:@"label_icon_color_yellow"] forState:UIControlStateSelected];
    }
    if (indexpathRow % 6 == 1) {
       [_iconButton setImage:[UIImage imageNamed:@"label_icon_color_violet"] forState:UIControlStateSelected];
    }
    if (indexpathRow % 6 == 2) {
        [_iconButton setImage:[UIImage imageNamed:@"label_icon_color_blue"] forState:UIControlStateSelected];
    }
    if (indexpathRow % 6 == 3) {
        [_iconButton setImage:[UIImage imageNamed:@"label_icon_color_pink"] forState:UIControlStateSelected];
    }
    if (indexpathRow % 6 == 4) {
        [_iconButton setImage:[UIImage imageNamed:@"label_icon_color_red"] forState:UIControlStateSelected];
    }
    if (indexpathRow % 6 == 5) {
        [_iconButton setImage:[UIImage imageNamed:@"label_icon_color_green"] forState:UIControlStateSelected];
    }
    self.functionNamelabel.text = contentStr;
}

-(void)UpdateCellWithState:(BOOL)select{
    self.iconButton.selected = select;
    self.duigouButton.selected = select;
    if (self.iconButton.selected) {
        self.functionNamelabel.textColor = [UIColor whiteColor];
    }else{
        self.functionNamelabel.textColor = FontUIColorBlack;
    }
    _isSelected = select;
}

- (UILabel *)functionNamelabel {
    if (_functionNamelabel == nil) {
        _functionNamelabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentCenter font:14 TextColor:FontUIColorBlack];
        _functionNamelabel.frame = CGRectMake(7,15, self.iconButton.size.width-14, self.iconButton.size.height-30);
        _functionNamelabel.numberOfLines = 2;
    }
    return _functionNamelabel;
}
@end
