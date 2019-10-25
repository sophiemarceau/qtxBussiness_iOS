//
//  LabelTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CDZBaseCell.h"
#import "ResumeTableItem.h"
@interface LabelTableViewCell : CDZBaseCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) UITextField *ValueLabel;
@property (nonatomic, strong) UIImageView *lineImageView;


- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem;
@end
