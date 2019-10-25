//
//  PersonTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PersonTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation PersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"PersonTableViewCell";
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[PersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
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
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.headerFlagImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.jobDesLabel];
    [self.contentView addSubview:self.lineImageView];
    
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X));
    }];
    
    [self.headerFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(43*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(43*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(65*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(19*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth -(65+15)*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.jobDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(65*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(39*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth -(65+15)*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(-1*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
}

-(void)setMydictionary:(NSDictionary *)mydictionary{
    _mydictionary = mydictionary;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:mydictionary[@"userCSimpleInfoDto"][@"c_photo"]] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    
    NSDictionary *dto =   mydictionary[@"userCSimpleInfoDto"];
    int userPosition_code = [dto[@"userPosition_code"] intValue];
    NSString *nameString;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    NSInteger answer_is_anonymous  = [mydictionary[@"answer_is_anonymous"] integerValue];
    if (answer_is_anonymous ==1 ) {
        nameString = @"匿名用户";
        self.headerFlagImageView.hidden = NO;
    }else{
        if (userPosition_code == 0) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dto[@"c_expert_profiles"]]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_expert_certification"];
        }
        if (userPosition_code == 1) {
            NSString *jobString = dto[@"c_jobtitle"];
            NSString *companyStr = dto[@"company_name"];
            if (![jobString isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@"%@",jobString]];
            }
            if (![companyStr isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@" | %@",companyStr]];
            }
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];
            
        }
        if (userPosition_code == 2) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dto[@"c_profiles"]]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_default"];
        }
        if (userPosition_code == 3) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dto[@"c_profiles"]]];
            self.headerFlagImageView.hidden = YES;
        }else{
            self.headerFlagImageView.hidden = NO;
        }
       nameString =  dto[@"c_nickname"];
    }
    self.jobDesLabel.text = jobstr;
    self.nameLabel.text = nameString;

//    self.iconImageView.image = [UIImage imageNamed:self.mydictionary[@"iconImageView"]];
//    self.titleLabel.text = [NSString stringWithFormat:@"%@" ,self.mydictionary[@"titleName"]];
}

-(UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [UIImageView new];
        
        self.headImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X);
        self.headImageView.layer.cornerRadius = 40/2*AUTO_SIZE_SCALE_X;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return  _headImageView;
}

-(UIImageView *)headerFlagImageView{
    if (_headerFlagImageView == nil) {
        self.headerFlagImageView = [UIImageView new];
    }
    return  _headerFlagImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        
        _nameLabel.textColor = FontUIColorGray;
    }
    return _nameLabel;
}

- (UILabel *)jobDesLabel {
    if (_jobDesLabel == nil) {
        _jobDesLabel = [[UILabel alloc]init];
        _jobDesLabel.backgroundColor = [UIColor clearColor];
        _jobDesLabel.textAlignment = NSTextAlignmentLeft;
        _jobDesLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _jobDesLabel.textColor = FontUIColorGray;
    }
    return _jobDesLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}


@end
