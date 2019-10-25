//
//  CompanyBaseCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CompanyBaseCell.h"

@implementation CompanyBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(EnterpriseItem *)object{
    return 44.f;
}


- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem{
    
    
}

@end
