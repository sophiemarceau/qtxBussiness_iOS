//
//  YXTabTitleView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTabTitleView : UIView
-(instancetype)initWithTitleArray:(NSArray *)titleArray;

-(void)setItemSelected: (NSInteger)column;

/**
 *  定义点击的block
 *
 *  @param NSInteger 点击column数
 */
typedef void (^YXTabTitleClickBlock)(NSInteger);

@property (nonatomic, strong) YXTabTitleClickBlock titleClickBlock;

@end
