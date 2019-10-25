//
//  TagDetailViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "TagDetailViewController.h"
#import "YX.h"
#import "YXTabView.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"
#import "IgnorHeaderTouchTableView.h"
#import "noWifiView.h"
#import "UIImageView+WebCache.h"
#import "CusPageControlWithView.h"
@interface TagDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    noWifiView * failView;
    Boolean isnotCollection;
    NSDictionary *result1;
    NSDictionary *result2;
    NSDictionary *result3;
    NSDictionary *result4;
    NSError *error1;NSError *error2;NSError *error3;NSError *error4;
    int total_count1;
    int total_count2;
    int total_count3;
}
@property(nonatomic,strong)UIView *tagHeaderBGView;
@property(nonatomic,strong)UIView *tagHeaderView;

@property(nonatomic,strong)UILabel *tagLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIButton *collectionButton;

@property(nonatomic,strong)YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;

@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabView;
@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabViewPre;
@property(nonatomic,assign)BOOL canScroll;

@property(nonatomic,strong)NSMutableArray *answerArray,*questionArray,*projectArray;

@end

@implementation TagDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@",self.dicData[@"tag_content"]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finish:) name:kfinishLoadingView object:nil];
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
    [self loadData];
}

-(void)acceptMsg : (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)finish: (NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        [LZBLoadingView dismissLoadingView];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    CGFloat height = 0;
    if (section==0) {
        height = [self tagHeaderBGView].frame.size.height;
    }else if(section==1){
        height = CGRectGetHeight(self.view.frame)-kNavHeight;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section  = indexPath.section;
    if (section==0) {
        [cell.contentView addSubview:self.tagHeaderBGView];
    }else if(section==1){
        NSArray *tabConfigArray = @[
                                    @{
                                        @"title":@"精品回答",
                                        @"view":@"ClassicQuestionTableView",
                                        @"data":self.answerArray,
                                        @"position":@0,
                                        @"vc":self,
                                        @"tag_id":[NSString stringWithFormat:@"%d",[self.dicData[@"tag_id"] intValue]],
                                        @"total_count":[NSString stringWithFormat:@"%d",total_count1],
                                        },
                                    @{
                                        @"title":@"全部问题",
                                        @"view":@"AllQuestionTableViw",
                                        @"data":self.questionArray,
                                        @"position":@1,
                                        @"vc":self,
                                        @"tag_id":[NSString stringWithFormat:@"%d",[self.dicData[@"tag_id"] intValue]],
                                        @"total_count":[NSString stringWithFormat:@"%d",total_count2],
                                        },
//                                    @{
//                                        @"title":@"相关项目",
//                                        @"view":@"RelatedProjectlistView",
//                                        @"data":self.projectArray,
//                                        @"position":@2,
//                                        @"vc":self,
//                                        @"tag_id":[NSString stringWithFormat:@"%d",[self.dicData[@"tag_id"] intValue]],
//                                        @"total_count":[NSString stringWithFormat:@"%d",total_count3],
//                                        }
                                    ];
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight);
        YXTabView *tabView = [[YXTabView alloc] initWithTabConfigArray:tabConfigArray WithFrame:frame];
        UIView * Line = [[UIView alloc] initWithFrame:CGRectMake(0, kTabTitleViewHeight*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5)];
        Line.backgroundColor = lineImageColor;
        [tabView addSubview:Line];
        [cell.contentView addSubview:tabView];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat tabOffsetY = self.tagHeaderBGView.frame.size.height;
    //    CGFloat tabOffsetY = round([_tableView rectForSection:1].origin.y)-kNavHeight;
//    NSLog(@"tabOffsetY=scrollViewDidScroll--------%f",tabOffsetY);

    
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"offsetY=scrollViewDidScroll--------%f",offsetY);
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
        
        
    }else{
        _isTopIsCanNotMoveTabView = NO;
        
        
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData{
    [self.answerArray removeAllObjects];
    [self.projectArray removeAllObjects];
    [self.questionArray removeAllObjects];
    result1 = result2 =result3 = result4 = nil;
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    failView.hidden = YES;
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第一个网络请求任务添加到组中
 // 获取精品问答列表
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        NSDictionary *dic0 = @{
                               @"tag_id":[NSString stringWithFormat:@"%d",[self.dicData[@"tag_id"] intValue]],
                               @"_currentPage":@"",
                               @"_pageSize":@"",
                               };
        [[RequestManager shareRequestManager] searchBoutiqueAnswerQuestionDtos:dic0 viewController:self successData:^(NSDictionary *result){
            result1= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error1 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    // 将第2个网络请求任务添加到组中
    // 全部问题列表
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *dic1 = @{
                               @"tag_id":[NSString stringWithFormat:@"%d",[self.dicData[@"tag_id"] intValue]],
                               };
        // 开始网络请求任务
        [[RequestManager shareRequestManager] searchQuestionDtosByTag:dic1 viewController:self successData:^(NSDictionary *result){
            result2= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            
            error2 = error;
//            NSLog(@"失败请求数据");
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        
        
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    // 将第3个网络请求任务添加到组中
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *dic2 = @{
                               @"tag_id":[NSString stringWithFormat:@"%d",[self.dicData[@"tag_id"] intValue]],
                               @"_currentPage":@"",
                               @"_pageSize":@"",
                               };
        // 开始网络请求任务
        //相关项目
//        NSLog(@"dic2==================>%@",dic2);
        [[RequestManager shareRequestManager]searchOnlinProjectDtosByTagIdResult:dic2 viewController:self successData:^(NSDictionary *result){
            result3= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error3 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    
    // 将第4个网络请求任务添加到组中
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *dic3 = @{
                               @"tag_id":[NSString stringWithFormat:@"%d",[self.dicData[@"tag_id"] intValue]],
                               
                               };
        // 开始网络请求任务
        //获取标签详情的接口
        
        [[RequestManager shareRequestManager] getTagDto:dic3 viewController:self successData:^(NSDictionary *result){
            result4= result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error4 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (result1 ==nil||result2==nil || result3==nil || result4==nil
            ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                [LZBLoadingView dismissLoadingView];
            });
        }else{
//            NSLog(@"成功请求数据=1:%@",result1);
//            NSLog(@"成功请求数据=2:%@",result2);
//            NSLog(@"成功请求数据=3:%@",result3);
//            NSLog(@"成功请求数据=4:%@",result4);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更UI
                [self initUIView];
                failView.hidden = YES;
                [LZBLoadingView dismissLoadingView];
            });
        }
    });
}

-(void)initUIView{
    
    if (IsSucess(result1) == 1) {
        id list = [[result1 objectForKey:@"data"] objectForKey:@"list"];
       total_count1 = [[[result1 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        if (![list isEqual:[NSNull null]] ) {
            NSArray *array = [[result1 objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil && array.count > 0){
                [self.answerArray addObjectsFromArray:array];
            }
        }
    }else{
        if (IsSucess(result1) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result1];
        }else{
            [[RequestManager shareRequestManager] resultFail:result1 viewController:self];
        }
    }
    
    if (IsSucess(result2) == 1) {
        NSArray *array = [[result2 objectForKey:@"data"] objectForKey:@"list"];
        total_count2 = [[[result2 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        if(![NSArray isEqual:[NSNull null]] && array !=nil && array.count > 0){
            [self.questionArray addObjectsFromArray:array];
        }
    }else{
        if (IsSucess(result2) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result2];
        }else{
            [[RequestManager shareRequestManager] resultFail:result2 viewController:self];
        }
    }
    if (IsSucess(result3) == 1) {
        NSArray *array = [[result3 objectForKey:@"data"] objectForKey:@"list"];
        total_count3 = [[[result3 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        if(![NSArray isEqual:[NSNull null]] && array !=nil && array.count > 0){
            [self.projectArray addObjectsFromArray:array];
        }
    }else{
        if (IsSucess(result3) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result3];
        }else{
            [[RequestManager shareRequestManager] resultFail:result3 viewController:self];
        }
    }
    
    if (IsSucess(result4) == 1) {

        NSDictionary *dto = [[result4 objectForKey:@"data"] objectForKey:@"dto"];
        if(![dto isEqual:[NSNull null]] && dto !=nil){
            self.tagLabel.text = dto[@"tag_content"];
            self.descLabel.text = [NSString stringWithFormat:@"%@个问题   %@人收藏"
                                   ,dto[@"tag_question_count"],dto[@"tag_collection_count"]];
            int isCollected = [dto[@"isCollected"] intValue];
            if (isCollected == 0) {
                self.collectionButton.selected = NO;
            }else{
                self.collectionButton.selected = YES;
            }
        }
    }else{
        if (IsSucess(result4) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result4];
        }else{
            [[RequestManager shareRequestManager] resultFail:result4 viewController:self];
        }
    }
    [self initUI];
}

-(void)initUI{
    _tableView = [[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc] initWithFrame:CGRectMake(0, kNavHeight,kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
}

-(void)ButtonOnclick:(UIButton *)sender{
    
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            NSDictionary *dic = @{
                                  @"tag_id":[NSString stringWithFormat:@"%d",[self.dicData[@"tag_id"] intValue]],
                                  };
            if (sender.selected) {
                
                [[RequestManager shareRequestManager] cancelCollectTag:dic viewController:self successData:^(NSDictionary *result){
//                    NSLog(@"result--cancelCollectTag-->%@",result);
                    failView.hidden = YES;
                    if(IsSucess(result) == 1){
                        self.collectionButton.selected = !self.collectionButton.selected;
                        [[RequestManager shareRequestManager] tipAlert:@"已取消收藏" viewController:self];
                    }else{
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self];
                        }
                    }
                }failuer:^(NSError *error){
                    [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                    failView.hidden = NO;
                }];
            }else{
                [[RequestManager shareRequestManager] collectTag:dic viewController:self successData:^(NSDictionary *result){
//                    NSLog(@"result--collectTag-->%@",result);
                    failView.hidden = YES;
                    
                    
                    if(IsSucess(result) == 1){
                        
                        self.collectionButton.selected = !self.collectionButton.selected;
                        [[RequestManager shareRequestManager] tipAlert:@"收藏成功" viewController:self];
                        
                    }else{
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self];
                        }
                    }
                }failuer:^(NSError *error){
                    
                    [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                    failView.hidden = NO;
                }];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kTagDetailPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kTagDetailPage];
}

-(UIView *)tagHeaderView{
    if (_tagHeaderView == nil) {
        _tagHeaderView = [UIView new];
        _tagHeaderView.backgroundColor = [UIColor whiteColor];
        _tagHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 90*AUTO_SIZE_SCALE_X);
        [_tagHeaderView addSubview:self.tagLabel];
        [_tagHeaderView addSubview:self.descLabel];
        [_tagHeaderView addSubview:self.collectionButton];
    }
    return _tagHeaderView;
}

-(UIView *)tagHeaderBGView{
    if (_tagHeaderBGView == nil) {
        _tagHeaderBGView = [UIView new];
        _tagHeaderBGView.backgroundColor = BGColorGray;
        [_tagHeaderBGView addSubview:self.tagHeaderView];
        _tagHeaderBGView.frame = CGRectMake(0, 0, kScreenWidth, 95*AUTO_SIZE_SCALE_X);
    }
    return _tagHeaderBGView;
}

-(UILabel *)tagLabel{
    if (_tagLabel == nil) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font =  [UIFont systemFontOfSize:20*AUTO_SIZE_SCALE_X];
        _tagLabel.backgroundColor = [UIColor whiteColor];
        _tagLabel.textAlignment =NSTextAlignmentLeft;
        _tagLabel.textColor = FontUIColorBlack;
        _tagLabel.text =@"";
        _tagLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 240*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _tagLabel;
}

-(UILabel *)descLabel{
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font =  [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _descLabel.backgroundColor = [UIColor whiteColor];
        _descLabel.textAlignment =NSTextAlignmentLeft;
        _descLabel.textColor = FontUIColor757575Gray;
        _descLabel.text =@"";
        _descLabel.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 53*AUTO_SIZE_SCALE_X, 240*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _descLabel;
}

-(UIButton *)collectionButton{
    if (_collectionButton == nil) {
        _collectionButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionButton.frame = CGRectMake(kScreenWidth-(20+78)*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 78*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        
        [_collectionButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF4F5F7)] forState:UIControlStateNormal];
        
        [_collectionButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        
        [_collectionButton setTitle:@"已收藏" forState:UIControlStateSelected];
        
        [_collectionButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF4F5F7)] forState:UIControlStateSelected];
        
        [_collectionButton setTitleColor:FontUIColor999999Gray forState:UIControlStateSelected];
        
        _collectionButton.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [_collectionButton addTarget:self action:@selector(ButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        _collectionButton.layer.cornerRadius = 15*AUTO_SIZE_SCALE_X;
        _collectionButton.layer.masksToBounds = YES;
    }
    return _collectionButton;
}

-(NSMutableArray *)answerArray{
    if (_answerArray == nil ) {
        _answerArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _answerArray;
}

-(NSMutableArray *)questionArray{
    if (_questionArray == nil ) {
        _questionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _questionArray;
}

-(NSMutableArray *)projectArray{
    if (_projectArray == nil ) {
        _projectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _projectArray;
}

@end
