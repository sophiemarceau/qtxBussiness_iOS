//
//  BossAnswerListViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossAnswerListViewController.h"
#import "QuestTableCell.h"
#import "QuestModel.h"
#import "QuestTableViewCellFrame.h"
#import "AnswerDetailViewController.h"
#import "PersonalHomePageViewController.h"
@interface BossAnswerListViewController ()<UITableViewDelegate,UITableViewDataSource,HeaderViewDelegate>
@property (nonatomic, assign) BOOL canScroll;
@end

@implementation BossAnswerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTableView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.baseTableView.frame.size.height)];
    nocontent.hidden = YES;
   
    if (self.answerArray.count > 0) {
        nocontent.hidden = YES;
    }else{
        nocontent.hidden = NO;
    }
    if (self.total_count == self.answerArray.count) {
        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.total_count == 0) {
        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.baseTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kGoTopNotificationName object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)acceptMsg:(NSNotification *)notification{
//    NSLog(@"acceptMsg----%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        self.canScroll = YES;
        self.baseTableView.scrollEnabled = YES;
        self.baseTableView.showsVerticalScrollIndicator = YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.DidScrollBlock) {
        self.DidScrollBlock(scrollView.contentOffset.y);
    }
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
        [scrollView setContentOffset:CGPointZero];
        self.canScroll = NO;
        self.baseTableView.showsVerticalScrollIndicator = NO;
        self.baseTableView.scrollEnabled = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.answerArray count] == 0) {
        return 1;
    }else{
        return [self.answerArray count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.answerArray count] == 0) {
        return self.baseTableView.frame.size.height;
    }else{
        QuestTableViewCellFrame *questTableCellFrame =  [self.answerArray objectAtIndex:indexPath.row];
        return questTableCellFrame.rowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.answerArray count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noAnswerTableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noAnswerTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:nocontent];
        return cell;
    }else{
        QuestTableCell *cell = [QuestTableCell userStatusCellWithTableView:tableView];
        cell.delegate = self;
        QuestTableViewCellFrame *questTableCellFrame =  [self.answerArray objectAtIndex:indexPath.row];
        cell.questTableViewCellFrame = questTableCellFrame;
        return  cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    //    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    //    if (userID) {
    //        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
    if ([self.answerArray count] == 0) {
        
    }else{
        AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
        QuestTableViewCellFrame *questTableCellFrame =  [self.answerArray objectAtIndex:indexPath.row];
        vc.answer_id = questTableCellFrame.questModel.answer_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
    //        }else{
    //            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
    //        }
    //    }else{
    //        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
    //    }
}

-(void)gotoPersonalHomePageView:(NSInteger)userid{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = userid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didSelectHeaderGotoHomePage:(NSInteger)userID{
    [self gotoPersonalHomePageView:userID];
}


-(void)loadData{
    NSString *userStr ;
    if (self.user_id == 0 ) {
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        NSDictionary *dic0 = @{ @"_currentPage":@"",
                                @"_pageSize":@"",
                                };
        [[RequestManager shareRequestManager] searchMyAnswerDtos:dic0 viewController:nil successData:^(NSDictionary *result){
            [self.baseTableView.mj_header endRefreshing];
            [self.baseTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    [self.answerArray removeAllObjects];
                    for (NSDictionary *dict in array) {
                        QuestModel *questModel = [QuestModel logisticsWithDict:dict];
                        QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                        cellFrame.questModel = questModel;
                        [self.answerArray addObject:cellFrame];
                    }
                    if (self.answerArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.answerArray.count == self.total_count || self.answerArray.count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [self.baseTableView reloadData];
                }
            }else {
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            [LZBLoadingView dismissLoadingView];
            
        }failuer:^(NSError *error){
            [self.baseTableView.mj_header endRefreshing];
            nocontent.hidden = YES;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
        }];
    }else{
        userStr = [NSString stringWithFormat:@"%ld",self.user_id];
        
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        NSDictionary *dic0 = @{
                               @"user_id_owner":userStr,
                               @"_currentPage":@"",
                               @"_pageSize":@"",
                               };
        [[RequestManager shareRequestManager] searchAnswerDtosByUserId:dic0 viewController:nil successData:^(NSDictionary *result){
            [self.baseTableView.mj_header endRefreshing];
            
            [self.baseTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    [self.answerArray removeAllObjects];
                    for (NSDictionary *dict in array) {
                        QuestModel *questModel = [[QuestModel alloc] initWithDictionary:dict];
                        QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                        cellFrame.questModel = questModel;
                        [self.answerArray addObject:cellFrame];
                    }
                    if (self.answerArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.answerArray.count == self.total_count || self.answerArray.count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [self.baseTableView reloadData];
                }
            }else {
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            [LZBLoadingView dismissLoadingView];
            
        }failuer:^(NSError *error){
            [self.baseTableView.mj_header endRefreshing];
            nocontent.hidden = YES;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
        }];
    }
    
}

-(void)moreData{
    self.current_page++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.current_page];
    
    NSString *userStr ;
    if (self.user_id == 0 ) {
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        NSDictionary *dic0 = @{
                               @"_currentPage":page,
                               @"_pageSize":@"",
                               };
        [[RequestManager shareRequestManager] searchMyQuestionDtos:dic0 viewController:nil successData:^(NSDictionary *result){
            
            [self.baseTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    
                    for (NSDictionary *dict in array) {
                        QuestModel *questModel = [QuestModel logisticsWithDict:dict];
                        QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                        cellFrame.questModel = questModel;
                        [self.answerArray addObject:cellFrame];
                    }
                    if (self.answerArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.answerArray.count == self.total_count || self.answerArray.count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [self.baseTableView reloadData];
                }
            }else {
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            [LZBLoadingView dismissLoadingView];
            
        }failuer:^(NSError *error){
            [self.baseTableView.mj_footer endRefreshing];
            nocontent.hidden = YES;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
        }];
    }else{
        userStr = [NSString stringWithFormat:@"%ld",self.user_id];
        
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        NSDictionary *dic0 = @{
                               @"user_id_owner":userStr,
                               @"_currentPage":page,
                               @"_pageSize":@"",
                               };
        [[RequestManager shareRequestManager] searchAnswerDtosByUserId:dic0 viewController:nil successData:^(NSDictionary *result){
            [self.baseTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    
                    for (NSDictionary *dict in array) {
                        QuestModel *questModel = [[QuestModel alloc] initWithDictionary:dict];
                        QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                        cellFrame.questModel = questModel;
                        [self.answerArray addObject:cellFrame];
                    }
                    if (self.answerArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.answerArray.count == self.total_count || self.answerArray.count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [self.baseTableView reloadData];
                }
            }else {
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            [LZBLoadingView dismissLoadingView];
            
        }failuer:^(NSError *error){
            [self.baseTableView.mj_footer endRefreshing];
            nocontent.hidden = YES;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, scrollViewHeight)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = [UIColor whiteColor];
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight = 50*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = YES;
        
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//        _baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self loadData];
//        }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _baseTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    }
    return _baseTableView;
}

@end
