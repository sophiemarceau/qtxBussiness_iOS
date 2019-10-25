//
//  DetailTextViewTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CDZBaseCell.h"
#import "ResumeTableItem.h"
#import "UITextView+ZWPlaceHolder.h"
@interface DetailTextViewTableViewCell : CDZBaseCell
@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIImageView *lineImageView;
@property (nonatomic,strong) UITextView * remarksTextView;
@property (nonatomic,strong) UIView *remarksbgView;
- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem;
@end
