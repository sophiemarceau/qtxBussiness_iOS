//
//  SystemMessageViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "SystemTableItem.h"
#import "SystemBaseTableViewCell.h"
#import "SystemMessageTableViewCell.h"
#import "SystemLabelCellTableViewCell.h"
#import "noContent.h"
#import "noWifiView.h"
#import "QuestDetailViewController.h"
static NSString *simpleIdentify = @"timeTableViewCell";
@interface SystemMessageViewController ()<UITableViewDataSource,UITableViewDelegate,SystemLabelelegate>{
    NSInteger current_page,total_count;
    noContent *nocontent;
    SystemLabelCellTableViewCell *cell;
    
    
}
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)NSMutableArray *mydata;
@property(nonatomic,strong)noWifiView *failView;
@end

@implementation SystemMessageViewController

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
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page = 0;
    NSDictionary *dic = @{
                          @"_current_page":@""
                          };
//    NSLog(@"result------dic---->%@",dic);
    [[RequestManager shareRequestManager] searchSysMsgDtos:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result------searchSysMsgDtos---->%@",result);
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            [self.mydata removeAllObjects];
            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
            if (![list isEqual:[NSNull null]] ) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
                    for (NSDictionary *dic in array) {
                        SystemTableItem *item = [SystemTableItem new];
                        item.showtype = SystemLabelMessage;
                        item.timeStr = dic[@"msg_createdtime"];
                        item.titleStr = dic[@"msg_title"];
                        item.msg_kind = [dic[@"msg_kind"] intValue];
                        item.contentStr = dic[@"msg_content"];
                        item.user_id_receiver = [dic[@"user_id_receiver"] intValue];
                        item.msg_page_to = dic[@"msg_page_to"];
                        [self.mydata addObject:item];
                    }

                }
                [self.baseTableView reloadData];
                if (self.mydata.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.mydata.count == total_count) {
                    [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                nocontent.hidden = NO;
            }
            if (0 == total_count) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
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
        [self.baseTableView.mj_header endRefreshing];
        [self.baseTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = NO;
    }];
}

-(void)giveMeMoreData{
    current_page++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)current_page];
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{
                          @"_current_page":page
                          };
//     NSLog(@"result------current_page---->%@",dic);
    [[RequestManager shareRequestManager] searchSysMsgDtos:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result------searchSysMsgDtos---->%@",result);
        
        [self.baseTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
//            NSLog(@"self.mydata------searchSysMsgDtos---before->%ld",self.mydata.count);
            id list = [[result objectForKey:@"data"] objectForKey:@"list"];
            if (![list isEqual:[NSNull null]] ) {
                NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
                    for (NSDictionary *dic in array) {
                        SystemTableItem *item = [SystemTableItem new];
                        item.showtype = SystemLabelMessage;
                        item.timeStr = dic[@"msg_createdtime"];
                        item.titleStr = dic[@"msg_title"];
                        item.msg_kind = [dic[@"msg_kind"] intValue];
                        item.contentStr = dic[@"msg_content"];
                        item.user_id_receiver = [dic[@"user_id_receiver"] intValue];
                        item.msg_page_to = dic[@"msg_page_to"];
                        [self.mydata addObject:item];
                    }
                    
                }
//                NSLog(@"array------searchSysMsgDtos-array--->%ld",array.count);
//                 NSLog(@"self.mydata------searchSysMsgDtos--after-->%ld",self.mydata.count);
                [self.baseTableView reloadData];
                
                if (self.mydata.count == total_count) {
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
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
    } failuer:^(NSError *error) {
        
        [self.baseTableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = NO;
    }];
}

#pragma mark TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mydata.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SystemTableItem *item = self.mydata[indexPath.row];
    SystemLabelCellTableViewCell *cell = [[SystemLabelCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
    return [cell rowHeightForObject:item];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemTableItem *item = self.mydata[indexPath.row];
     cell =(SystemLabelCellTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SystemLabelCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:simpleIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ((SystemLabelCellTableViewCell *)cell).delegate = self;
    [cell rowHeightForObject:item];
    return cell;
//    SystemBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
//    if (!cell) {
//        Class cls = [self cellClassAtIndexPath:item];
//        cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
//    }
//
//    cell.backgroundColor = BGColorGray;
//    if(item.showtype == SystemLabelMessage){
//        ((SystemLabelCellTableViewCell *)cell).delegate = self;
//        ((SystemLabelCellTableViewCell *)cell).resumTableItem = item;
//
//    }else{
//        [cell setResumeTableItem:item];
//
//    }
   
    
}

-(void)checkButtonOnclick:(NSInteger)index{
//    NSLog(@"checkButtonOnclick-------%ld",index);
    QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
    vc.title = @"问题详情";
    vc.question_id = index;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (Class)cellClassAtIndexPath:(SystemTableItem *)nowItem{
    switch (nowItem.showtype) {
        case SystemPicMessage:{
            
            return [SystemMessageTableViewCell class];
        }
            break;
        case SystemLabelMessage:{
            return [SystemLabelCellTableViewCell class];
        }
            break;
        
            
            break;
    }
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

    [MobClick beginLogPageView:kSystemMessagePage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kSystemMessagePage];
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.bounces = YES;
        [_baseTableView registerClass:[SystemMessageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SystemMessageTableViewCell class])];
        [_baseTableView registerClass:[SystemLabelCellTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SystemLabelCellTableViewCell class])];
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
