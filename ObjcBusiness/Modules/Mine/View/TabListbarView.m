//
//  TabListbarView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "TabListbarView.h"
typedef NS_ENUM(NSUInteger, HeaderButtonType) {
    browseButtonTag,
    CollectionButtonTag,
    dealButttonTag,
};
@implementation TabListbarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initViews];
    }
    return self;
}

-(void)setLabelText:(NSArray *)numberArray{
    for (int i = 0;  i < self.self.subLabelviews.count ; i++) {
        UILabel *label = self.subLabelviews[i];
        label.text = [NSString stringWithFormat:@"%d",[[numberArray objectAtIndex:i] intValue] ];
    }
}

-(void)initViews{
    self.subLabelviews = [NSMutableArray array];
    self.labeltextArray = [NSArray arrayWithObjects:@"收到的赞", @"关注的人", @"粉丝", nil];
    self.backgroundColor = [UIColor whiteColor];
    float with = kScreenWidth/self.labeltextArray.count;
    for (int i = 0;  i < self.labeltextArray.count ; i++) {
        //设置自定义按钮
        UIButton * view = [[UIButton alloc]initWithFrame:CGRectMake( i*with, 0, with, 78*AUTO_SIZE_SCALE_X)];
        [view addTarget:self action:@selector(ViewTaped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            view.tag = browseButtonTag;
        }
        if (i == 1) {
            view.tag = CollectionButtonTag;
        }
        if (i == 2) {
            view.tag = dealButttonTag;
        }
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*AUTO_SIZE_SCALE_X, with, 16*AUTO_SIZE_SCALE_X)];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        titleLabel.textColor =  FontUIColorBlack;
        [view addSubview:titleLabel];
        
        UILabel * numberlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 46*AUTO_SIZE_SCALE_X, with, 12*AUTO_SIZE_SCALE_X)];
        numberlabel.textAlignment = NSTextAlignmentCenter;
        numberlabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        numberlabel.textColor = FontUIColor999999Gray;
        numberlabel.text = [self.labeltextArray objectAtIndex:i];
        numberlabel.tag = i;
        [view addSubview:numberlabel];
        [self.subLabelviews addObject:titleLabel];
        if (i != self.labeltextArray.count-1) {
            UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(with-1, 26.5, 0.5, 25)];
            imv.backgroundColor = lineImageColor;
            [view addSubview:imv];
        }
        [self addSubview:view];
    }
    
}

-(void)ViewTaped:(UIButton *)sender{
    [self.barlistButtonDelegate ButtonDidSelected:sender];
}
@end
