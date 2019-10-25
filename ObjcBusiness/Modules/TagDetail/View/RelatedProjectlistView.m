//
//  RelatedProjectlistView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/25.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "RelatedProjectlistView.h"
#import "YX.h"
#import "HomeListTableViewCell.h"
#import "ProjectDetailViewController.h"
#import "HomeListTableViewCell+HomeListModel.h"

@implementation RelatedProjectlistView
-(void)renderUIWithInfo:(NSDictionary *)info WithHeight:(CGFloat)height{
    [super renderUIWithInfo:info WithHeight:height];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView:) name:NOTIFICATION_NAME_RelateProjectTableViw object:nil];
    id obj = info[@"data"];
    if (![obj isKindOfClass:[NSString class]]) {
        
        [self.listArray addObjectsFromArray:info[@"data"]];

    }
    
    self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width, kScreenHeight-kNavHeight-kTabTitleViewHeight);
    
    self.tableView.frame = self.bounds;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    [self.tableView addSubview:self.failView];
    self.failView.frame = self.bounds;
    nocontent = [[noContent alloc]initWithFrame:self.bounds];
    
    nocontent.hidden = YES;
    [self.tableView addSubview:nocontent];
    
    
    
    
    total_count = [info[@"total_count"] intValue];
    if (self.listArray.count == total_count || self.listArray.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
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
    
    if ([self.listArray count] > 0) {
        
        [cell configureWithHomeListEntity:[self.listArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProjectDetailViewController * vc = [[ProjectDetailViewController alloc] init];
    vc.title =[[self.listArray  objectAtIndex:indexPath.row] objectForKey:@"project_name"];
    vc.project_id = [[[self.listArray objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
    UIViewController *viewController = self.info[@"vc"];
    [viewController.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
    
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic0 = @{
                           @"tag_id":[NSString stringWithFormat:@"%d",[self.info[@"tag_id"] intValue]],
                           @"_currentPage":@"0",
                           @"_pageSize":@"",
                           };
    
    [[RequestManager shareRequestManager] searchOnlinProjectDtosByTagIdResult:dic0 viewController:nil successData:^(NSDictionary *result){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.listArray removeAllObjects];
                if (array.count >0) {
                    [self.listArray addObjectsFromArray:array];
                }
                
                if (self.listArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.listArray.count == total_count || self.listArray.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.tableView reloadData];
            }
            
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:nil];
            }
        }
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
        
    }failuer:^(NSError *error){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
    }];
}

-(void)refreshTableView:(NSNotification *)notification{
    [self loadData];
}

-(void)moreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page++;
    
    NSString *page = [NSString stringWithFormat:@"%d",current_page];
    NSDictionary *dic0 = @{
                           @"tag_id":[NSString stringWithFormat:@"%d",[self.info[@"tag_id"] intValue]],
                           @"_currentPage":page,
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager] searchQuestionDtosByTag:dic0 viewController:nil successData:^(NSDictionary *result){
        [self.tableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                
                if (array.count >0) {
                    [self.listArray addObjectsFromArray:array];
                }
 
                if (self.listArray.count == total_count || self.listArray.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.tableView reloadData];
            }
            
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:nil];
            }
        }
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
    }failuer:^(NSError *error){
        self.failView.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
    }];
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectZero];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}
@end
