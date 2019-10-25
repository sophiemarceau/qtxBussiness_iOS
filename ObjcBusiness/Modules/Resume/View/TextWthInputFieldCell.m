//
//  TextWthInputFieldCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "TextWthInputFieldCell.h"

@implementation TextWthInputFieldCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(ResumeTableItem *)object{
    return 50.0f*AUTO_SIZE_SCALE_X;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self.contentView addSubview:self.functionLabel];
    [self.contentView addSubview:self.phoneTextField];
    [self.contentView addSubview:self.lineImageView];
    
    [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(140*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,  0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50*AUTO_SIZE_SCALE_X));
    }];
}

- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem{
    self.backgroundColor = [UIColor whiteColor];
    self.functionLabel.text = resumTableItem.name;
    self.phoneTextField.text = resumTableItem.functionValue;
    if (resumTableItem.isShowLineImageFlag) {
        self.lineImageView.hidden = YES;
    }else{
        self.lineImageView.hidden = NO;
    }
}

-(UILabel *)functionLabel{
    if (_functionLabel == nil) {
        _functionLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _functionLabel;
}

- (UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

- (UITextField *)phoneTextField{
    if (_phoneTextField == nil) {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.textAlignment = NSTextAlignmentRight;
        _phoneTextField.tintColor  =  RedUIColorC1;
    }
    return _phoneTextField;
}

@end
