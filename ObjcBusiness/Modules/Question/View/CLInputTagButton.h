//
//  CLInputTagButton.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLInputTagButton;

@protocol CLInputTagButtonDelegate <NSObject>

// 菜单栏删除按钮回调
- (void)tagButtonDelete:(CLInputTagButton *)tagBtn;

// 展示标签页displayTagView 上的标签点击事件(状态变化已经在内部处理)
- (void)tagButtonDidSelected:(CLInputTagButton *)tagBtn;

// 最近标签页resentTagView  上的标签点击事件
- (void)recentTagButtonClick:(CLInputTagButton *)tagBtn;

@end

@interface CLInputTagButton : UIButton

// 初始化标签展示页的标签(上半部分标签)
- (instancetype)initWithTextField:(UITextField *)textField;

// 初始化最近标签页的标签(下半部分标签)
+ (instancetype)initWithTagDesc:(NSString *)tagStr;

@property (weak, nonatomic) id<CLInputTagButtonDelegate> tagBtnDelegate;

/**
 最近标签展示页的标签是否被选中
 */
@property (assign, nonatomic) BOOL tagSelected;

/**
 判断标签展示页中前后两次点击的标签是否为自己，用于“删除菜单栏的显示与否”
 */
@property (assign, nonatomic) BOOL isNotSelf;
@end
