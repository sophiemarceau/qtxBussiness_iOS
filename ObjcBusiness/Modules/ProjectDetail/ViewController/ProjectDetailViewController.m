//
//  ProjectDetailViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//
#import "ProjectDetailViewController.h"
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
#import "CusPageControlWithView.h"
#import "LeaveMessageViewController.h"
#import "SharedView.h"
#import "ComplainViewController.h"

@interface ProjectDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate,UIGestureRecognizerDelegate,SelectSharedTypeDelegate>{
    NSDictionary *dto;
    Boolean isProjectCollected;
    NSMutableArray *titlesArray;
    NSMutableArray *projectsignList;
    NSMutableArray *silkbagArrray;
    NSString *project_desc;
    NSString *project_policy;
    NSString *project_commission_note;
    noWifiView * failView;
    NSDictionary *result1;
    NSDictionary *result2;
    NSError *error1;NSError *error2;
    UIView *indicateLine;
    NSString *image_url;
    CusPageControlWithView *pageControllDot;
    NSString *clientTitle ;
    UIImageView *barImageView;
    NSInteger total_count;
}
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
@property(nonatomic,strong)UIImageView *flagBgView;
@property(nonatomic,strong)UILabel *titleLabel;


@property(nonatomic,strong)UILabel *clientDesLabel;

@property(nonatomic,strong)YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *tableView;

@property(nonatomic,strong)UIView *collectView;
@property(nonatomic,strong)UIImageView *collectImageView;
@property(nonatomic,strong)UILabel *collectLabel,*investLabel;
@property(nonatomic,strong)UIButton *reportButton;

@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabView;
@property(nonatomic,assign)BOOL isTopIsCanNotMoveTabViewPre;
@property(nonatomic,assign)BOOL canScroll;

@property(nonatomic,strong)UIButton *gobackButton;
@property(nonatomic,strong)UIButton *moreButton;


@property(nonatomic,strong)NSMutableArray *labelsArray,*imageArray;
@property (nonatomic, strong) UIImage *shadowImage;
@end

@implementation ProjectDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initNavgation];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(towebview:) name:kProjectDetailToPost object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finish:) name:kfinishLoadingView object:nil];
    
    project_desc =project_policy = @"";
    silkbagArrray = [NSMutableArray arrayWithCapacity:0];
    
    [self loadData];
    //加载数据失败时显示
    failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    [failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    failView.hidden = YES;
    [self.view addSubview:failView];
}

#pragma mark -Navigation
- (void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
//    UIImage *goBackImage = nil;
//    goBackImage =[UIImage imageNamed:@"detail_pages_btn_more"];
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:goBackImage forState:UIControlStateNormal];
//
//    [backButton sizeToFit];
//    //点击事件
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [leftBackItem setTitle:@""];
//    self.navigationItem.leftBarButtonItem = leftBackItem;
//
//
//    UIImage *rightImage = nil;
//    rightImage =[UIImage imageNamed:@"detail_pages_btn_more"];
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setImage:rightImage forState:UIControlStateNormal];
//    [rightButton sizeToFit];
//    //点击事件
//    [rightButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//
//    [rightBackItem setTitle:@""];
//    self.navigationItem.rightBarButtonItem = rightBackItem;
//}
}
- (void)adjuestNavigator{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIImage *goBackImage = nil;
    goBackImage =[UIImage imageNamed:@"detail_pages_btn_return"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:goBackImage forState:UIControlStateNormal];
    
    [backButton sizeToFit];
    //点击事件
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [leftBackItem setTitle:@""];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    
    UIImage *rightImage = nil;
    rightImage =[UIImage imageNamed:@"detail_pages_btn_more"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton sizeToFit];
    //点击事件
    [rightButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [rightBackItem setTitle:@""];
    self.navigationItem.rightBarButtonItem = rightBackItem;
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
//    NSLog(@"canscrol===========notifcation------->%@",notification);
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
    //    cell.cycleImageView.image = [UIImage imageNamed:self.imageDatas[index]];
    [cell.cycleImageView sd_setImageWithURL:self.imageDatas[index]
//                           placeholderImage:[UIImage imageNamed:@""]
     ];
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
    pageControllDot.indexNumWithSlide = toIndex;
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
    CGFloat height = 0;
    if (section==0) {
        //        NSLog(@"height-pagerView---->%ld",self.pagerView.frame.size.height);
        //        NSLog(@"height---projectHeaderView-->%ld",self.projectHeaderView.frame.size.height);
        //        NSLog(@"height-personalHeaerView---->%ld",self.personalHeaerView.frame.size.height);
        self.prepareHeaderView.frame = CGRectMake(0,
                                                  0,
                                                  kScreenWidth,
                                                  self.pagerView.frame.size.height +
                                                  self.projectHeaderView.frame.size.height+
                                                  self.personalHeaerView.frame.size.height+
                                                  30*AUTO_SIZE_SCALE_X);
        height = [self prepareHeaderView].frame.size.height;
    }else if(section==1){
        height = CGRectGetHeight(self.view.frame)-kNavHeight-kTabHeight;
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
                                        @"position":@0,
                                        @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                                        @"total_count":[NSString stringWithFormat:@"%ld",(long)total_count],
                                        },
                                    @{
                                        @"title":@"合作模式",
                                        @"view":@"InvestmentDetailTableViw",
                                        @"data":project_policy,
                                        @"position":@1,
                                        @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                                        @"total_count":[NSString stringWithFormat:@"%ld",(long)total_count],
                                        },
                                    @{
                                        @"title":clientTitle,
                                        @"view":@"CommentView",
                                        @"data":silkbagArrray,
                                        @"position":@2,
                                        @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                                        @"total_count":[NSString stringWithFormat:@"%ld",(long)total_count],
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
    
    
    barImageView.alpha = scrollView.contentOffset.y/(self.prepareHeaderView.frame.size.height-kNavHeight);
    CGFloat tabOffsetY = self.prepareHeaderView.frame.size.height-kNavHeight;
//    CGFloat tabOffsetY = round([_tableView rectForSection:1].origin.y)-kNavHeight;
    
    
//    NSLog(@"tabOffsetY------->%f",tabOffsetY);
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"offsetY------->%f",offsetY);
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY+1>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
        self.title = self.subtitleLabel.text;
        
    }else{
        _isTopIsCanNotMoveTabView = NO;
        self.moreButton.hidden = NO;
        self.gobackButton.hidden = NO;
        self.title = @"";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    result1 = result2 = nil;
    failView.hidden = YES;
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第一个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        NSDictionary *dic0 = @{
                               @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                               @"_currentPage":@"",
                               @"_pageSize":@"",
                               };
        [[RequestManager shareRequestManager] searchProjectMessageDtos4Project:dic0 viewController:self successData:^(NSDictionary *result){
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
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSDictionary *dic1 = @{
                               @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                               };
        // 开始网络请求任务
        [[RequestManager shareRequestManager] getProjectDto4App:dic1 viewController:self successData:^(NSDictionary *result){
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
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (result1 == nil||result2==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                failView.hidden = NO;
                [LZBLoadingView dismissLoadingView];
            });
            
        }else{
//            NSLog(@"成功请求数据=1:%@",result1);
//            NSLog(@"成功请求数据=2:%@",result2);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更UI5
                [self initUIView];
                failView.hidden = YES;
                [LZBLoadingView dismissLoadingView];
            });
        }
    });
}

-(void)initUIView{
    
    if (IsSucess(result1) == 1) {
        NSArray *array = [[result1 objectForKey:@"data"] objectForKey:@"list"];
        total_count  = [[[result1 objectForKey:@"data"] objectForKey:@"total_count"] integerValue];
        if(![array isEqual:[NSNull null]] && array !=nil){
            [silkbagArrray addObjectsFromArray:array];
        }
    }else{
        if (IsSucess(result1) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result1];
        }else{
            [[RequestManager shareRequestManager] resultFail:result1 viewController:self];
        }
    }
    if (IsSucess(result2) == 1) {
        dto = result2[@"data"][@"dto"];
        if(![dto isEqual:[NSNull null]] && dto !=nil){
            
            self.subtitleLabel.text = dto[@"project_name"];
            self.descLabel.text = dto[@"project_slogan"];
            self.imageDatas = [NSMutableArray arrayWithCapacity:0];
            NSString *picc = dto[@"project_detail_pics"];
            NSArray *picsArray = [picc componentsSeparatedByString:@","];
            if (picsArray != nil && ![picsArray isEqual:[NSNull null]] && picsArray.count >0 ) {
                [self addPagerView];
                [self.imageDatas addObjectsFromArray:picsArray];
                self.pageControl.numberOfPages = self.imageDatas.count;
                [self addPageControl];
                [self.pagerView reloadData];
                [self.pagerView setNeedUpdateLayout];
            }
            NSString *string = [NSString stringWithFormat:@"%@",dto[@"minModeAmountName"]];
            NSString *str = [NSString stringWithFormat:@"投入%@",string];
            NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc] initWithString:str];
            self.investLabel.textColor =UIColorFromRGB(0x333333);
            [mutablestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X]  range:NSMakeRange(2,[string length])];
            [mutablestr addAttribute:NSForegroundColorAttributeName value:RedUIColorC1 range:NSMakeRange(2,[string length])];
            self.investLabel.attributedText = mutablestr;
            
            int trueflag =  [dto[@"project_authentication"] intValue];
            int project_recommend =  [dto[@"project_recommend"] intValue];
            int project_default_compensation =  [dto[@"project_default_compensation"] intValue];
        
         
            self.labelsArray = [NSMutableArray arrayWithCapacity:0];
            self.imageArray = [NSMutableArray arrayWithCapacity:0];
            //项目如果未认证且没有推荐标识 项目详情不显示标识显示条
            if (trueflag != 3  && project_recommend != 1 ) {
                self.trueProjectView.hidden = YES;
            }else{
                 self.trueProjectView.hidden = NO;
            }
            if (self.trueProjectView.hidden) {
                self.projectHeaderView.frame =CGRectMake(0,
                                                         375*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X,
                                                         kScreenWidth,
                                                         79*AUTO_SIZE_SCALE_X);
            }else{
                if (trueflag != 3 ) {
                    
                    [self.labelsArray addObject: @"未认证"];
                    [self.imageArray addObject:@"detail_pages_icon_real"];
                }else{
                    
                    [self.labelsArray addObject: @"官方认证"];
                    [self.imageArray addObject:@"detail_pages_icon_real"];
                    
                    
                }
                
                [self.labelsArray addObject: @"精品推荐"];
                [self.imageArray addObject:@"detail_pages_icon_compensate"];
                
                [self.labelsArray addObject:@"违约赔付"];
                [self.imageArray addObject:@"detail_pages_icon_boutique"];
                
                
                [self.projectHeaderView addSubview:self.trueProjectView];
                for (int i = 0; i<self.labelsArray.count; i++) {
                    UILabel *tempLabel = [UILabel new];
                    tempLabel.textAlignment = NSTextAlignmentLeft;
                    tempLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
                    tempLabel.textColor = FontUIColorBlack;
                    UIImageView *tempImageView = [UIImageView new];
                    tempLabel.text = self.labelsArray[i];
                    tempImageView.image = [UIImage imageNamed:self.imageArray[i]];
                    [self.trueProjectView addSubview:tempLabel];
                    [self.trueProjectView addSubview:tempImageView];
                    if (i == 0) {
                        tempLabel.frame = CGRectMake(34*AUTO_SIZE_SCALE_X, 10.5*(AUTO_SIZE_SCALE_X), 60*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
                        tempImageView.frame =CGRectMake(15*AUTO_SIZE_SCALE_X, 10*(AUTO_SIZE_SCALE_X), 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
                        if (trueflag != 3 ) {
                            tempLabel.hidden = YES;
                            tempImageView.hidden = YES;
                        }
                    }
                    if (i == 1) {
                        tempLabel.frame = CGRectMake(158*AUTO_SIZE_SCALE_X, 10.5*(AUTO_SIZE_SCALE_X), 60*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
                        tempImageView.frame =CGRectMake(139*AUTO_SIZE_SCALE_X, 10*(AUTO_SIZE_SCALE_X), 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
                        if (project_recommend != 1 ) {
                            tempLabel.hidden = YES;
                            tempImageView.hidden = YES;
                        }
                    }
                    if (i == 2) {
                        tempLabel.frame = CGRectMake(282*AUTO_SIZE_SCALE_X, 10.5*(AUTO_SIZE_SCALE_X), 60*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
                        tempImageView.frame =CGRectMake(263*AUTO_SIZE_SCALE_X, 10*(AUTO_SIZE_SCALE_X), 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
                        if (project_default_compensation != 1 ) {
                            tempLabel.hidden = YES;
                            tempImageView.hidden = YES;
                        }
                    }
                }
                self.projectHeaderView.frame =CGRectMake(0,
                                                         375*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X,
                                                         kScreenWidth,133*AUTO_SIZE_SCALE_X);
            }

            [self.headImageView sd_setImageWithURL:dto[@"userCDto"][@"c_photo"] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
            self.nameLabel.text = dto[@"userCDto"][@"c_realname"];
            int isAuchentication = [dto[@"cac_status_code"] intValue];
            if (isAuchentication == 1) {
                 self.flagBgView.image = [UIImage imageNamed:@"icon_authentication_complete_blue1"];
//                self.flagBgView.layer.borderColor = [blueImageColor CGColor];
//                self.flagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];
//                self.flagLabel.textColor = blueImageColor;
//                self.flagLabel.text = @"已认证";
            }else{
//                self.flagBgView.layer.borderColor = [FontUIColor999999Gray CGColor];
                self.flagBgView.image = [UIImage imageNamed:@"icon_authentication_default1"];
//                self.flagImageView.image = [UIImage imageNamed:@"icon_authentication_default"];
//                self.flagLabel.textColor = FontUIColor999999Gray;
//                self.flagLabel.text = @"未认证";
            }
            self.clientDesLabel.text = [NSString stringWithFormat:@"%@ | %@",dto[@"userCDto"][@"c_jobtitle"],dto[@"companyDto"][@"company_name"]];
            
            clientTitle = [NSString stringWithFormat:@"意向客户(%d)",[dto[@"projectExtDto"][@"pe_message_count"] intValue]];
            project_desc = dto[@"projectDetailsH5Url"];
            project_policy = dto[@"projectCooperationModeH5Url"];
            
            [self initUI];

            isProjectCollected = [dto[@"project_isCollect"] intValue];
            if (isProjectCollected) {
                self.collectImageView.image = [UIImage imageNamed:@"detail_pages_btn_collection_selected"];
                self.collectLabel.text =@"已收藏";
            }else{
                self.collectImageView.image = [UIImage imageNamed:@"detail_pages_btn_collection_normal"];
                self.collectLabel.text =@"收藏";
            }
        }
    }else{
        if (IsSucess(result2) == -1) {
            [[RequestManager shareRequestManager] loginCancel:result2];
        }else{
            [[RequestManager shareRequestManager] resultFail:result2 viewController:self];
        }
    }
}

-(void)onCollect:(UITapGestureRecognizer *)sender{
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            if (isProjectCollected) {
                NSDictionary *dic = @{
                                      @"project_id":[NSString stringWithFormat:@"%ld",(long)self.project_id],
                                      };
                [[RequestManager shareRequestManager] cancelProjectCollect:dic viewController:self successData:^(NSDictionary *result){
                    
                    failView.hidden = YES;
                    if(IsSucess(result) == 1){
                        Boolean flag = [[[result objectForKey:@"data"] objectForKey:@"result"] boolValue];
                        if (flag) {
                            self.collectImageView.image = [UIImage imageNamed:@"detail_pages_btn_collection_normal"];
                            isProjectCollected = NO;
                            self.collectLabel.text =@"收藏";
                            [[RequestManager shareRequestManager] tipAlert:@"已取消收藏" viewController:self];
                            
                        }else{
                            self.collectImageView.image = [UIImage imageNamed:@"detail_pages_btn_collection_selected"];
                            isProjectCollected =YES;
                            self.collectLabel.text =@"已收藏";
                        }
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
                NSDictionary * dic = @{@"project_id":[NSString stringWithFormat:@"%ld",(long)self.project_id],
                                       @"pc_source":@"2"
                                       };
                [[RequestManager shareRequestManager] addProjectCollect:dic viewController:self successData:^(NSDictionary *result){
//                    NSLog(@"result--addProjectCollect------>%@",result);
                    failView.hidden = YES;
                    if(IsSucess(result) == 1){
                        [[RequestManager shareRequestManager] resultFail:result viewController:self];
                        isProjectCollected =YES;
                        self.collectImageView.image = [UIImage imageNamed:@"detail_pages_btn_collection_selected"];
                        self.collectLabel.text =@"已收藏";
                        
                        [[RequestManager shareRequestManager] tipAlert:@"收藏成功" viewController:self];
                    }else{
                        
                        isProjectCollected =NO;
                        self.collectImageView.image = [UIImage imageNamed:@"detail_pages_btn_collection_normal"];
                        self.collectLabel.text =@"收藏";
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

-(void)onclickButton:(UIButton *)sender{
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            LeaveMessageViewController *vc = [[LeaveMessageViewController alloc] init];
            vc.project_id = self.project_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
    }
    
    
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
    NSString  *pic = [NSString stringWithFormat:@"%@",dto[@"project_cover_pic"]];
    NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:pic]];
    id image = [UIImage imageWithData:data];
    if (image == nil) {
        image = @"";
    }
    NSDictionary *dic = @{@"title" :self.subtitleLabel.text,
                          @"desc" :self.descLabel.text,
                          @"image": image,
                          @"url"  :[NSString stringWithFormat:@"%@/%@",@"project",[NSString stringWithFormat:@"%ld",self.project_id]]};
    SharedView *sharedView = [[SharedView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    sharedView.delegate = self;
    sharedView.currentVC = self;
    [sharedView initPublishContent:dic FlagWithDeleButton:0];
}

- (void)SelectSharedTypeDelegateReturnPage:(ShareType)returnShareType{
    if (returnShareType == ShareTypeReport) {
        NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
        NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (userID) {
            if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
                ComplainViewController *vc = [[ComplainViewController alloc] init];
                vc.feedback_kind = 1;
                vc.reportType = 6;
                vc.reportFromID = self.project_id;
                vc.FromProjectFlag = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
        }
       
    }
    if(returnShareType == ShareTypeDelete){
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (returnShareType == ShareTypeCopy) {
        [[RequestManager shareRequestManager] tipAlert:@"复制成功" viewController:self];
    }
}

-(void)goBack{
     [super goBack];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.alpha = 0;
    self.navigationController.navigationBar.alpha = 0;
    [MobClick beginLogPageView:kProjectDetailPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [MobClick endLogPageView:kProjectDetailPage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.alpha = 1;
    
    self.title = @"";
}

#pragma 懒加载
//-(UIView *)navView{
//    if (_navView == nil) {
//        _navView = [UIView new];
//        _navView.frame = CGRectMake(0, 0, kScreenWidth, kNavHeight);
//        _navView.backgroundColor = [UIColor whiteColor];
//        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.frame.size.height-0.5, kScreenWidth, 0.5)];
//        lineImageView.backgroundColor = lineImageColor;
//        [_navView addSubview:lineImageView];
//        _navView.alpha = 0;
//        UIButton  *gobackButton = [CommentMethod createButtonWithBackgroundImage:[UIImage imageNamed:@"detail_pages_btn_return-1"] Target:self Action:nil Title:@"" textLabelFont:7];
//        gobackButton.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 26*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X);
//        UIButton  *moreButton = [CommentMethod createButtonWithBackgroundImage:[UIImage imageNamed:@"detail_pages_btn_more"] Target:self Action:nil Title:@"" textLabelFont:7];
//        [_navView addSubview:gobackButton];
//        moreButton.frame = CGRectMake(kScreenWidth-32*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 26*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X, 32*AUTO_SIZE_SCALE_X);
//        [_navView addSubview:moreButton];
//        //创建标题
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.font = [UIFont systemFontOfSize:17.0f];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel = titleLabel;
//        self.titleLabel.frame = CGRectMake((kScreenWidth-200)/2, 20, 200, 44);
//        [_navView addSubview:titleLabel];
//
//    }
//    return _navView;
//}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    //    pagerView.layer.borderWidth = 1;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
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
    
    CGRect rectValue=CGRectMake(10*AUTO_SIZE_SCALE_X, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame)-20*AUTO_SIZE_SCALE_X, 26);
    UIImage *currentImage = [UIImage imageNamed:@"project__roduct_drawing_one"];
    UIImage *pageImage = [UIImage imageNamed:@"project__roduct_drawing_two"];
    
    pageControllDot=[[CusPageControlWithView alloc] initWithCusPageControl:rectValue pageNum:self.imageDatas.count currentPageIndex:0 currentShowImage:currentImage pageIndicatorShowImage:pageImage];
    //    [CusPageControlWithView cusPageControlWithView:rectValue pageNum:self.imageDatas.count currentPageIndex:0 currentShowImage:currentImage pageIndicatorShowImage:pageImage];
    
    [_pagerView addSubview:pageControllDot];
    //    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //    //pageControl.numberOfPages = _datas.count;
    //    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    pageControl.pageIndicatorImage = [UIImage imageNamed:@"slideCirclePoint"];
    //    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"slidePoint"];
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    //    [_pagerView addSubview:pageControl];
    //    _pageControl = pageControl;
    //    _pageControl.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame)-20*AUTO_SIZE_SCALE_X, 26);
}

-(UIView *)prepareHeaderView{
    if(_prepareHeaderView==nil){
        self.prepareHeaderView = [UIView new];
        self.prepareHeaderView.backgroundColor = BGColorGray;
        [self.prepareHeaderView addSubview:self.pagerView];
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
    }
    return _trueProjectView;
}

-(UILabel *)subtitleLabel{
    if (_subtitleLabel == nil) {
        self.subtitleLabel =  [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:17 TextColor:FontUIColorBlack];

        self.subtitleLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, kScreenWidth-30, 17*AUTO_SIZE_SCALE_X);
    }
    return _subtitleLabel;
}

-(UILabel *)descLabel{
    if (_descLabel == nil) {
        self.descLabel =  [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorBlack];
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
        [self.projectHeaderView addSubview:self.subtitleLabel];
        [self.projectHeaderView addSubview:self.descLabel];
        [self.projectHeaderView addSubview:self.investLabel];
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
        
        [self.clientDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personalHeaerView.mas_left).offset(65*AUTO_SIZE_SCALE_X);
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
        self.headImageView.backgroundColor = [UIColor clearColor];
        self.headImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X);
        self.headImageView.layer.cornerRadius = 40/2*AUTO_SIZE_SCALE_X;
        self.headImageView.layer.borderWidth= 1.0;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return  _headImageView;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        self.nameLabel =[ CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
//        [CommentMethod createLabelWithText:@"" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:12*AUTO_SIZE_SCALE_X];
    }
    return _nameLabel;
}

//-(UILabel *)flagLabel{
//    if (_flagLabel == nil) {
//        self.flagLabel =  [CommentMethod createLabelWithText:@"已认证" TextColor:blueImageColor BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter Font:9*AUTO_SIZE_SCALE_X];
//    }
//    return _flagLabel;
//}

-(UIView *)flagBgView{
    if (_flagBgView == nil) {
        _flagBgView = [UIImageView new];
//        _flagBgView.layer.borderWidth = 1;
//        _flagBgView.layer.borderColor = [blueImageColor CGColor];
//        _flagBgView.backgroundColor = [UIColor whiteColor];
//        _flagBgView.layer.masksToBounds = YES;
//        _flagBgView.layer.cornerRadius = 8.0f;
    }
    return  _flagBgView;
}

//-(UIImageView *)flagImageView{
//    if (_flagImageView == nil) {
//        _flagImageView = [UIImageView new];
//        _flagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];
//    }
//    return  _flagImageView;
//}

-(UILabel *)clientDesLabel{
    if (_clientDesLabel == nil) {
        _clientDesLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorBlack];
//        [CommentMethod createLabelWithText:@"" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:12*AUTO_SIZE_SCALE_X];
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
                                           (kTabHeight)-(BottomHeight));
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
        self.reportButton.frame = CGRectMake(self.collectView.frame.origin.x+self.collectView.frame.size.width, kScreenHeight-kTabHeight, kScreenWidth-self.collectView.frame.size.width, kTabHeight-(BottomHeight));
    }
    return _reportButton;
}

-(UILabel *)collectLabel{
    if (_collectLabel == nil) {
        self.collectLabel =  [CommentMethod createLabelWithText:@"收藏" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:16];
        self.collectLabel.textColor = FontUIColorGray;
        self.collectLabel.frame = CGRectMake(60*AUTO_SIZE_SCALE_X,
                                             16.5*AUTO_SIZE_SCALE_X,
                                             40*AUTO_SIZE_SCALE_X  ,
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
        self.moreButton.enabled = YES;
    }
    return _moreButton;
}

-(UILabel *)investLabel{
    if(_investLabel == nil){
        _investLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:15 TextColor:FontUIColorBlack];
         self.investLabel.frame =CGRectMake(kScreenWidth-135*AUTO_SIZE_SCALE_X, 42*AUTO_SIZE_SCALE_X, 120*AUTO_SIZE_SCALE_X,18.5*AUTO_SIZE_SCALE_X);
    }
    return _investLabel;
}
@end


