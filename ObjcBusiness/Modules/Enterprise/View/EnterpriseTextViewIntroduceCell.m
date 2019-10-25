//
//  EnterpriseTextViewIntroduceCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EnterpriseTextViewIntroduceCell.h"

@implementation EnterpriseTextViewIntroduceCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(EnterpriseItem *)object{
    
    return 117*AUTO_SIZE_SCALE_X;
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
    [self.contentView addSubview:self.remarksbgView];
    [self.remarksbgView addSubview:self.introduceView];
    
    [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(120*AUTO_SIZE_SCALE_X, 49.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.functionLabel.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,  0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.remarksbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 67*AUTO_SIZE_SCALE_X));
    }];
    
    [self.introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 67*AUTO_SIZE_SCALE_X));
    }];
}

- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem{
    self.cellableItem = resumTableItem;
    self.backgroundColor = [UIColor whiteColor];
    self.functionLabel.text = resumTableItem.name;
    self.ValueLabel.text = resumTableItem.functionValue;
    
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

- (void)textViewDidChange:(UITextView *)textView{
    self.cellableItem.functionValue = textView.text;
}


-(UITextView *)introduceView{
    if (_introduceView == nil) {
        _introduceView = [[UITextView alloc] initWithFrame:CGRectZero];
        _introduceView.layer.borderWidth = 0;
        _introduceView.font = [UIFont systemFontOfSize:14];
        _introduceView.layer.borderColor = [UIColor clearColor].CGColor;
        _introduceView.zw_placeHolder = @"请填写企业一句话介绍，20字以内";
        _introduceView.zw_placeHolderColor = FontUIColor999999Gray;
        _introduceView.textColor = FontUIColorBlack;
        _introduceView.tintColor = RedUIColorC1;
        _introduceView.delegate = self;
        
    }
    return _introduceView;
}

- (UIView *)remarksbgView{
    if (_remarksbgView == nil) {
        _remarksbgView = [UIView new];
        _remarksbgView.backgroundColor = [UIColor whiteColor];
        
    }
    return _remarksbgView;
}
@end
