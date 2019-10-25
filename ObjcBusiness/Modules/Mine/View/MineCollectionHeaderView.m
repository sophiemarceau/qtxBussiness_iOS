//
//  MineCollectionHeaderView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MineCollectionHeaderView.h"
#import "HeaderView.h"
#import "TabListbarView.h"
@implementation MineCollectionHeaderView


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
    [self addSubview:self.headerView];
    [self addSubview:self.tabbarView];

}

-(void)layoutSubviews{
    
    _headerView.frame = CGRectMake(0, self.resumeView.frame.size.height, kScreenWidth, (85)*AUTO_SIZE_SCALE_X);
    _tabbarView.frame = CGRectMake(0, self.resumeView.frame.size.height+_headerView.frame.size.height, kScreenWidth, (78)*AUTO_SIZE_SCALE_X);
    self.frame = CGRectMake(0, 0, kScreenWidth, self.resumeView.frame.size.height+(85+78+10)*AUTO_SIZE_SCALE_X);
    
    
}

#pragma mark - Getter

- (ResumeView *)resumeView{
    if (_resumeView == nil) {
        _resumeView = [ResumeView new];
        _resumeView.backgroundColor = UIColorFromRGB(0xFFF7A8);
        _resumeView.frame = CGRectMake(0, 0, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
//        UITapGestureRecognizer * NewViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NewGuideViewTaped:)];
        self.resumeView.userInteractionEnabled = YES;
//        [self.resumeView addGestureRecognizer:NewViewtap];
//        [self.resumeView.resumeButton addTarget:self action:@selector(NewGuideViewTaped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resumeView;
}

- (HeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [HeaderView new];
        _headerView.backgroundColor = [UIColor whiteColor];
        
    }
    return _headerView;
}


-(TabListbarView *)tabbarView{
    if (_tabbarView == nil ) {
        _tabbarView = [[TabListbarView alloc] initWithFrame:CGRectZero];
    }
    return _tabbarView;
}
@end
