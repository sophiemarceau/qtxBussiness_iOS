//
//  PersonTableViewCell+Data.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PersonTableViewCell+Data.h"
#import "UIImageView+WebCache.h"
@implementation PersonTableViewCell (Data)
- (void)configureWithListEntity:(NSDictionary *)mydictionary{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:mydictionary[@"c_photo"]] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    
    
    int userPosition_code = [mydictionary[@"userPosition_code"] intValue];
    NSString *nameString;
    NSMutableString *jobstr = [[NSMutableString alloc] initWithString:@""];
    NSInteger answer_is_anonymous  = [mydictionary[@"answer_is_anonymous"] integerValue];
    if (answer_is_anonymous ==1 ) {
        nameString = @"匿名用户";
        self.headerFlagImageView.hidden = NO;
    }else{
        if (userPosition_code == 0) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",mydictionary[@"c_expert_profiles"]]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_expert_certification"];
        }
        if (userPosition_code == 1) {
            NSString *jobString = mydictionary[@"c_jobtitle"];
            NSString *companyStr = mydictionary[@"company_name"];
            if (![jobString isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@"%@",jobString]];
            }
            if (![companyStr isEqualToString:@""]) {
                [jobstr appendString:[NSString stringWithFormat:@" | %@",companyStr]];
            }
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];
            
        }
        if (userPosition_code == 2) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",mydictionary[@"c_profiles"]]];
            self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_default"];
        }
        if (userPosition_code == 3) {
            [jobstr appendString:[NSString stringWithFormat:@"%@",mydictionary[@"c_profiles"]]];
            self.headerFlagImageView.hidden = YES;
        }else{
            self.headerFlagImageView.hidden = NO;
        }
        nameString =  mydictionary[@"c_nickname"];
    }
    self.jobDesLabel.text = jobstr;
    self.nameLabel.text = nameString;

}
@end
