//
//  DetailTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "DetailTableCellFrame.h"
#import "DetailCellModel.h"
#import "UIImageView+WebCache.h"
@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"DetailTableViewCell";
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
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
    [self.contentView addSubview:self.infoView];

    [self.infoView addSubview:self.headerImageView];
    [self.infoView addSubview:self.headerFlagImageView];
    [self.infoView addSubview:self.nameLabel];
    [self.infoView addSubview:self.jobDesLabel];
    [self.infoView addSubview:self.questionContentLabel];
    [self.infoView addSubview:self.leftSubDesLabel];
    [self.infoView addSubview:self.rightSubDesLabel];
}

-(void)setDetailTableViewFrame:(DetailTableCellFrame *)detailTableViewFrame{

    _detailTableViewFrame = detailTableViewFrame;
    
    self.headerImageView.frame = detailTableViewFrame.headFrame;
    self.headerFlagImageView.frame = detailTableViewFrame.headFlagFrame;
    self.nameLabel.frame = detailTableViewFrame.nameFrame;
    self.jobDesLabel.frame = detailTableViewFrame.jobSubFrame;
    self.questionContentLabel.frame = detailTableViewFrame.questContentFrame;
    self.leftSubDesLabel.frame = detailTableViewFrame.leftLabelFrame;
    self.rightSubDesLabel.frame = detailTableViewFrame.rightLabelFrame;
    self.infoView.frame = detailTableViewFrame.questCellContentFrame;
    
    DetailCellModel *questModel = detailTableViewFrame.questModel;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:questModel.headURLStr] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    
    if (questModel.questionStr == nil) {
        questModel.questionStr = @"";
    }
    [self setLabelSpace:self.questionContentLabel withValue:[NSString stringWithFormat:@"%@",questModel.questionStr] withFont:self.questionContentLabel.font];
    self.leftSubDesLabel.text = [NSString stringWithFormat:@"%@",questModel.timeStr];
    self.rightSubDesLabel.text = [NSString stringWithFormat:@"%@评论   %@点赞 ",questModel.commentStr,questModel.dingStr];
    
    self.headerImageView.tag = questModel.user_id;
    self.jobDesLabel.tag = questModel.user_id;
    self.nameLabel.tag = questModel.user_id;
    
    
    NSString *nameString;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    //是否为匿名回答；0，否，默认；1，匿名；
    if (questModel.answer_is_anonymous == 1) {
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
        _infoView.userInteractionEnabled = YES;
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

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
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
        _questionContentLabel.numberOfLines = 0;
        _questionContentLabel.textColor = FontUIColorBlack;
        
    }
    return _questionContentLabel;
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

- (UILabel *)rightSubDesLabel {
    if (_rightSubDesLabel == nil) {
        _rightSubDesLabel = [[UILabel alloc] init];
        _rightSubDesLabel.backgroundColor = [UIColor clearColor];
        _rightSubDesLabel.textAlignment = NSTextAlignmentRight;
        _rightSubDesLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _rightSubDesLabel.numberOfLines = 0;
        _rightSubDesLabel.textColor = FontUIColor999999Gray;
    }
    return _rightSubDesLabel;
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
