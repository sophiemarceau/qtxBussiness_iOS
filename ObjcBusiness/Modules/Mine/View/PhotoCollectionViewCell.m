//
//  PhotoCollectionViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

//懒加载创建数据
-(UIImageView *)photoV{
    if (_photoV == nil) {
        self.photoV = [[UIImageView alloc]initWithFrame:self.bounds];
        self.photoV.userInteractionEnabled = YES;
        [self.photoV setContentMode:UIViewContentModeScaleAspectFill];
        self.photoV.clipsToBounds = YES;
    }
    return _photoV;
}

-(UIImageView *)cancelImageView{
    if (_cancelImageView == nil) {
        self.cancelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-18*AUTO_SIZE_SCALE_X, (0)*AUTO_SIZE_SCALE_X,18*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X)];
        self.cancelImageView.image =[UIImage imageNamed:@"me_resume_icon_shop_pic_delete"];
        self.cancelImageView.userInteractionEnabled = YES;
    }
    return _cancelImageView;
}


//创建自定义cell时调用该方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoV];
        [self.photoV addSubview:self.cancelImageView];
        
    }
    return self;
}
@end
