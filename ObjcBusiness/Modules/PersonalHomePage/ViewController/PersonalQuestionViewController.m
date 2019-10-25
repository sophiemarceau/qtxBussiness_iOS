//
//  PersonalQuestionViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/17.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PersonalQuestionViewController.h"
#import "NewQuestionModel.h"
#import "NewQuestionCellFrame.h"
#import "QuestListCell.h"
#import "QuestListCell+NewQuestionCellFrame.h"
#import "QuestDetailViewController.h"
@interface PersonalQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@end

@implementation PersonalQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTableView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-44*AUTO_SIZE_SCALE_X)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
    if (self.questionArray.count > 0) {
        nocontent.hidden = YES;
    }else{
       nocontent.hidden = NO;
    }
    if (self.total_count == self.questionArray.count) {
        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.baseTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.questionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewQuestionCellFrame *newquestionCellFrame =  [self.questionArray objectAtIndex:indexPath.row];
    return newquestionCellFrame.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestListCell *cell = [QuestListCell userStatusCellWithTableView:tableView];
    NewQuestionCellFrame *questTableCellFrame =  [self.questionArray objectAtIndex:indexPath.row];
    [cell configureWithListEntity:questTableCellFrame];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
    NewQuestionCellFrame *cellFrame =  [self.questionArray objectAtIndex:indexPath.row];
    vc.question_id = cellFrame.homequestionModel.question_id;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)loadData{
    NSString *userStr ;
    if (self.user_id == 0 ) {
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        NSDictionary *dic0 = @{ @"_currentPage":@"",
                                @"_pageSize":@"",
                                };
        [[RequestManager shareRequestManager] searchMyQuestionDtos:dic0 viewController:nil successData:^(NSDictionary *result){
            [self.baseTableView.mj_header endRefreshing];
            [self.baseTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    [self.questionArray removeAllObjects];
                    for (NSDictionary *dict in array) {
                        NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                        NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                        cellFrame.homequestionModel = questModel;
                        [self.questionArray addObject:cellFrame];
                    }
                    if (self.questionArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.questionArray.count == self.total_count || self.questionArray.count == 0) {
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
        [[RequestManager shareRequestManager] searchQuestionDtosByUserId:dic0 viewController:nil successData:^(NSDictionary *result){
            [self.baseTableView.mj_header endRefreshing];
            
            [self.baseTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    [self.questionArray removeAllObjects];
                    for (NSDictionary *dict in array) {
                        NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                        NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                        cellFrame.homequestionModel = questModel;
                        [self.questionArray addObject:cellFrame];
                    }
                    if (self.questionArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.questionArray.count == self.total_count || self.questionArray.count == 0) {
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
                        NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                        NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                        cellFrame.homequestionModel = questModel;
                        [self.questionArray addObject:cellFrame];
                    }
                    if (self.questionArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.questionArray.count == self.total_count || self.questionArray.count == 0) {
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
        [[RequestManager shareRequestManager] searchQuestionDtosByUserId:dic0 viewController:nil successData:^(NSDictionary *result){
            [self.baseTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    
                    for (NSDictionary *dict in array) {
                        NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                        NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                        cellFrame.homequestionModel = questModel;
                        [self.questionArray addObject:cellFrame];
                    }
                    if (self.questionArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.questionArray.count == self.total_count || self.questionArray.count == 0) {
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
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-44*AUTO_SIZE_SCALE_X)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = [UIColor whiteColor];
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight = 50*AUTO_SIZE_SCALE_X;
        _baseTableView.scrollEnabled = YES;
        _baseTableView.bounces = YES;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        _baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _baseTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    }
    return _baseTableView;
}



@end
