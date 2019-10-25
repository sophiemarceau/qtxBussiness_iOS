//
//  DetailTableCellFrame.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailCellModel.h"

@interface DetailTableCellFrame : NSObject
@property(nonatomic,strong)DetailCellModel *questModel;

@property(nonatomic,assign,readonly)CGRect headFrame;
@property(nonatomic,assign,readonly)CGRect headFlagFrame;
@property(nonatomic,assign,readonly)CGRect nameFrame;
@property(nonatomic,assign,readonly)CGRect jobSubFrame;
@property(nonatomic,assign,readonly)CGRect questContentFrame;
@property(nonatomic,assign,readonly)CGRect leftLabelFrame;
@property(nonatomic,assign,readonly)CGRect rightLabelFrame;
@property(nonatomic,assign,readonly)CGRect questCellContentFrame;


@property(nonatomic,assign,readonly)CGFloat rowHeight;

@end
