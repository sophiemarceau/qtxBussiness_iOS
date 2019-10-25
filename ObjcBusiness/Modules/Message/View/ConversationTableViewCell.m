//
//  ConversationTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/21.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ConversationTableViewCell.h"

@implementation ConversationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _headImageView = [UIImageView new];
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = 5.0f;
        if ([[RCIM sharedRCIM] globalConversationAvatarStyle] ==
            RC_USER_AVATAR_CYCLE) {
            _headImageView.layer.cornerRadius = 25*AUTO_SIZE_SCALE_X;
        }
        
        [_headImageView setBackgroundColor:[UIColor clearColor]];
        
        _nameLabel = [UILabel new];
        [_nameLabel setFont:[UIFont systemFontOfSize:18.f*AUTO_SIZE_SCALE_X]];
        [_nameLabel setTextColor:FontUIColorBlack];
         _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"";
//        [NSString stringWithFormat:@"%", _userName];
        
        _companyAndJobLabel = [[UILabel alloc] init];
        _companyAndJobLabel.backgroundColor = [UIColor clearColor];
        _companyAndJobLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _companyAndJobLabel.textColor = FontUIColorBlack;
        _companyAndJobLabel.textAlignment = NSTextAlignmentLeft;
        _companyAndJobLabel.text = @"";
        //        [NSString stringWithFormat:@"%", _userName];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _timeLabel.textColor = FontUIColor999999Gray;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"";
         //        [NSString stringWithFormat:@"%", _userName];
        
        _messageSketchLabel = [UILabel new];
        [_messageSketchLabel setFont:[UIFont systemFontOfSize:14.f*AUTO_SIZE_SCALE_X]];
        [_messageSketchLabel setTextColor:FontUIColor999999Gray];
        _messageSketchLabel.textAlignment = NSTextAlignmentLeft;
        _messageSketchLabel.text = @"";
        //        [NSString stringWithFormat:@"%", _userName];
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_companyAndJobLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_messageSketchLabel];
//         [_headImageView setBackgroundColor:[UIColor blackColor]];
//         [_nameLabel setBackgroundColor:[UIColor redColor]];
//         [_companyAndJobLabel setBackgroundColor:[UIColor orangeColor]];
//         [_timeLabel setBackgroundColor:[UIColor blueColor]];
//        [_messageSketchLabel setBackgroundColor:[UIColor brownColor]];
        
        _headImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
        _nameLabel.frame = CGRectMake(75*AUTO_SIZE_SCALE_X, 12.5, 72*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
        _companyAndJobLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+10*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, kScreenWidth-(CGRectGetMaxX(_nameLabel.frame)+10*AUTO_SIZE_SCALE_X)-58*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
        _timeLabel.frame = CGRectMake(kScreenWidth-55*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X);
        _messageSketchLabel.frame = CGRectMake(75*AUTO_SIZE_SCALE_X,37.5*AUTO_SIZE_SCALE_X, 240*AUTO_SIZE_SCALE_X,20*AUTO_SIZE_SCALE_X);
    }
    return self;
}


@end
