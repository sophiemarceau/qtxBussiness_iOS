//
//  GetCommentListViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "GetCommentListViewController.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "CommentTableViewCell.h"
#import "CommentFrame.h"
#import "CommentModel.h"
#import "PersonalHomePageViewController.h"
#import "AnswerDetailViewController.h"
@interface GetCommentListViewController ()<UITableViewDataSource,UITableViewDelegate,CommentHeaderViewDelegate>{
    int current_page;
    int total_count;
     noContent *nocontent;
}
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)NSMutableArray *mydata;
@property(nonatomic,strong)noWifiView *failView;
@end

@implementation GetCommentListViewController

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
-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@""
                          };
    [[RequestManager shareRequestManager] searchCommentDtosByUserId:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"searchCommentDtosByUserId--->%@",result);
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            [self.mydata removeAllObjects];
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
                    for (NSDictionary *dict  in array) {
                        CommentModel *commentModel = [[CommentModel alloc] initWithDict:dict];
                        CommentFrame *cellFrame = [[CommentFrame alloc] init];
                        cellFrame.commentModel = commentModel;
                        [self.mydata addObject:cellFrame];
                    }
                }
                if (self.mydata.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.mydata.count == total_count) {
                    [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.baseTableView reloadData];
            }
            
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
    } failuer:^(NSError *error) {
        nocontent.hidden = YES;
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = NO;
    }];
}

-(void)giveMeMoreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@""
                          };
    [[RequestManager shareRequestManager] searchCommentDtosByUserId:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"searchCommentDtosByUserId--->%@",result);
        
        [self.baseTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
                    for (NSDictionary *dict  in array) {
                        CommentModel *commentModel = [[CommentModel alloc] initWithDict:dict];
                        CommentFrame *cellFrame = [[CommentFrame alloc] init];
                        cellFrame.commentModel = commentModel;
                        [self.mydata addObject:cellFrame];
                    }
                }
                if (self.mydata.count == total_count) {
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
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
    } failuer:^(NSError *error) {
        
        [self.baseTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = NO;
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mydata.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentFrame *cellFrame = [self.mydata objectAtIndex:indexPath.row];
    return cellFrame.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = [CommentTableViewCell userStatusCellWithTableView:tableView];
    cell.delegate = self;
    cell.commentFrame =  [self.mydata objectAtIndex:indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
    CommentFrame *cellFrame = [self.mydata objectAtIndex:indexPath.row];
    vc.answer_id = cellFrame.commentModel.answer_id;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kgetCommentListPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kgetCommentListPage];
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
