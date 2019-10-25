//
//  YXTabTitleView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "YXTabTitleView.h"
#import "YX.h"

@interface YXTabTitleView()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleBtnArray;
@property (nonatomic, strong) UIView  *indicateLine;

@end

@implementation YXTabTitleView

-(instancetype)initWithTitleArray:(NSArray *)titleArray{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titleArray = titleArray;
        _titleBtnArray = [NSMutableArray array];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTabTitleViewHeight*AUTO_SIZE_SCALE_X);
        CGFloat btnWidth = SCREEN_WIDTH/titleArray.count;
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, kTabTitleViewHeight*AUTO_SIZE_SCALE_X)];
            btn.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
            [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
            if (i==0) {
                [btn setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:FontUIColorGray forState:UIControlStateNormal];
            }
            
            
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:btn];
            [_titleBtnArray addObject:btn];
            UIImageView *verticalLineImageView ;
            if (i != 2){
                verticalLineImageView = [UIImageView new];
                verticalLineImageView.frame = CGRectMake(btnWidth+i*btnWidth, 16*AUTO_SIZE_SCALE_X, 0.5, 12*AUTO_SIZE_SCALE_X);
                verticalLineImageView.backgroundColor = lineImageColor;
                [self addSubview:verticalLineImageView];
            }
        }
        
        //        _indicateLine = [[UIView alloc] initWithFrame:CGRectMake(25, kTabTitleViewHeight*AUTO_SIZE_SCALE_X-1, btnWidth-50, 1)];
        //        _indicateLine.backgroundColor = RedUIColorC1;
        //        [self addSubview:_indicateLine];
    }
    return self;
}

-(void)clickBtn : (UIButton *)btn{
    NSInteger tag = btn.tag;
    [self setItemSelected:tag];
    
    if (self.titleClickBlock) {
        self.titleClickBlock(tag);
    }
}

-(void)setItemSelected: (NSInteger)column{
    for (int i=0; i<_titleBtnArray.count; i++) {
        UIButton *btn = _titleBtnArray[i];
        if (i==column) {
            [btn setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:FontUIColorGray forState:UIControlStateNormal];
        }
    }
    CGFloat btnWidth = SCREEN_WIDTH/_titleBtnArray.count;
    _indicateLine.frame = CGRectMake(25+btnWidth*column, kTabTitleViewHeight*AUTO_SIZE_SCALE_X-2, btnWidth-50, 2);
}

@end
