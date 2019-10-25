//
//  TextWithMarginCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "TextWithMarginCell.h"

@implementation TextWithMarginCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.functionLabel];
    [self.bgView addSubview:self.lineImageView];
    [self.bgView addSubview:self.arrowImageView];
    [self.bgView addSubview:self.ValueLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bgView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bgView.mas_top).offset(17.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.ValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bgView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,  0.5*AUTO_SIZE_SCALE_X));
    }];
}

- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem{
    self.functionLabel.text = resumTableItem.name;
    self.ValueLabel.text = resumTableItem.functionValue;
    if (resumTableItem.isShowLineImageFlag) {
        self.lineImageView.hidden = YES;
    }else{
        self.lineImageView.hidden = NO;
    }
    
    if (resumTableItem.hiddenArrowImageView) {
        self.arrowImageView.hidden = YES;
    }else{
        self.arrowImageView.hidden = NO;
    }
}

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"list_icon_more"];
    }
    return _arrowImageView;
}

- (UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}


-(UILabel *)functionLabel{
    if (_functionLabel == nil) {
        _functionLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _functionLabel;
}

-(UILabel *)ValueLabel{
    if (_ValueLabel == nil) {
        _ValueLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:14 TextColor:FontUIColorBlack];
    }
    return _ValueLabel;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(ResumeTableItem *)object{
    return 60.0f*AUTO_SIZE_SCALE_X;
}

@end
