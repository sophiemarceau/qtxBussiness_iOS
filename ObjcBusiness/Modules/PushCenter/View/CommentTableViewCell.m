//
//  CommentTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentFrame.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
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
    [self.contentView addSubview:self.replybgView];
    [self.contentView addSubview:self.replyLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineImageView];
    
    
}

-(void)setMydictionary:(NSDictionary *)mydictionary{
    _mydictionary = mydictionary;
}

-(void)setCommentFrame:(CommentFrame *)commentFrame{
    _commentFrame = commentFrame;
    self.headImageView.frame = commentFrame.headFrame;
    self.headerFlagImageView.frame = commentFrame.headFlagFrame;
    self.nameLabel.frame = commentFrame.nameFrame;
    self.jobDesLabel.frame = commentFrame.jobSubFrame;
    self.commentFromLabel.frame = commentFrame.commentFromFrame;
    self.replyLabel.frame = commentFrame.ContentFrame;
    self.replybgView.frame = commentFrame.ContentBgFrame;
    self.timeLabel.frame = commentFrame.leftLabelFrame;
    self.lineImageView.frame = commentFrame.lineImageViewFrame;
    
    
    
    CommentModel *commentModel = commentFrame.commentModel;
    
    self.headImageView.tag = commentModel.user_id;
    self.jobDesLabel.tag = commentModel.user_id;
    self.nameLabel.tag = commentModel.user_id;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.headURLStr] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    self.commentFromLabel.text = [NSString stringWithFormat:@"回复了您的评论：“%@”",commentModel.commentFromStr];
    self.replyLabel.text = [NSString stringWithFormat:@"%@",commentModel.replyStr];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",commentModel.timeStr];
    
    
    NSString *nameString;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    if (commentModel.answer_is_anonymous == 1 ) {
        nameString = @"匿名用户";
        self.headImageView.userInteractionEnabled = NO;
        self.jobDesLabel.userInteractionEnabled = NO;
        self.headerFlagImageView.hidden = YES;
        self.nameLabel.userInteractionEnabled = NO;
    }else{
        self.headImageView.userInteractionEnabled = YES;
        self.jobDesLabel.userInteractionEnabled = YES;
        self.nameLabel.userInteractionEnabled = YES;
        if (commentModel.userPosition_code == 0) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",commentModel.c_expert_profiles]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_expert_certification"];
        }
        if (commentModel.userPosition_code == 1) {
            NSString *jobString = commentModel.jobStr;
            NSString *companyStr = commentModel.companyStr;
            if (![jobString isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@"%@",commentModel.jobStr]];
            }
            if (![companyStr isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@" | %@",commentModel.companyStr]];
            }
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];
            
        }
        if (commentModel.userPosition_code == 2) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",commentModel.c_profiles]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_default"];
        }
        if (commentModel.userPosition_code == 3) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",commentModel.c_profiles]];
            self.headerFlagImageView.hidden = YES;
        }else{
            self.headerFlagImageView.hidden = NO;
        }
        nameString = commentModel.nameStr;
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

-(UIImageView *)headerFlagImageView{
    if (_headerFlagImageView == nil) {
        _headerFlagImageView = [UIImageView new];
        
    }
    return _headerFlagImageView;
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

- (UILabel *)replyLabel {
    if (_replyLabel == nil) {
        _replyLabel = [[UILabel alloc]init];
        _replyLabel.backgroundColor = [UIColor clearColor];
        _replyLabel.textAlignment = NSTextAlignmentLeft;
        _replyLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _replyLabel.numberOfLines = 0;
        _replyLabel.textColor = FontUIColorGray;
        
    }
    return _replyLabel;
}

-(UIView *)replybgView{
    if (_replybgView == nil) {
        _replybgView = [UIView new];
        _replybgView.backgroundColor = UIColorFromRGB(0xf4f5f7);
        _replybgView.layer.cornerRadius = 5.0f;
        _replybgView.layer.masksToBounds = YES;
    }
    return _replybgView;
}


- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        _timeLabel.numberOfLines = 0;
        _timeLabel.textColor = FontUIColorBlack;
        
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

@end
