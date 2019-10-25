//
//  QuestListCell+NewQuestionCellFrame.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestListCell+NewQuestionCellFrame.h"
#import "NewQuestionCellFrame.h"
#import "NewQuestionModel.h"
@implementation QuestListCell (NewQuestionCellFrame)
- (void)configureWithListEntity:(NewQuestionCellFrame *)questcellFrame{
        questcellFrame = questcellFrame;
        self.titleLabel.frame = questcellFrame.questTitleFrame;
        self.questionContentLabel.frame = questcellFrame.questContentFrame;
        self.questionContentBgView.frame = questcellFrame.questContentBGFrame;
        self.leftSubDesLabel.frame = questcellFrame.leftLabelFrame;
        self.infoView.frame = questcellFrame.cellbgFrame;
    
        NewQuestionModel *newQuestionModel = questcellFrame.homequestionModel;
        
        self.titleLabel.text = newQuestionModel.titleStr;
    if (newQuestionModel.questionStr == nil) {
        newQuestionModel.questionStr = @"";
    }
    [self setLabelSpace:self.questionContentLabel withValue:newQuestionModel.questionStr withFont:self.questionContentLabel.font];
        self.leftSubDesLabel.text = [NSString stringWithFormat:@"%@回答 %@收藏",newQuestionModel.questionNumStr,newQuestionModel.collectionNumStr];
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
