//
//  BossQuestionViewController.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"
@protocol JohnScrollViewDelegate<NSObject>

@optional
- (void)johnScrollViewDidScroll:(CGFloat)scrollY;

@end
@interface BossQuestionViewController : BaseViewController{
    
    noContent * nocontent;
}
@property (nonatomic,copy) void(^DidScrollBlock)(CGFloat scrollY);

@property (nonatomic,strong) BaseTableView *baseTableView;

@property (nonatomic,weak) id<JohnScrollViewDelegate>delegate;
@property (nonatomic,assign)NSInteger user_id;


@property(nonatomic,strong)NSMutableArray *questionArray;

@property (nonatomic,assign)NSInteger current_page;
@property (nonatomic,assign)NSInteger total_count;
@end
