//
//  QuestListCell.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestListCell.h"
#import "NewQuestionCellFrame.h"
#import "NewQuestionModel.h"
@implementation QuestListCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"QuestListCell";
    QuestListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[QuestListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
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
    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.questionContentBgView];
    [self.questionContentBgView addSubview:self.questionContentLabel];
    [self.contentView addSubview:self.leftSubDesLabel];
   
}

-(void)setHomeNewQuestionCellFrame:(NewQuestionCellFrame *)homeNewQuestionCellFrame{
    homeNewQuestionCellFrame = homeNewQuestionCellFrame;
    self.titleLabel.frame = homeNewQuestionCellFrame.questTitleFrame;
    self.questionContentLabel.frame = homeNewQuestionCellFrame.questContentFrame;
    self.questionContentBgView.frame = homeNewQuestionCellFrame.questContentBGFrame;
    self.leftSubDesLabel.frame = homeNewQuestionCellFrame.leftLabelFrame;
    self.infoView.frame = homeNewQuestionCellFrame.cellbgFrame;
    
    NewQuestionModel *newQuestionModel = homeNewQuestionCellFrame.homequestionModel;
    self.titleLabel.text = newQuestionModel.titleStr;
    if (newQuestionModel.questionStr == nil) {
        newQuestionModel.questionStr = @"";
    }
    [self setLabelSpace:self.questionContentLabel withValue:newQuestionModel.questionStr withFont:self.questionContentLabel.font];
    self.leftSubDesLabel.text = [NSString stringWithFormat:@"%@回答 %@收藏",newQuestionModel.questionNumStr,newQuestionModel.collectionNumStr];
}
//-(void)setQuestTableViewCellFrame:(QuestTableViewCellFrame *)questTableViewCellFrame{
//
//    _questTableViewCellFrame = questTableViewCellFrame;
//    self.titleLabel.frame = questTableViewCellFrame.questTitleFrame;
//    self.headerImageView.frame = questTableViewCellFrame.headFrame;
//    self.nameLabel.frame = questTableViewCellFrame.nameFrame;
//    self.jobDesLabel.frame = questTableViewCellFrame.jobSubFrame;
//    self.questionContentLabel.frame = questTableViewCellFrame.questContentFrame;
//    self.questionContentBgView.frame = questTableViewCellFrame.questBgFrame;
//    self.leftSubDesLabel.frame = questTableViewCellFrame.leftLabelFrame;
//    self.infoView.frame = questTableViewCellFrame.questCellContentFrame;
//
//    QuestModel *questModel = questTableViewCellFrame.questModel;
//    //    NSLog(@"model----->%@",questModel.description);
//    self.titleLabel.text = questModel.titleStr;
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:questModel.headURLStr] placeholderImage:[UIImage imageNamed:@""]];
//    self.nameLabel.text = questModel.nameStr;
//    self.jobDesLabel.text = [NSString stringWithFormat:@"%@ | %@",questModel.nameStr,questModel.nameStr];
//    self.questionContentLabel.text = [NSString stringWithFormat:@"%@",questModel.questionStr];
//    self.leftSubDesLabel.text = [NSString stringWithFormat:@"%@点赞 %@评论",questModel.dingStr,questModel.commentStr];
//
//}

-(UIView *)infoView{
    if (_infoView == nil) {
        _infoView = [UIView new];
        _infoView.backgroundColor = [UIColor whiteColor];
    }
    return _infoView;
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





- (UILabel *)questionContentLabel {
    if (_questionContentLabel == nil) {
        _questionContentLabel = [[UILabel alloc]init];
        _questionContentLabel.backgroundColor = [UIColor clearColor];
        _questionContentLabel.font = [UIFont systemFontOfSize:14];
        _questionContentLabel.textAlignment = NSTextAlignmentLeft;
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
