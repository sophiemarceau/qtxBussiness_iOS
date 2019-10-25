//
//  MyQuestionAnswerViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MyQuestionAnswerViewController.h"
#import "QuestListCell.h"
#import "QuestTableCell.h"
#import "NewQuestionCellFrame.h"
#import "QuestTableViewCellFrame.h"
#import "QuestListCell+NewQuestionCellFrame.h"
#import "MJDIYBackFooter.h"
#import "noWifiView.h"
#import "MenuTitleView.h"
#import "BaseTableView.h"
#import "AnswerDetailViewController.h"
#import "QuestDetailViewController.h"
#import "PersonalHomePageViewController.h"

@interface MyQuestionAnswerViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,HeaderViewDelegate>{
    noWifiView * failView;
    NSDictionary *result0;
    NSDictionary *result1;
    noContent *nocontent;
    int current_page0;
    int total_count0;
    int current_page1;
    int total_count1;
    NSError *error0;NSError *error1;
}
@property(nonatomic,strong)NSMutableArray *titleArray,*arrayGroup,*baseTableViewArray;
@property(nonatomic,strong)MenuTitleView *menuTitleView;
@property(nonatomic,strong)UIScrollView *tabContentView;
@property(nonatomic,assign) NSInteger currentNum;
@end

@implementation MyQuestionAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的问答";
    self.currentNum = 0;
    [self initSubViews];
    [self loadData];
}

-(void)initSubViews{
    
    [self.view addSubview:self.menuTitleView];
    [self.view addSubview:self.tabContentView];

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
        
        
        [_tabContentView addSubview:listView];
        
        if (listView.tag == 0) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadMyAnswer];
            }];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreMyAnswer)];
            [listView registerClass:[QuestListCell class] forCellReuseIdentifier:@"QuestListCell"];
        }
        
        if (listView.tag == 1) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadMyQuestion];
            }];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreMyQuestion)];
            [listView registerClass:[QuestTableCell class] forCellReuseIdentifier:@"QuestTableCell"];
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


- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData{
    current_page0 = total_count0 = 0;
    current_page1 = total_count1 = 0;
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    failView.hidden = YES;
    result1 = result0 = nil;
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第0个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        NSDictionary *dic0 = @{
                               @"_currentPage":@"",
                               @"_pageSize":@"",
                               };
        
        [[RequestManager shareRequestManager] searchMyAnswerDtos:dic0 viewController:self successData:^(NSDictionary *result){
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
        NSDictionary *dic1  = @{
                                @"_currentPage":@"",
                                @"_pageSize":@"",
                                };
        // 开始网络请求任务
        [[RequestManager shareRequestManager] searchMyQuestionDtos:dic1 viewController:self successData:^(NSDictionary *result){
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

    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (result0==nil || result1==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                [LZBLoadingView dismissLoadingView];
            });
        }else{
//            NSLog(@"成功请求数据=0:%@",result0);
//            NSLog(@"成功请求数据=1:%@",result1);
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initUIView];
                failView.hidden = YES;
                [LZBLoadingView dismissLoadingView];
            });
        }
    });
}

-(void)loadMyAnswer{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:0];
    NSDictionary *dic0 = @{
                           @"_currentPage":@"",
                           @"_pageSize":@"",
                           };
    
    [[RequestManager shareRequestManager] searchMyAnswerDtos:dic0 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_header endRefreshing];
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page0 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count0 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
            if (![list isEqual:[NSNull null]] ) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
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
                    [self.arrayGroup replaceObjectAtIndex:0 withObject:mArray];
                    
                    if (mArray.count == total_count0 || mArray.count == 0) {
                        [currentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [currentTableView reloadData];
                }
            }else{
                nocontent.hidden = NO;
            }
            if (total_count0 == 0) {
                [currentTableView.mj_footer endRefreshingWithNoMoreData];
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
-(void)moreMyAnswer{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page0++;
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:0];
    NSString * page = [NSString stringWithFormat:@"%d",current_page0];
    NSDictionary *dic0 = @{
                           @"_currentPage":page,
                           @"_pageSize":@"",
                           };
    
    [[RequestManager shareRequestManager] searchMyAnswerDtos:dic0 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page0 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count0 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
            if (![list isEqual:[NSNull null]] ) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
                    NSMutableArray *mArray = [self.arrayGroup objectAtIndex:0];
                    
                    for (NSDictionary *dict in array) {
                        QuestModel *questModel = [QuestModel logisticsWithDict:dict];
                        QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                        cellFrame.questModel = questModel;
                        [mArray addObject:cellFrame];
                    }
                    
                    [self.arrayGroup replaceObjectAtIndex:0 withObject:mArray];
                    
                    [currentTableView reloadData];
                    if (mArray.count == total_count0 || mArray.count == 0) {
                        [currentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
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
-(void)loadMyQuestion{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:1];
    NSDictionary *dic1  = @{
                            @"_currentPage":@"",
                            @"_pageSize":@"",
                            };
    
    [[RequestManager shareRequestManager] searchMyQuestionDtos:dic1 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_header endRefreshing];
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page1 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count1 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
            if (![list isEqual:[NSNull null]] ) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                NSLog(@"array--result0--count->%ld",array.count);
                if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
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
                    [self.arrayGroup replaceObjectAtIndex:1 withObject:mArray];
                    
                    if (mArray.count == total_count1 || mArray.count == 0) {
                        [currentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [currentTableView reloadData];
                }
            }else{
                nocontent.hidden = NO;
            }
            if (total_count1 == 0) {
                [currentTableView.mj_footer endRefreshingWithNoMoreData];
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
-(void)moreMyQuestion{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:1];
    current_page1++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page1];
    NSDictionary *dic1  = @{
                            @"_currentPage":page,
                            @"_pageSize":@"",
                            };
    
    [[RequestManager shareRequestManager] searchMyQuestionDtos:dic1 viewController:self successData:^(NSDictionary *result){
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page1 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count1 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
            if (![list isEqual:[NSNull null]] ) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                NSLog(@"array--result0--count->%ld",array.count);
                if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
                    NSMutableArray *mArray = [self.arrayGroup objectAtIndex:1];
                    for (NSDictionary *dict in array) {
                        NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                        NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                        cellFrame.homequestionModel = questModel;
                        [mArray addObject:cellFrame];
                    }
                    
                    [self.arrayGroup replaceObjectAtIndex:1 withObject:mArray];
                    
                    
                    [currentTableView reloadData];
                    if (mArray.count == total_count1 || mArray.count == 0) {
                        [currentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
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

-(void)initUIView{
    
    if (IsSucess(result0) == 1) {
        BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:0];
        current_page0 = [[[result0 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
        total_count0 =  [[[result0 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        id list = [[result0 objectForKey:@"data"] objectForKey:@"list"];
        if (![list isEqual:[NSNull null]] ) {
            NSArray *array = [[result0 objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
                NSMutableArray *mArray = [NSMutableArray new];
                
                for (NSDictionary *dict in array) {
                    QuestModel *questModel = [QuestModel logisticsWithDict:dict];
                    QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                    cellFrame.questModel = questModel;
                    [mArray addObject:cellFrame];
                }
                
                [self.arrayGroup replaceObjectAtIndex:0 withObject:mArray];
                
                
                [currentTableView reloadData];
                if (mArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (mArray.count == total_count0 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            nocontent.hidden = NO;
        }
        if (total_count0 == 0) {
            [currentTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        if (IsSucess(result0) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result0];
        }else{
            [[RequestManager shareRequestManager] resultFail:result0 viewController:self];
        }
    }
    
    if (IsSucess(result1) == 1) {
        BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:1];
        current_page1 = [[[result1 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
        total_count1 =  [[[result1 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        id list = [[result1 objectForKey:@"data"] objectForKey:@"list"];
        if (![list isEqual:[NSNull null]] ) {
            NSArray *array = [[result1 objectForKey:@"data"] objectForKey:@"list"];
//            NSLog(@"array--result0--count->%ld",array.count);
            if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
                NSMutableArray *mArray = [NSMutableArray new];
                for (NSDictionary *dict in array) {
                    NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                    NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                    cellFrame.homequestionModel = questModel;
                    [mArray addObject:cellFrame];
                }
                
                [self.arrayGroup replaceObjectAtIndex:1 withObject:mArray];
                
                
                [currentTableView reloadData];
                
                if (mArray.count == total_count1 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            nocontent.hidden = NO;
        }
        if (total_count1 == 0) {
            [currentTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        if (IsSucess(result1) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result1];
        }else{
            [[RequestManager shareRequestManager] resultFail:result1 viewController:self];
        }
    }
}

#pragma mark BaseTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return [[self.arrayGroup objectAtIndex:0] count];
    }else{
        return [[self.arrayGroup objectAtIndex:1] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        QuestTableViewCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
        return questTableCellFrame.rowHeight;
        
    }else{
        NewQuestionCellFrame *newquestionCellFrame =  [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        return newquestionCellFrame.rowHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        QuestTableCell *cell = [QuestTableCell userStatusCellWithTableView:tableView];
        QuestTableViewCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
        cell.questTableViewCellFrame = questTableCellFrame;
        cell.delegate = self;
        return  cell;
    }else {
        QuestListCell *cell = [QuestListCell userStatusCellWithTableView:tableView];
        NewQuestionCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        [cell configureWithListEntity:questTableCellFrame];
        return  cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
        QuestTableViewCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
        vc.answer_id = questTableCellFrame.questModel.answer_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tableView.tag == 1) {
        QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
        vc.title = @"问题详情";
        NewQuestionCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        vc.question_id = questTableCellFrame.homequestionModel.question_id;
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
        [self loadMyAnswer];
    }
    if(pageNum == 1){
        [self loadMyQuestion];
    }
}

-(void)didSelectHeaderGotoHomePage:(NSInteger)userID{
    [self gotoPersonalHomePageView:userID];
}

-(void)gotoPersonalHomePageView:(NSInteger)userid{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = userid;
    [self.navigationController pushViewController:vc animated:YES];
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
    [MobClick beginLogPageView:kMyAnswerANDQuestionPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyAnswerANDQuestionPage];
}

-(NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray arrayWithCapacity:0];
        [_titleArray addObjectsFromArray:@[@"我的回答",@"我的提问"]];
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

-(MenuTitleView *)menuTitleView{
    if (_menuTitleView == nil) {
        self.menuTitleView = [[MenuTitleView alloc] initWithTitleArray:self.titleArray];
        self.menuTitleView.frame = CGRectMake(0, kNavHeight, kScreenWidth, self.menuTitleView.frame.size.height);
        self.menuTitleView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _menuTitleView.titleClickBlock = ^(NSInteger row){
            weakSelf.currentNum = row;
//            NSLog(@"当前点击-----------%zi",row);
//            NSLog(@"当前点击----currentNum-------%zi",weakSelf.currentNum);
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake(kScreenWidth*row, 0);
            }
            if(row == 0){
                            [weakSelf loadMyAnswer];
            }
            if(row == 1){
                            [weakSelf loadMyQuestion];
            }
            if(row == 2){
                //            [weakSelf loadsearchCollectionProjectDtosByUserId];
            }
            if(row == 3){
                //            [weakSelf loadsearchCollectionTagDtosByUserId];
            }
            
        };
    }
    return _menuTitleView;
}

-(UIScrollView *)tabContentView{
    if (_tabContentView == nil) {
        _tabContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuTitleView.frame), kScreenWidth, kScreenHeight - kNavHeight - CGRectGetHeight(self.menuTitleView.frame))];
        _tabContentView.contentSize = CGSizeMake(CGRectGetWidth(_tabContentView.frame)*self.titleArray.count, CGRectGetHeight(_tabContentView.frame));
        _tabContentView.pagingEnabled = YES;
        _tabContentView.bounces = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.delegate = self;
    }
    return _tabContentView;
}
@end
