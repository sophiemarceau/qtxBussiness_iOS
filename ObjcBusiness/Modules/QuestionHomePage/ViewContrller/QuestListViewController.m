//
//  QuestListViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestListViewController.h"
#import "BaseTableView.h"
#import "NewQuestionModel.h"
#import "NewQuestionCellFrame.h"
#import "QuestListCell.h"
#import "QuestDetailViewController.h"
#import "QuestListCell+NewQuestionCellFrame.h"
@interface QuestListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    int current_page;
    int total_count;
    noContent * nocontent;
}
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong)BaseTableView *basetTableView;
@property (nonatomic,strong) noWifiView *failView;
@end

@implementation QuestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
    if ([self.tagid isEqualToString:@"-1"]) {
        [self loadListContentFromNewsQuestionData];
    }else{
        [self loadListContentData];
    }
}

-(void)initSubViews{
    [self.view addSubview:self.basetTableView];
    [self.view addSubview:self.failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, scrollViewHeight)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}


- (void)reloadButtonClick:(UIButton *)sender {
    if ([self.tagid isEqualToString:@"-1"]) {
        [self loadListContentFromNewsQuestionData];
    }else{
        [self loadListContentData];
    }
}

#pragma mark 刷新数据
// 根据 在菜单中所选的功能去加载 底下的列表功能
-(void)loadListContentData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          @"tag_id":self.tagid
                          };
    [[RequestManager shareRequestManager] searchQuestionDtosByTag:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"根据菜单中所选的功能去加载 底下的列表功能------------result--------------->%@",result);
        [self.basetTableView.mj_header endRefreshing];
        [self.basetTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            [self.listArray removeAllObjects];
            if(![array isEqual:[NSNull null]] && array !=nil){
                
                for (NSDictionary *dict in array) {
                    NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                    NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                    cellFrame.homequestionModel = questModel;
                    [self.listArray addObject:cellFrame];
                }
                
                [self.basetTableView reloadData];
                if (array.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (array.count == total_count || array.count == 0) {
                    [self.basetTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                nocontent.hidden = NO;
            }
            if (total_count == 0) {
                [self.basetTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        self.failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [self.basetTableView.mj_header endRefreshing];
        [self.basetTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)moreLoadListContentData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    //        NSString * pageOffset = @"20";
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          @"tag_id":self.tagid
                          };
    [[RequestManager shareRequestManager] searchQuestionDtosByTag:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"根据菜单中所选的功能去加载 底下的列表功能------------result--------------->%@",result);
        [self.basetTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                
                
                for (NSDictionary *dict in array) {
                    NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                    NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                    cellFrame.homequestionModel = questModel;
                    [self.listArray addObject:cellFrame];
                }
                
                
                
                [self.basetTableView reloadData];
                
                if (self.listArray.count == total_count) {
                    [self.basetTableView.mj_footer endRefreshingWithNoMoreData];
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
        self.failView.hidden = YES;
    }failuer:^(NSError *error){
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [self.basetTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

//获取 最新问题 下的问答列表
-(void)loadListContentFromNewsQuestionData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] searchLatestQuestionDtos:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"获取 最新问题 下的问答列表------------result--------------->%@",result);
        [self.basetTableView.mj_header endRefreshing];
        [self.basetTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            [self.listArray removeAllObjects];
            if(![array isEqual:[NSNull null]] && array !=nil){
                
                for (NSDictionary *dict in array) {
                    NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                    NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                    cellFrame.homequestionModel = questModel;
                    [self.listArray addObject:cellFrame];
                }
                
                if (self.listArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.listArray.count == total_count || self.listArray.count == 0) {
                    [self.basetTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.basetTableView reloadData];
            }
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
    }failuer:^(NSError *error){
        [self.basetTableView.mj_header endRefreshing];
        [self.basetTableView.mj_footer endRefreshing];
        
        self.failView.hidden = NO;
        nocontent.hidden = YES;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)moreDataloadListContentFromNewsQuestionDataStart{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    current_page++;
    
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    //        NSString * pageOffset = @"20";
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] searchLatestQuestionDtos:dic viewController:self successData:^(NSDictionary *result){
        [self.basetTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                
                
                for (NSDictionary *dict in array) {
                    NewQuestionModel *questModel = [NewQuestionModel logisticsWithDict:dict];
                    NewQuestionCellFrame *cellFrame = [[NewQuestionCellFrame alloc] init];
                    cellFrame.homequestionModel = questModel;
                    [self.listArray addObject:cellFrame];
                }
                
                
                
                
                [self.basetTableView reloadData];
                
                if (self.listArray.count == total_count) {
                    [self.basetTableView.mj_footer endRefreshingWithNoMoreData];
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
        self.failView.hidden = YES;
    }failuer:^(NSError *error){
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [self.basetTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

#pragma mark BaseTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewQuestionCellFrame *newquestionCellFrame =  [self.listArray objectAtIndex:indexPath.row];
    return newquestionCellFrame.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestListCell *cell = [QuestListCell userStatusCellWithTableView:tableView];
    NewQuestionCellFrame *questTableCellFrame =  [self.listArray objectAtIndex:indexPath.row];
    [cell configureWithListEntity:questTableCellFrame];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
    vc.title = @"问题详情";
    NewQuestionCellFrame *questTableCellFrame =  [self.listArray objectAtIndex:indexPath.row];
    vc.question_id = questTableCellFrame.homequestionModel.question_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BaseTableView *)basetTableView{
    if (_basetTableView == nil) {
        _basetTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, scrollViewHeight)];
        [_basetTableView registerClass:[QuestListCell class] forCellReuseIdentifier:@"QuestListCell"];
        _basetTableView.delegate = self;
        _basetTableView.dataSource = self;
        _basetTableView.showsHorizontalScrollIndicator = NO;
        _basetTableView.showsVerticalScrollIndicator = YES;
        _basetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _basetTableView.backgroundColor = BGColorGray;
        __weak __typeof(self) weakSelf = self;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        _basetTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([self.tagid isEqualToString:@"-1"]) {
                 [weakSelf loadListContentFromNewsQuestionData];
            }else{
                 [weakSelf loadListContentData];
            }
        }];
         // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        if ([self.tagid isEqualToString:@"-1"]) {
             _basetTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreDataloadListContentFromNewsQuestionDataStart)];
        }else{
             _basetTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreLoadListContentData)];
        }
    }
    return _basetTableView;
}

-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, scrollViewHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}
@end
