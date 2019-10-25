//
//  SearchHeaderView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/3.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHeaderView : UIView
@property(nonatomic,strong)UIImageView *searchImageView;
@property(nonatomic,strong)UILabel *searchLabel;
@property(nonatomic,strong)UIButton *cancelButton;

-(void)setsearchContent:(NSString *)searchContent;
@end
