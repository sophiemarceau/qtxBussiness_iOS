//
//  HeaderView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/25.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *userSubLabel;
@property(nonatomic,strong)UILabel *AttentLabel;
@property(nonatomic,strong)UILabel *personalPageLabel;


@property(nonatomic,strong)NSArray *labeltextArray;
@property(nonatomic,strong) NSMutableArray *subLabelviews;

@property(nonatomic,strong)UIImageView *expertFlagImageView;
@property(nonatomic,strong)UIImageView *companyFlagImageView;


@end
