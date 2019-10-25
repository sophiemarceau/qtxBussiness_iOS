//
//  ChannelCollectionViewCell.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/11/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ChannelCollectionViewCell.h"

@implementation ChannelCollectionViewCell
//创建自定义cell时调用该方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.channelLabel];
    }
    return self;
}

- (UILabel *)channelLabel {
    if (_channelLabel == nil) {
        _channelLabel = [[UILabel alloc] init];
        _channelLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        _channelLabel.textColor = FontUIColorBlack;
        _channelLabel.textAlignment = NSTextAlignmentCenter;
        _channelLabel.frame = CGRectMake(25*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X ,150*AUTO_SIZE_SCALE_X, ceilf(34*AUTO_SIZE_SCALE_X));
        _channelLabel.backgroundColor = UIColorFromRGB(0xf4f5f7);
        _channelLabel.layer.cornerRadius = ceilf(17*AUTO_SIZE_SCALE_X);
        _channelLabel.layer.masksToBounds = YES;
    }
    return _channelLabel;
}
@end
