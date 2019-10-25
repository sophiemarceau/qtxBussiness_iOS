//
//  BossCellFrame.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/12/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossCellFrame.h"
#import "NSString+textStringToSize.h"
@implementation BossCellFrame
-(void)setBossModel:(BossModel *)bossModel{
    _bossModel = bossModel;
    NSString *subString =  bossModel.subStr;
    NSString *locationStr = bossModel.locationStr;
    NSString *companyNameString =  bossModel.companyNameStr;
    CGFloat leftMargin = 15*AUTO_SIZE_SCALE_X;
    CGFloat topMargin = 15*AUTO_SIZE_SCALE_X;
    CGFloat leftMargin1 = 100*AUTO_SIZE_SCALE_X;
    
    _headFrame = CGRectMake(leftMargin, topMargin, 75*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X);
    
    _bossFlagFrame = CGRectMake(68*AUTO_SIZE_SCALE_X, 68*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X);
    
    _nameAndJobFrame = CGRectMake(leftMargin1, topMargin, kScreenWidth - leftMargin1 -10*AUTO_SIZE_SCALE_X -75*AUTO_SIZE_SCALE_X, 22.5*AUTO_SIZE_SCALE_X);
    
    _directChatFrame = CGRectMake(kScreenWidth - 75*AUTO_SIZE_SCALE_X, topMargin, 60*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);
                        
    CGSize subSize = [NSString sizeWithText:subString maxSize:CGSizeMake(kScreenWidth - leftMargin1 -10*AUTO_SIZE_SCALE_X - 75*AUTO_SIZE_SCALE_X, MAXFLOAT) font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
    _subFame = CGRectMake(leftMargin1,
                                  CGRectGetMaxY(_nameAndJobFrame) +1*AUTO_SIZE_SCALE_X,
                                  subSize.width,
                                  subSize.height);
    
    _locationFrame = CGRectMake(leftMargin1, CGRectGetMaxY(_subFame) +11.5*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
    
    CGSize locationStrSize = [NSString sizeWithText:locationStr maxSize:CGSizeMake(kScreenWidth - CGRectGetMaxX(_locationFrame) -77*AUTO_SIZE_SCALE_X -20*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
    _locationStrFrame = CGRectMake(CGRectGetMaxX(_locationFrame),
                                   CGRectGetMaxY(_subFame) +10*AUTO_SIZE_SCALE_X,
                                   locationStrSize.width,
                                   locationStrSize.height);
    
    _tradeFrame = CGRectMake(CGRectGetMaxX(_locationStrFrame) + 20*AUTO_SIZE_SCALE_X, _locationFrame.origin.y, 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
    
    _tradeStrFrame = CGRectMake(CGRectGetMaxX(_tradeFrame), _locationStrFrame.origin.y, kScreenWidth - CGRectGetMaxX(_tradeFrame) -15*AUTO_SIZE_SCALE_X, _locationStrFrame.size.height);
    
    _lineFrame = CGRectMake(leftMargin1,
                            CGRectGetMaxY(_locationFrame)+14.5*AUTO_SIZE_SCALE_X,
                            kScreenWidth - leftMargin1, 0.5*AUTO_SIZE_SCALE_X);
    
    _companyPicFrame = CGRectMake(leftMargin1, CGRectGetMaxY(_lineFrame)+10*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X);
    
    CGSize companyNameSize = [NSString sizeWithText:companyNameString maxSize:CGSizeMake(
                            kScreenWidth - 144*AUTO_SIZE_SCALE_X - 10*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
    _companyNameFrame = CGRectMake(144*AUTO_SIZE_SCALE_X , CGRectGetMaxY(_lineFrame) +8*AUTO_SIZE_SCALE_X, companyNameSize.width, companyNameSize.height);
    
    _identifyIconFrame = CGRectMake(CGRectGetMaxX(_companyNameFrame) + 10*AUTO_SIZE_SCALE_X, CGRectGetMaxY(_lineFrame) +9*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    
    _companySubFrame = CGRectMake(144*AUTO_SIZE_SCALE_X , CGRectGetMaxY(_companyNameFrame)+1*AUTO_SIZE_SCALE_X,
                                  kScreenWidth - CGRectGetMaxX(_companyPicFrame) - 10*AUTO_SIZE_SCALE_X -15*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X);
    
    _bgviewFrame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_companyPicFrame) + 10*AUTO_SIZE_SCALE_X);
    
    _rowHeight = CGRectGetMaxY(_bgviewFrame) + 10*AUTO_SIZE_SCALE_X;
}

@end
