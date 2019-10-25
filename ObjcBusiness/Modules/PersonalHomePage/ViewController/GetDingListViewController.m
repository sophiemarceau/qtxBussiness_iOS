//
//  GetDingListViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "GetDingListViewController.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "DingTableViewCell.h"
#import "DingModel.h"
#import "DingFrame.h"
#import "AnswerDetailViewController.h"
#import "PersonalHomePageViewController.h"

@interface GetDingListViewController ()<UITableViewDataSource,UITableViewDelegate,DingHeaderViewDelegate>{
    int current_page,total_count;
    noContent *nocontent;
}
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)NSMutableArray *mydata;
@property(nonatomic,strong)noWifiView *failView;
@end

@implementation GetDingListViewController

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

-(void)gotoPersonalHomePageView:(NSInteger)userid{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = userid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didSelectHeaderGotoHomePage:(NSInteger)userID{
//    NSLog(@"userid----->%ld",userID);
    [self gotoPersonalHomePageView:userID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mydata.count;
}

-(void)loadData{
    NSString *userStr1;
    if (self.user_id == 0 ) {
        userStr1 =[NSString stringWithFormat:@"%d",[[DEFAULTS objectForKey:@"userId"] intValue]];
    }else{
        userStr1 = [NSString stringWithFormat:@"%ld",self.user_id];
    }
     [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@""
                          };
    [[RequestManager shareRequestManager] searchDingDtosByUserId:dic viewController:self successData:^(NSDictionary *result) {
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
//        NSLog(@"searchDingDtosByUserId--->%@",result);
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
                    [self.mydata removeAllObjects];
                    for (NSDictionary *dict in array) {
                         DingModel *dingModel = [[DingModel alloc] initWithDict:dict];
                        if ([self.title isEqualToString:@"收到的赞"]) {
                            dingModel.strIntegralDetail = @"";
                        }else{
                            dingModel.strIntegralDetail = dict[@"strIntegralDetail"];
                        }
                        DingFrame *cellFrame = [[DingFrame alloc] init];
                        cellFrame.dingModel = dingModel;
                        [self.mydata addObject:cellFrame];
                    }
                     [self.baseTableView reloadData];
                }
            }
            if (self.mydata.count > 0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
            if (self.mydata.count == total_count || self.mydata.count == 0) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }
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
        self.failView.hidden = NO;
        nocontent.hidden = YES;
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
    }];
}

-(void)giveMeMoreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@""
                          };
    [[RequestManager shareRequestManager] searchDingDtosByUserId:dic viewController:self successData:^(NSDictionary *result) {
        
        [self.baseTableView.mj_footer endRefreshing];
//        NSLog(@"searchDingDtosByUserId--->%@",result);
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
                    for (NSDictionary *dict in array) {
                        DingModel *dingModel = [[DingModel alloc] initWithDict:dict];
                        if ([self.title isEqualToString:@"收到的赞"]) {
                            dingModel.strIntegralDetail = @"";
                        }else{
                            dingModel.strIntegralDetail = dict[@"strIntegralDetail"];
                        }
                        DingFrame *cellFrame = [[DingFrame alloc] init];
                        cellFrame.dingModel = dingModel;
                        [self.mydata addObject:cellFrame];
                    }
                    [self.baseTableView reloadData];
                }
                
                if (self.mydata.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.mydata.count == total_count || self.mydata.count == 0) {
                    [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
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
        self.failView.hidden = NO;
        [self.baseTableView.mj_footer endRefreshing];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.title isEqualToString:@"收到的赞"]) {
         return 100*AUTO_SIZE_SCALE_X;
    }else{
         return 122*AUTO_SIZE_SCALE_X;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DingTableViewCell *cell = [DingTableViewCell userStatusCellWithTableView:tableView];
    cell.delegate = self;
    DingFrame  *dingFrame  =  [self.mydata objectAtIndex:indexPath.row];
    cell.dingFrame = dingFrame ;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
    DingFrame *cellFrame = [self.mydata objectAtIndex:indexPath.row];
    vc.answer_id = cellFrame.dingModel.answer_id;
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
    [MobClick beginLogPageView:kgetDingListPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kgetDingListPage];
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


-(NSMutableArray *)mydata{
    if (_mydata == nil) {
        _mydata = [NSMutableArray arrayWithCapacity:0];
    }
    return _mydata;
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
