//
//  SystemMessageTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SystemMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation SystemMessageTableViewCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(SystemTableItem *)object{
    return (251.5+60)*AUTO_SIZE_SCALE_X;
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
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bgImageView];
    
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.picImageView];
    [self.bgImageView addSubview:self.lineImageView];
    [self.bgImageView addSubview:self.checkLabel];
    [self.bgImageView addSubview:self.arrowImageView];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(120*AUTO_SIZE_SCALE_X);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.mas_top).offset(25*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(135.5*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(60*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(345*AUTO_SIZE_SCALE_X,  251.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bgImageView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-60*AUTO_SIZE_SCALE_X,  42*AUTO_SIZE_SCALE_X));
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bgImageView.mas_top).offset(42*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-60*AUTO_SIZE_SCALE_X,  150*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bgImageView.mas_top).offset(206*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-60*AUTO_SIZE_SCALE_X,  0.5*AUTO_SIZE_SCALE_X));
    }];
    
    
    [self.checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bgImageView.mas_top).offset(207*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-60*AUTO_SIZE_SCALE_X,  44*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X,  15*AUTO_SIZE_SCALE_X));
    }];
}

- (void)setResumeTableItem:(SystemTableItem *)resumTableItem{
    self.timeLabel.text = [NSString stringWithFormat:@"%@",resumTableItem.timeStr];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",resumTableItem.titleStr];
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:resumTableItem.picStr]];

}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12 TextColor:[UIColor whiteColor]];
        _timeLabel.backgroundColor = UIColorFromRGB(0xdddddd);
        
    }
    return _timeLabel;
}

-(UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [UIImageView new];
        _bgImageView.backgroundColor = [UIColor whiteColor];
    }
    return _bgImageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _titleLabel;
}

-(UIImageView *)picImageView{
    if (_picImageView == nil) {
        _picImageView = [UIImageView new];
        
    }
    return _picImageView;
}

-(UILabel *)checkLabel{
    if (_checkLabel == nil) {
        _checkLabel = [CommentMethod initLabelWithText:@"点击查看" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
    }
    return _checkLabel;
}


- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image =[UIImage imageNamed:@"list_icon_more"];
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



@end
