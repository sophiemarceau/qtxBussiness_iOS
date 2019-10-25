//
//  MyInfoView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MyInfoView.h"

@implementation MyInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)addExpertString:(NSString *)expertString addJobIdentify:(NSString *)jobStr{
    if (expertString !=nil) {
        [self addSubview:self.expertLabel];
//        self.expertLabel.text = expertString;
        self.expertLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 0, kScreenWidth-40*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
        NSString *expstr = [NSString stringWithFormat:@"专家认证：%@",expertString];
        NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:expstr];
        
        [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(0,5)];
        [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,5)];
        
        [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorBlack range:NSMakeRange(5,[expertString length])];
        [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(5,[expertString length])];
        self.expertLabel.attributedText = mutablestr;
    }
    if (jobStr != nil) {
        [self addSubview:self.jobLabel];
        
        if (expertString != nil) {
            self.jobLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.expertLabel.frame), kScreenWidth-40*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
        }else{
            self.jobLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X,0, kScreenWidth-40*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
        }
        NSString *jobString = [NSString stringWithFormat:@"职位已认证：%@",jobStr];
        NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:jobString];
        
        [mutablestr addAttribute:NSForegroundColorAttributeName value:blueLabelColor range:NSMakeRange(0,6)];
        [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(0,6)];
        
        [mutablestr addAttribute:NSForegroundColorAttributeName value:FontUIColorBlack range:NSMakeRange(6,[jobStr length])];
        [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]  range:NSMakeRange(6,[jobStr length])];
         self.jobLabel.attributedText = mutablestr;
    }
}

-(UILabel *)expertLabel{
    if (_expertLabel == nil) {
        _expertLabel = [[UILabel alloc]init];
        _expertLabel.textColor = FontUIColorGray;
        _expertLabel.textAlignment = NSTextAlignmentLeft;
        _expertLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
//        [CommentMethod createLabelWithText:@"" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:12*AUTO_SIZE_SCALE_X];
    }
    return _expertLabel;
}
-(UILabel *)jobLabel{
    if (_jobLabel == nil) {
        _jobLabel = [[UILabel alloc]init];
        _jobLabel.textColor = FontUIColorGray;
        _jobLabel.textAlignment = NSTextAlignmentLeft;
        _jobLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    }
    return _jobLabel;
}
@end
