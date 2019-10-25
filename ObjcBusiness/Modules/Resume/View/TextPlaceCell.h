//
//  TextPlaceCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CDZBaseCell.h"
#import "ResumeTableItem.h"

@interface TextPlaceCell : CDZBaseCell
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UILabel *placeNameLabel;
@property (nonatomic, strong) UIView *tagViews;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *placeImageView;
- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem;
@end
