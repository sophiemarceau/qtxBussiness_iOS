//
//  QuestionViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestionViewController.h"
#import "AddQuestCotentControllerViewController.h"
#import "BaseNavView.h"
#import "SearchViewController.h"
#import "noWifiView.h"
#import "noContent.h"
#import "BaseTableView.h"
#import "QHCommonUtil.h"
#import "QuestTableCell.h"
#import "QuestModel.h"
#import "SelectTagViewController.h"

#import "QuestListCell+NewQuestionCellFrame.h"
#import "AFTableViewCell.h"
#import "ExpertCollectionViewCell.h"

#import "PYSearch.h"
#import "QuestDetailViewController.h"
#import "AnswerDetailViewController.h"
#import "PersonalHomePageViewController.h"
#import "ChannelViewController.h"
#import "AnswerDetailViewController.h"
#import "ProjectDetailViewController.h"
#import "SPPageMenu.h"
#import "QuestListViewController.h"
#import "HotAnswerListViewController.h"



@interface QuestionViewController ()<SPPageMenuDelegate,PYSearchViewControllerDelegate,SelectChannelDelegate>{
    long currentNum;
    int current_page;
    int total_count;
    NSString * navID;
    noContent * nocontent;
    NSDictionary *tagResult1;//获取标签的结果
    NSDictionary *hotResult5;//获取热门标签的结果
    NSError *error1;NSError *error5;
}
@property (nonatomic,strong) SPPageMenu *pageMenu;
@property (nonatomic,strong) NSMutableArray *myChildViewControllers;
@property (nonatomic,strong) NSMutableArray *hotTagListArray ,*navigationListArray;
@property (nonatomic,strong) UIButton  *questButton;
@property (nonatomic,strong) BaseNavView  *navView;
@property (nonatomic,strong) UIView  *searchbgView;
@property (nonatomic,strong) UILabel  *searchLabel;
@property (nonatomic,strong) UIImageView  *searchImageView;
@property (nonatomic,strong) noWifiView *failView;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavgation];
    [self initSubViews];
    [self loadData];
}

- (void)reloadButtonClick:(UIButton *)sender {
    tagResult1 = hotResult5 = nil;
    [self loadData];
}
-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    [self.myChildViewControllers removeAllObjects];
    [self.navigationListArray removeAllObjects];
    [self.hotTagListArray removeAllObjects];
    
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第1个网络请求任务添加到组中
    //菜单有什么选项的获取 接口
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        NSDictionary *dic1 = @{ @"tag_is_hot":@"1",@"tag_is_hotso":@"0" };
        [[RequestManager shareRequestManager] getTagDtoList:dic1 viewController:self successData:^(NSDictionary *result){
            tagResult1= result;
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
    //获取 搜索下面🔍的热门标签🏷️
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSDictionary *dic5 = @{ @"tag_is_hot":@"0",@"tag_is_hotso":@"1" };
        // 开始网络请求任务
        [[RequestManager shareRequestManager] getTagDtoList:dic5 viewController:self successData:^(NSDictionary *result){
            hotResult5 = result;
            // 如果请求成功，发送信号量
            dispatch_semaphore_signal(semaphore);
        }failuer:^(NSError *error){
            error5 = error;
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"tagResult1===:%@",tagResult1);
//        NSLog(@"hotResult5===:%@",hotResult5);
        
        if (tagResult1==nil||hotResult5==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
                self.failView.hidden = NO;
                [LZBLoadingView dismissLoadingView];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.failView.hidden = YES;
                [self initUIView];
                [LZBLoadingView dismissLoadingView];
            });
        }
    });
}

-(void)initUIView{
    if (IsSucess(tagResult1) == 1) {
        self.pageMenu.hidden = NO;
        current_page = [[[tagResult1 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
        total_count = [[[tagResult1 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        NSArray *array = [[tagResult1 objectForKey:@"data"] objectForKey:@"list"];
        if(![array isEqual:[NSNull null]] && array !=nil){
            [self.navigationListArray removeAllObjects];
            [self.navigationListArray addObject:@{
                                                  @"tag_content" : @"最新问题",
                                                  @"tag_id" :@"-1"}];
            [self.navigationListArray addObject:@{
                                                  @"tag_content" : @"热门答案",
                                                  @"tag_id" :@"-1"}];
            [self.navigationListArray addObjectsFromArray:array];
            NSMutableArray *tagNameList = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < self.navigationListArray.count; i++) {
                [tagNameList addObject:self.navigationListArray[i][@"tag_content"]];
                navID = [NSString stringWithFormat:@"%d",[[[self.navigationListArray objectAtIndex:i] objectForKey:@"tag_id"] intValue]];
                BaseViewController *vc;
                if (i == 1) {
                    vc = [[HotAnswerListViewController alloc] init];
                }else{
                    vc = [[QuestListViewController alloc] init];
                    ((QuestListViewController *)vc).tagid = navID;
                }
                
                [self addChildViewController:vc];
                // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
                [self.myChildViewControllers addObject:vc];
            }
            [self.pageMenu setItems:tagNameList selectedItemIndex:1];
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight+pageMenuH, kScreenWidth, scrollViewHeight)];
            scrollView.delegate = self;
            scrollView.pagingEnabled = YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            [self.view addSubview:scrollView];
            _scrollView = scrollView;
            
            // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
            self.pageMenu.bridgeScrollView = self.scrollView;
            
            // pageMenu.selectedItemIndex就是选中的item下标
            if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
                BaseViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
                [scrollView addSubview:baseVc.view];
                baseVc.view.frame = CGRectMake(kScreenWidth*self.pageMenu.selectedItemIndex, 0, kScreenWidth, scrollViewHeight);
                scrollView.contentOffset = CGPointMake(kScreenWidth*self.pageMenu.selectedItemIndex, 0);
                scrollView.contentSize = CGSizeMake(self.navigationListArray.count*kScreenWidth, 0);
            }
        }
        [self.view addSubview:self.questButton];
    }else{
        if (IsSucess(tagResult1) == -1) {
            [[RequestManager shareRequestManager] loginCancel:tagResult1];
        }else{
            [[RequestManager shareRequestManager] resultFail:tagResult1 viewController:self];
        }
    }
    
    if (IsSucess(hotResult5) == 1) {
        current_page = [[[hotResult5 objectForKey:@"data"] objectForKey:@"current_page"] intValue];
        total_count = [[[hotResult5 objectForKey:@"data"] objectForKey:@"total_count"] intValue];
        NSArray *array = [[hotResult5 objectForKey:@"data"] objectForKey:@"list"];
        if(![array isEqual:[NSNull null]] && array !=nil){
            [self.hotTagListArray addObjectsFromArray:array];
        }
    }else{
        if (IsSucess(hotResult5) == -1) {
            [[RequestManager shareRequestManager] loginCancel:hotResult5];
        }else{
            [[RequestManager shareRequestManager] resultFail:hotResult5 viewController:self];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initNavgation{
    [self.view addSubview:self.navView];
}

-(void)initSubViews{
    [self.view addSubview:self.pageMenu];
    [self.view addSubview:self.failView];
}

-(void)ButtonOnClick:(UIButton *)sener{
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            AddQuestCotentControllerViewController *vc = [[AddQuestCotentControllerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
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

-(void)gotoSearchView:(UITapGestureRecognizer *)sender{
   [self gotoSearchView];
}

-(void)didSelectDelegateReturnPage:(NSInteger)selectIndex FromIndex:(NSInteger)fromIndex{
    
    [self.pageMenu setSelectedItemIndex:selectIndex];
}

#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    currentNum = toIndex;
    
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(kScreenWidth * toIndex, 0, kScreenWidth, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
    ChannelViewController *vc = [[ChannelViewController alloc] init];
    vc.delegate = self;
    vc.channelArray = self.navigationListArray;
    vc.currentSelect = currentNum;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - insert or remove

// object是插入的对象(NSString或UIImage),insertNumber是插入到第几个
- (void)insertItemWithObject:(id)object toIndex:(NSInteger)insertNumber {
//    // 插入之前，先将新控制器之后的控制器view往后偏移
//    for (int i = 0; i < self.myChildViewControllers.count; i++) {
//        if (i >= insertNumber) {
//            UIViewController *childController = self.myChildViewControllers[i];
//            childController.view.frame = CGRectMake(kScreenWidth * (i+1), 0, kScreenWidth, kScreenHeight-kNavHeight-pageMenuH);
//            [self.scrollView addSubview:childController.view];
//        }
//    }
//    if (insertNumber <= self.pageMenu.selectedItemIndex && self.myChildViewControllers.count) { // 如果新插入的item在当前选中的item之前
//        // scrollView往后偏移
//        self.scrollView.contentOffset = CGPointMake(kScreenWidth*(self.pageMenu.selectedItemIndex+1), 0);
//    } else {
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//    }
//
//    SixViewController *sixVc = [[SixViewController alloc] init];
//    sixVc.text = @"我是新插入的";
//    [self addChildViewController:sixVc];
//    [self.myChildViewControllers insertObject:sixVc atIndex:insertNumber];
//
//    // 要先添加控制器，再添加item，如果先添加item，会立即调代理方法，此时myChildViewControllers的个数还是0，在代理方法中retun了
//    if ([object isKindOfClass:[NSString class]]) {
//        [self.pageMenu insertItemWithTitle:object atIndex:insertNumber animated:YES];
//    } else {
//        [self.pageMenu insertItemWithImage:object atIndex:insertNumber animated:YES];
//    }
//
//    // 重新设置scrollView容量
//    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}

- (void)removeItemAtIndex:(NSInteger)index {
    
//    if (index >= self.myChildViewControllers.count) {
//        return;
//    }
//
//    [self.pageMenu removeItemAtIndex:index animated:YES];
//
//    // 删除之前，先将新控制器之后的控制器view往前偏移
//    for (int i = 0; i < self.myChildViewControllers.count; i++) {
//        if (i >= index) {
//            UIViewController *childController = self.myChildViewControllers[i];
//            childController.view.frame = CGRectMake(screenW * (i>0?(i-1):i), 0, screenW, scrollViewHeight);
//            [self.scrollView addSubview:childController.view];
//        }
//    }
//    if (index <= self.pageMenu.selectedItemIndex) { // 移除的item在当前选中的item之前
//        // scrollView往前偏移
//        NSInteger offsetIndex = self.pageMenu.selectedItemIndex-1;
//        if (offsetIndex < 0) {
//            offsetIndex = 0;
//        }
//        self.scrollView.contentOffset = CGPointMake(screenW*offsetIndex, 0);
//    }
//
//    UIViewController *vc = [self.myChildViewControllers objectAtIndex:index];
//    [self.myChildViewControllers removeObjectAtIndex:index];
//    [vc removeFromParentViewController];
//    [vc.view removeFromSuperview];
//
//    // 重新设置scrollView容量
//    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}

- (void)removeAllItems {
    [self.pageMenu removeAllItems];
    for (UIViewController *vc in self.myChildViewControllers) {
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    [self.myChildViewControllers removeAllObjects];
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = CGSizeMake(0, 0);
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
    //[self.pageMenu moveTrackerFollowScrollView:scrollView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [MobClick beginLogPageView:kQuestionHomePage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [MobClick endLogPageView:kQuestionHomePage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

-(UIButton *)questButton{
    if (_questButton == nil) {
        _questButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_questButton setImage:[UIImage imageNamed:@"qa_home_btn_quiz"] forState:UIControlStateNormal];
        [_questButton setImage:[UIImage imageNamed:@"qa_home_btn_quiz"] forState:UIControlStateSelected];
        _questButton.frame = CGRectMake(kScreenWidth-75*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X,
                                        kScreenHeight-75*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X-kTabHeight-self.view.frame.origin.y,
                                        75*AUTO_SIZE_SCALE_X,
                                        75*AUTO_SIZE_SCALE_X);
        [_questButton addTarget:self action:@selector(ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _questButton;
}

-(BaseNavView *)navView{
    if (_navView == nil) {
        _navView = [[BaseNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        _navView.backgroundColor   = [UIColor whiteColor];
        [_navView addSubview:self.searchbgView];
        [self.searchbgView addSubview:self.searchLabel];
        [self.searchbgView addSubview:self.searchImageView];
        [self.searchbgView mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
            make.left.equalTo(_navView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
            make.bottom.equalTo(_navView.mas_bottom).offset(-8*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X));
        }];
        [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
            make.left.equalTo(self.searchbgView.mas_left).offset(142*AUTO_SIZE_SCALE_X);
            make.bottom.equalTo(self.searchbgView.mas_bottom).offset(-4*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(90*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
        }];
        [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {//获取验证码按钮
            make.left.equalTo(self.searchbgView.mas_left).offset(119*AUTO_SIZE_SCALE_X);
            make.bottom.equalTo(self.searchbgView.mas_bottom).offset(-7.5*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(13*AUTO_SIZE_SCALE_X, 13*AUTO_SIZE_SCALE_X));
        }];
        
    }
    return _navView;
}

-(UIView *)searchbgView{
    if (_searchbgView == nil) {
        _searchbgView = [UIView new];
        _searchbgView.backgroundColor   =  BGColorGray;
        _searchbgView.layer.cornerRadius = 15*AUTO_SIZE_SCALE_X;
        _searchbgView.layer.masksToBounds = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSearchView:)];
        [_searchbgView addGestureRecognizer:tap1];
    }
    return _searchbgView;
}

-(UILabel *)searchLabel{
    if (_searchLabel == nil) {
        _searchLabel = [CommentMethod createLabelWithText:@"请输入关键字" TextColor:FontUIColor999999Gray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:14];
        _searchLabel.backgroundColor   =  BGColorGray;
    }
    return _searchLabel;
}

-(UIImageView *)searchImageView{
    if (_searchImageView == nil) {
        _searchImageView = [UIImageView new];
        _searchImageView.image = [UIImage imageNamed:@"qa_home_search"];
    }
    return _searchImageView;
}

-(SPPageMenu *)pageMenu{
    if (_pageMenu == nil) {
        // trackerStyle:跟踪器的样式
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, pageMenuH) trackerStyle:SPPageMenuTrackerStyleTextZoom];
        // 同时设置图片和文字，如果只想要文字，image传nil，如果只想要图片，title传nil，imagePosition和ratio传0即可
        [_pageMenu setFunctionButtonTitle:nil image:[UIImage imageNamed:@"qa_home_nav"] imagePosition:SPItemImagePositionTop imageRatio:0 forState:UIControlStateNormal];
        _pageMenu.showFuntionButton = YES;
        // 等宽,不可滑动
        _pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        // 设置代理
        _pageMenu.delegate = self;
        _pageMenu.hidden = YES;
    }
    return _pageMenu;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

-(NSMutableArray *)navigationListArray{
    if (_navigationListArray == nil) {
        _navigationListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _navigationListArray;
}

-(NSMutableArray *)myChildViewControllers{
    if (_myChildViewControllers == nil) {
        _myChildViewControllers = [NSMutableArray arrayWithCapacity:0];
    }
    return _myChildViewControllers;
}

-(NSMutableArray *)hotTagListArray{
    if (_hotTagListArray == nil) {
        _hotTagListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotTagListArray;
}
@end
