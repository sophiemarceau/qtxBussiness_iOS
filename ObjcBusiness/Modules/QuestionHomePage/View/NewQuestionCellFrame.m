//
//  NewQuestionCellFrame.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "NewQuestionCellFrame.h"
@class NewQuestionModel;
@implementation NewQuestionCellFrame
-(void)setHomequestionModel:(NewQuestionModel *)homequestionModel{
        _homequestionModel = homequestionModel;
        CGFloat leftMargin = 15*AUTO_SIZE_SCALE_X;
        CGFloat topMargin = 15*AUTO_SIZE_SCALE_X;
        CGSize questTitleSize = [NSString sizeWithText:homequestionModel.titleStr maxSize:CGSizeMake(kScreenWidth-2*leftMargin, MAXFLOAT) font:[UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X]];
        CGFloat questTitleHeight = questTitleSize.height > 48*AUTO_SIZE_SCALE_X ? 48*AUTO_SIZE_SCALE_X : questTitleSize.height;
        _questTitleFrame = CGRectMake(leftMargin,
                                      topMargin,
                                      questTitleSize.width,
                                      questTitleHeight);
    
    if (homequestionModel.questionStr.length != 0) {
        CGFloat questContentTopMargin = 10*AUTO_SIZE_SCALE_X;
        CGFloat questBGPadding = 10*AUTO_SIZE_SCALE_X;
            CGSize questContentSize = [NSString sizeWithText:homequestionModel.questionStr maxSize:CGSizeMake(kScreenWidth - 2*leftMargin - 2*questBGPadding, MAXFLOAT) font:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
            CGFloat questContentHeight = questContentSize.height > 60*AUTO_SIZE_SCALE_X ? 60*AUTO_SIZE_SCALE_X : questContentSize.height;
            _questContentFrame = CGRectMake(questBGPadding, questContentTopMargin, kScreenWidth - 2*leftMargin - 2*questBGPadding, questContentHeight);
            CGFloat questBGTopMargin = 5*AUTO_SIZE_SCALE_X;
            CGFloat questBGBottomMargin = 10*AUTO_SIZE_SCALE_X;
            _questContentBGFrame = CGRectMake(leftMargin,
                                              (CGRectGetMaxY(_questTitleFrame)+questBGTopMargin) ,
                                              (kScreenWidth - 2*leftMargin),
                                              _questContentFrame.size.height + 2*questBGBottomMargin);
        CGFloat leftLabelTopMargin = 0;
        _leftLabelFrame = CGRectMake(leftMargin, (CGRectGetMaxY(_questContentBGFrame)+leftLabelTopMargin ), (kScreenWidth - 2*leftMargin), 34*AUTO_SIZE_SCALE_X);
    }else{
        _questContentFrame = CGRectMake(0,0,0,0);
        _questContentBGFrame = CGRectMake(0,0,0,0);
        CGFloat leftLabelTopMargin = 0;
        _leftLabelFrame = CGRectMake(leftMargin, (CGRectGetMaxY(_questTitleFrame)+leftLabelTopMargin ), (kScreenWidth - 2*leftMargin), 34*AUTO_SIZE_SCALE_X);
    }
    _cellbgFrame = CGRectMake(0, 0 , kScreenWidth, CGRectGetMaxY(_leftLabelFrame));
    _rowHeight = CGRectGetMaxY(_leftLabelFrame) + 10*AUTO_SIZE_SCALE_X;
}

@end
