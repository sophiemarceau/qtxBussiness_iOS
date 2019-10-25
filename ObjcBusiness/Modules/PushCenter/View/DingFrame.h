//
//  DingFrame.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/31.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DingModel.h"
#import "NSString+textStringToSize.h"

@interface DingFrame : NSObject
@property(nonatomic,assign,readonly)CGRect headFrame;
@property(nonatomic,assign,readonly)CGRect headFlagFrame;
@property(nonatomic,assign,readonly)CGRect nameFrame;
@property(nonatomic,assign,readonly)CGRect jobSubFrame;
@property(nonatomic,assign,readonly)CGRect commentFromFrame;
@property(nonatomic,assign,readonly)CGRect dingScoreFrame;
@property(nonatomic,assign,readonly)CGRect leftLabelFrame;
@property(nonatomic,assign,readonly)CGRect lineImageViewFrame;


@property(nonatomic,assign,readonly)CGFloat rowHeight;


@property(nonatomic,strong)DingModel *dingModel;
@end
