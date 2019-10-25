//
//  SystemTableItem.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SystemTableItem.h"
#import "SystemMessageTableViewCell.h"
#import "SystemLabelCellTableViewCell.h"
@implementation SystemTableItem
- (NSString *)cellIdentifier
{
    if (_showtype == SystemPicMessage) {
        return NSStringFromClass([SystemMessageTableViewCell class]);
    }else{
        return NSStringFromClass([SystemLabelCellTableViewCell class]);
    }
}
@end
