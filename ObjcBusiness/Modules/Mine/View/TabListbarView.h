//
//  TabListbarView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TaglistButtonDelegate <NSObject>

@optional




- (void)ButtonDidSelected:(UIButton *)tagBtn;



@end
@interface TabListbarView : UIView

@property(nonatomic,strong)NSArray *labeltextArray;
@property(nonatomic,strong) NSMutableArray *subLabelviews;

@property (weak, nonatomic) id<TaglistButtonDelegate> barlistButtonDelegate;

-(void)setLabelText:(NSArray *)numberArray;

@end
