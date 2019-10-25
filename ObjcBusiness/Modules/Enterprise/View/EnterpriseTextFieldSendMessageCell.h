//
//  EnterpriseTextFieldSendMessageCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CompanyBaseCell.h"

@interface EnterpriseTextFieldSendMessageCell : CompanyBaseCell{
    NSInteger i;
}

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UITextField *ValueLabel;
@property (nonatomic, strong) UIButton *sendMessageButton;
@property (nonatomic, strong) EnterpriseItem *cellableItem;
@property (nonatomic, strong) UILabel *timeLabel;
@property(nonatomic,strong)NSTimer *timer;
- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem;
@end
