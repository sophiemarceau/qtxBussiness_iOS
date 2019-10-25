//
//  ResumePersonalInfoCell.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/9/10.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CDZBaseCell.h"

@interface ResumePersonalInfoCell : CDZBaseCell
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *userNameLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *oneMoreIntroduceLabel;
- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem;
@end
