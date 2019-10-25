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
@interface GetDingListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    int current_page,total_count;
    
}
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)NSMutableArray *mydata;
@end

@implementation GetDingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)){
    }else{self.automaticallyAdjustsScrollViewInsets = NO;}
    [self initSubViews];
    
    [self loadData];
}

-(void)initSubViews{
    [self.view addSubview:self.baseTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mydata.count;
}

-(void)loadData{
    [[RequestManager shareRequestManager] searchDingDtosByUserId:nil viewController:self successData:^(NSDictionary *result) {
        NSLog(@"searchDingDtosByUserId--->%@",result);
        if (IsSucess(result)) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
       
                    for (NSDictionary *dict in array) {
                        NSLog(@"dic-------->%@",dict);
                        DingModel *dingModel = [[DingModel alloc] init];
//                        dingModel.titleStr = dict[@"question_content"];
//                        dingModel.nameStr = dict[@"c_nickname"];
//                        dingModel.headURLStr = dict[@"c_photo"];
//                        NSString *job = dict[@"answerDto"][@"userCSimpleInfoDto"][@"c_jobtitle"];
//
//                        if (job == nil) {
//                            questModel.jobStr = @"";
//                        }else{
//                            questModel.jobStr = job;
//                        }
//                        NSString *company_name = dict[@"answerDto"][@"userCSimpleInfoDto"][@"company_name"];
//                        if (company_name == nil) {
//                            questModel.companyStr = @"";
//                        }else{
//                            questModel.companyStr = company_name;
//                        }
//                        questModel.questionStr = dict[@"answerDto"][@"answer_content"];
//                        questModel.commentStr = dict[@"question_collect_count"];
//                        questModel.dingStr= dict[@"question_ding_count"];
                        DingFrame *cellFrame = [[DingFrame alloc] init];
                        cellFrame.dingModel = dingModel;
                        [self.mydata addObject:cellFrame];
                    }
                }
//                [self.mydata addObjectsFromArray:array];
            }
            
            [self.baseTableView reloadData];
        }else{
            
        }
    } failuer:^(NSError *error) {
        
    }];
}

-(void)giveMeMoreData{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DingTableViewCell *cell = [DingTableViewCell userStatusCellWithTableView:tableView];
    
    DingFrame  *dingFrame  =  [self.mydata objectAtIndex:indexPath.row];
    cell.dingFrame = dingFrame ;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseViewController *vc ;
    
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
@end
