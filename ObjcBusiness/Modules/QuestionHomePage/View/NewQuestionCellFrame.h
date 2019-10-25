//
//  NewQuestionCellFrame.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewQuestionModel.h"
#import "NSString+textStringToSize.h"

@interface NewQuestionCellFrame : NSObject

@property(nonatomic,strong)NewQuestionModel *homequestionModel;

@property(nonatomic,assign,readonly)CGRect questTitleFrame;
@property(nonatomic,assign,readonly)CGRect questContentFrame;
@property(nonatomic,assign,readonly)CGRect leftLabelFrame;
@property(nonatomic,assign,readonly)CGRect questContentBGFrame;

@property(nonatomic,assign,readonly)CGRect cellbgFrame;

@property(nonatomic,assign,readonly)CGFloat rowHeight;
@end
