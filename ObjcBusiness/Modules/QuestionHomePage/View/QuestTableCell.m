//
//  QuestTableCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestTableCell.h"
#import "QuestModel.h"
#import "UIImageView+WebCache.h"
#import "QuestTableViewCellFrame.h"
@implementation QuestTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"QuestTableCell";
    QuestTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[QuestTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BGColorGray;
        [self _initView];
    }
    return self;
}

-(void)_initView{
    self.contentView.userInteractionEnabled = YES;
    
    [self.contentView addSubview:self.infoView];
    
    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.questionContentBgView];
    
    [self.questionContentBgView addSubview:self.headerImageView];
    [self.questionContentBgView addSubview:self.headerFlagImageView];
    [self.questionContentBgView addSubview:self.nameLabel];
    [self.questionContentBgView addSubview:self.jobDesLabel];
    [self.questionContentBgView addSubview:self.questionContentLabel];
    
    [self.contentView addSubview:self.leftSubDesLabel];
}

-(void)setQuestTableViewCellFrame:(QuestTableViewCellFrame *)questTableViewCellFrame{
    
    _questTableViewCellFrame = questTableViewCellFrame;
    self.titleLabel.frame = questTableViewCellFrame.questTitleFrame;
    self.headerImageView.frame = questTableViewCellFrame.headFrame;
    self.headerFlagImageView.frame = questTableViewCellFrame.headFlagFrame;
    self.nameLabel.frame = questTableViewCellFrame.nameFrame;
    self.jobDesLabel.frame = questTableViewCellFrame.jobSubFrame;
    self.questionContentLabel.frame = questTableViewCellFrame.questContentFrame;
    self.questionContentBgView.frame = questTableViewCellFrame.questBgFrame;
    self.leftSubDesLabel.frame = questTableViewCellFrame.leftLabelFrame;
    self.infoView.frame = questTableViewCellFrame.questCellContentFrame;
    
    QuestModel *questModel = questTableViewCellFrame.questModel;

    self.titleLabel.text = questModel.titleStr;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:questModel.headURLStr] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
//    self.questionContentLabel.text = [NSString stringWithFormat:@"%@",questModel.questionStr];
    if (questModel.questionStr == nil) {
        questModel.questionStr = @"";
    }
    [self setLabelSpace:self.questionContentLabel withValue:questModel.questionStr withFont:self.questionContentLabel.font];
    self.leftSubDesLabel.text = [NSString stringWithFormat:@"%@点赞 %@评论",questModel.dingStr,questModel.commentStr];
    self.headerImageView.tag = questModel.user_id;
    self.jobDesLabel.tag = questModel.user_id;
    self.nameLabel.tag = questModel.user_id;
    NSString *nameString;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    
    //是否为匿名回答；0，否，默认；1，匿名
    if (questModel.answer_is_anonymous  == 1) {
        nameString = @"匿名用户";
        self.headerImageView.userInteractionEnabled = NO;
        self.jobDesLabel.userInteractionEnabled = NO;
        self.headerFlagImageView.hidden = YES;
        self.nameLabel.userInteractionEnabled = NO;
    }else{
        self.headerImageView.userInteractionEnabled = YES;
        self.jobDesLabel.userInteractionEnabled = YES;
        self.nameLabel.userInteractionEnabled = YES;
        if (questModel.userPosition_code == 0) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",questModel.c_expert_profiles]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_expert_certification"];
        }
        if (questModel.userPosition_code == 1) {
            NSString *jobString = questModel.jobStr;
            NSString *companyStr = questModel.companyStr;
            if (![jobString isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@"%@",questModel.jobStr]];
            }
            if (![companyStr isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@" | %@",questModel.companyStr]];
            }
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];

        }
        if (questModel.userPosition_code == 2) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",questModel.c_profiles]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_default"];
        }
        if (questModel.userPosition_code == 3) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",questModel.c_profiles]];
            self.headerFlagImageView.hidden = YES;
        }else{
            self.headerFlagImageView.hidden = NO;
        }
        nameString = questModel.nameStr;
    }
    self.nameLabel.text = nameString;
    self.jobDesLabel.text = jobstr;
}

-(void)gotohisHomePage:(UITapGestureRecognizer *)sender{
    [self.delegate didSelectHeaderGotoHomePage:sender.view.tag];
}

-(UIView *)infoView{
    if (_infoView == nil) {
        _infoView = [UIView new];
        _infoView.backgroundColor = [UIColor whiteColor];
        self.infoView.userInteractionEnabled = YES;
    }
    return _infoView;
}

-(UIImageView *)headerImageView{
    if (_headerImageView == nil) {
        _headerImageView = [UIImageView new];
        _headerImageView.backgroundColor = [UIColor clearColor];
        _headerImageView.layer.cornerRadius = 25/2*AUTO_SIZE_SCALE_X;
        _headerImageView.layer.borderWidth= 0.0;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.borderColor = [[UIColor clearColor] CGColor];
        UITapGestureRecognizer * headviewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotohisHomePage:)];
        _headerImageView.userInteractionEnabled = YES;
        [_headerImageView addGestureRecognizer:headviewtap];
    }
    return _headerImageView;
}


-(UIImageView *)headerFlagImageView{
    if (_headerFlagImageView == nil) {
        _headerFlagImageView = [UIImageView new];
        _headerFlagImageView.backgroundColor = [UIColor clearColor];
    }
    return _headerFlagImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        _titleLabel.numberOfLines = 0;
        
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//如果计算结果不准确 是因为没有设置这一行
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
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
        
        _jobDesLabel.textColor = FontUIColorGray;
        
        _jobDesLabel.textAlignment = NSTextAlignmentLeft;
        _jobDesLabel.lineBreakMode = NSLineBreakByWordWrapping;//如果计算结果不准确 是因为没有设置这一行
        _jobDesLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _jobDesLabel.numberOfLines = 0;
        UITapGestureRecognizer * jobviewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotohisHomePage:)];
        _jobDesLabel.userInteractionEnabled = YES;
        [_jobDesLabel addGestureRecognizer:jobviewtap];
    }
    return _jobDesLabel;
}

- (UILabel *)questionContentLabel {
    if (_questionContentLabel == nil) {
        _questionContentLabel = [[UILabel alloc]init];
        _questionContentLabel.backgroundColor = [UIColor clearColor];
        _questionContentLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _questionContentLabel.textAlignment = NSTextAlignmentLeft;
        _questionContentLabel.lineBreakMode = NSLineBreakByWordWrapping;//如果计算结果不准确 是因为没有设置这一行
        _questionContentLabel.numberOfLines = 0;
        _questionContentLabel.textColor = FontUIColorGray;
        
    }
    return _questionContentLabel;
}

- (UIView *)questionContentBgView {
    if (_questionContentBgView == nil) {
        _questionContentBgView = [UIView new];
        _questionContentBgView.backgroundColor = BGColorGray;
        _questionContentBgView.layer.cornerRadius = 8.0f;
        _questionContentBgView.userInteractionEnabled = YES;
    }
    return _questionContentBgView;
}

- (UILabel *)leftSubDesLabel {
    if (_leftSubDesLabel == nil) {
        _leftSubDesLabel = [[UILabel alloc] init];
        _leftSubDesLabel.backgroundColor = [UIColor clearColor];
        _leftSubDesLabel.textAlignment = NSTextAlignmentLeft;
        _leftSubDesLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _leftSubDesLabel.numberOfLines = 0;
        _leftSubDesLabel.textColor = FontUIColor999999Gray;
    }
    return _leftSubDesLabel;
}


-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}
@end
