//
//  LeaveMessageClientInfoViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "LeaveMessageClientInfoViewController.h"
#import "BaseTableView.h"
#import "BaseTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LeaveMessageDetailViewController.h"

@interface LeaveMessageClientInfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    noContent * nocontent;
    int current_page;
    int total_count;
}

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) BaseTableView *baseTableView;
@property (nonatomic, strong) noWifiView *failView;

@end

@implementation LeaveMessageClientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"留言用户列表";
    self.data = [NSMutableArray arrayWithCapacity:0];
    [self initSubViews];
    [self loadData];
}

-(void)initSubViews{
    [self.view addSubview:self.baseTableView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_X)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.data removeAllObjects];
    NSDictionary *dic0 = @{
                           @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                           @"_currentPage":@"",
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager] searchProjectMessageDtos4Project:dic0 viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result---->%@",result);
        [self.baseTableView.mj_header endRefreshing];
         [self.baseTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.data addObjectsFromArray:array];
                if (self.data.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.data.count == total_count || self.data.count == 0) {
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
        self.failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    } failuer:^(NSError *error) {
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}
- (void)giveMeMoreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    current_page++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    NSDictionary *dic0 = @{
                           @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                           @"_currentPage":page,
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager] searchProjectMessageDtos4Project:dic0 viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result---->%@",result);
        [self.baseTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.data addObjectsFromArray:array];
                if (self.data.count == total_count || self.data.count == 0) {
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
        self.failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    } failuer:^(NSError *error) {
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = NO;
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight - kTabHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"publicTableViewCell";
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [(BaseTableViewCell *)[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.data count] > 0) {
        
        UIImageView *headImageView = [UIImageView new];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X);
        headImageView.layer.cornerRadius = 40/2*AUTO_SIZE_SCALE_X;
        headImageView.layer.borderWidth= 1.0;
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [cell addSubview:headImageView];
        
        UILabel *nameLabel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:15*AUTO_SIZE_SCALE_X];
        [cell addSubview:nameLabel];
        
        UILabel *timeLabel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentRight Font:12*AUTO_SIZE_SCALE_X];
        [cell addSubview:timeLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 70*AUTO_SIZE_SCALE_X-1, kScreenWidth-15, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [cell addSubview:lineImageView];
        
        nameLabel.text = [[self.data objectAtIndex:indexPath.row]  objectForKey:@"message_user_name"];
        [headImageView sd_setImageWithURL:[[self.data objectAtIndex:indexPath.row]  objectForKey:@"user_c_photo"] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
        timeLabel.text =  [[self.data objectAtIndex:indexPath.row]  objectForKey:@"message_createdtime"];
        nameLabel.frame = CGRectMake(65*AUTO_SIZE_SCALE_X,0,kScreenWidth/2-65*AUTO_SIZE_SCALE_X,70*AUTO_SIZE_SCALE_X);
        timeLabel.frame = CGRectMake(kScreenWidth/2,0,kScreenWidth/2-15*AUTO_SIZE_SCALE_X,70*AUTO_SIZE_SCALE_X);
        
        if ((int)indexPath.row==([self.data count]-1)) {
            lineImageView.hidden = YES;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeaveMessageDetailViewController *vc = [[LeaveMessageDetailViewController alloc] init];
    vc.message_id = [[self.data objectAtIndex:indexPath.row][@"message_id"] intValue];
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
    [MobClick beginLogPageView:kLeaveMessageClientInfoPage];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kLeaveMessageClientInfoPage];
}


-(BaseTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight-kNavHeight-10*AUTO_SIZE_SCALE_X)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight  = (70)*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = YES;
                __weak __typeof(self) weakSelf = self;
        
         //设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
                self.baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [weakSelf loadData];
                        }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
                self.baseTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
    }
    return _baseTableView;
}
@end
