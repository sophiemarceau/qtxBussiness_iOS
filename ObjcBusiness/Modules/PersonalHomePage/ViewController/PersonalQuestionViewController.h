//
//  PersonalQuestionViewController.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/17.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"

@interface PersonalQuestionViewController : BaseViewController{
    noContent * nocontent;
}
@property (nonatomic,strong)BaseTableView *baseTableView;
@property (nonatomic,assign)NSInteger user_id;
@property (nonatomic,strong)NSMutableArray *questionArray;
@property (nonatomic,assign)NSInteger current_page;
@property (nonatomic,assign)NSInteger total_count;
@end
