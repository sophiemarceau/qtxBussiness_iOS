//
//  inviteExpertViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "inviteExpertViewController.h"
#import "BaseTableView.h"
#import "ExpertTableViewCell.h"
#import "MJDIYBackFooter.h"
#import "PersonalHomePageViewController.h"

@interface inviteExpertViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    int current_page;
    int total_count;
    noContent *nocontent;
}

@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)noWifiView *failView;
@end

@implementation inviteExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initNavgation];
    [self initSubViews];
}
//- (void)initNavgation {
//
//}

-(void)gotohisHomePage:(UITapGestureRecognizer *)sender{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = sender.view.tag;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initSubViews {
    [self.view addSubview:self.baseTableView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpertTableViewCell *cell = [ExpertTableViewCell userStatusCellWithTableView:tableView];
    cell.superVC = self;
    cell.dataDic = [self.data objectAtIndex:indexPath.row];
    cell.question_id = self.question_id;
    
    UITapGestureRecognizer * headviewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotohisHomePage:)];
    cell.headerImageView.userInteractionEnabled = YES;
    cell.headerImageView.tag = [self.data[indexPath.row][@"user_id"] integerValue];
    [cell.headerImageView addGestureRecognizer:headviewtap];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{ @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],};
    [[RequestManager shareRequestManager] searchExpert:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"searchExpert------>%@",result);
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            [self.data removeAllObjects];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.data addObjectsFromArray:array];
            }
            if (self.data.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
            if (self.data.count == total_count || self.data.count == 0) {
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
    }failuer:^(NSError *error){
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        self.failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)giveMeMoreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    current_page++;
    
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    
    NSDictionary *dic = @{
                          @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] searchExpert:dic viewController:self successData:^(NSDictionary *result){
        
        [self.baseTableView.mj_footer endRefreshing];
        
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.data addObjectsFromArray:array];
            }
            if (self.data.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
            if (self.data.count == total_count || self.data.count == 0) {
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
    }failuer:^(NSError *error){
        self.failView.hidden = NO;
        
        [self.baseTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kInviteExpertListPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kInviteExpertListPage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = [UIColor whiteColor];
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight = 70*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = YES;
                __weak __typeof(self) weakSelf = self;
        
         //设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
         _baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [weakSelf loadData];
                        }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _baseTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
    }
    return _baseTableView;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
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
