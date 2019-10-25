//
//  TagListViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "TagListViewController.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "TagTableViewCell.h"
#import "TagDetailViewController.h"
@interface TagListViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    int current_page;
    int total_count;
}
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) noWifiView *failView;
@end

@implementation TagListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self initNavgation];
    [self initSubViews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initSubViews {
    [self.view addSubview:self.baseTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TagTableViewCell *cell = [TagTableViewCell userStatusCellWithTableView:tableView];
    cell.dataDic = [self.data objectAtIndex:indexPath.row];
    cell.question_id = self.question_id;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TagDetailViewController *vc = [[TagDetailViewController alloc] init];
    vc.dicData = self.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData {
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.data removeAllObjects];
    NSDictionary *dic = @{ @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],};
    [[RequestManager shareRequestManager] getTagDtoListByQuestionId:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"getTagDtoListByQuestionId---result--->%@",result);
        if (IsSucess(result) == 1) {
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"] ;
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.data addObjectsFromArray:array];
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
        [LZBLoadingView dismissLoadingView];
        
        self.failView.hidden = NO;
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
    [MobClick beginLogPageView:kTagListPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kTagListPage];
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = [UIColor whiteColor];
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight = 49*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = YES;
        //        __weak __typeof(self) weakSelf = self;
        
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        //        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakSelf loadlistData];
        //                }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//        _baseTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
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
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}
- (void)reloadButtonClick:(UIButton *)sender {
    
    [self loadData];
}
@end
