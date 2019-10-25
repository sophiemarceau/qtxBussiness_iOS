//
//  DetailTableCellFrame.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DetailTableCellFrame.h"
#import "NSString+textStringToSize.h"
@implementation DetailTableCellFrame

-(void)setQuestModel:(DetailCellModel *)questModel{
    _questModel = questModel;
    
    NSString *nameString ;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    
    if (questModel.answer_is_anonymous == 1) {
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
    
    
    
    
    CGFloat margin = 15*AUTO_SIZE_SCALE_X;
    CGFloat topmargin = 15*AUTO_SIZE_SCALE_X;
    
    _headFrame = CGRectMake(margin, topmargin, 25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
    CGFloat headFlagLeftPadding = 31*AUTO_SIZE_SCALE_X;
    CGFloat headFlagTopPadding = 31*AUTO_SIZE_SCALE_X;
    _headFlagFrame = CGRectMake(headFlagLeftPadding,
                                headFlagTopPadding, 12*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
    
    
    
    CGFloat nameLeftMargin = 10*AUTO_SIZE_SCALE_X;
    CGFloat nameTopMargin = 21.5*AUTO_SIZE_SCALE_X;
    
    CGSize nameSize = [NSString sizeWithText:nameString maxSize:CGSizeMake(96*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
    _nameFrame = CGRectMake((CGRectGetMaxX(_headFrame)+nameLeftMargin), nameTopMargin , nameSize.width,
                            12*AUTO_SIZE_SCALE_X);
    
    CGFloat jobLeftMargin = 10*AUTO_SIZE_SCALE_X;
    CGFloat maxwidth = kScreenWidth - CGRectGetMaxX(_nameFrame) -(margin  + jobLeftMargin)  ;
    
    CGSize jobSize = [NSString sizeWithText:jobstr maxSize:CGSizeMake(maxwidth, 12*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:12]];
    _jobSubFrame = CGRectMake(
                              (CGRectGetMaxX(_nameFrame)+jobLeftMargin),
                              nameTopMargin,
                              jobSize.width,
                              12*AUTO_SIZE_SCALE_X);
    
    CGFloat questContentTopMargin = 7*AUTO_SIZE_SCALE_X;
    CGSize questContentSize = [NSString sizeWithText:questModel.questionStr maxSize:CGSizeMake(kScreenWidth - 2*margin , MAXFLOAT) font:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]];
    CGFloat questContentHeight = questContentSize.height > 63*AUTO_SIZE_SCALE_X ? 63*AUTO_SIZE_SCALE_X : questContentSize.height;
    _questContentFrame = CGRectMake(margin, (CGRectGetMaxY(_headFrame) +questContentTopMargin),kScreenWidth - 2*margin, questContentHeight);
    
    CGFloat leftLabelTopMargin = 0;
    _leftLabelFrame = CGRectMake(margin, (CGRectGetMaxY(_questContentFrame)+leftLabelTopMargin ), (kScreenWidth /2), 34*AUTO_SIZE_SCALE_X);
 
    _rightLabelFrame = CGRectMake(kScreenWidth/2, (CGRectGetMaxY(_questContentFrame)+leftLabelTopMargin ), (kScreenWidth /2)-margin, 34*AUTO_SIZE_SCALE_X);
    
    _questCellContentFrame = CGRectMake(0, 0 , kScreenWidth, (CGRectGetMaxY(_leftLabelFrame)));
    
     _rowHeight = CGRectGetMaxY(_leftLabelFrame) + 10*AUTO_SIZE_SCALE_X;
}
@end
