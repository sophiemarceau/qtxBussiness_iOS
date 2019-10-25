//
//  FansListViewController.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/11/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "FansListViewController.h"
#import "PersonTableViewCell.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "PersonalHomePageViewController.h"

@interface FansListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int current_page,total_count;
    noContent * nocontent;
}
@property(nonatomic,strong)NSMutableArray *myData;
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)noWifiView *failView;
@end

@implementation FansListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self loadData];
}
-(void)initSubViews{
    [self.view addSubview:self.baseTableView];
    [self.view addSubview:self.failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

-(void)loadData{
    if (self.user_id == 0 ) {
        [DEFAULTS objectForKey:@"userId"];
        //（1，普通用户；2，企业用户；3，平台运营
        [DEFAULTS objectForKey:@"userKind"];
        self.title = @"我的粉丝";
         [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        NSDictionary *dic = @{ @"user_id": [NSString stringWithFormat:@"%d",[[DEFAULTS objectForKey:@"userId"] intValue]]};
        
        [[RequestManager shareRequestManager] searchMyFansConnectionDtos:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"searchMyFansConnectionDtos-我的-->%@",result);
            [self.baseTableView.mj_header endRefreshing];
            [self.baseTableView.mj_footer endRefreshing];
            if(IsSucess(result) == 1){
                [self.myData removeAllObjects];
                current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                id list = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if (![list isEqual:[NSNull null]]) {
                    NSArray *listarray = [[result objectForKey:@"data"] objectForKey:@"list"];
                    if(![listarray isEqual:[NSNull null]] && listarray !=nil){
                        [self.myData addObjectsFromArray:listarray];
                    }
                    if (((NSArray *)list).count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (((NSArray *)list).count == total_count || ((NSArray *)list).count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    nocontent.hidden = NO;
                }
                
                if(total_count == 0){
                    [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.baseTableView reloadData];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            self.failView.hidden = YES;
            [LZBLoadingView dismissLoadingView];
        } failuer:^(NSError *error) {
            [self.baseTableView.mj_header endRefreshing];
            [self.baseTableView.mj_footer endRefreshing];
            self.failView.hidden = NO;
            nocontent.hidden = YES;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }else{
         [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        self.title = @"他的粉丝";
        NSDictionary *dic = @{ @"user_id":[NSString stringWithFormat:@"%ld",(long)self.user_id],};
        [[RequestManager shareRequestManager] searchHisFansConnectionDtos:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"searchHisFansConnectionDtos--他的->%@",result);
            [self.baseTableView.mj_header endRefreshing];
            [self.baseTableView.mj_footer endRefreshing];
            if(IsSucess(result) == 1){
                [self.myData removeAllObjects];
                current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                id list = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if (![list isEqual:[NSNull null]]) {
                    NSArray *listarray = [[result objectForKey:@"data"] objectForKey:@"list"];
                    if(![listarray isEqual:[NSNull null]] && listarray !=nil){
                        [self.myData addObjectsFromArray:listarray];
                    }
                    if (((NSArray *)list).count>0) {
                        nocontent.hidden = YES;
                    }else{
                        nocontent.hidden = NO;
                    }
                    if (((NSArray *)list).count == total_count || ((NSArray *)list).count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    nocontent.hidden = NO;
                }
                
                if(total_count == 0){
                    [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.baseTableView reloadData];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            self.failView.hidden = YES;
            [LZBLoadingView dismissLoadingView];
        } failuer:^(NSError *error) {
            [self.baseTableView.mj_header endRefreshing];
            [self.baseTableView.mj_footer endRefreshing];
            self.failView.hidden = NO;
            nocontent.hidden = YES;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }
}

-(void)giveMeMoreData{
    if (self.user_id == 0 ) {
        [DEFAULTS objectForKey:@"userId"];
        //（1，普通用户；2，企业用户；3，平台运营
        [DEFAULTS objectForKey:@"userKind"];
        self.title = @"我的粉丝";
         [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        current_page++;
        NSString * page = [NSString stringWithFormat:@"%d",current_page];
        NSDictionary *dic = @{ @"user_id": [NSString stringWithFormat:@"%d",[[DEFAULTS objectForKey:@"userId"] intValue]],
                               @"current_page":page};
        
        [[RequestManager shareRequestManager] searchMyFansConnectionDtos:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"searchMyFansConnectionDtos--->%@",result);
             [self.baseTableView.mj_footer endRefreshing];
            if(IsSucess(result) == 1){
                current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                id list = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if (![list isEqual:[NSNull null]]) {
                    NSArray *listarray = [[result objectForKey:@"data"] objectForKey:@"list"];
                    if(![listarray isEqual:[NSNull null]] && listarray !=nil){
                        [self.myData addObjectsFromArray:listarray];
                    }
                    if (listarray.count == total_count || listarray.count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                [self.baseTableView reloadData];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            self.failView.hidden = YES;
            [LZBLoadingView dismissLoadingView];
        } failuer:^(NSError *error) {
            [self.baseTableView.mj_footer endRefreshing];
            self.failView.hidden = NO;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }else{
         [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        current_page++;
        NSString * page = [NSString stringWithFormat:@"%d",current_page];
        self.title = @"他的粉丝";
        NSDictionary *dic = @{ @"user_id":[NSString stringWithFormat:@"%ld",(long)self.user_id],
                               @"current_page":page};
        [[RequestManager shareRequestManager] searchHisFansConnectionDtos:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"searchHisFansConnectionDtos--->%@",result);
             [self.baseTableView.mj_footer endRefreshing];
            if(IsSucess(result) == 1){
                current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
                total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
                id list = [[result objectForKey:@"data"] objectForKey:@"list"];
                
                if (![list isEqual:[NSNull null]]) {
                    NSArray *listarray = [[result objectForKey:@"data"] objectForKey:@"list"];
                    if(![listarray isEqual:[NSNull null]] && listarray !=nil){
                        [self.myData addObjectsFromArray:listarray];
                    }
                    
                    if (listarray.count == total_count || listarray.count == 0) {
                        [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                [self.baseTableView reloadData];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            self.failView.hidden = YES;
            [LZBLoadingView dismissLoadingView];
        } failuer:^(NSError *error) {
            [self.baseTableView.mj_footer endRefreshing];
            self.failView.hidden = NO;
            [LZBLoadingView dismissLoadingView];
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonTableViewCell *cell = [PersonTableViewCell userStatusCellWithTableView:tableView];
    cell.mydictionary =  [self.myData objectAtIndex:indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = [self.myData[indexPath.row][@"userCSimpleInfoDto"][@"user_id"]  integerValue];
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
    [MobClick beginLogPageView:kfansListPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kfansListPage];
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = [UIColor whiteColor];
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight = 50*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = YES;
        __weak __typeof(self) weakSelf = self;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
         _baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [weakSelf loadData];
         }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _baseTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
    }
    return _baseTableView;
}

-(NSMutableArray *)myData{
    if (_myData==nil) {
        _myData = [NSMutableArray arrayWithCapacity:0];
    }
    return _myData;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight )];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}
- (void)reloadButtonClick:(UIButton *)sender {
    
    [self loadData];
}
@end
