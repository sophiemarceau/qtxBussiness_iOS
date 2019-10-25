//
//  SharedView.h
//  wecoo
//
//  Created by 屈小波 on 2017/2/22.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ShareType) {
    ShareTypeSocialWechat = 0,
    ShareTypeSocialWechatTimeLine,
    ShareTypeSocialQQ,
    ShareTypeSocialQQZone,
    ShareTypeCopy,     //系统
    ShareTypeDelete,
    ShareTypeReport,
};

typedef NS_ENUM(NSInteger,FromWhereShareType) {
    ShareTypeFromAnswerDetail = 0,
    ShareTypeFromQuestionDetail,
    ShareTypeFromBossDetail
};
@protocol  SelectSharedTypeDelegate<NSObject>
- (void)SelectSharedTypeDelegateReturnPage:(ShareType)returnShareType;
@end

@interface SharedView : UIView{
    
}

@property (nonatomic, strong) UIView  *shareBGView;
@property (nonatomic, strong) UILabel  *cancelLabel;
@property (nonatomic, strong) NSArray *DataArray;
@property (nonatomic, strong) NSMutableArray *ButtonTypeShareArray1;
@property (nonatomic, strong) NSMutableArray *ButtonTypeShareArray2;
@property (nonatomic, strong) NSArray *typeArray1;
@property (nonatomic, strong) NSArray *typeArray2;
@property (nonatomic, weak)id <SelectSharedTypeDelegate>delegate;
@property (nonatomic, strong) NSDictionary *publishContent;
@property (nonatomic, strong) UIViewController  *currentVC;

@property (nonatomic,assign) FromWhereShareType fromWhereFlag;


@property (nonatomic,assign) NSInteger question_id;
@property (nonatomic,assign) NSInteger answer_id;
@property (nonatomic,assign) NSInteger boss_id;
- (void)initPublishContent:(id)content FlagWithDeleButton:(NSInteger)deleteButtonflag;



@end
