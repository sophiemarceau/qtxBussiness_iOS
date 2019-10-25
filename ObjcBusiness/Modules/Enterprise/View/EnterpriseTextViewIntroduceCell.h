//
//  EnterpriseTextViewIntroduceCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CompanyBaseCell.h"
#import "UITextView+ZWPlaceHolder.h"
@interface EnterpriseTextViewIntroduceCell : CompanyBaseCell<UITextViewDelegate>
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UITextField *ValueLabel;
@property (nonatomic, strong) UITextView *introduceView;
@property (nonatomic, strong) UIView *remarksbgView;
@property (nonatomic, strong) EnterpriseItem *cellableItem;
- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem;
@end
