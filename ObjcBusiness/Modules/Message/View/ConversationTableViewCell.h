//
//  ConversationTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/21.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ConversationTableViewCell : RCConversationBaseCell
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *companyAndJobLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *messageSketchLabel;
@property(nonatomic, strong) UILabel *bubbleLabel;

@end

