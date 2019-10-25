//
//  SearchViewController.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/8/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHeaderView.h"
#import "MenuTitleView.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "noWifiView.h"
#import "QuestListCell.h"
#import "NewQuestionCellFrame.h"
#import "QuestTableViewCellFrame.h"
#import "QuestListCell+NewQuestionCellFrame.h"
#import "TagTableViewCell.h"
#import "PersonTableViewCell.h"
#import "HomeListTableViewCell.h"
#import "HomeListTableViewCell+HomeListModel.h"
#import "AddQuestCotentControllerViewController.h"
#import "QuestDetailViewController.h"
#import "TagDetailViewController.h"
#import "PersonalHomePageViewController.h"
#import "ProjectDetailViewController.h"
#import "BossCellFrame.h"
#import "BossTableViewCell.h"
#import "BossTableViewCell+BossCellFrame.h"
#import "PersonTableViewCell+Data.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    noWifiView *failView;
    int current_page0;
    int total_count0;
    int current_page1;
    int total_count1;
    int current_page2;
    int total_count2;
    int current_page3;
    int total_count3;
    noContent *nocontent;
}
@property(nonatomic,strong)SearchHeaderView *searchHeaderView;
@property(nonatomic,strong)NSMutableArray *titleArray,*arrayGroup,*baseTableViewArray;
@property(nonatomic,strong)MenuTitleView *menuTitleView;
@property(nonatomic,strong)UIScrollView *tabContentView;
@property(nonatomic,assign)NSInteger currentNum;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentNum = 0;
    [self initSubViews];
    [self loadData];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)initSubViews{
    UIView *navview = [UIView new];
    navview.backgroundColor = [UIColor whiteColor];
    [navview addSubview:self.searchHeaderView];
    navview.frame = CGRectMake(0, 0, kScreenWidth, kNavHeight);
    [self.view addSubview:navview];
    [navview addSubview:self.searchHeaderView];
     [_searchHeaderView setsearchContent:self.searchStr];
    
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
        if (listView.tag == 1 || listView.tag == 2) {
            listView.backgroundColor = [UIColor whiteColor];
        }
        
        [_tabContentView addSubview:listView];
        
        if (listView.tag == 0) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadData];
            }];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreQuestList)];
            [listView registerClass:[QuestListCell class] forCellReuseIdentifier:@"QuestListCell"];
        }
        
        if (listView.tag == 1) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadData];
            }];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeBossData)];
            [listView registerClass:[BossTableViewCell class] forCellReuseIdentifier:@"BossTableViewCell"];
        }
        
        if (listView.tag == 2) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadData];
            }];
            
            [listView registerClass:[TagTableViewCell class] forCellReuseIdentifier:@"TagTableViewCell"];
        }
        
        if (listView.tag == 3) {
            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadData];
            }];
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(morePersonalList)];
            [listView registerClass:[PersonTableViewCell class] forCellReuseIdentifier:@"PersonTableViewCell"];
//            // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//            listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                [self loadData];
//            }];
//            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//            listView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreProjectList)];
//            [listView registerClass:[HomeListTableViewCell class] forCellReuseIdentifier:@"HomeListTableViewCell"];
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
-(BOOL)pattern:(NSString *)searchStr{
    NSString *regex = @"^[a-zA-Z0-9]{1,2}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:searchStr];
    return  isValid;
}
-(void)loadData{
    if (self.currentNum == 0 ) {
        nocontent.hidden = YES;
        current_page0 = total_count0 = 0;
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        failView.hidden = YES;
        BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
        BOOL isValid  = [self pattern:self.searchStr];
        if (isValid) {
             [currentTableView.mj_header endRefreshing];
             [currentTableView.mj_footer endRefreshingWithNoMoreData];
            [currentTableView reloadData];
            [LZBLoadingView dismissLoadingView];
            return;
        }
        #pragma mark -  模糊搜索问题
        NSDictionary *dic = @{
                              @"question_content":self.searchStr,
                              @"_currentPage":@"",
                              @"_pageSize":@"",
                              };
        [[RequestManager shareRequestManager] searchLikeQuestionDtos:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"searchLikeQuestionDtos------>%@",result);
            [currentTableView.mj_header endRefreshing];
            [currentTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                current_page0 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count0 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                id list = [[result objectForKey:@"data"] objectForKey:@"list"];
                if (![list isEqual:[NSNull null]]) {
                    NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                    if(![array isEqual:[NSNull null]] && array !=nil){
                        NSMutableArray *mArray = [NSMutableArray new];
                        
                        for (NSDictionary *dict in array) {
                            NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                            NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                            cellFrame.homequestionModel = questModel;
                            [mArray addObject:cellFrame];
                        }
                        
                        [self.arrayGroup replaceObjectAtIndex:0 withObject:mArray];
                        [currentTableView reloadData];
                        if ( mArray.count == total_count0 ) {
                            [currentTableView.mj_footer endRefreshingWithNoMoreData];
                        }
                    }
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
        } failuer:^(NSError *error) {
            [currentTableView.mj_header endRefreshing];
            [currentTableView.mj_footer endRefreshing];
            failView.hidden = NO;
            
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }
    if (self.currentNum == 1 ) {
        nocontent.hidden = YES;
        failView.hidden = YES;
        current_page1 = total_count1 = 0;
        BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        NSDictionary *dic = @{
                              @"_currentPage":@"",
                              @"_pageSize":@"",
                              @"_Keyword":self.searchStr,
                              };
        
        [[RequestManager shareRequestManager] searchBossProjectDtos:dic viewController:self successData:^(NSDictionary *result){
//            NSLog(@"boss----list-------result--------------->%@",result);
            [currentTableView.mj_header endRefreshing];
            [currentTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                current_page1 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count1 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if(![array isEqual:[NSNull null]] && array != nil){
                    NSMutableArray *mArray = [NSMutableArray new];
                    for (NSDictionary *dict in array) {
                        BossModel *bossModel = [BossModel logisticsWithDict:dict];
                        BossCellFrame *cellFrame = [[BossCellFrame alloc] init];
                        cellFrame.bossModel = bossModel;
                        [mArray addObject:cellFrame];
                    }
                    [self.arrayGroup replaceObjectAtIndex:1 withObject:mArray];
                    [currentTableView reloadData];
                    if (array.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (array.count == total_count1 || array.count == 0) {
                        [currentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                }else{
                    nocontent.hidden = NO;
                }
                if (total_count1 == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
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
            [LZBLoadingView dismissLoadingView];
            nocontent.hidden = YES;
            failView.hidden = NO;
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }
    if (self.currentNum == 2 ) {
        nocontent.hidden = YES;
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        failView.hidden = YES;
        BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
#pragma mark - 模糊搜索标签   最多显示20条没有分页
        NSDictionary *dic = @{
                              @"tag_content":self.searchStr,
                              };
        [[RequestManager shareRequestManager] getLikeTagDtoLike:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"getLikeTagDtoLike------>%@",result);
            [currentTableView.mj_header endRefreshing];
            if (IsSucess(result) == 1) {
                id list = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if (![list isEqual:[NSNull null]]) {
                    NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                    if(![array isEqual:[NSNull null]] && array !=nil){
                        NSMutableArray *mArray = [NSMutableArray new];
                        [mArray addObjectsFromArray:array];
                        if (mArray.count>0) {
                            nocontent.hidden = YES;
                        }else{
                            nocontent.hidden = NO;
                        }
                        [self.arrayGroup replaceObjectAtIndex:self.currentNum withObject:mArray];
                        
                        [currentTableView reloadData];
                    }
                }else{
                    nocontent.hidden = NO;
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
        } failuer:^(NSError *error) {
            [currentTableView.mj_header endRefreshing];
            failView.hidden = NO;
            nocontent.hidden = YES;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }
    if (self.currentNum == 3 ) {
        nocontent.hidden = YES;
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        failView.hidden = YES;
        BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
        current_page3 = total_count3 = 0;
#pragma mark -  搜索用户
        NSDictionary *dic = @{
                              @"keyword":self.searchStr,
                              @"_currentPage":@"",
                              @"_pageSize":@"",
                              };
        [[RequestManager shareRequestManager] searchUserCSimpleInfoDtos:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"searchUserCSimpleInfoDtos------>%@",result);
            [currentTableView.mj_header endRefreshing];
            [currentTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                current_page3 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count3 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                id list = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if (![list isEqual:[NSNull null]]) {
                    NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                    if(![array isEqual:[NSNull null]] && array !=nil){
                        NSMutableArray *mArray = [NSMutableArray new];
                        [mArray addObjectsFromArray:array];
                        [self.arrayGroup replaceObjectAtIndex:self.currentNum withObject:mArray];
                        if (mArray.count>0) {
                            nocontent.hidden = YES;
                        }else{
                            nocontent.hidden = NO;
                        }
                        [currentTableView reloadData];
                        if (mArray.count == total_count3 || mArray.count == 0) {
                            [currentTableView.mj_footer endRefreshingWithNoMoreData];
                        }
                    }
                }else{
                    nocontent.hidden = NO;
                }
                if (total_count3 == 0) {
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
        } failuer:^(NSError *error) {
            [currentTableView.mj_header endRefreshing];
            [currentTableView.mj_footer endRefreshing];
            failView.hidden = NO;
            nocontent.hidden = YES;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
//        nocontent.hidden = YES;
//        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//        failView.hidden = YES;
//        current_page3 = total_count3 = 0;
//        BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
//
//        #pragma mark -  搜索项目
//        NSDictionary *dic = @{
//                              @"_Keyword":self.searchStr,
//                              @"_currentPage":@"",
//                              @"_pageSize":@""
//                              };
//        NSLog(@"dic------>%@",dic);
//        [[RequestManager shareRequestManager] searchProjectDtos4App:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"searchProjectDtos4App------>%@",result);
//            [currentTableView.mj_header endRefreshing];
//            [currentTableView.mj_footer endRefreshing];
//            if (IsSucess(result) == 1) {
//                current_page3 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//                total_count3 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//                id list = [[result objectForKey:@"data"] objectForKey:@"list"];
//
//                if (![list isEqual:[NSNull null]]) {
//                    NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                    if(![array isEqual:[NSNull null]] && array !=nil){
//                        NSMutableArray *mArray = [NSMutableArray new];
//                        [mArray addObjectsFromArray:array];
//                        [self.arrayGroup replaceObjectAtIndex:self.currentNum withObject:mArray];
//                        if (mArray.count>0) {
//                            nocontent.hidden = YES;
//                        }else{
//                            nocontent.hidden = NO;
//                        }
//                        [currentTableView reloadData];
//                        if (mArray.count == total_count3 || mArray.count == 0) {
//                            [currentTableView.mj_footer endRefreshingWithNoMoreData];
//                        }
//                    }
//                }else{
//                    nocontent.hidden = NO;
//                }
//                if (total_count3 == 0) {
//                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            }else{
//                if (IsSucess(result) == -1) {
//                    [[RequestManager shareRequestManager] loginCancel:result];
//                }else{
//                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                }
//            }
//            failView.hidden = YES;
//            [LZBLoadingView dismissLoadingView];
//        } failuer:^(NSError *error) {
//            [currentTableView.mj_header endRefreshing];
//            [currentTableView.mj_footer endRefreshing];
//            failView.hidden = NO;
//            nocontent.hidden = YES;
//            [LZBLoadingView dismissLoadingView];
//            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//        }];
    }
}

-(void)moreQuestList{
#pragma mark -  模糊搜索问题
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    failView.hidden = YES;
    current_page0++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page0];
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
    NSDictionary *dic = @{
                          @"question_content":self.searchStr,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] searchLikeQuestionDtos:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"searchLikeQuestionDtos------>%@",result);
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page0 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count0 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if (![list isEqual:[NSNull null]]) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    NSMutableArray *mArray = [self.arrayGroup objectAtIndex:self.currentNum];
                    for (NSDictionary *dict in array) {
                        NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                        NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                        cellFrame.homequestionModel = questModel;
                        [mArray addObject:cellFrame];
                    }
                    if (mArray.count == total_count0 + 1 || mArray.count == 1) {
                        [currentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [self.arrayGroup replaceObjectAtIndex:0 withObject:mArray];
                    
                    
                    [currentTableView reloadData];
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
    } failuer:^(NSError *error) {
        failView.hidden = NO;
        [currentTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)giveMeBossData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page1++;
    NSString *page = [NSString stringWithFormat:@"%d",current_page1];
    BaseTableView *currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
    //        NSString * pageOffset = @"20";
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          @"_Keyword":self.searchStr,
                          };
    [[RequestManager shareRequestManager] searchBossProjectDtos:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"boss----list-----givememore--result-----searchBossProjectDtos---------->%@",result);
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page1 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count1 = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array != nil){
                NSMutableArray *mArray = [self.arrayGroup objectAtIndex:self.currentNum];
                for (NSDictionary *dict in array) {
                    BossModel *bossModel = [BossModel logisticsWithDict:dict];
                    BossCellFrame *cellFrame = [[BossCellFrame alloc] init];
                    cellFrame.bossModel = bossModel;
                    [mArray addObject:cellFrame];
                }
                [self.arrayGroup replaceObjectAtIndex:self.currentNum withObject:mArray];
                [currentTableView reloadData];
                if (mArray.count == total_count1 || mArray.count == 0) {
                    [currentTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        [LZBLoadingView dismissLoadingView];
        failView.hidden = YES;
    }failuer:^(NSError *error){
        nocontent.hidden = YES;
       failView.hidden = NO;
        [currentTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)morePersonalList{
#pragma mark -  搜索更多的用户
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    failView.hidden = YES;
    current_page2++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page2];
    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
    NSDictionary *dic = @{
                          @"keyword":self.searchStr,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] searchUserCSimpleInfoDtos:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"searchUserCSimpleInfoDtos------>%@",result);
        [currentTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page3 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count3 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if (![list isEqual:[NSNull null]]) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    NSMutableArray *mArray = [self.arrayGroup objectAtIndex:self.currentNum];
                    [mArray addObjectsFromArray:array];
                    [self.arrayGroup replaceObjectAtIndex:self.currentNum withObject:mArray];
                    if (mArray.count == total_count3 || mArray.count == 0) {
                        [currentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [currentTableView reloadData];
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
    } failuer:^(NSError *error) {
        failView.hidden = NO;
        [currentTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

//-(void)moreProjectList{
//    #pragma mark -  搜索更多的项目
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    failView.hidden = YES;
//    current_page3++;
//    NSString * page = [NSString stringWithFormat:@"%d",current_page3];
//    BaseTableView * currentTableView = [self.baseTableViewArray objectAtIndex:self.currentNum];
//
//    NSDictionary *dic = @{
//                          @"_Keyword":self.searchStr,
//                          @"_currentPage":page,
//                          @"_pageSize":@""
//                          };
//    NSLog(@"dic------>%@",dic);
//    [[RequestManager shareRequestManager] searchProjectDtos4App:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"searchProjectDtos4App------>%@",result);
//        [currentTableView.mj_footer endRefreshing];
//        if (IsSucess(result) == 1) {
//            current_page3 = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
//            total_count3 =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
//
//            if (![list isEqual:[NSNull null]]) {
//                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
//                if(![array isEqual:[NSNull null]] && array !=nil){
//                    NSMutableArray *mArray = [self.arrayGroup objectAtIndex:self.currentNum];
//                    [mArray addObjectsFromArray:array];
//                    [self.arrayGroup replaceObjectAtIndex:self.currentNum withObject:mArray];
//                    if (mArray.count == total_count3 || mArray.count == 0) {
//                        [currentTableView.mj_footer endRefreshingWithNoMoreData];
//                    }
//                    [currentTableView reloadData];
//                }
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
//    } failuer:^(NSError *error) {
//        failView.hidden = NO;
//        [currentTableView.mj_footer endRefreshing];
//        [LZBLoadingView dismissLoadingView];
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//    }];
//}

-(void)CancelOnClick:(UIButton *)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
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

-(void)goBack{
    [super goBack];
}

#pragma mark BaseTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        if ([[self.arrayGroup objectAtIndex:0] count] >0) {
            return [[self.arrayGroup objectAtIndex:0] count];
        }else{
            return 1;
        }
    }else if(tableView.tag == 1){
        return [[self.arrayGroup objectAtIndex:1] count];
    }else if(tableView.tag == 2){
        return [[self.arrayGroup objectAtIndex:2] count];
    }else{
        return [[self.arrayGroup objectAtIndex:3] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        if ([[self.arrayGroup objectAtIndex:0] count] >0) {
            if (indexPath.row == 0) {
                return 114*AUTO_SIZE_SCALE_X;
            }else{
                NewQuestionCellFrame *newquestionCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
                return newquestionCellFrame.rowHeight;
            }
        }else{
             return kScreenHeight-kNavHeight -self.menuTitleView.frame.size.height;
        }
    }else if(tableView.tag == 1){
        BossCellFrame *bossCellFrame = [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        return bossCellFrame.rowHeight;
    }else if(tableView.tag == 2){
         return 49*AUTO_SIZE_SCALE_X;
    }else{
         return 70*AUTO_SIZE_SCALE_X;
//        return (130+10+44)*AUTO_SIZE_SCALE_X;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        if ([[self.arrayGroup objectAtIndex:0] count] >0) {
//            if (indexPath.row == 0) {
//                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noAnswerTableViewCellidentify"];
//                if (cell == nil) {
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noAnswerTableViewCellidentify"];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                cell.backgroundColor = BGColorGray;
//                UIView *bgv = [UIView new];
//                bgv.backgroundColor = [UIColor whiteColor];
//                bgv.frame = CGRectMake(0, 0, kScreenWidth, 109*AUTO_SIZE_SCALE_X);
//                [cell addSubview:bgv];
//
//                UILabel *nameLabel =[[UILabel alloc] init];
//                [bgv addSubview:nameLabel];
//                nameLabel.frame = CGRectMake(0, 25*AUTO_SIZE_SCALE_X, kScreenWidth, 14*AUTO_SIZE_SCALE_X);
//                nameLabel.font =[UIFont systemFontOfSize:14];
//                nameLabel.backgroundColor =[UIColor whiteColor];
//                nameLabel.textAlignment = NSTextAlignmentCenter;
//                nameLabel.textColor = FontUIColor757575Gray;
//                nameLabel.text = @"没有您想看的问题或答案？";
//
//                UILabel *buttonLabel =[[UILabel alloc] init];
//                [bgv addSubview:buttonLabel];
//                buttonLabel.frame = CGRectMake(134.5, 54*AUTO_SIZE_SCALE_X, 106*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);
//                buttonLabel.font =[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
//                buttonLabel.backgroundColor = UIColorFromRGB(0xf4f5f7);
//                buttonLabel.textAlignment = NSTextAlignmentCenter;
//                buttonLabel.textColor = FontUIColorBlack;
//                buttonLabel.text = @"立刻提问";
//                buttonLabel.layer.masksToBounds = YES;
//                buttonLabel.layer.cornerRadius = 15.0f;
//                return cell;
//            }else{
                QuestListCell *cell = [QuestListCell userStatusCellWithTableView:tableView];
                NewQuestionCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
                [cell configureWithListEntity:questTableCellFrame];
                return  cell;
//            }
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noAnswerTableViewCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noAnswerTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            UILabel *nameLabel =[[UILabel alloc] init];
            [cell addSubview:nameLabel];
            nameLabel.frame = CGRectMake(0, 100*AUTO_SIZE_SCALE_X, kScreenWidth, 14*AUTO_SIZE_SCALE_X);
            nameLabel.font =[UIFont systemFontOfSize:14];
            nameLabel.backgroundColor =[UIColor whiteColor];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.textColor = FontUIColor757575Gray;
            nameLabel.text = @"没有您想看的问题或答案？";
            
            UILabel *buttonLabel =[[UILabel alloc] init];
            [cell addSubview:buttonLabel];
            buttonLabel.frame = CGRectMake(134.5, 129*AUTO_SIZE_SCALE_X, 106*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);
            buttonLabel.font =[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
            buttonLabel.backgroundColor = UIColorFromRGB(0xf4f5f7);
            buttonLabel.textAlignment = NSTextAlignmentCenter;
            buttonLabel.textColor = FontUIColorBlack;
            buttonLabel.text = @"立刻提问";
            buttonLabel.layer.masksToBounds = YES;
            buttonLabel.layer.cornerRadius = 15.0f;
            return cell;
        }
    }else if(tableView.tag == 1){
        BossTableViewCell *cell = [BossTableViewCell userStatusCellWithTableView:tableView];
        BossCellFrame *bossCellFrame =  [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        [cell configureWithListEntity:bossCellFrame];
        cell.superVC = self;
        return  cell;
    }else if(tableView.tag == 2){
        TagTableViewCell *cell = [TagTableViewCell userStatusCellWithTableView:tableView];
        cell.dataDic = [[self.arrayGroup objectAtIndex:2] objectAtIndex:indexPath.row];
        return cell;
    }else{
        PersonTableViewCell *cell = [PersonTableViewCell userStatusCellWithTableView:tableView];
        [cell configureWithListEntity:[[self.arrayGroup objectAtIndex:3] objectAtIndex:indexPath.row]];
        return  cell;
//        static NSString * identifier = @"HomeListTableViewCell";
//        HomeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (cell == nil) {
//            cell = [(HomeListTableViewCell *)[HomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        if ([[self.arrayGroup objectAtIndex:self.currentNum] count] > 0) {
//            [cell configureWithHomeListEntity:[[self.arrayGroup objectAtIndex:3] objectAtIndex:indexPath.row]];
//        }
//        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        if ([[self.arrayGroup objectAtIndex:0] count] >0) {
//            if (indexPath.row == 0) {
//                NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
//                NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
//                if (userID) {
//                    if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
//                        AddQuestCotentControllerViewController *vc = [[AddQuestCotentControllerViewController alloc] init];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }else{
//                        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
//                    }
//                }else{
//                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
//                }
//            }else{
                QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
                vc.title = @"问题详情";
                NewQuestionCellFrame *questTableCellFrame =  [[self.arrayGroup objectAtIndex:0] objectAtIndex:indexPath.row];
                vc.question_id = questTableCellFrame.homequestionModel.question_id;
                [self.navigationController pushViewController:vc animated:YES];
//            }
        }else{
            NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
            NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
            if (userID) {
                if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
                    AddQuestCotentControllerViewController *vc = [[AddQuestCotentControllerViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
                }
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
            }
        }
    }
    if (tableView.tag == 1) {
        PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
        BossCellFrame *bossCellFrame =  [[self.arrayGroup objectAtIndex:1] objectAtIndex:indexPath.row];
        vc.user_id = bossCellFrame.bossModel.bossID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tableView.tag == 2) {
        TagDetailViewController *vc = [[TagDetailViewController alloc] init];
        vc.dicData =  [[self.arrayGroup objectAtIndex:2] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tableView.tag == 3) {
        PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
        NSDictionary *dic= [self.arrayGroup objectAtIndex:3];
        
        vc.user_id = [[[self.arrayGroup objectAtIndex:3] objectAtIndex:indexPath.row][@"user_id"]  integerValue];
        [self.navigationController pushViewController:vc animated:YES];
//        ProjectDetailViewController * vc = [[ProjectDetailViewController alloc] init];
//        vc.title =[ [[self.arrayGroup objectAtIndex:3] objectAtIndex:indexPath.row] objectForKey:@"project_name"];
//        vc.project_id = [[ [[self.arrayGroup objectAtIndex:3] objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [MobClick beginLogPageView:kSearchResultPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [MobClick endLogPageView:kSearchResultPage];
}

-(SearchHeaderView *)searchHeaderView{
    if(_searchHeaderView == nil){
        _searchHeaderView = [[SearchHeaderView alloc] initWithFrame:CGRectMake(0, kSystemBarHeight, kScreenWidth, 44)];
        [_searchHeaderView.cancelButton addTarget:self action:@selector(CancelOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer * tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
        [_searchHeaderView.searchLabel addGestureRecognizer:tap0];
        
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
        [_searchHeaderView.searchImageView addGestureRecognizer:tap1];
    }
    return _searchHeaderView;
}

-(NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray arrayWithCapacity:0];
        [_titleArray addObjectsFromArray:@[@"问答",@"老板",@"标签",@"用户"]];
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
//            NSLog(@"当前点击----currentNum-------%zi",weakSelf.currentNum);
            [weakSelf loadData];
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake(kScreenWidth*row, 0);
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
