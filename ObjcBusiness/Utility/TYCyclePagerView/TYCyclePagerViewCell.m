//
//  TYCyclePagerViewCell.m
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell ()
@property (nonatomic, weak) UILabel *label;
@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addImgeView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addImgeView];
    }
    return self;
}


- (void)addImgeView {
    
    UIImageView *cycleImageView = [[UIImageView alloc] init];
    [self addSubview:cycleImageView];
    _cycleImageView = cycleImageView;
    
  }

- (void)layoutSubviews {
    [super layoutSubviews];
    _cycleImageView.frame = self.bounds;
}

@end
