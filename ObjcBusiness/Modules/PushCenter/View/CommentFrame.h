//
//  CommentFrame.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "NSString+textStringToSize.h"
@interface CommentFrame : NSObject


@property(nonatomic,assign,readonly)CGRect headFrame,headFlagFrame;
@property(nonatomic,assign,readonly)CGRect nameFrame;
@property(nonatomic,assign,readonly)CGRect jobSubFrame;
@property(nonatomic,assign,readonly)CGRect commentFromFrame;
@property(nonatomic,assign,readonly)CGRect ContentFrame;
@property(nonatomic,assign,readonly)CGRect ContentBgFrame;
@property(nonatomic,assign,readonly)CGRect leftLabelFrame;
@property(nonatomic,assign,readonly)CGRect lineImageViewFrame;


@property(nonatomic,assign,readonly)CGFloat rowHeight;


@property(nonatomic,strong)CommentModel *commentModel;
@end
