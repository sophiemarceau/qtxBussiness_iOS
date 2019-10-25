//
//  PushTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PushTableViewCell.h"

@implementation PushTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"PushTableViewCell";
    PushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[PushTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self _initView];
    }
    return self;
}

-(void)_initView{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.badgeView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(12.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(50*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-100*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(17.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(-1*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    
}

-(void)setMydictionary:(NSDictionary *)mydictionary{
    _mydictionary = mydictionary;
    self.iconImageView.image = [UIImage imageNamed:self.mydictionary[@"iconImageView"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@" ,self.mydictionary[@"titleName"]];
    int countNum = [self.mydictionary[@"count"] intValue];
    if (countNum == 0) {
        [self.badgeView setHidden:YES];
    }else{
        [self.badgeView setHidden:NO];
        [self.badgeView setBadgeNumber:countNum];
    }
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}
-(UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image =[UIImage imageNamed:@"list_icon_more"];

    }
    return _arrowImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = FontUIColorGray;
        
    }
    return _titleLabel;
}
-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}


-(WHC_BadgeView *)badgeView{
    if (_badgeView == nil) {
        _badgeView = [[WHC_BadgeView alloc]initWithSuperView:self.contentView position:CGPointMake(kScreenWidth-50, 15.0) radius:10.0];
    }
    return _badgeView;
}
@end
