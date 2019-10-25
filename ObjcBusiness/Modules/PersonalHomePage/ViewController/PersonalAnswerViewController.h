//
//  PersonalAnswerViewController.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/17.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"
@interface PersonalAnswerViewController : BaseViewController{

    noContent * nocontent;
}
@property (nonatomic,copy) void(^DidScrollBlock)(CGFloat scrollY);

@property (strong,nonatomic)BaseTableView *baseTableView;
@property (nonatomic,assign)NSInteger user_id;
@property (nonatomic,strong)NSMutableArray *answerArray;
@property (nonatomic,assign)NSInteger current_page;
@property (nonatomic,assign)NSInteger total_count;
@end
