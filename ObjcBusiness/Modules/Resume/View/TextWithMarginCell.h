//
//  TextWithMarginCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//


#import "CDZBaseCell.h"
#import "ResumeTableItem.h"

@interface TextWithMarginCell : CDZBaseCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) UILabel *ValueLabel;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;

- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem;

@end
