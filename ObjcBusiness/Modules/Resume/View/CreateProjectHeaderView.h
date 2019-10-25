//
//  CreateProjectHeaderView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeView.h"
#import "CDZBaseCell.h"

@interface CreateProjectHeaderView : CDZBaseCell

@property (nonatomic,strong) ResumeView *resumeView;
@property (nonatomic,strong) UIView *projectBgView;
@property (nonatomic,strong) UIImageView *projectImageView;
@property (nonatomic,strong) UILabel *projectLabel;

- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem;
@end

