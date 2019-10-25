//
//  BossListViewContrller.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossListViewContrller.h"
#import "MMComBoBoxView.h"
#import "BaseTableView.h"
#import "MMComBoBox.h"
#import "DistrictManager.h"
#import "MJDIYBackFooter.h"
#import "BossCellFrame.h"
#import "BossTableViewCell.h"
#import "BossTableViewCell+BossCellFrame.h"
#import "BossComingViewController.h"
#import "PYSearch.h"
#import "SearchViewController.h"
#import "CreateProjectViewController.h"
#import "ProjectManagerViewController.h"
#import "PerfectAttentionView.h"
#import "PersonalViewController.h"
#import "PersonalHomePageViewController.h"
@interface BossListViewContrller ()<UIGestureRecognizerDelegate,MMComBoBoxViewDataSource, MMComBoBoxViewDelegate,UITableViewDelegate,UITableViewDataSource,BackToPersonViewDelegate>{
    int current_page;
    int total_count;
    noContent * nocontent;
    
    NSString *_sort;//排序方式：1、推荐；2、最新；
    NSString *_project_industry;//项目行业 code
    UIView *customSearchBar;
    NSInteger projectCount ;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) BaseTableView *bossListView;
@property (nonatomic, strong) MMComBoBoxView *tabTitleView;
@property (nonatomic, strong) NSMutableArray *mutableArray,*hotTagListArray;
@property (nonatomic, assign) BOOL isMultiSelection;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) noWifiView *failView;
@end

@implementation BossListViewContrller

- (void)viewDidLoad {
    _sort = _project_industry = @"";
    [super viewDidLoad];
    [self initSubViews];
    [self loadData];
    [self loadProject];
    [self getHotSearchData];
    
}

- (void)reloadButtonClick:(UIButton *)sender {
    projectCount= 0;
    [self.hotTagListArray removeAllObjects];
    [self loadData];
    [self loadProject];
    [self getHotSearchData];
}

-(void)BackPersonViewDelegateReturnPage{
    PersonalViewController *vc = [[PersonalViewController alloc] init];
    vc.title = @"个人主页";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    customSearchBar = [[UIView alloc] initWithFrame:CGRectMake(15, kSystemBarHeight+8*AUTO_SIZE_SCALE_X, 284*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X)];
    customSearchBar.backgroundColor = UIColorFromRGB(0xf4f5f7);
    customSearchBar.layer.cornerRadius = 14.0f;
    [self.navigationController.view addSubview:customSearchBar];
    
    UIImageView *imageicon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qa_home_search"]];
    imageicon.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, 7.5*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X);
    [customSearchBar addSubview:imageicon];
    
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageicon.frame)+10*AUTO_SIZE_SCALE_X, 0, 180*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X)];
    searchLabel.text = @"请输入想知道的任何内容";
    searchLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    searchLabel.textAlignment = NSTextAlignmentLeft;
    searchLabel.textColor = FontUIColor999999Gray;
    [customSearchBar addSubview:searchLabel];
    customSearchBar.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
    [customSearchBar addGestureRecognizer:tap1];
    
    UIImageView *rightImageView =  [UIImageView new];
    rightImageView.image = [UIImage imageNamed:@"boss_icon_settled"];
    rightImageView.frame = CGRectMake(0,
                                      (kNavHeight-kSystemBarHeight-13*AUTO_SIZE_SCALE_X)/2,
                                      13*AUTO_SIZE_SCALE_X,
                                      13*AUTO_SIZE_SCALE_X);
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame  = CGRectMake(kScreenWidth-(46-15)*AUTO_SIZE_SCALE_X, 0, 46*AUTO_SIZE_SCALE_X, kNavHeight-kSystemBarHeight);
    [rightButton addSubview:rightImageView];
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rightImageView.frame)+5*AUTO_SIZE_SCALE_X, 0, 35*AUTO_SIZE_SCALE_X, kNavHeight-kSystemBarHeight)];
    buttonLabel.text = @"入驻";
    buttonLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
    buttonLabel.textAlignment = NSTextAlignmentLeft;
    buttonLabel.textColor = RedUIColorC1;
    [rightButton addSubview:buttonLabel];
    [rightButton addTarget:self action:@selector(gotoThisProgram:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBackItem;
}

-(void)initSubViews{
    [self.view addSubview:self.tabTitleView];
     [self.tabTitleView reload];
    [self.view addSubview:self.bossListView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight+self.tabTitleView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-self.tabTitleView.frame.size.height)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

-(void)loadProject{
    
}

-(void)GetUserInfoResult{
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
            NSString *user_id_str = [DEFAULTS objectForKey:@"user_id_str"];
            if (!user_id_str) {
                user_id_str  = @"";
            }
            NSDictionary *dic = @{
                                  @"user_id_str":user_id_str,
                                  @"_isReturnCompanyInfo":@"1",
                                  @"_isReturnExt":@"1"
                                  };
            [[RequestManager shareRequestManager] GetUserInfoResult:dic viewController:self successData:^(NSDictionary *result) {
//                NSLog(@"GetUserInfoResult------>%@",result);
                if (IsSucess(result) == 1) {
                    NSDictionary *resultDic = [[result objectForKey:@"data"] objectForKey:@"result"];
                    NSString *description = [resultDic objectForKey:@"c_description"];
                    if(description == nil ||[description isEqualToString:@""]){
                        PerfectAttentionView *sharedView;
                        sharedView = [[PerfectAttentionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                        sharedView.delegate = self;
                    }
                }else{
                    if (IsSucess(result) == -1) {
                        [[RequestManager shareRequestManager] loginCancel:result];
                    }else{
                        [[RequestManager shareRequestManager] resultFail:result viewController:self];
                    }
                }
                [LZBLoadingView dismissLoadingView];
            } failuer:^(NSError *error) {
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                [LZBLoadingView dismissLoadingView];
            }];
        }
    }
}

-(void)loadData{
    
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          @"_Keyword":@"",
                          @"_sort":_sort,//排序方式：1、推荐；2、最新；
                          @"_project_industry":_project_industry,//项目行业 code
                          };
    [[RequestManager shareRequestManager] searchBossProjectDtos:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"boss----list-------result--------------->%@",result);
        [self.bossListView.mj_header endRefreshing];
        [self.bossListView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            [self.data removeAllObjects];
            if(![array isEqual:[NSNull null]] && array != nil){
                for (NSDictionary *dict in array) {
                    BossModel *bossModel = [BossModel logisticsWithDict:dict];
                    BossCellFrame *cellFrame = [[BossCellFrame alloc] init];
                    cellFrame.bossModel = bossModel;
                    [self.data addObject:cellFrame];
                }
               
                [self.bossListView reloadData];
                if (array.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (array.count == total_count || array.count == 0) {
                    [self.bossListView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }else{
                nocontent.hidden = NO;
            }
            if (total_count == 0) {
                [self.bossListView.mj_footer endRefreshingWithNoMoreData];
            }else{
                NSIndexPath *indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.bossListView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        
       
        self.failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [self.bossListView.mj_header endRefreshing];
        [self.bossListView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)giveMeMoreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    //        NSString * pageOffset = @"20";
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",
                          @"_Keyword":@"",
                          @"_sort":_sort,//排序方式：1、推荐；2、最新；
                          @"_project_industry":_project_industry,//项目行业 code
                          };
    [[RequestManager shareRequestManager] searchBossProjectDtos:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"boss----list-----givememore--result--------------->%@",result);
        [self.bossListView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array != nil){
                for (NSDictionary *dict in array) {
                    BossModel *bossModel = [BossModel logisticsWithDict:dict];
                    BossCellFrame *cellFrame = [[BossCellFrame alloc] init];
                    cellFrame.bossModel = bossModel;
                    [self.data addObject:cellFrame];
                }
                
                [self.bossListView reloadData];
                if (self.data.count == total_count) {
                    [self.bossListView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
    }failuer:^(NSError *error){
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [self.bossListView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)gotoThisProgram:(UIButton *)sender{
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            NSString *userkind = [DEFAULTS objectForKey:@"userKind"];
            if (![userkind isEqualToString:@"2"]) {
                BossComingViewController *vc = [[BossComingViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSDictionary *dic = @{};
                [[RequestManager shareRequestManager] getProjectCountByUserId:dic viewController:self successData:^(NSDictionary *result) {
//                    NSLog(@"boss----getProjectCountByUserId-------result--------------->%@",result);
                    if (IsSucess(result) == 1) {
                        projectCount = [[[result objectForKey:@"data"] objectForKey:@"result"] integerValue];
                        if (projectCount > 0) {
                            ProjectManagerViewController *vc = [[ProjectManagerViewController alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            CreateProjectViewController *vc = [[CreateProjectViewController alloc] init];
                            vc.viewType = CreateProject;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }else {
                        if (IsSucess(result) == -1) {
                            [[RequestManager shareRequestManager] loginCancel:result];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self];
                        }
                    }
                } failuer:^(NSError *error) {
                    [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                }];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
    }
}

-(void)gotoSearchView{
    //    SearchViewController *vc = [[SearchViewController alloc] init];
    //
    //    vc.title = @"搜索";
    //    [self.navigationController pushViewController:vc animated:YES];
    
    // 1. Create an Array of popular search
    NSMutableArray *hotArray = [NSMutableArray arrayWithCapacity:self.hotTagListArray.count];
    for (NSDictionary *tagDic  in self.hotTagListArray) {
        [hotArray addObject:tagDic[@"tag_content"]];
    }
    //    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotArray searchBarPlaceholder:@"请输入关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        SearchViewController *vc = [[SearchViewController alloc] init];
        vc.searchStr = searchText;
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
    // 3. Set style for popular search and search history
    searchViewController.hotSearchStyle = PYSearchHistoryStyleBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleDefault;
    
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [self gotoSearchView];
}

#pragma mark BaseTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BossCellFrame *bossCellFrame = [self.data objectAtIndex:indexPath.row];
    return bossCellFrame.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BossTableViewCell *cell = [BossTableViewCell userStatusCellWithTableView:tableView];
    BossCellFrame *bossCellFrame =  [self.data objectAtIndex:indexPath.row];
    [cell configureWithListEntity:bossCellFrame];
    cell.superVC = self;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    BossCellFrame *bossCellFrame =  [self.data objectAtIndex:indexPath.row];
    vc.user_id = bossCellFrame.bossModel.bossID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.mutableArray.count;
}

- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.mutableArray[column];
}

#pragma mark - MMComBoBoxViewDelegate
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    MMItem *rootItem = self.mutableArray[index];
    switch (rootItem.displayType) {
        case MMPopupViewDisplayTypeNormal:
        case MMPopupViewDisplayTypeMultilayer:{
            //拼接选择项
            NSMutableString *title = [NSMutableString string];
            
            NSMutableString *codeStr = [NSMutableString string];
            __block NSInteger firstPath;
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                [title appendString:idx?[NSString stringWithFormat:@";%@",[rootItem findTitleBySelectedPath:path]]:[rootItem findTitleBySelectedPath:path]];
                //                [codeStr appendString:idx?[NSString stringWithFormat:@";%@",[rootItem findCodeBySelectedPath:path]]:[rootItem findCodeBySelectedPath:path]];
                if (idx == 0) {
                    firstPath = path.firstPath;
                }
                [codeStr appendString:[rootItem findCodeBySelectedPath:path]];
            }];
            if([rootItem.title isEqualToString:@"推荐"]){
                _sort = codeStr;
            }
           
            if([rootItem.title isEqualToString:@"行业"]){
                _project_industry = codeStr;
            }
            [self.bossListView.mj_footer endRefreshing];
//            NSLog(@"当title为%@时，所选字段为 %@---code---%@",rootItem.title ,title,codeStr);
            [self loadData];
            
            break;
        }
        case MMPopupViewDisplayTypeFilters:{
            MMCombinationItem * combineItem = (MMCombinationItem *)rootItem;
            [array enumerateObjectsUsingBlock:^(NSMutableArray*  _Nonnull subArray, NSUInteger idx, BOOL * _Nonnull stop) {
                if (combineItem.isHasSwitch && idx == 0) {
                    for (MMSelectedPath *path in subArray) {
                        MMAlternativeItem *alternativeItem = combineItem.alternativeArray[path.firstPath];
//                        NSLog(@"当title为: %@ 时，选中状态为: %d",alternativeItem.title,alternativeItem.isSelected);
                    }
                    return;
                }
                
                NSString *title;
                
                NSMutableString *subtitles = [NSMutableString string];
                NSMutableString *subtitlesCode = [NSMutableString string];
                for (MMSelectedPath *path in subArray) {
                    MMItem *firstItem = combineItem.childrenNodes[path.firstPath];
                    MMItem *secondItem = combineItem.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                    title = firstItem.title;
                    
                    [subtitles appendString:[NSString stringWithFormat:@"%@",secondItem.title]];
                    [subtitlesCode appendString:[NSString stringWithFormat:@"%@",secondItem.code]];
                    
//                    if ([firstItem.title isEqualToString:@"合作模式"]) {
//                        _mode_kind = subtitlesCode ;
//                    }
//                    if ([firstItem.title isEqualToString:@"项目认证"]) {
//                        if ([subtitles isEqualToString:@"不限"]) {
//                            _project_recommend = @"";
//                            _project_authentication = @"";
//                        }
//                        if ([subtitles isEqualToString:@"官方认证"]) {
//                            _project_recommend = @"";
//                            _project_authentication = @"3";
//                        }
//                        if ([subtitles isEqualToString:@"精品推荐"]) {
//                            _project_recommend = @"1";
//                            _project_authentication = @"";
//                        }
//                    }
//                    if ([firstItem.title isEqualToString:@"场所性质"]) {
//                        _mode_place_demands = subtitlesCode ;
//                    }
//                    if ([firstItem.title isEqualToString:@"投入金额"]) {
//                        _mode_amount = subtitlesCode ;
//                    }
                }
                //                NSLog(@"当title为%@时，所选字段为 %@-----code---%@",title,subtitles,subtitlesCode);
            }];
            [self.bossListView.mj_footer endRefreshing];
            [self loadData];
            break;}
        default:
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
    return  NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kBossListPage];
    [self initNavgation];
    [self GetUserInfoResult];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kBossListPage];
    [customSearchBar removeFromSuperview];
}

-(MMComBoBoxView *)tabTitleView{
    if (_tabTitleView == nil) {
        _tabTitleView = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
        _tabTitleView.backgroundColor = [UIColor whiteColor];
        _tabTitleView.dataSource = self;
        _tabTitleView.delegate = self;
    }
    return _tabTitleView;
}

#pragma mark - Getter mutableArray
- (NSMutableArray *)mutableArray {
    if (_mutableArray == nil) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        //root 1
        MMSingleItem *rootItem1 = [MMSingleItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:YES titleName:@"推荐" subtitleName:nil code:@"0"];
        if (self.isMultiSelection){
            rootItem1.selectedType = MMPopupViewMultilSeMultiSelection;
        }
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:YES titleName:@"推荐" subtitleName:nil code:@"1"]];
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:NO titleName:@"最新" subtitleName:nil code:@"2"]];
    
       
        [[DistrictManager shareManger] setIsDifferentTrade:NO];
        [[DistrictManager shareManger] getIndustryData];
        NSArray *industryArray =  [[DistrictManager shareManger] industryArray];
        //root 3
        MMMultiItem *rootItem3 = [MMMultiItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"行业"];
        rootItem3.numberOflayers = MMPopupViewTwolayers;
        rootItem3.displayType = MMPopupViewDisplayTypeMultilayer;
        for(int i = 0; i<industryArray.count;i++){
            NSDictionary *parentDictionary =  [industryArray objectAtIndex:i];
            NSArray *childArray = [parentDictionary objectForKey:@"children"];
            MMItem *item3_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:NO titleName:[parentDictionary objectForKey:@"text"] subtitleName:nil code:[parentDictionary objectForKey:@"value"]];
            item3_A.isSelected = (i == 0);
            [rootItem3 addNode:item3_A];
            if (childArray.count > 0) {
                for (int j = 0; j< childArray.count; j++) {
                    NSDictionary *childDictionary =  [childArray objectAtIndex:j];
                    
                    MMItem *item3_B = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:NO titleName:[childDictionary objectForKey:@"text"] subtitleName:nil code:[childDictionary objectForKey:@"value"]];
                    [item3_A addNode:item3_B];
                    item3_B.isSelected = (i == 0 && j == 0);
                    
                }
            }
        }
        [mutableArray addObject:rootItem1];
        [mutableArray addObject:rootItem3];
        _mutableArray  = [mutableArray copy];
    }
    return _mutableArray;
}

-(BaseTableView *)bossListView{
    if (_bossListView == nil) {
        _bossListView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+self.tabTitleView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight-self.tabTitleView.frame.size.height)];
        _bossListView.backgroundColor = BGColorGray;
        _bossListView.dataSource = self;
        
        _bossListView.delegate = self;
        _bossListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _bossListView.bounces = YES;
        [_bossListView registerClass:[BossTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BossTableViewCell class])];
        __weak __typeof(self) weakSelf = self;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        _bossListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _bossListView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
    }
    return _bossListView;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, scrollViewHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

-(void)getHotSearchData{
    NSDictionary *dic5 = @{ @"tag_is_hot":@"0",@"tag_is_hotso":@"1" };
    // 开始网络请求任务
    [[RequestManager shareRequestManager] getTagDtoList:dic5 viewController:self successData:^(NSDictionary *result){
        
        if (IsSucess(result) == 1) {
            //        current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            //        total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.hotTagListArray addObjectsFromArray:array];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    }failuer:^(NSError *error){
        
    }];
}

-(NSMutableArray *)hotTagListArray{
    if (_hotTagListArray == nil) {
        _hotTagListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotTagListArray;
}
@end
