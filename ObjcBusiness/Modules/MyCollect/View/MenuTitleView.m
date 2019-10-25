//
//  MenuTitleView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MenuTitleView.h"

@interface MenuTitleView ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleBtnArray;
@property (nonatomic, strong) UIView  *indicateLine;
@end

@implementation MenuTitleView

-(instancetype)initWithTitleArray:(NSArray *)titleArray{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titleArray = titleArray;
        _titleBtnArray = [NSMutableArray array];
        
        self.frame = CGRectMake(0, 0, kScreenWidth, 44*AUTO_SIZE_SCALE_X);
        CGFloat btnWidth = kScreenWidth/titleArray.count;
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, 44*AUTO_SIZE_SCALE_X)];
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
            
        }
        _indicateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44*AUTO_SIZE_SCALE_X-1, kScreenWidth, 0.5*AUTO_SIZE_SCALE_X)];
        _indicateLine.backgroundColor = lineImageColor;
        [self addSubview:_indicateLine];
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
   
}

@end
