//
//  PersonalProjectViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/11/17.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PersonalProjectViewController.h"
#import "HomeListTableViewCell.h"
#import "ProjectDetailViewController.h"
#import "HomeListTableViewCell+HomeListModel.h"
@interface PersonalProjectViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PersonalProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTableView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-44*AUTO_SIZE_SCALE_X)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
    if (self.projectArray.count > 0) {
        nocontent.hidden = YES;
    }else{
        nocontent.hidden = NO;
    }
    if (self.total_count == self.projectArray.count) {
        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.baseTableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.DidScrollBlock) {
        self.DidScrollBlock(scrollView.contentOffset.y);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.projectArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (130+10+44)*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"homelistTableViewCell";
    
    HomeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [(HomeListTableViewCell *)[HomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.projectArray count] > 0) {
        [cell configureWithHomeListEntity:[self.projectArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectDetailViewController * vc = [[ProjectDetailViewController alloc] init];
    vc.title =[[self.projectArray  objectAtIndex:indexPath.row] objectForKey:@"project_name"];
    vc.project_id = [[[self.projectArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSString *userStr ;
    if (self.user_id == 0 ) {
        userStr = [NSString stringWithFormat:@"%d",[[DEFAULTS objectForKey:@"userId"] intValue]];
    }else{
        userStr = [NSString stringWithFormat:@"%ld",self.user_id];
    }
    NSDictionary *dic = @{
                           @"user_id":userStr,
                           @"_currentPage":@"",
                           @"_pageSize":@"",
                           };

        [[RequestManager shareRequestManager] searchOnlinProjectDtosByUserId:dic viewController:nil successData:^(NSDictionary *result){
            [self.baseTableView.mj_header endRefreshing];
            [self.baseTableView.mj_footer endRefreshing];
            if (IsSucess(result) == 1) {
                self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil){
                    [self.projectArray removeAllObjects];
                    if (array.count >0) {
                        [self.projectArray addObjectsFromArray:array];
                    }
                    if (self.projectArray.count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (self.projectArray.count == self.total_count || self.projectArray.count == 0) {
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

-(void)moreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    self.current_page++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.current_page];
    NSString *userStr ;
    if (self.user_id == 0 ) {
        userStr = [NSString stringWithFormat:@"%d",[[DEFAULTS objectForKey:@"userId"] intValue]];
    }else{
        userStr = [NSString stringWithFormat:@"%ld",self.user_id];
    }
    NSDictionary *dic = @{
                          @"user_id":userStr,
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] searchOnlinProjectDtosByUserId:dic viewController:nil successData:^(NSDictionary *result){
        
        [self.baseTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            self.current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            self.total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                
                if (array.count >0) {
                    [self.projectArray addObjectsFromArray:array];
                }
                if (self.projectArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.projectArray.count == self.total_count || self.projectArray.count == 0) {
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
