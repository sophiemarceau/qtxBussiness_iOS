//
//  QuestTableViewCellFrame.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestTableViewCellFrame.h"
#import "NSString+textStringToSize.h"
@implementation QuestTableViewCellFrame
-(void)setQuestModel:(QuestModel *)questModel{
    _questModel = questModel;
    
    NSString *nameString ;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    
    if (questModel.answer_is_anonymous  == 1) {
        nameString = @"匿名用户";
    }else{
        if (questModel.userPosition_code == 0) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",questModel.c_expert_profiles]];
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
        }
        if (questModel.userPosition_code == 2) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",questModel.c_profiles]];
        }
        if (questModel.userPosition_code == 3) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",questModel.c_profiles]];
        }
        nameString = questModel.nameStr;
    }
    
    CGFloat leftMargin = 15*AUTO_SIZE_SCALE_X;
    CGFloat topMargin = 15.5*AUTO_SIZE_SCALE_X;
    CGSize questTitleSize = [NSString sizeWithText:questModel.titleStr maxSize:CGSizeMake(kScreenWidth-2*leftMargin, MAXFLOAT) font:[UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X]];
    CGFloat questTitleHeight = questTitleSize.height > 48*AUTO_SIZE_SCALE_X ? 48*AUTO_SIZE_SCALE_X : questTitleSize.height;
    _questTitleFrame = CGRectMake(leftMargin,
                                  topMargin,
                                  questTitleSize.width,
                                  questTitleHeight);
    
    CGFloat questBGPadding = 10*AUTO_SIZE_SCALE_X;
    CGFloat questBGTopPadding = 10*AUTO_SIZE_SCALE_X;
    _headFrame = CGRectMake(questBGPadding,
                            questBGTopPadding, 25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
    CGFloat headFlagLeftPadding = 26*AUTO_SIZE_SCALE_X;
    CGFloat headFlagTopPadding = 26*AUTO_SIZE_SCALE_X;
    _headFlagFrame = CGRectMake(headFlagLeftPadding,
                                headFlagTopPadding, 12*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
    CGFloat nameTopMargin = 16.5*AUTO_SIZE_SCALE_X;

    CGSize nameSize = [NSString sizeWithText:nameString maxSize:CGSizeMake(96*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
    _nameFrame = CGRectMake(
                            (CGRectGetMaxX(_headFrame)+10*AUTO_SIZE_SCALE_X),
                            nameTopMargin,
                            nameSize.width,
                            12*AUTO_SIZE_SCALE_X);
    
    CGFloat jobleftMargin = 10*AUTO_SIZE_SCALE_X;
    CGFloat maxwidth = kScreenWidth - CGRectGetMaxX(_nameFrame) -(leftMargin + questBGPadding + jobleftMargin) ;

    CGSize jobSize = [NSString sizeWithText:jobstr maxSize:CGSizeMake(maxwidth, 12*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
    _jobSubFrame = CGRectMake(
                              (CGRectGetMaxX(_nameFrame)+jobleftMargin),
                              nameTopMargin,
                              jobSize.width,
                              12*AUTO_SIZE_SCALE_X);
    
    CGFloat questContentTopMargin = 8*AUTO_SIZE_SCALE_X;
    CGSize questContentSize = [NSString sizeWithText:questModel.questionStr maxSize:CGSizeMake(kScreenWidth - 2*leftMargin - 2*questBGPadding, MAXFLOAT) font:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
    CGFloat questContentHeight = questContentSize.height > 60*AUTO_SIZE_SCALE_X ? 60*AUTO_SIZE_SCALE_X : questContentSize.height;
    _questContentFrame = CGRectMake(questBGPadding, (CGRectGetMaxY(_headFrame) +questContentTopMargin), kScreenWidth - 2*leftMargin - 2*questBGPadding, questContentHeight);
    
    CGFloat questBGTopMargin = 5*AUTO_SIZE_SCALE_X;
    CGFloat questBGBottomMargin = 10*AUTO_SIZE_SCALE_X;
    _questBgFrame = CGRectMake(leftMargin, (CGRectGetMaxY(_questTitleFrame)+questBGTopMargin) , (kScreenWidth - 2*leftMargin), (CGRectGetMaxY(_questContentFrame) + questBGBottomMargin));
    
    CGFloat leftLabelTopMargin = 0;
    _leftLabelFrame = CGRectMake(leftMargin, (CGRectGetMaxY(_questBgFrame)+leftLabelTopMargin ), (kScreenWidth - 2*leftMargin), 34*AUTO_SIZE_SCALE_X);
    
    
    _questCellContentFrame = CGRectMake(0, 0 , kScreenWidth, (CGRectGetMaxY(_leftLabelFrame)));
    
    _rowHeight = CGRectGetMaxY(_leftLabelFrame) + 10*AUTO_SIZE_SCALE_X;
}



@end
