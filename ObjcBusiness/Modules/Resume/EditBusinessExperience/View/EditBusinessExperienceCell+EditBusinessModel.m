//
//  EditBusinessExperienceCell+EditBusinessModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EditBusinessExperienceCell+EditBusinessModel.h"

@implementation EditBusinessExperienceCell (EditBusinessModel)
- (void)configureWithListEntity:(EditBusinessModel *)tempModel{
    self.titleLabel.text = tempModel.functionnameStr;
    self.contentTextField.placeholder = tempModel.placenameStr;
    self.contentTextField.text = tempModel.contentStr;
    if ([tempModel.functionnameStr isEqualToString:@"客流量（选填）"]) {
        self.lineImageView.hidden = YES;
    }
    if ([tempModel.functionnameStr isEqualToString:@"希望合作模式（选填）"]) {
        self.lineImageView.hidden = YES;
    }
    if (tempModel.isEditTextField) {
        self.contentTextField.userInteractionEnabled =YES;
    }

}
@end
