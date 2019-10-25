//
//  BossTableViewCell+BossCellFrame.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/14.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossTableViewCell+BossCellFrame.h"
#import "BossCellFrame.h"
#import "BossModel.h"
#import "UIImageView+WebCache.h"
@implementation BossTableViewCell (BossCellFrame)
- (void)configureWithListEntity:(BossCellFrame *)bosscellFrame{
    
    self.CellBGView.frame = bosscellFrame.bgviewFrame;
    self.headImageView.frame = bosscellFrame.headFrame;
    self.bossFlagImageView.frame = bosscellFrame.bossFlagFrame;
    self.nameAndJobLabel.frame = bosscellFrame.nameAndJobFrame;
    self.directChatImageView.frame = bosscellFrame.directChatFrame;
    self.subLabel.frame = bosscellFrame.subFame;
    self.locationLabel.frame = bosscellFrame.locationStrFrame;
    self.locationImageView.frame = bosscellFrame.locationFrame;
    self.tradeLabel.frame = bosscellFrame.tradeStrFrame;
    self.tradeImageView.frame = bosscellFrame.tradeFrame;
    self.lineImageView.frame = bosscellFrame.lineFrame;
    self.companyPicImageView.frame = bosscellFrame.companyPicFrame;
    self.companyNameLabel.frame = bosscellFrame.companyNameFrame;
    self.companySubLabel.frame = bosscellFrame.companySubFrame;
    self.identifyIconImageView.frame = bosscellFrame.identifyIconFrame;

    BossModel *bossModel = bosscellFrame.bossModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:bossModel.headStr] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    self.nameAndJobLabel.text = bossModel.nameAndJobStr;
    self.subLabel.text = bossModel.subStr;
    self.locationLabel.text = bossModel.locationStr;
    self.tradeLabel.text = bossModel.tradeStr;
    self.companyNameLabel.text = bossModel.companyNameStr;
    [self.companyPicImageView sd_setImageWithURL:[NSURL URLWithString:bossModel.companyUrlStr] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
     self.companySubLabel.text = bossModel.companySubStr;
    //企业用户、代理人是否认证；0，没有认证；1，已认证；
    if (bossModel.bossFlag == 1) {
        self.bossFlagImageView.hidden = NO;
    }else{
        self.bossFlagImageView.hidden = YES;
    }
    //project_authentication：项目认证：项目认证：0、未认证；1、提交认证；2、认证未通过；3、通过认证；
    if (bossModel.officialFlag == 3) {
        self.identifyIconImageView.hidden = NO;
    }else{
        self.identifyIconImageView.hidden = YES;
    }
    self.user_id_str = bossModel.user_id_str;
    self.directChatImageView.tag = [bossModel.user_id_str integerValue];
    self.userID = bossModel.bossID;
  
    self.bossName = bossModel.bossName;
    
    
    
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
