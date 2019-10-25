//
//  DingFrame.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/31.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DingFrame.h"

@implementation DingFrame
-(void)setDingModel:(DingModel *)dingModel{
    _dingModel = dingModel;
    
    NSString *nameString ;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    if (dingModel.answer_is_anonymous == 1) {
        nameString = @"匿名用户";
    }else{
        if (dingModel.userPosition_code == 0) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dingModel.c_expert_profiles]];
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
        }
        if (dingModel.userPosition_code == 2) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dingModel.c_profiles]];
        }
        if (dingModel.userPosition_code == 3) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",dingModel.c_profiles]];
        }
        nameString = dingModel.nameStr;
    }
    
    
    NSString *strIntegralDetail = dingModel.strIntegralDetail;
    
    
    
    CGFloat leftMargin = 15*AUTO_SIZE_SCALE_X;
    CGFloat topMargin = 15*AUTO_SIZE_SCALE_X;
    _headFrame = CGRectMake(leftMargin, topMargin, 25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
    
    _headFlagFrame = CGRectMake(31*AUTO_SIZE_SCALE_X, 31*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
    
    CGFloat nameTopMargin = 20*AUTO_SIZE_SCALE_X;
    CGSize nameSize = [NSString sizeWithText:nameString maxSize:CGSizeMake(96*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
    _nameFrame = CGRectMake(
                            (CGRectGetMaxX(_headFrame)+10*AUTO_SIZE_SCALE_X),
                            nameTopMargin,
                            nameSize.width,
                            14*AUTO_SIZE_SCALE_X);
    
    CGFloat jobleftMargin = 6*AUTO_SIZE_SCALE_X;
    CGFloat jobTopMargin = 21.5*AUTO_SIZE_SCALE_X;
    CGFloat maxwidth = kScreenWidth - CGRectGetMaxX(_nameFrame) -(jobleftMargin+leftMargin) ;
    
    CGSize jobSize = [NSString sizeWithText:jobstr maxSize:CGSizeMake(maxwidth, 12*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
    _jobSubFrame = CGRectMake(
                              (CGRectGetMaxX(_nameFrame)+jobleftMargin),
                              jobTopMargin,
                              jobSize.width,
                              12*AUTO_SIZE_SCALE_X);
    
     CGFloat commentFromFrameTopMargin = 45*AUTO_SIZE_SCALE_X;
    _commentFromFrame = CGRectMake(_nameFrame.origin.x, commentFromFrameTopMargin, kScreenWidth-leftMargin-_nameFrame.origin.x, 21*AUTO_SIZE_SCALE_X);
    
    if ([strIntegralDetail isEqualToString:@""]) {
        _dingScoreFrame = CGRectMake(0, 0, 0, 0);
        CGFloat leftLabelFrameTopMargin = 77*AUTO_SIZE_SCALE_X;
        _leftLabelFrame = CGRectMake(_nameFrame.origin.x, leftLabelFrameTopMargin, kScreenWidth-leftMargin-_nameFrame.origin.x, 12*AUTO_SIZE_SCALE_X);
    }else{
         _dingScoreFrame = CGRectMake(_nameFrame.origin.x, 76*AUTO_SIZE_SCALE_X, kScreenWidth-leftMargin-_nameFrame.origin.x, 12*AUTO_SIZE_SCALE_X);
        CGFloat leftLabelFrameTopMargin = 99*AUTO_SIZE_SCALE_X;
        _leftLabelFrame = CGRectMake(_nameFrame.origin.x, leftLabelFrameTopMargin, kScreenWidth-leftMargin-_nameFrame.origin.x, 12*AUTO_SIZE_SCALE_X);
    }

     _lineImageViewFrame = CGRectMake(15*AUTO_SIZE_SCALE_X, CGRectGetMaxX(_leftLabelFrame)-1, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
}
@end
