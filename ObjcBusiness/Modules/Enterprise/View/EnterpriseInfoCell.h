//
//  EnterpriseInfoCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CompanyBaseCell.h"
#import "EnterpriseItem.h"
@class EnterpriseItem;
@interface EnterpriseInfoCell : CompanyBaseCell
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UITextField *ValueLabel;
@property (nonatomic, strong) EnterpriseItem *cellableItem;
- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem;
@end
