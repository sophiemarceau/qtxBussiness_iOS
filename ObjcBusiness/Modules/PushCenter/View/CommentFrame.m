//
//  CommentFrame.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CommentFrame.h"

@implementation CommentFrame
-(void)setCommentModel:(CommentModel *)commentModel{
    _commentModel = commentModel;
    
    
    NSString *nameString ;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    if (commentModel.answer_is_anonymous == 1) {
        nameString = @"匿名用户";
    }else{
        if (commentModel.userPosition_code == 0) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",commentModel.c_expert_profiles]];
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
        }
        if (commentModel.userPosition_code == 2) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",commentModel.c_profiles]];
        }
        if (commentModel.userPosition_code == 3) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",commentModel.c_profiles]];
        }
        nameString = commentModel.nameStr;
    }
    
    
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
    _commentFromFrame = CGRectMake(_nameFrame.origin.x, commentFromFrameTopMargin, kScreenWidth-leftMargin-CGRectGetMaxX(_nameFrame), 21*AUTO_SIZE_SCALE_X);
    
    
    CGFloat ContentTopMargin = 81*AUTO_SIZE_SCALE_X;
    
    CGSize ContentSize = [NSString sizeWithText:commentModel.replyStr maxSize:CGSizeMake(kScreenWidth - 60*AUTO_SIZE_SCALE_X - 25*AUTO_SIZE_SCALE_X, MAXFLOAT) font:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
    CGFloat ContentHeight = ContentSize.height > 40*AUTO_SIZE_SCALE_X ? 40*AUTO_SIZE_SCALE_X : ContentSize.height;
    
    _ContentFrame = CGRectMake(60*AUTO_SIZE_SCALE_X, (ContentTopMargin), ContentSize.width, ContentHeight*AUTO_SIZE_SCALE_X);
    
    
    CGFloat ContentBgTopMargin = 71*AUTO_SIZE_SCALE_X;
    
    _ContentBgFrame = CGRectMake(50*AUTO_SIZE_SCALE_X, (ContentBgTopMargin), kScreenWidth-50*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, _ContentFrame.size.height+20*AUTO_SIZE_SCALE_X);

    _leftLabelFrame = CGRectMake(_nameFrame.origin.x, CGRectGetMaxY(_ContentBgFrame), kScreenWidth-leftMargin-_nameFrame.origin.x, 34*AUTO_SIZE_SCALE_X);
    
    
    _lineImageViewFrame = CGRectMake(15*AUTO_SIZE_SCALE_X, CGRectGetMaxY(_leftLabelFrame)-1, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5);
    
    _rowHeight = CGRectGetMaxY(_leftLabelFrame);
}
@end
