//
//  HomeListTableViewCell+HomeListModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "HomeListTableViewCell+HomeListModel.h"
#import "UIImageView+WebCache.h"
@implementation HomeListTableViewCell (HomeListModel)

- (void)configureWithHomeListEntity:(NSDictionary *)homeListModel{
//    NSLog(@"homeListModel------>%@",homeListModel);
    [self.bgroundView addSubview:self.titleLabel];
    self.titleLabel.text = homeListModel[@"project_name"];
    self.subLabel.text = homeListModel[@"project_slogan"];
    [self.picImageView sd_setImageWithURL:homeListModel[@"project_cover_pic"] placeholderImage:nil];
    [self.headImageView sd_setImageWithURL:homeListModel[@"userCSimpleInfoDto"][@"c_photo"] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    self.nameLabel.text = homeListModel[@"userCSimpleInfoDto"][@"c_realname"];
    self.postionDesLabel.text = [NSString stringWithFormat:@"%@  | %@",homeListModel[@"userCSimpleInfoDto"][@"c_jobtitle"],homeListModel[@"companyDto"][@"company_name"]];
    NSString *string = [NSString stringWithFormat:@"%@",homeListModel[@"modeAmountName"]];
    NSString *str = [NSString stringWithFormat:@"投入%@",string];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    self.investLabel.textColor =UIColorFromRGB(0x333333);
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X]  range:NSMakeRange(2,[string length])];
    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(2,[string length])];
    self.investLabel.attributedText = mutablestr;
    NSMutableArray *labelArray = [NSMutableArray arrayWithCapacity:0];
    int trueflag =  [homeListModel[@"project_authentication"] intValue];
    int project_recommend = [homeListModel[@"project_recommend"] intValue];
    int project_default_compensation = [homeListModel[@"project_default_compensation"] intValue];
    
    
//    NSLog(@"trueflag------>%d",trueflag);
//    NSLog(@"project_recommend------>%d",project_recommend);
//    NSLog(@"project_default_compensation------>%d",project_default_compensation);
//    NSLog(@"project_name---------->%@",homeListModel[@"project_name"]);
    
 
    
    
    
    if (trueflag != 3 ) {
        
        [labelArray addObject: @"未认证"];
        
    }else{
        
        [labelArray addObject: @"官方认证"];
        
        
        
    }
    
    [labelArray addObject: @"精品推荐"];
    
    
    [labelArray addObject:@"违约赔付"];
    
    
    NSLog(@"labelArray------>%ld",labelArray.count);
    for (int i = 0; i<labelArray.count; i++) {
        UILabel *tempLabel = [UILabel new];
        tempLabel.layer.borderColor = UIColorFromRGB(0xAB6A00).CGColor;
        tempLabel.layer.masksToBounds = YES;
        tempLabel.layer.borderWidth = 1;
        tempLabel.layer.cornerRadius = 2;
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.font = [UIFont systemFontOfSize:9];
        tempLabel.textColor = UIColorFromRGB(0xAB6A00);
        tempLabel.text = labelArray[i];
        [self.tagView addSubview:tempLabel];
        if (i == 0) {
            tempLabel.frame = CGRectMake(0*AUTO_SIZE_SCALE_X, 0*(AUTO_SIZE_SCALE_X), 40*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
            if (trueflag != 3 ) {
                
                tempLabel.alpha = 0.5;
                
            }
        }
        if (i == 1) {
            tempLabel.frame = CGRectMake(52*AUTO_SIZE_SCALE_X, 0*(AUTO_SIZE_SCALE_X), 40*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
            if (project_recommend != 1 ) {
                tempLabel.hidden = YES;
            }
        }
        if (i == 2) {
            tempLabel.frame = CGRectMake((80+24)*AUTO_SIZE_SCALE_X, 0*(AUTO_SIZE_SCALE_X), 40*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
            if (project_default_compensation != 1 ) {
                tempLabel.hidden = YES;
            }
        }
    }
    //is_certification：企业用户是否认证；0，没有认证；1，已认证；
    
    NSInteger is_certification = [homeListModel[@"userCSimpleInfoDto"][@"is_certification"] intValue];
//    if (userPosition_code == 0) {
//        self.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_expert_certification"];
//    }
    
    if (is_certification == 1) {
        self.headerFlagImageView.image = [UIImage imageNamed:@"project_icon_authentication_blue"];
    }else{
        self.headerFlagImageView.image = [UIImage imageNamed:@"project_icon_authentication_black"];
    }
    
   
    
}
@end
