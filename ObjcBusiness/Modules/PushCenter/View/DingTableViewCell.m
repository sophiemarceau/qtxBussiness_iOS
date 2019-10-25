//
//  DingTableViewCell.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/31.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DingTableViewCell.h"
#import "DingFrame.h"
#import "UIImageView+WebCache.h"
@implementation DingTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"DingTableViewCell";
    DingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[DingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
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
    [self.contentView addSubview:self.commentFromLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineImageView];
    
}

-(void)setMydictionary:(NSDictionary *)mydictionary{
    _mydictionary = mydictionary;
}

-(void)setDingFrame:(DingFrame *)dingFrame{
    _dingFrame = dingFrame;
    self.headImageView.frame = dingFrame.headFrame;
    self.headerFlagImageView.frame = dingFrame.headFlagFrame;
    self.nameLabel.frame = dingFrame.nameFrame;
    self.jobDesLabel.frame = dingFrame.jobSubFrame;
    self.commentFromLabel.frame = dingFrame.commentFromFrame;
    self.scoreLabel.frame = dingFrame.dingScoreFrame;
    self.timeLabel.frame = dingFrame.leftLabelFrame;
    
    
    
    DingModel *dingModel = dingFrame.dingModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dingModel.headURLStr] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",dingModel.timeStr];
    
    //ding_obj_kind_code：被赞对象类型 code：3、问题；4、回答；5、评论\回复；6、项目；
    if (dingModel.ding_obj_kind_code == 3) {
        self.commentFromLabel.text = [NSString stringWithFormat:@"赞了您的问题：%@",dingModel.commentFromStr];
    }
    if (dingModel.ding_obj_kind_code == 4) {
        self.commentFromLabel.text = [NSString stringWithFormat:@"赞了您的回答：%@",dingModel.commentFromStr];
    }
    if (dingModel.ding_obj_kind_code == 5) {
        self.commentFromLabel.text = [NSString stringWithFormat:@"赞了您的评论\回复：%@",dingModel.commentFromStr];
    }
    if (dingModel.ding_obj_kind_code == 6) {
        self.commentFromLabel.text = [NSString stringWithFormat:@"赞了您的项目：%@",dingModel.commentFromStr];
    }
    
    

    NSString *strIntegralDetail = dingModel.strIntegralDetail;
    if ([strIntegralDetail isEqualToString:@""]) {
        self.scoreLabel.hidden = YES;
        self.lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X-1, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    }else{
       self.scoreLabel.hidden = NO;
        self.scoreLabel.text = strIntegralDetail;
        self.lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 122*AUTO_SIZE_SCALE_X-1, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    }
    self.headImageView.tag = dingModel.user_id;
    self.jobDesLabel.tag = dingModel.user_id;
    self.nameLabel.tag = dingModel.user_id;
    NSString *nameString;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    if (dingModel.answer_is_anonymous == 1 ) {
        nameString = @"匿名用户";
        self.headImageView.userInteractionEnabled = NO;
        self.jobDesLabel.userInteractionEnabled = NO;
        self.headerFlagImageView.hidden = YES;
        self.nameLabel.userInteractionEnabled = NO;
    }else{
        self.headImageView.userInteractionEnabled = YES;
        self.jobDesLabel.userInteractionEnabled = YES;
        self.nameLabel.userInteractionEnabled = YES;
        if (dingModel.userPosition_code == 0) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dingModel.c_expert_profiles]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_expert_certification"];
        }
        if (dingModel.userPosition_code == 1) {
            NSString *jobString = dingModel.jobStr;
            NSString *companyStr = dingModel.companyStr;
            if (![jobString isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@"%@",dingModel.jobStr]];
            }
            if (![companyStr isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@" | %@",dingModel.companyStr]];
            }
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];
            
        }
        if (dingModel.userPosition_code == 2) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dingModel.c_profiles]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_default"];
        }
        if (dingModel.userPosition_code == 3) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dingModel.c_profiles]];
            self.headerFlagImageView.hidden = YES;
        }else{
            self.headerFlagImageView.hidden = NO;
        }
        nameString = dingModel.nameStr;
    }
    self.nameLabel.text = nameString;
    self.jobDesLabel.text = jobstr;
}

-(void)gotohisHomePage:(UITapGestureRecognizer *)sender{
    [self.delegate didSelectHeaderGotoHomePage:sender.view.tag];
}

-(UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 25/2*AUTO_SIZE_SCALE_X;
        _headImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer * headviewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotohisHomePage:)];
        _headImageView.userInteractionEnabled = YES;
        [_headImageView addGestureRecognizer:headviewtap];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = FontUIColorBlack;
        UITapGestureRecognizer * nameLabeltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotohisHomePage:)];
        _nameLabel.userInteractionEnabled = YES;
        [_nameLabel addGestureRecognizer:nameLabeltap];
    }
    return _nameLabel;
}

- (UILabel *)jobDesLabel {
    if (_jobDesLabel == nil) {
        _jobDesLabel = [[UILabel alloc]init];
        _jobDesLabel.backgroundColor = [UIColor clearColor];
        _jobDesLabel.textAlignment = NSTextAlignmentLeft;
        _jobDesLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _jobDesLabel.numberOfLines = 0;
        _jobDesLabel.textColor = FontUIColor757575Gray;
        UITapGestureRecognizer * jobviewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotohisHomePage:)];
        _jobDesLabel.userInteractionEnabled = YES;
        [_jobDesLabel addGestureRecognizer:jobviewtap];
        
    }
    return _jobDesLabel;
}


- (UILabel *)scoreLabel {
    if (_scoreLabel == nil) {
        _scoreLabel = [[UILabel alloc]init];
        _scoreLabel.textColor = RedUIColorC1;;
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        _scoreLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _scoreLabel.numberOfLines = 0;
        _scoreLabel.backgroundColor = [UIColor clearColor];
        
    }
    return _scoreLabel;
}

- (UILabel *)commentFromLabel {
    if (_commentFromLabel == nil) {
        _commentFromLabel = [[UILabel alloc]init];
        _commentFromLabel.backgroundColor = [UIColor clearColor];
        _commentFromLabel.textAlignment = NSTextAlignmentLeft;
        _commentFromLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        _commentFromLabel.numberOfLines = 0;
        _commentFromLabel.textColor = FontUIColorBlack;
        
    }
    return _commentFromLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _timeLabel.numberOfLines = 0;
        _timeLabel.textColor = FontUIColor999999Gray;
        
    }
    return _timeLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}


-(UIImageView *)headerFlagImageView{
    if (_headerFlagImageView == nil) {
        _headerFlagImageView = [UIImageView new];
        
    }
    return _headerFlagImageView;
}
@end
