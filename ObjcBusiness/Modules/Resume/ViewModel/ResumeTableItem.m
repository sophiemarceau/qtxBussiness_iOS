//
//  ResumeTableItem.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ResumeTableItem.h"
#import "TextWithLineCell.h"
#import "TextWithMarginCell.h"
#import "TextWthInputFieldCell.h"
#import "TextPlaceCell.h"
#import "DetailTextViewTableViewCell.h"
#import "CreateProjectHeaderView.h"
#import "LabelTableViewCell.h"
#import "TextFieldBaseCell.h"
@implementation ResumeTableItem
- (NSString *)cellIdentifier
{
    if (_showtype == ResumSelectText) {
        return NSStringFromClass([TextWithLineCell class]);
    } else if (_showtype == ResumInput){
        return NSStringFromClass([TextWthInputFieldCell class]);
    }else if (_showtype == ResumSelectPlace){
        return NSStringFromClass([TextPlaceCell class]);
    }else if(_showtype == ResumePersonalInfo){
        return NSStringFromClass([TextPlaceCell class]);
    }else if (_showtype == TextViewInput){
        return NSStringFromClass([DetailTextViewTableViewCell class]);
    }else if (_showtype == ProjectPicUpload){
        return NSStringFromClass([CreateProjectHeaderView class]);
    }else if (_showtype == LabelText){
        return NSStringFromClass([LabelTableViewCell class]);
    }else if (_showtype == TextFieldText){
        return NSStringFromClass([TextFieldBaseCell class]);
    }else {
        return NSStringFromClass([TextWithMarginCell class]);
    }
}
@end
