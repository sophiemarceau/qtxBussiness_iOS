//
//  SearchEnterpriseCell+SearchEnterpriseModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SearchEnterpriseCell+SearchEnterpriseModel.h"

@implementation SearchEnterpriseCell (SearchEnterpriseModel)
- (void)configureWithListEntity:(NSDictionary *)dic WithSelectKeyName:(NSString *)highStr{
    NSString *dataStr = dic[@"company_name"];
    
        NSRange range = [dataStr rangeOfString:highStr];
    
    
        NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:dataStr];
        [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:range];
    
        self.nameLabel.attributedText = mutablestr;
    if ([dic[@"company_agent_ca_status"] intValue] == 1) {
        self.flagBgView.hidden =NO;
        self.flagLabel.hidden  = NO;
        self.flagImageView.hidden = NO;
    }else{
        self.flagBgView.hidden =YES;
        self.flagLabel.hidden  = YES;
        self.flagImageView.hidden  = YES;
    }
    
}
@end
