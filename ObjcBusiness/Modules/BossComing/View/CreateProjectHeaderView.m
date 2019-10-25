//
//  CreateProjectHeaderView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CreateProjectHeaderView.h"

@implementation CreateProjectHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = BGColorGray;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    [self addSubview:self.resumeView];
    [self addSubview:self.projectBgView];
    [self.projectBgView addSubview:self.projectImageView];
    [self.projectBgView addSubview:self.projectLabel];
}

-(void)layoutSubviews{
    _projectBgView.frame = CGRectMake(0, self.resumeView.frame.size.height, kScreenWidth, (155)*AUTO_SIZE_SCALE_X);
    self.frame = CGRectMake(0, 0, kScreenWidth, self.resumeView.frame.size.height+(155+10)*AUTO_SIZE_SCALE_X);
}

#pragma mark - Getter
- (ResumeView *)resumeView{
    if (_resumeView == nil) {
        _resumeView = [ResumeView new];
        _resumeView.backgroundColor = UIColorFromRGB(0xFFF7A8);
        _resumeView.frame = CGRectMake(0, 0, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
        //        UITapGestureRecognizer * NewViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NewGuideViewTaped:)];
        self.resumeView.userInteractionEnabled = YES;
        _resumeView.resumeTitleLabel.text = @"提交后客服将会在一个工作日内完成审核";
        //        [self.resumeView addGestureRecognizer:NewViewtap];
        //        [self.resumeView.resumeButton addTarget:self action:@selector(NewGuideViewTaped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resumeView;
}

-(UIView *)projectBgView{
    if (_projectBgView == nil) {
        _projectBgView = [UIView new];
        _projectBgView.backgroundColor = [UIColor whiteColor];
    }
    return _projectBgView;
}


-(UIImageView *)projectImageView{
    if (_projectImageView == nil) {
        _projectImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settled_icon_add_logo"]];
        _projectImageView.frame = CGRectMake((kScreenWidth-100*AUTO_SIZE_SCALE_X)/2, 15*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X);
    }
    return _projectImageView;
}


-(UILabel *)projectLabel{
    if (_projectLabel == nil) {
        _projectLabel = [CommentMethod initLabelWithText:@"上传项目logo" textAlignment:NSTextAlignmentCenter font:14 TextColor:FontUIColorBlack];
        _projectLabel.frame = CGRectMake(0, CGRectGetMaxY(self.projectImageView.frame)+10*AUTO_SIZE_SCALE_X, kScreenWidth, 20*AUTO_SIZE_SCALE_X);
    }
    return _projectLabel;
}
@end
