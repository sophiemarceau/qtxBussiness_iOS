//
//  ServiceDetailViewController.m
//  YourBusiness
//
//  Created by sophiemarceau_qu on 2017/7/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "ServiceViewModel.h"
#import "YX.h"
#import "YXTabView.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"
#import "IgnorHeaderTouchTableView.h"
#import "noWifiView.h"
#import "UIImageView+WebCache.h"
@interface ServiceDetailViewController  ()<UITableViewDataSource,UITableViewDelegate,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>{
    NSDictionary *dto;
    
    Boolean isProjectCollected;
    NSMutableArray *titlesArray;
    NSMutableArray *projectsignList;
    NSArray *silkbagArrray;
    NSString *project_desc;
    NSString *project_policy;
    NSString *project_commission_note;
    noWifiView * failView;
    NSDictionary *result1;
    NSDictionary *result2;
    NSDictionary *result3;
    NSDictionary *result4;
    NSError *error1;NSError *error2;NSError *error3;NSError *error4;
    UIView *indicateLine;
    
    NSString *image_url;
}
@property(nonatomic,strong)UIView *navView;

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imagesList;
@property (nonatomic, strong) NSArray<NSString *> *imageNames;
@property (nonatomic, strong) NSMutableArray *imageDatas;

@property(nonatomic,strong)UIView *prepareHeaderView;
@property(nonatomic,strong)UIView *projectHeaderView;
@property(nonatomic,strong)UIView *personalHeaerView;

@property(nonatomic,strong)UILabel *subtitleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIView *trueProjectView;

@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIView *flagBgView;
@property(nonatomic,strong)UILabel *flagLabel;
@property(nonatomic,strong)UIImageView *flagImageView;

@property(nonatomic,strong)UILabel *clientDesLabel;

@property(nonatomic,strong)YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;

@property(nonatomic,strong)UIView *collectView;
@property(nonatomic,strong)UIImageView *collectImageView;
@property(nonatomic,strong)UILabel *collectLabel;
@property(nonatomic,strong)UIButton *reportButton;

@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabView;
@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabViewPre;
@property(nonatomic,assign)BOOL canScroll;

@property(nonatomic,strong)UIButton *gobackButton;
@property(nonatomic,strong)UIButton *moreButton;

@end

@implementation ServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kProjectDetailToPost object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(towebview:) name:kProjectDetailToPost object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kfinishLoadingView object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finish:) name:kfinishLoadingView object:nil];
    
    project_desc =project_policy = @"http://www.apple.com.cn";
    silkbagArrray = @[
                      @{@"jinNangTit":@"cesjo"},
                      @{@"jinNangTit":@"测试测试"}
                      ];

    //   [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self loadData];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

-(void)finish: (NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更UI
        [LZBLoadingView dismissLoadingView];
    });
}

-(void)towebview : (NSNotification *)notification{
//    NSDictionary *userInfo = notification.userInfo;
//    NSString *canScroll = userInfo[@"silk"];
//    WebViewController *vc = [[WebViewController alloc] init];
//    vc.webViewurl = canScroll;
//    vc.fromWhere = @"silk";
//    vc.webtitle = userInfo[@"webdesc"];
//    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.imageDatas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.cycleImageView.image = [UIImage imageNamed:self.imageDatas[index]];
    //    [cell.cycleImageView sd_setImageWithURL:self.imageDatas[index] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    //    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSize = CGSizeMake(self.view.frame.size.width , 375*AUTO_SIZE_SCALE_X);
    layout.itemSpacing = 0*AUTO_SIZE_SCALE_X;
    layout.itemHorizontalCenter = YES;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    //    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}
- (void)pagerViewDidScroll:(TYCyclePagerView *)pageView{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    CGFloat height = 0.;
    if (section==0) {
        height = [self prepareHeaderView].frame.size.height;
    }else if(section==1){
        height = CGRectGetHeight(self.view.frame)-kNavHeight-kTabTitleViewHeight;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section  = indexPath.section;
    if (section==0) {
        [cell.contentView addSubview:self.prepareHeaderView];
    }else if(section==1){
        NSArray *tabConfigArray = @[
                                    @{
                                        @"title":@"项目内容",
                                        @"view":@"ProjectIntrduceTableView",
                                        @"data":project_desc,
                                        @"position":@0
                                        },
                                    @{
                                        @"title":@"合作模式",
                                        @"view":@"InvestmentDetailTableViw",
                                        @"data":project_policy,
                                        @"position":@1
                                        },
                                    @{
                                        @"title":@"详情客户",
                                        @"view":@"CommentView",
                                        @"data":silkbagArrray,
                                        @"position":@2
                                        }
                                    ];
        YXTabView *tabView = [[YXTabView alloc] initWithTabConfigArray:tabConfigArray];
        UIView * Line = [[UIView alloc] initWithFrame:CGRectMake(0, kTabTitleViewHeight*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5)];
        Line.backgroundColor = lineImageColor;
        [tabView addSubview:Line];
        [cell.contentView addSubview:tabView];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabOffsetY = round([_tableView rectForSection:1].origin.y)-kNavHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY+1>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
        self.moreButton.hidden = YES;
        self.gobackButton.hidden = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
        self.moreButton.hidden = NO;
        self.gobackButton.hidden = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            
            //            NSLog(@"滑动到顶端---------->%f",offsetY);
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //            NSLog(@"离开顶端");
            //            NSLog(@"离开顶端---------->%f",offsetY);
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
//    NSLog(@"滑动到顶端---------->%f",self.navView.alpha);
    self.navView.alpha = offsetY/tabOffsetY;
}

-(UILabel *)returnlable:(UILabel *)label WithString:(NSString *)string Withindex:(NSInteger)index WithDocument:(NSString *)doc1 WithDoc1:(NSString *)doc2{
    
    label.numberOfLines = 1;
    
    label.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    
    label.textAlignment =NSTextAlignmentLeft;
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",doc1,string,doc2];
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X]  range:NSMakeRange(index,[string length])];
    
    [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(index,[string length])];
    label.attributedText = mutablestr;
    
    [label sizeToFit];
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData{
    NSLog(@"loadData---->%ld",self.project_id);
    [self initUI];
    [self.view addSubview:self.moreButton];
    [self.view addSubview:self.gobackButton];
    [self.view addSubview:self.navView];
    [self addPagerView];
    [self addPageControl];
    
    self.imageDatas = [NSMutableArray arrayWithArray:@[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg"]];
    self.pageControl.numberOfPages = self.imageDatas.count;
    [self.pagerView reloadData];
    [self.pagerView setNeedUpdateLayout];
//    failView.hidden = YES;
//    // 创建组
//    dispatch_group_t group = dispatch_group_create();
//    // 将第一个网络请求任务添加到组中
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 创建信号量
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//        // 开始网络请求任务
//        NSDictionary *dic0 = @{
//                               @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
//                               };
//        
//        [[RequestManager shareRequestManager] GetProjectDtoResult:dic0 viewController:self successData:^(NSDictionary *result){
//            result1= result;
//            // 如果请求成功，发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }failuer:^(NSError *error){
//            error1 = error;
//            // 如果请求失败，也发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }];
//        // 在网络请求任务成功之前，信号量等待中
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    });
//    // 将第2个网络请求任务添加到组中
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 创建信号量
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//        
//        NSDictionary *dic1 = @{
//                               @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
//                               };
//        // 开始网络请求任务
//        [[RequestManager shareRequestManager] IsProjectCollectedResult:dic1 viewController:self successData:^(NSDictionary *result){
//            result2= result;
//            // 如果请求成功，发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }failuer:^(NSError *error){
//            
//            error2 = error;
//            NSLog(@"失败请求数据");
//            // 如果请求失败，也发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }];
//        
//        
//        // 在网络请求任务成功之前，信号量等待中
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    });
//    
//    // 将第3个网络请求任务添加到组中
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 创建信号量
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//        
//        NSDictionary *dic3 = @{
//                               @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
//                               };
//        // 开始网络请求任务
//        
//        [[RequestManager shareRequestManager] SearchReportListSignedUpDtoListResult:dic3 viewController:self successData:^(NSDictionary *result){
//            result3= result;
//            // 如果请求成功，发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }failuer:^(NSError *error){
//            error3 = error;
//            // 如果请求失败，也发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }];
//        // 在网络请求任务成功之前，信号量等待中
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    });
//    
//    
//    // 将第3个网络请求任务添加到组中
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 创建信号量
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//        
//        NSDictionary *dic4 = @{
//                               @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
//                               };
//        // 开始网络请求任务
//        [[RequestManager shareRequestManager] AddProjectBrowsingRecordesult:dic4 viewController:self successData:^(NSDictionary *result){
//            
//            result4= result;
//            // 如果请求成功，发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }failuer:^(NSError *error){
//            error4 = error;
//            // 如果请求失败，也发送信号量
//            dispatch_semaphore_signal(semaphore);
//        }];
//        // 在网络请求任务成功之前，信号量等待中
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    });
//    
//    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        if (error1!=nil||error2!=nil||error3!=nil||error4!=nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//                failView.hidden = NO;
//                [LZBLoadingView dismissLoadingView];
//            });
//            
//        }else{
//            //            NSLog(@"成功请求数据=1:%@",result1);
//            //            NSLog(@"成功请求数据=2:%@",result2);
//            //            NSLog(@"成功请求数据=3:%@",result3);
//            //            NSLog(@"成功请求数据=4:%@",result4);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 更UI5
//                [self initUIView];
//                
//                
//            });
//        }
//    });
}

-(void)onCollect:(UITapGestureRecognizer *)sender{
//    [MobClick event:kProjectDetailCollectButtonclick];
//    
//    if (isProjectCollected) {
//        NSDictionary *dic = @{
//                              @"project_id":[NSString stringWithFormat:@"%ld",(long)self.project_id],
//                              };
//        [[RequestManager shareRequestManager] ProjecDetailCancelCollectionRecordResult:dic viewController:self successData:^(NSDictionary *result){
//            
//            failView.hidden = YES;
//            if(IsSucess(result)){
//                Boolean flag = [[[result objectForKey:@"data"] objectForKey:@"result"] boolValue];
//                if (flag) {
//                    self.collectImageView.image = [UIImage imageNamed:@"icon-collect-gray"];
//                    isProjectCollected = NO;
//                    self.collectLabel.text =@"关注";
//                    [[RequestManager shareRequestManager] tipAlert:@"已取消关注" viewController:self];
//                    
//                }else{
//                    self.collectImageView.image = [UIImage imageNamed:@"icon-collect-red"];
//                    isProjectCollected =YES;
//                    self.collectLabel.text =@"关注";
//                }
//            }else{
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            }
//        }failuer:^(NSError *error){
//            
//            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//            failView.hidden = NO;
//        }];
//    }else{
//        NSDictionary * dic = @{@"project_id":[NSString stringWithFormat:@"%ld",(long)self.project_id],};
//        [[RequestManager shareRequestManager] AddProjectCollectionRecordResult:dic viewController:self successData:^(NSDictionary *result){
//            
//            failView.hidden = YES;
//            if(IsSucess(result)){
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                isProjectCollected =YES;
//                self.collectImageView.image = [UIImage imageNamed:@"icon-collect-red"];
//                self.collectLabel.text =@"已关注";
//                
//                [[RequestManager shareRequestManager] tipAlert:@"关注成功" viewController:self];
//            }else{
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//                isProjectCollected =NO;
//                self.collectImageView.image = [UIImage imageNamed:@"icon-collect-gray"];
//                self.collectLabel.text =@"关注";
//            }
//        }failuer:^(NSError *error){
//            
//            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//            failView.hidden = NO;
//        }];
//    }
}

-(void)onclickButton:(UIButton *)sender{
//    [MobClick event:kProjectDetailonClickEvent];
//    NSDictionary *dic = @{};
//    [[RequestManager shareRequestManager] isReportAllowedResult :dic viewController:self successData:^(NSDictionary *result){
//        
//        if(IsSucess(result)){
//            int  Flag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
//            if (Flag == 1) {
//                ReportViewController *vc = [[ReportViewController alloc]init];
//                vc.tradecode = [NSString stringWithFormat:@"%ld",(long)self.project_industry];
//                vc.project_id = [NSString stringWithFormat:@"%ld",(long)self.project_id];
//                vc.titles = @"推荐客户";
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                [[RequestManager shareRequestManager] tipAlert:@"您暂不允许报备" viewController:self];
//            }
//        }else{
//            [[RequestManager shareRequestManager] resultFail:result viewController:self];
//        }
//        sender.enabled = YES;
//    }failuer:^(NSError *error){
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//        sender.enabled = YES;
//    }];
}

-(void)shareClick:(UIButton *)sender{
    
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

#pragma 懒加载
-(UIView *)navView{
    if (_navView == nil) {
        _navView = [UIView new];
        _navView.frame = CGRectMake(0, 0, kScreenWidth, kNavHeight);
        _navView.backgroundColor = [UIColor whiteColor];
        _navView.alpha = 0;
        UIButton  *gobackButton = [CommentMethod createButtonWithBackgroundImage:[UIImage imageNamed:@"detail_pages_btn_return-1"] Target:self Action:nil Title:@"" textLabelFont:7];
        gobackButton.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 26*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X);
        UIButton  *moreButton = [CommentMethod createButtonWithBackgroundImage:[UIImage imageNamed:@"detail_pages_btn_more"] Target:self Action:nil Title:@"" textLabelFont:7];
        [_navView addSubview:gobackButton];
        moreButton.frame = CGRectMake(kScreenWidth-32*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 26*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X);
        [_navView addSubview:moreButton];
    }
    return _navView;
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    //    pagerView.layer.borderWidth = 1;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 1.0;
    pagerView.layout.layoutType = TYCyclePagerTransformLayoutLinear;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    //    [self.view addSubview:pagerView];
    _pagerView = pagerView;
    _pagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 375*AUTO_SIZE_SCALE_X);
    pagerView.backgroundColor = [UIColor clearColor];
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"pagecontrol-thumb-normal"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"pagecontrol-thumb-selected"];
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
    _pageControl.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame)-20*AUTO_SIZE_SCALE_X, 26);
}

-(UIView *)prepareHeaderView{
    if(_prepareHeaderView==nil){
        self.prepareHeaderView = [UIView new];
        self.prepareHeaderView.frame = CGRectMake(0, 0, kScreenWidth, self.pagerView.frame.size.height+self.personalHeaerView.frame.size.height+self.projectHeaderView.frame.size.height+30*AUTO_SIZE_SCALE_X);
        [self.prepareHeaderView addSubview:self.pagerView];
        self.prepareHeaderView.backgroundColor = [UIColor greenColor];
        [self.prepareHeaderView addSubview:self.projectHeaderView];
        [self.prepareHeaderView addSubview:self.personalHeaerView];
    }
    return _prepareHeaderView;
}

-(UIView *)trueProjectView{
    if (_trueProjectView == nil) {
        _trueProjectView = [UIView new];
        _trueProjectView.backgroundColor = UIColorFromRGB(0xf4f5f7);
        _trueProjectView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 84*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X);
        NSArray *labelsArray = @[@"真实项目",@"精品推荐",@"违约赔付"];
        NSArray *imageArray = @[@"detail_pages_icon_real",@"detail_pages_icon_compensate",@"detail_pages_icon_boutique"];
        for (int i = 0; i<labelsArray.count; i++) {
            UILabel *tempLabel = [UILabel new];
            tempLabel.textAlignment = NSTextAlignmentLeft;
            tempLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
            tempLabel.textColor = FontUIColorGray;
            UIImageView *tempImageView = [UIImageView new];
            tempLabel.text = labelsArray[i];
            tempImageView.image = [UIImage imageNamed:imageArray[i]];
            [_trueProjectView addSubview:tempLabel];
            [_trueProjectView addSubview:tempImageView];
            if (i == 0) {
                tempLabel.frame = CGRectMake(34*AUTO_SIZE_SCALE_X, 10.5*(AUTO_SIZE_SCALE_X), 60*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
                tempImageView.frame =CGRectMake(15*AUTO_SIZE_SCALE_X, 10*(AUTO_SIZE_SCALE_X), 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
            }
            if (i == 1) {
                tempLabel.frame = CGRectMake(158*AUTO_SIZE_SCALE_X, 10.5*(AUTO_SIZE_SCALE_X), 60*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
                tempImageView.frame =CGRectMake(139*AUTO_SIZE_SCALE_X, 10*(AUTO_SIZE_SCALE_X), 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
            }
            if (i == 2) {
                tempLabel.frame = CGRectMake(282*AUTO_SIZE_SCALE_X, 10.5*(AUTO_SIZE_SCALE_X), 60*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
                tempImageView.frame =CGRectMake(263*AUTO_SIZE_SCALE_X, 10*(AUTO_SIZE_SCALE_X), 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
            }
        }
    }
    return _trueProjectView;
}

-(UILabel *)subtitleLabel{
    if (_subtitleLabel == nil) {
        self.subtitleLabel =  [CommentMethod createLabelWithText:@"索尼相机全国总代理" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:17*AUTO_SIZE_SCALE_X];
        self.subtitleLabel.textColor = FontUIColorBlack;
        self.subtitleLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, kScreenWidth-30, 17*AUTO_SIZE_SCALE_X);
    }
    return _subtitleLabel;
}

-(UILabel *)descLabel{
    if (_descLabel == nil) {
        self.descLabel =  [CommentMethod createLabelWithText:@"小机身，高画质，全幅旗舰" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:12*AUTO_SIZE_SCALE_X];
        self.descLabel.textColor = FontUIColorGray;
        self.descLabel.frame =CGRectMake(15*AUTO_SIZE_SCALE_X, self.subtitleLabel.frame.origin.y+self.subtitleLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-(30+110)*AUTO_SIZE_SCALE_X,12*AUTO_SIZE_SCALE_X);
        self.descLabel.backgroundColor = [UIColor clearColor];
        self.descLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    }
    return _descLabel;
}

-(UIView *)projectHeaderView{
    if (_projectHeaderView == nil) {
        self.projectHeaderView = [UIView new];
        self.projectHeaderView.backgroundColor = [UIColor whiteColor];
        self.projectHeaderView.frame =CGRectMake(0,
                                                375*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X,
                                                 kScreenWidth,
                                                 133*AUTO_SIZE_SCALE_X);
        [self.projectHeaderView addSubview:self.subtitleLabel];
        [self.projectHeaderView addSubview:self.descLabel];
        [self.projectHeaderView addSubview:self.trueProjectView];
    }
    return  _projectHeaderView;
}

-(UIView *)personalHeaerView{
    if (_personalHeaerView == nil) {
        self.personalHeaerView = [UIView new];
        self.personalHeaerView.backgroundColor = [UIColor whiteColor];
        self.personalHeaerView.frame =CGRectMake(0,
                                                 375*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X+self.projectHeaderView.frame.size.height+10*AUTO_SIZE_SCALE_X,
                                                 kScreenWidth,
                                                 70*AUTO_SIZE_SCALE_X);
        [self.personalHeaerView addSubview:self.headImageView];
        [self.personalHeaerView addSubview:self.nameLabel];
        [self.personalHeaerView addSubview:self.flagBgView];
        [self.flagBgView addSubview:self.flagImageView];
        [self.flagBgView addSubview:self.flagLabel];
        [self.personalHeaerView addSubview:self.clientDesLabel];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personalHeaerView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.personalHeaerView.mas_top).offset(15*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X));
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personalHeaerView.mas_left).offset(65*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.personalHeaerView.mas_top).offset(15*AUTO_SIZE_SCALE_X);
            make.bottom.equalTo(self.personalHeaerView.mas_bottom).offset(-40*AUTO_SIZE_SCALE_X);
        }];
        
        [self.flagBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(10*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.personalHeaerView.mas_top).offset(15*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(48*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X));
        }];
        [self.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.flagBgView.mas_left).offset(1.5*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.flagBgView.mas_top).offset(1.5*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(12*AUTO_SIZE_SCALE_X,12*AUTO_SIZE_SCALE_X));
        }];
        [self.flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.flagImageView.mas_left).offset(15.5*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.flagBgView.mas_top).offset(3*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(27.5*AUTO_SIZE_SCALE_X,9*AUTO_SIZE_SCALE_X));
        }];
        [self.clientDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personalHeaerView.mas_left).offset(67.5*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.personalHeaerView.mas_top).offset(43*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-(15+67.5)*AUTO_SIZE_SCALE_X,12*AUTO_SIZE_SCALE_X));
        }];
    }
    return  _personalHeaerView;
}

-(void)initUI{
    _tableView = [[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight-kTabHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self.view addSubview:self.collectView];
    [self.view addSubview:self.reportButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
}

-(UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [UIImageView new];
        self.headImageView.backgroundColor = [UIColor redColor];
        self.headImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X);
    }
    return  _headImageView;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        self.nameLabel =  [CommentMethod createLabelWithText:@"ceshi" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:12*AUTO_SIZE_SCALE_X];
    }
    return _nameLabel;
}

-(UILabel *)flagLabel{
    if (_flagLabel == nil) {
        self.flagLabel =  [CommentMethod createLabelWithText:@"已认证" TextColor:blueImageColor BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter Font:9*AUTO_SIZE_SCALE_X];
    }
    return _flagLabel;
}

-(UIView *)flagBgView{
    if (_flagBgView == nil) {
        _flagBgView = [UIView new];
        _flagBgView.layer.borderWidth = 1;
        _flagBgView.layer.borderColor = [blueImageColor CGColor];
        _flagBgView.backgroundColor = [UIColor whiteColor];
        _flagBgView.layer.masksToBounds = YES;
        _flagBgView.layer.cornerRadius = 8.0f;
    }
    return  _flagBgView;
}

-(UIImageView *)flagImageView{
    if (_flagImageView == nil) {
        _flagImageView = [UIImageView new];
        _flagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];
    }
    return  _flagImageView;
}

-(UILabel *)clientDesLabel{
    if (_clientDesLabel == nil) {
        _clientDesLabel =  [CommentMethod createLabelWithText:@"河北省招商总代理 | 北京市友渠信息科技有限公司" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:12*AUTO_SIZE_SCALE_X];
        _clientDesLabel.textColor = FontUIColorGray;
    }
    return _clientDesLabel;
}

-(UIView *)collectView{
    if (_collectView == nil) {
        self.collectView = [UIView new];
        self.collectView.backgroundColor = UIColorFromRGB(0xffffff);
        self.collectView.frame =CGRectMake(0,
                                           kScreenHeight-kTabHeight,
                                           231/2*AUTO_SIZE_SCALE_X,
                                           kTabHeight);
        [self.collectView addSubview:self.collectImageView];
        [self.collectView addSubview:self.collectLabel];
        UITapGestureRecognizer *collect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCollect:)];
        self.collectView.userInteractionEnabled = YES;
        [self.collectView addGestureRecognizer:collect];
        UIImageView *lineimageview= [[UIImageView alloc] init];
        lineimageview.backgroundColor = lineImageColor;
        lineimageview.frame = CGRectMake(0, 0, self.collectView.frame.size.width, 0.5);
        [self.collectView addSubview:lineimageview];
    }
    return  _collectView;
}

-(UIButton *)reportButton{
    if (_reportButton == nil) {
        self.reportButton = [CommentMethod createButtonWithBackgroundColor:RedUIColorC1 Target:self Action:@selector(onclickButton:) Title:@"立刻留言" FontColor:[UIColor whiteColor] FontSize:16*AUTO_SIZE_SCALE_X];
        self.reportButton.frame = CGRectMake(self.collectView.frame.origin.x+self.collectView.frame.size.width, kScreenHeight-kTabHeight, kScreenWidth-self.collectView.frame.size.width, kTabHeight);
    }
    return _reportButton;
}

-(UILabel *)collectLabel{
    if (_collectLabel == nil) {
        self.collectLabel =  [CommentMethod createLabelWithText:@"收藏" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:16*AUTO_SIZE_SCALE_X];
        self.collectLabel.textColor = FontUIColorGray;
        self.collectLabel.frame = CGRectMake(60*AUTO_SIZE_SCALE_X,
                                             16.5*AUTO_SIZE_SCALE_X,
                                             32*AUTO_SIZE_SCALE_X  ,
                                             16*AUTO_SIZE_SCALE_X);
    }
    return _collectLabel;
}

-(UIImageView *)collectImageView{
    if (_collectImageView == nil) {
        self.collectImageView = [UIImageView new];
        self.collectImageView.image = [UIImage imageNamed:@"detail_pages_btn_collection_selected"];
        self.collectImageView.frame = CGRectMake(33*AUTO_SIZE_SCALE_X,
                                                 16*AUTO_SIZE_SCALE_X,
                                                 17*AUTO_SIZE_SCALE_X,
                                                 17*AUTO_SIZE_SCALE_X);
    }
    return  _collectImageView;
}

- (UIButton *)gobackButton {
    if (_gobackButton == nil) {
        self.gobackButton = [CommentMethod createButtonWithBackgroundImage:[UIImage imageNamed:@"detail_pages_btn_return-1"] Target:self Action:@selector(goBack)  Title:@"" textLabelFont:7];
        self.gobackButton.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 26*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X);
    }
    return _gobackButton;
}

-(UIButton *)moreButton{
    if (_moreButton == nil) {
        self.moreButton = [CommentMethod createButtonWithBackgroundImage:[UIImage imageNamed:@"detail_pages_btn_more"] Target:self Action:@selector(shareClick:) Title:@"" textLabelFont:7];
        self.moreButton.frame = CGRectMake(kScreenWidth-32*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 26*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X);
        self.moreButton.alpha = 0.58;
    }
    return _moreButton;
}

@end
