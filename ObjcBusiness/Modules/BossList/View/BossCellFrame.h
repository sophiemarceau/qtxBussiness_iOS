//
//  BossCellFrame.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/12/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BossModel.h"

@interface BossCellFrame : NSObject
@property(nonatomic,strong)BossModel *bossModel;
@property(nonatomic,assign,readonly) CGRect bgviewFrame;
@property(nonatomic,assign,readonly) CGRect headFrame;
@property(nonatomic,assign,readonly) CGRect nameAndJobFrame;
@property(nonatomic,assign,readonly) CGRect subFame;
@property(nonatomic,assign,readonly) CGRect locationFrame;
@property(nonatomic,assign,readonly) CGRect locationStrFrame;
@property(nonatomic,assign,readonly) CGRect directChatFrame;
@property(nonatomic,assign,readonly) CGRect tradeFrame;
@property(nonatomic,assign,readonly) CGRect tradeStrFrame;
@property(nonatomic,assign,readonly) CGRect lineFrame;
@property(nonatomic,assign,readonly) CGRect companyPicFrame;
@property(nonatomic,assign,readonly) CGRect companyNameFrame;
@property(nonatomic,assign,readonly) CGRect identifyIconFrame;
@property(nonatomic,assign,readonly) CGRect companySubFrame;
@property(nonatomic,assign,readonly) CGRect bossFlagFrame;


@property(nonatomic,assign,readonly)CGFloat rowHeight;
@end
