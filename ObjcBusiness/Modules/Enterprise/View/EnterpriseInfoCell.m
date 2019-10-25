//
//  EnterpriseInfoCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EnterpriseInfoCell.h"

@implementation EnterpriseInfoCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(EnterpriseItem *)object{
    
    return 50*AUTO_SIZE_SCALE_X;
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
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.ValueLabel];
    
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
    [self.ValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50*AUTO_SIZE_SCALE_X));
    }];
}

- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem{
    self.cellableItem = resumTableItem;
    self.backgroundColor = [UIColor whiteColor];
    self.functionLabel.text = resumTableItem.name;
    self.ValueLabel.placeholder = resumTableItem.placeholder;
    self.ValueLabel.text = resumTableItem.functionValue;
    if (resumTableItem.UserInteractive) {
        self.ValueLabel.userInteractionEnabled = YES;
    }else{
        self.ValueLabel.userInteractionEnabled = NO;
    }
    if(resumTableItem.isHiddenLine){
        self.lineImageView.hidden = YES;
    }else{
        self.lineImageView.hidden = NO;
    }
    if(resumTableItem.issetNumberKeyboard){
        self.ValueLabel.keyboardType = UIKeyboardTypeNumberPad;
    }
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

- (UITextField *)ValueLabel{
    if (_ValueLabel == nil) {
        _ValueLabel = [[UITextField alloc] init];
        _ValueLabel.textAlignment = NSTextAlignmentRight;
        _ValueLabel.tintColor  =  RedUIColorC1;
        [_ValueLabel addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
//        _ValueLabel.placeholder = @"请输入手机号";
//        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
//        _phoneTextField.textAlignment = NSTextAlignmentRight;
//        _phoneTextField.tintColor  =  RedUIColorC1;
    }
    return _ValueLabel;
}


- (void)textFieldWithText:(UITextField *)textField{
    self.cellableItem.functionValue = textField.text;
}

@end
