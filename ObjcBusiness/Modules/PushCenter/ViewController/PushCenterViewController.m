//
//  PushCenterViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PushCenterViewController.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "PushTableViewCell.h"
#import "GetDingListViewController.h"
#import "GetCommentListViewController.h"
#import "SystemMessageViewController.h"
#import "WHC_BadgeView.h"
@interface PushCenterViewController ()<UITableViewDataSource,UITableViewDelegate,WHC_BadgeViewDelegate>
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)NSMutableArray *mydata;
@property(nonatomic,strong)noWifiView *failView;
@end

@implementation PushCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"消息";

    [self initSubViews];
    
    
}

-(void)initSubViews{
    [self.view addSubview:self.baseTableView];
}

- (void)giveMeMoreData{
    
}

-(void)loadData{
     [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    NSDictionary *dic =@{};
    [[RequestManager shareRequestManager] getUnReadCountDto:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result-------->%@",result);
        if (IsSucess(result) == 1) {
            [self.mydata removeAllObjects];
            NSDictionary *dic = result[@"data"][@"result"];

            NSArray *temparray = @[
                                   @{@"titleName":@"系统消息",@"iconImageView":@"me_message_official",@"count":dic[@"sysMsgUnReadCount"]},
                                   @{@"titleName":@"收到的点赞打赏",@"iconImageView":@"me_message_praise",@"count":dic[@"dingUnReadCount"]},
                                   @{@"titleName":@"收到的评论",@"iconImageView":@"me_message_comment",@"count":dic[@"commentUnReadCount"]}
                                   ];
            [self.mydata addObjectsFromArray:temparray];
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
        
        self.failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mydata.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PushTableViewCell *cell = [PushTableViewCell userStatusCellWithTableView:tableView];
    cell.badgeView.delegate = self;
    cell.mydictionary =  [self.mydata objectAtIndex:indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        NSDictionary *dic =@{};
        [[RequestManager shareRequestManager] updateSysMsgToRead:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"result ==updateSysMsgToRead===>%@",result);
            if (IsSucess(result) == 1) {
                
                SystemMessageViewController *vc = [[SystemMessageViewController alloc] init];
                vc.title = @"系统消息";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
        }];
        
       
    }
    if (indexPath.row == 1) {
        NSDictionary *dic =@{};
        [[RequestManager shareRequestManager] updateDingToRead:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"result ===updateDingToRead===>%@",result);
            if (IsSucess(result) == 1) {
                
                GetDingListViewController  *vc = [[GetDingListViewController alloc] init];
                vc.title = @"收到的点赞打赏";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
        }];
       
        
    }
    if (indexPath.row == 2) {
        NSDictionary *dic =@{};
        [[RequestManager shareRequestManager] updateCommentToRead:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"result ===updateCommentToRead===>%@",result);
            if (IsSucess(result) == 1) {
                
                GetCommentListViewController  *vc = [[GetCommentListViewController alloc] init];
                vc.title = @"收到的评论";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
        }];
        
    }
    
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

    [MobClick beginLogPageView:kPushCenterPage];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:kPushCenterPage];
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
        _baseTableView.estimatedRowHeight = 50*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = YES;
        //        __weak __typeof(self) weakSelf = self;
        
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        //        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakSelf loadlistData];
        //                }];
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

#pragma mark - WHC_BadgeViewDelegate -
- (void)whc_BadgeViewWillStartDrag{
    
}

- (void)whc_BadgeViewDidEndDrag{
    
}

- (void)whc_BadgeViewDidRemoveFromSuperViewWithIndex:(NSInteger)index{
//    NSLog(@"已经移除BadgeIndex = %ld",index);
    if (index == 0) {
        NSDictionary *dic =@{};
        [[RequestManager shareRequestManager] updateSysMsgToRead:dic viewController:self successData:^(NSDictionary *result) {
            NSLog(@"result ==updateSysMsgToRead===>%@",result);
            if (IsSucess(result) == 1) {
                
               
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
        }];
    }
    if (index == 1) {
        NSDictionary *dic =@{};
        [[RequestManager shareRequestManager] updateDingToRead:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"result ===updateDingToRead===>%@",result);
            if (IsSucess(result) == 1) {
              
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
        }];
        
    }
    if (index == 2) {
        NSDictionary *dic =@{};
        [[RequestManager shareRequestManager] updateCommentToRead:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"result ===updateCommentToRead===>%@",result);
            if (IsSucess(result) == 1) {
                
             
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
        }];
    }
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
