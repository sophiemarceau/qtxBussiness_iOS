//
//  MenuTableViewCell.m
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    _lineView = lineView;
    [self addSubview:lineView];
    self.backgroundColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = [UIColor redColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(4, self.bounds.size.height - 1, self.bounds.size.width - 8, 0.5);
}

- (void)setMenuModel:(MenuModel *)menuModel{
    _menuModel = menuModel;
    self.imageView.image = [UIImage imageNamed:menuModel.imageName];
    self.textLabel.text = menuModel.itemName;
    
    if (menuModel.selectFlag == 1) {
        self.textLabel.textColor = RedUIColorC1;
    }else{
        self.textLabel.textColor = FontUIColorBlack;
    }
}

@end
