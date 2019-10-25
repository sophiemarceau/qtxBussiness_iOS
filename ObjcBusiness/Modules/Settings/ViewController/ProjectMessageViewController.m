//
//  ProjectMessageViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ProjectMessageViewController.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "ProjectMessageCell.h"
#import "ProjectMessageCell+ProjecMessagetModel.h"
#import "LeaveMessageClientInfoViewController.h"

@interface ProjectMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_sort;
    NSString *_mode_area;
    NSString *_mode_kind;
    NSString *_project_authentication;
    NSString *_project_industry;
    NSString *_project_recommend;
    NSString *_mode_place_demands;
    NSString *_mode_amount;
    
    NSString *_pageSize;
    
    int current_page;
    int total_count;
       noContent *nocontent;
}
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic,strong) BaseTableView *projectMessageTableView;
@property(nonatomic,strong)noWifiView *failView;

@end

@implementation ProjectMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColorGray;
    self.title = @"项目留言";
    self.data = [NSMutableArray arrayWithCapacity:0];
    [self initSubViews];
    [self loadData];
    
}

-(void)initSubViews{
    [self.view addSubview:self.projectMessageTableView];
    [self.view addSubview:self.failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

-(void)loadData{
   [ LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [[RequestManager shareRequestManager] getOnlineAndOfflineProjectDtoListByUserId:nil viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result---->%@",result);
        if (IsSucess(result) == 1) {
            [self.data removeAllObjects];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.data addObjectsFromArray:array];
                [self.projectMessageTableView reloadData];
            }
            if (self.data.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
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
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = NO;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"ProjectMessageCell";
    
    ProjectMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [(ProjectMessageCell *)[ProjectMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.data count] > 0) {
        
        [cell configureWithListEntity:[self.data objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [MobClick event:kProjectDetailSlikBagListclick label:[NSString stringWithFormat:@"%@",[[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangTit"] ]];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kProjectDetailToPost object:nil userInfo:@{@"silk":
    //                                                                                                              [[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangUrl"],
    //                                                                                                          @"webdesc":
    //                                                                                                              [[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangTit"]
    //                                                                                                          }
    //
    //     ];
    //    [MobClick event:kProjectListEvent label:[NSString stringWithFormat:@"%ld",[[[self.data objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]]];
    
    LeaveMessageClientInfoViewController * vc = [[LeaveMessageClientInfoViewController alloc] init];
    
    vc.project_id = [[[self.data objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [MobClick beginLogPageView:kProjectMessagePage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kProjectMessagePage];
}

-(BaseTableView *)projectMessageTableView{
    if (_projectMessageTableView == nil) {
        _projectMessageTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_X)];
        _projectMessageTableView.dataSource = self;
        _projectMessageTableView.backgroundColor = BGColorGray;
        _projectMessageTableView.delegate = self;
        _projectMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _projectMessageTableView.estimatedRowHeight  = (130+10+44)*AUTO_SIZE_SCALE_X;
        _projectMessageTableView.bounces = YES;
//        __weak __typeof(self) weakSelf = self;
//        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//        _projectMessageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf loadData];
//        }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//        _projectMessageTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
    }
    return _projectMessageTableView;
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
