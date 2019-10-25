//
//  MyCollectViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MJDIYBackFooter.h"
#import "noWifiView.h"
#import "MyCollectViewController.h"
#import "MenuTitleView.h"
#import "BaseTableView.h"
#import "QuestListCell.h"
#import "QuestTableCell.h"
#import "HomeListTableViewCell.h"
#import "HomeListTableViewCell+HomeListModel.h"
#import "TagTableViewCell.h"

#import "NewQuestionCellFrame.h"
#import "QuestTableViewCellFrame.h"
#import "QuestListCell+NewQuestionCellFrame.h"

#import "QuestDetailViewController.h"
#import "ProjectDetailViewController.h"
#import "TagDetailViewController.h"
#import "AnswerDetailViewController.h"
#import "PersonalHomePageViewController.h"

@interface MyCollectViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HeaderViewDelegate>{
    noWifiView * failView;
    NSDictionary *result0;
    NSDictionary *result1;
    NSDictionary *result2;
    NSDictionary *result3;
    
    NSError *error0;NSError *error1;NSError *error2;NSError *error3;
    
    int current_page0;
    int total_count0;
    int current_page1;
    int total_count1;
    int current_page2;
    int total_count2;
    int current_page3;
    int total_count3;
    noContent * nocontent;
}
@property(nonatomic,strong)NSMutableArray *titleArray,*arrayGroup,*baseTableViewArray;
@property(nonatomic,strong)MenuTitleView *menuTitleView;
@property(nonatomic,strong)UIScrollView *tabContentView;
@property(nonatomic,assign) NSInteger currentNum;
@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.currentNum = 0;
    [self initSubViews];
    [self loadData];
}

- (void)reloadButtonClick:(UIButton *)sender {
    result0 = result1 = result2 = result3 = nil;
    [self loadData];
}
-(void)loadData{
    current_page0 = total_count0 = 0;
    current_page1 = total_count1 = 0;
    current_page2 = total_count2 = 0;
    current_page3 = total_count3 = 0;
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    failView.hidden = YES;
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第0个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        NSDictionary *dic0 = @{};
        
        [[RequestManager shareRequestManager] searchQuestionDtosCollection:dic0 viewController:self successData:^(NSDictionary *result){
            result0= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error0 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    // 将第1个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSDictionary *dic1  = @{};
        // 开始网络请求任务
        [[RequestManager shareRequestManager] searchCollectionAnswerDtosByUserId:dic1 viewController:self successData:^(NSDictionary *result){
            result1 = result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            
            error1 = error;
//            NSLog(@"失败请求数据");
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
//    // 将第2个网络请求任务添加到组中
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 创建信号量
//        // 开始网络请求任务
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//        NSDictionary *dic2 = @{};
//        [[RequestManager shareRequestManager]searchCollectionProjectDtosByUserId4App:dic2 viewController:self successData:^(NSDictionary *result){
//            result2 = result;
//            // 如果请求成功，发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }failuer:^(NSError *error){
//            error2 = error;
//            // 如果请求失败，也发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }];
//        // 在网络请求任务成功之前，信号量等待中
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSDictionary *dic3 = @{};
        // 开始网络请求任务
        
        //        NSLog(@"dic3==================>%@",dic3);
        [[RequestManager shareRequestManager]searchCollectionTagDtosByUserId:dic3 viewController:self successData:^(NSDictionary *result){
            result3= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error3 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (result0==nil||result1==nil || result3==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                [LZBLoadingView dismissLoadingView];
            });
        }else{
//            NSLog(@"成功请求数据=0:%@",result0);
//            NSLog(@"成功请求数据=1:%@",result1);
//
//            NSLog(@"成功请求数据=3:%@",result3);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initUIView];
                failView.hidden = YES;
                [LZBLoadingView dismissLoadingView];
            });
        }
    });
}

-(void)initUIView{
    
    if (IsSucess(result0) == 1) {
        current_page0 = [[[result0 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
        total_count0 =  [[[result0 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        NSArray *array = [[result0 objectForKey:@"data"] objectForKey:@"list"];
        
        if(![array isEqual:[NSNull null]] && array !=nil){
            NSMutableArray *mArray = [NSMutableArray new];
            for (NSDictionary *dict in array) {
                NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                cellFrame.homequestionModel = questModel;
                [mArray addObject:cellFrame];
            }
            if (mArray.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
            
            [self.arrayGroup replaceObjectAtIndex:0 withObject:mArray];
            BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:0];
            currentTableView.backgroundColor = [UIColor whiteColor];
            [currentTableView reloadData];
            if (mArray.count == total_count0 || mArray.count == 0) {
                [currentTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else{
        if (IsSucess(result0) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result0];
        }else{
            [[RequestManager shareRequestManager] resultFail:result0 viewController:self];
        }
    }
    
    if (IsSucess(result1) == 1) {
        current_page1 = [[[result1 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
        total_count1 =  [[[result1 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        NSArray *array = [[result1 objectForKey:@"data"] objectForKey:@"list"];
        
        if(![array isEqual:[NSNull null]] && array !=nil){
            NSMutableArray *mArray = [NSMutableArray new];
            
            
            for (NSDictionary *dict in array) {
                QuestModel *questModel = [QuestModel logisticsWithDict:dict];
                QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                cellFrame.questModel = questModel;
                [mArray addObject:cellFrame];
            }
            
            
            [self.arrayGroup replaceObjectAtIndex:1 withObject:mArray];
            BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:1];
            if (mArray.count == total_count1 || mArray.count == 0) {
                [currentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [currentTableView reloadData];
        }
    }else{
        if (IsSucess(result1) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result1];
        }else{
            [[RequestManager shareRequestManager] resultFail:result1 viewController:self];
        }
    }
    
//    if (IsSucess(result2) == 1) {
//        current_page2 = [[[result2 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//        total_count2 =  [[[result2 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//        NSArray *array = [[result2 objectForKey:@"data"] objectForKey:@"list"];
//
//        if(![array isEqual:[NSNull null]] && array !=nil){
//            NSMutableArray *mArray = [NSMutableArray new];
//            [mArray addObjectsFromArray:array];
//
//
//
//            [self.arrayGroup replaceObjectAtIndex:2 withObject:mArray];
//            BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:2];
//            if (mArray.count == total_count2 || mArray.count == 0) {
//                [currentTableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            [currentTableView reloadData];
//        }
//    }else{
//        if (IsSucess(result2) == -1) {
//            [[RequestManager shareRequestManager] loginCancel:result2];
//        }else{
//            [[RequestManager shareRequestManager] resultFail:result2 viewController:self];
//        }
//    }
    
    if (IsSucess(result3) == 1) {
        current_page3 = [[[result3 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
        total_count3 =  [[[result3 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        NSArray *array = [[result3 objectForKey:@"data"] objectForKey:@"list"];
        
        if(![array isEqual:[NSNull null]] && array !=nil){
            NSMutableArray *mArray = [NSMutableArray new];
            [mArray addObjectsFromArray:array];
            
            
            
            [self.arrayGroup replaceObjectAtIndex:2 withObject:mArray];
            BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:2];
            if (mArray.count == total_count3 || mArray.count == 0) {
                [currentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [currentTableView reloadData];
        }
    }else{
        if (IsSucess(result3) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result3];
        }else{
            [[RequestManager shareRequestManager] resultFail:result3 viewController:self];
        }
    }
    
}

-(void)moreQuestin{
    current_page0++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page0];
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:0];
    
    

    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic3 = @{
                           @"_currentPage":page,
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager]searchQuestionDtosCollection:dic3 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page0 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count0 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                NSMutableArray *mArray = [self.arrayGroup objectAtIndex:0];
                for (NSDictionary *dict in array) {
                    NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                    NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                    cellFrame.homequestionModel = questModel;
                    [mArray addObject:cellFrame];
                }
                
                [self.arrayGroup replaceObjectAtIndex:0 withObject:mArray];
                
                currentTableView.backgroundColor = [UIColor whiteColor];
                if (mArray.count == total_count0 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [currentTableView reloadData];
            }
            
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [currentTableView.mj_footer endRefreshing];
        failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}


-(void)loadsearchQuestionDtosCollection{
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:0];
    
    
    current_page0 = total_count0 = 0;
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic3 = @{
                           @"_currentPage":@"",
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager]searchQuestionDtosCollection:dic3 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_header endRefreshing];
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page0 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count0 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                NSMutableArray *mArray = [NSMutableArray new];
                for (NSDictionary *dict in array) {
                    NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                    NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                    cellFrame.homequestionModel = questModel;
                    [mArray addObject:cellFrame];
                }
                if (mArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                [self.arrayGroup replaceObjectAtIndex:0 withObject:mArray];
                
                currentTableView.backgroundColor = [UIColor whiteColor];
                if (mArray.count == total_count0 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [currentTableView reloadData];
            }
            
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [currentTableView.mj_header endRefreshing];
        [currentTableView.mj_footer endRefreshing];
        failView.hidden = NO;
        nocontent.hidden = YES;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)moreAnswer{
    current_page1++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page1];
    
    
    
    
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:1];
    
    
    
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic3 = @{
                           @"_currentPage":page,
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager]searchCollectionAnswerDtosByUserId:dic3 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page0 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count0 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                NSMutableArray *mArray = [self.arrayGroup objectAtIndex:1];
                for (NSDictionary *dict in array) {
                    NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                    NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                    cellFrame.homequestionModel = questModel;
                    [mArray addObject:cellFrame];
                }
               
                [self.arrayGroup replaceObjectAtIndex:1 withObject:mArray];
                
                currentTableView.backgroundColor = [UIColor whiteColor];
                
                if (mArray.count == total_count1 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [currentTableView reloadData];
            }
            
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [currentTableView.mj_footer endRefreshing];
        failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)loadsearchCollectionAnswerDtosByUserId{
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:1];
    current_page1 = total_count1 = 0;
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic3 = @{
                           @"_currentPage":@"",
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager]searchCollectionAnswerDtosByUserId:dic3 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_header endRefreshing];
          [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page1 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count1 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                NSMutableArray *mArray = [NSMutableArray new];
                
                
                for (NSDictionary *dict in array) {
                    QuestModel *questModel = [QuestModel logisticsWithDict:dict];
                    QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                    cellFrame.questModel = questModel;
                    [mArray addObject:cellFrame];
                }
                if (mArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                
                
                [self.arrayGroup replaceObjectAtIndex:1 withObject:mArray];
                
                if (mArray.count == total_count1 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [currentTableView reloadData];
            }
            
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [currentTableView.mj_header endRefreshing];
          [currentTableView.mj_footer endRefreshing];
        failView.hidden = NO;
        nocontent.hidden = YES;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

//-(void)moreProject{
//    current_page2++;
//    NSString * page = [NSString stringWithFormat:@"%d",current_page2];
//    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:2];
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    NSDictionary *dic3 = @{
//                           @"_currentPage":page,
//                           @"_pageSize":@"",
//                           };
//    [[RequestManager shareRequestManager] searchCollectionProjectDtosByUserId4App:dic3 viewController:self successData:^(NSDictionary *result){
//        [currentTableView.mj_footer endRefreshing];
//        if (IsSucess(result) == 1) {
//            current_page2 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//            total_count2 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
//            if(![array isEqual:[NSNull null]] && array !=nil){
//                NSMutableArray *mArray = [NSMutableArray new];
//                [mArray addObjectsFromArray:array];
//
//                [self.arrayGroup replaceObjectAtIndex:2 withObject:mArray];
//
//                if (mArray.count == total_count2 || mArray.count == 0) {
//                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
//                }
//                [currentTableView reloadData];
//            }
//        }else{
//            if (IsSucess(result) == -1) {
//                [[RequestManager shareRequestManager] loginCancel:result];
//            }else{
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            }
//        }
//        failView.hidden = YES;
//        [LZBLoadingView dismissLoadingView];
//    }failuer:^(NSError *error){
//        [currentTableView.mj_footer endRefreshing];
//        failView.hidden = NO;
//        [LZBLoadingView dismissLoadingView];
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//    }];
//}


//-(void)loadsearchCollectionProjectDtosByUserId{
//    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:2];
//    current_page2 = total_count2 = 0;
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    NSDictionary *dic3 = @{
//                           @"_currentPage":@"",
//                           @"_pageSize":@"",
//                           };
//    [[RequestManager shareRequestManager] searchCollectionProjectDtosByUserId4App:dic3 viewController:self successData:^(NSDictionary *result){
//        [currentTableView.mj_header endRefreshing];
//          [currentTableView.mj_footer endRefreshing];
//        if (IsSucess(result) == 1) {
//            current_page2 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//            total_count2 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
//            if(![array isEqual:[NSNull null]] && array !=nil){
//                NSMutableArray *mArray = [NSMutableArray new];
//                [mArray addObjectsFromArray:array];
//
//
//                if (mArray.count>0) {
//                    nocontent.hidden = YES;
//                }else{
//                    nocontent.hidden = NO;
//                }
//                [self.arrayGroup replaceObjectAtIndex:2 withObject:mArray];
//
//                if (mArray.count == total_count2 || mArray.count == 0) {
//                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
//                }
//                [currentTableView reloadData];
//            }
//        }else{
//            if (IsSucess(result) == -1) {
//                [[RequestManager shareRequestManager] loginCancel:result];
//            }else{
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            }
//        }
//        failView.hidden = YES;
//        [LZBLoadingView dismissLoadingView];
//    }failuer:^(NSError *error){
//         [currentTableView.mj_header endRefreshing];
//          [currentTableView.mj_footer endRefreshing];
//        failView.hidden = NO;
//        nocontent.hidden = YES;
//        [LZBLoadingView dismissLoadingView];
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//    }];
//}


-(void)moreTag{
    current_page3++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page3];
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:2];
    current_page3 = total_count3 = 0;
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic3 = @{
                           @"_currentPage":page,
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager]searchCollectionTagDtosByUserId:dic3 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page3 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count3 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                NSMutableArray *mArray = [self.arrayGroup objectAtIndex:3];
                [mArray addObjectsFromArray:array];

                [self.arrayGroup replaceObjectAtIndex:2 withObject:mArray];
                
                if (mArray.count == total_count3 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [currentTableView reloadData];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [currentTableView.mj_footer endRefreshing];
        failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)loadsearchCollectionTagDtosByUserId{
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:2];
    current_page3 = total_count3 = 0;
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic3 = @{
                           @"_currentPage":@"",
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager]searchCollectionTagDtosByUserId:dic3 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_header endRefreshing];
          [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page3 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count3 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                NSMutableArray *mArray = [NSMutableArray new];
                [mArray addObjectsFromArray:array];

                if (mArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                [self.arrayGroup replaceObjectAtIndex:2 withObject:mArray];
                
                if (mArray.count == total_count3 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [currentTableView reloadData];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [currentTableView.mj_header endRefreshing];
          [currentTableView.mj_footer endRefreshing];
        failView.hidden = NO;
        nocontent.hidden = YES;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)initSubViews{
    self.menuTitleView = [[MenuTitleView alloc] initWithTitleArray:self.titleArray];
    self.menuTitleView.frame = CGRectMake(0, kNavHeight, kScreenWidth, self.menuTitleView.frame.size.height);
    self.menuTitleView.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    _menuTitleView.titleClickBlock = ^(NSInteger row){
        weakSelf.currentNum = row;
//        NSLog(@"当前点击-----------%zi",row);
//        NSLog(@"当前点击----currentNum-------%zi",weakSelf.currentNum);
        if (weakSelf.tabContentView) {
            weakSelf.tabContentView.contentOffset = CGPointMake(kScreenWidth*row, 0);
        }
        if(row == 0){
            [weakSelf loadsearchQuestionDtosCollection];
        }
        if(row == 1){
            [weakSelf loadsearchCollectionAnswerDtosByUserId];
        }
//        if(row == 2){
//            [weakSelf loadsearchCollectionProjectDtosByUserId];
//        }
        if(row == 2){
            [weakSelf loadsearchCollectionTagDtosByUserId];
        }
        
    };
    [self.view addSubview:self.menuTitleView];
    _tabContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuTitleView.frame), kScreenWidth, kScreenHeight - kNavHeight - CGRectGetHeight(self.menuTitleView.frame))];
    _tabContentView.contentSize = CGSizeMake(CGRectGetWidth(_tabContentView.frame)*self.titleArray.count, CGRectGetHeight(_tabContentView.frame));
    _tabContentView.pagingEnabled = YES;
    _tabContentView.bounces = NO;
    _tabContentView.showsHorizontalScrollIndicator = NO;
    _tabContentView.delegate = self;
    [self.view addSubview:_tabContentView];
    
    for (int i = 0; i < self.titleArray.count; i++){
        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
        [self.arrayGroup addObject:array];
        
        BaseTableView *listView = [[BaseTableView alloc] initWithFrame:CGRectMake(_tabContentView.frame.size.width * i, 0, _tabContentView.frame.size.width, _tabContentView.frame.size.height)];
        listView.tag = i ;
        listView.delegate = self;
        listView.dataSource = self;
        listView.showsHorizontalScrollIndicator = NO;
        listView.showsVerticalScrollIndicator = YES;
        listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        listView.backgroundColor = BGColorGray;
        if (listView.tag == 3) {
            listView.backgroundColor = [UIColor whiteColor];
        }
        
        [_tabContentView addSubview:listView];
        
        if (listView.tag == 0) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf loadsearchQuestionDtosCollection];
            }];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreQuestin)];
            [listView registerClass:[QuestListCell class] forCellReuseIdentifier:@"QuestListCell"];
        }
        
        if (listView.tag == 1) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf loadsearchCollectionAnswerDtosByUserId];
            }];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreAnswer)];
            [listView registerClass:[QuestTableCell class] forCellReuseIdentifier:@"QuestTableCell"];
        }
        
//        if (listView.tag == 2) {
//            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                [weakSelf loadsearchCollectionProjectDtosByUserId];
//            }];
//            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreProject)];
//            [listView registerClass:[HomeListTableViewCell class] forCellReuseIdentifier:@"HomeListTableViewCell"];
//        }
        
        if (listView.tag == 2) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf loadsearchCollectionTagDtosByUserId];
            }];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreTag)];
            [listView registerClass:[TagTableViewCell class] forCellReuseIdentifier:@"TagTableViewCell"];
        }
        
        [self.baseTableViewArray addObject:listView];
    }
    
    [_tabContentView setContentSize:CGSizeMake(_tabContentView.frame.size.width * self.titleArray.count, _tabContentView.frame.size.height)];
    
    
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight+self.menuTitleView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-self.menuTitleView.frame.size.height)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

-(void)didSelectHeaderGotoHomePage:(NSInteger)userID{
    [self gotoPersonalHomePageView:userID];
}

-(void)gotoPersonalHomePageView:(NSInteger)userid{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = userid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark BaseTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return [[self.arrayGroup objectAtIndex:0] count];
    }else if(tableView.tag == 1){
        return [[self.arrayGroup objectAtIndex:1] count];
    }else
//        if(tableView.tag == 2)
        {
        return [[self.arrayGroup objectAtIndex:2] count];
    }
//    else{
//        return [[self.arrayGroup objectAtIndex:3] count];
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        NewQuestionCellFrame *newquestionCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
        return newquestionCellFrame.rowHeight;
    }else if(tableView.tag == 1){
        QuestTableViewCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        return questTableCellFrame.rowHeight;
    }
//    else if(tableView.tag == 2){
//        return (130+10+44)*AUTO_SIZE_SCALE_X;
//    }
    else{
        return 49*AUTO_SIZE_SCALE_X;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        QuestListCell *cell = [QuestListCell userStatusCellWithTableView:tableView];
        NewQuestionCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
        [cell configureWithListEntity:questTableCellFrame];
        return  cell;
    }else if(tableView.tag == 1){
        QuestTableCell *cell = [QuestTableCell userStatusCellWithTableView:tableView];
        cell.delegate = self;
        QuestTableViewCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        cell.questTableViewCellFrame = questTableCellFrame;
        return  cell;
//    }else if(tableView.tag == 2){
//        static NSString * identifier = @"HomeListTableViewCell";
//        HomeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (cell == nil) {
//            cell = [(HomeListTableViewCell *)[HomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        if ([[self.arrayGroup objectAtIndex:self.currentNum] count] > 0) {
//            [cell configureWithHomeListEntity:[[self.arrayGroup objectAtIndex:2] objectAtIndex:indexPath.row]];
//        }
//        return cell;
    }else{
        TagTableViewCell *cell = [TagTableViewCell userStatusCellWithTableView:tableView];
        cell.dataDic = [[self.arrayGroup objectAtIndex:2] objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
        vc.title = @"问题详情";
        NewQuestionCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
        vc.question_id = questTableCellFrame.homequestionModel.question_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tableView.tag == 1) {
        AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
        QuestTableViewCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        vc.answer_id = questTableCellFrame.questModel.answer_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    if (tableView.tag == 2) {
//        ProjectDetailViewController * vc = [[ProjectDetailViewController alloc] init];
//        vc.title =[[[self.arrayGroup objectAtIndex:2] objectAtIndex:indexPath.row] objectForKey:@"project_name"];
//        vc.project_id = [[[[self.arrayGroup objectAtIndex:2] objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    if (tableView.tag == 2) {
        TagDetailViewController *vc = [[TagDetailViewController alloc] init];
        vc.dicData =  [[self.arrayGroup objectAtIndex:2] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[BaseTableView class]]) {
        return;
    }
    CGFloat offsetX = self.tabContentView.contentOffset.x;
     
    NSInteger pageNum = offsetX/kScreenWidth;
    self.currentNum = pageNum;
//    NSLog(@"pageNum == %zi",pageNum);
    [self.menuTitleView setItemSelected:pageNum];
    
    
    if(pageNum == 0){
        [self loadsearchQuestionDtosCollection];
    }
    if(pageNum == 1){
        [self loadsearchCollectionAnswerDtosByUserId];
    }
//    if(pageNum == 2){
//        [self loadsearchCollectionProjectDtosByUserId];
//    }
    if(pageNum == 2){
        [self loadsearchCollectionTagDtosByUserId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyCollectPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyCollectPage];
}

-(NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray arrayWithCapacity:0];
        [_titleArray addObjectsFromArray:@[@"问题",@"答案",@"标签"]];
    }
    return _titleArray;
}

-(NSMutableArray *)baseTableViewArray{
    if (_baseTableViewArray == nil) {
        _baseTableViewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _baseTableViewArray;
}

-(NSMutableArray *)arrayGroup{
    if (_arrayGroup == nil) {
        _arrayGroup = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrayGroup;
}
@end
