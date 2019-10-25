//
//  ProjectMessageCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProjectMessageCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *messageCountLabel;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UIImageView *lineImageView;
@end
