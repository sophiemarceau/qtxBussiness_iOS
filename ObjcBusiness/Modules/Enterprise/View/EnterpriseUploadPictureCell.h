//
//  EnterpriseUploadPictureCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CompanyBaseCell.h"

@interface EnterpriseUploadPictureCell : CompanyBaseCell
@property (nonatomic, strong) UILabel *functionLabel;
@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UIImageView *headBGView;
@property (nonatomic,strong)UILabel *headBGLabel;

- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem;
@end
