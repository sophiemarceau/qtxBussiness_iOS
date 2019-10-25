//
//  ServiceViewController.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ServiceViewController.h"
#import "ServiceDetailViewController.h"
#import "MMComBoBox.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "ServiceViewModel.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "CellSubTabView.h"
#import "SearchViewController.h"
#import "IgnorHeaderTouchTableView.h"
#import "UIImageView+WebCache.h"
#import "ProjectDetailViewController.h"

@interface ServiceViewController ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) ServiceViewModel *cyclePageViewModel;
@property (nonatomic, strong) ServiceViewModel *serviceListViewModel;

@property (nonatomic, strong) IgnorHeaderTouchTableView *baseTableView;
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;


@property (nonatomic, strong) NSMutableArray *imagesList;
@property (nonatomic, strong) NSArray<NSString *> *imageNames;
@property (nonatomic, strong) NSMutableArray *imageDatas;


@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollerTableView) name:NOTIFICATION_SCROLL_TOP object:nil];
    
    /**collectionView报错:
     The behavior of the UICollectionViewFlowLayout is not defined because:
     2016-12-08 18:19:54.774 PandaTVHomeDemo[21698:1193380] the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values.
     2016-12-08 18:19:54.775 PandaTVHomeDemo[21698:1193380] The relevant UICollectionViewFlowLayout instance is <XYHomeContainerViewLayout: 0x7f843b207f60>, and it is attached to <XYHomeContainerView: 0x7f843880a000; baseClass = UICollectionView; frame = (0 0; 414 736); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x60800005c170>; layer = <CALayer: 0x60800002daa0>; contentOffset: {0, -64}; contentSize: {0, 0}> collection view layout: <XYHomeContainerViewLayout: 0x7f843b207f60>.
     2016-12-08 18:19:54.775 PandaTVHomeDemo[21698:1193380] Make a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes to catch this in the debugger.
     
     解决方法:
     在collectionView所在的控制器中设置以下属性即可解决：
     self.automaticallyAdjustsScrollViewInsets = No
     当此属性默认为YES时，导航控制器下的scrollView的contentInset会被自动调整为为{64, 0, 0, 0}
     */
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self _initViews];
//
//
//    __block ServiceViewController *blockSelf = self;
//    [self.cyclePageViewModel setBlockWithReturnBlock:^(id returnValue, ResopnseFlagState returnFlag,NSString* signalString) {
//        if ([signalString isEqualToString:@"SearchAdDtoListResult"]) {
//            if (returnFlag == ResponseSuccess) {
//
//            }else{
//
//            }
//        }
//        blockSelf.imageDatas = [NSMutableArray arrayWithArray:@[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg"]];
//        blockSelf.pageControl.numberOfPages = blockSelf.imageDatas.count;
//        [blockSelf.pagerView reloadData];
//        [blockSelf.pagerView setNeedUpdateLayout];
//
//        NSLog(@"success");
//    } WithErrorBlock:^(id errorCode,NSString *errorSignalString) {
//        NSLog(@"cyclleViewList");
//    }];
//
//    [self.cyclePageViewModel cyclleViewList];
}

- (void)scrollerTableView{
    NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.baseTableView scrollToRowAtIndexPath:topRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)_initViews {
    [self.view addSubview:self.navView];
    [self.view addSubview:self.baseTableView];
    [self addPagerView];
    [self addPageControl];
    
//    [self loadData];
//    _pagerView.layout.layoutType = TYCyclePagerTransformLayoutLinear;
//    [_pagerView setNeedUpdateLayout];
//    [self.comBoBoxView reload];
//    [self.loginView setWithViewMoel:self.loginViewModel WithSuperViewController:self WithSelectIndex:self.selectedIndex];
}


-(void)searchButtonOnClick:(id)sender{
    ((UIButton *)sender).enabled = NO;
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    ((UIButton *)sender).enabled = YES;
}


//- (void)initData{
//    
//    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"推荐" titleforKeyCode:@""];
//    //first floor
//    [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"推荐"] titleforKeyCode:@""]];
//    [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"最近"]titleforKeyCode:@"0"]];
//    [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"金额"] titleforKeyCode:@"1"]];
//
//    //second root
//    MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"地区"];
//    //first floor
//    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"北京"] titleforKeyCode:@""]];
//    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"天津"]titleforKeyCode:@"0"]];
//    [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"西安"] titleforKeyCode:@"1"]];
//    
//    //third root
//    MMItem *rootItem3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"行业"];
//    for (int i = 0; i < 30; i++){
//        MMItem *item3_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"市区%d",i]];
//        [rootItem3 addNode:item3_A];
//        for (int j = 0; j < random()%30; j ++) {
//            if (i == 0 &&j == 0) {
//                [item3_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j] titleforKeyCode:[NSString stringWithFormat:@"%ld",random()%10000] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
//            }else{
//                 [item3_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j] titleforKeyCode:[NSString stringWithFormat:@"%ld",random()%10000] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
//            }
//        }
//    }
//    
//    //fourth root
//    MMItem *rootItem4 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"要求"];
//    rootItem4.menuflag = 1;
//    NSArray *tempArray20 =@[
//                            @{@"code":@"0",@"value":@"不限"},
//                            @{@"code":@"1",@"value":@"商品经销"},
//                            @{@"code":@"2",@"value":@"品牌代理"},
//                            @{@"code":@"3",@"value":@"店铺加盟"},
//                            ] ;
//    NSArray *tempArray21 =@[
//                            @{@"code":@"0",@"value":@"不限"},
//                            @{@"code":@"1",@"value":@"真实项目"},
//                            @{@"code":@"2",@"value":@"竞品推荐"},
//                            
//                            
//                            ] ;
//    NSArray *tempArray22 =@[
//                            @{@"code":@"0",@"value":@"不限"},
//                            @{@"code":@"1",@"value":@"0"},
//                            @{@"code":@"2",@"value":@"1-5人"},
//                            @{@"code":@"3",@"value":@"10-20人"},
//                            @{@"code":@"4",@"value":@"20人以上"},
//                            ] ;
//    NSArray *tempArray23 =@[
//                            @{@"code":@"0",@"value":@"不限"},
//                            @{@"code":@"1",@"value":@"0"},
//                            @{@"code":@"2",@"value":@"1-5"},
//                            @{@"code":@"3",@"value":@"5-10"},
//                            @{@"code":@"4",@"value":@"10-15"},
//                            @{@"code":@"5",@"value":@"15以上"},
//                            ] ;
//    NSArray *arr2= @[
//                     @{@"合作模式":tempArray20},
//                     @{@"项目认证":tempArray21},
//                     @{@"场所性质":tempArray22},
//                     @{@"投入金额":tempArray23},
//                     ];
//    
//    for (NSDictionary *itemDic in arr2) {
//        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
//        [rootItem4 addNode:item4_A];
//        for (NSDictionary *title in [itemDic.allValues lastObject]) {
//            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[title objectForKey:@"value"] titleforKeyCode:[title objectForKey:@"code"]]];
//        }
//    }
//    
//   
//    
//    self.mutableArray = [NSMutableArray array];
//    
//    [self.mutableArray addObject:rootItem2];
//    [self.mutableArray addObject:rootItem3];
//    [self.mutableArray addObject:rootItem4];
//    [self.comBoBoxView reload];
//
//}

-(void)onClick{
//    ProjectDetailViewController *vc = [[ProjectDetailViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)acceptMsg:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

#pragma mark -loadData
//- (void)loadData {
//
////    _pageControl.numberOfPages = self.imageDatas.count;
//    [self.pagerView reloadData];
//}


//-(SDCycleScrollView *)cycleScrollView{
//    if (_cycleScrollView == nil) {
//        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, kNavHeight+44, kScreenWidth, 175) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
//        _cycleScrollView.pageControlBottomOffset = 25*AUTO_SIZE_SCALE_X;
//        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"icon-indexBanner"];
//        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"icon-indexBannerActive"];
//        [self.view addSubview:_cycleScrollView];
////        [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.centerX.equalTo(self.view);
////            make.top.offset(self.comBoBoxView.bottom);
////            make.height.mas_equalTo(@175);
////            make.width.mas_equalTo(kScreenWidth);
////        }];
//    }
//    return _cycleScrollView;
//}

//#pragma mark - SDCycleScrollViewDelegate
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    NSLog(@"-------%@",[imagesList[index] objectForKey:@"ad_url"] );
//    if ([[imagesList[index] objectForKey:@"ad_url"] isEqualToString:@""]) {
//        return;
//    }
//    [MobClick event:kBannerEvent label:[NSString stringWithFormat:@"%ld",[[[imagesList objectAtIndex:index] objectForKey:@"ad_id"] integerValue]]];
//    
//    WebViewController *vc = [[WebViewController alloc] init];
//    vc.webViewurl = [imagesList[index] objectForKey:@"ad_url"];
//    vc.webtitle = @"";
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}

#pragma mark - Getter
-(UIView *)navView{
    if (_navView == nil) {
        _navView = [UIView new];
        _navView.frame = CGRectMake(0, 0, kScreenWidth, 64);
        _navView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X, 20, 100*AUTO_SIZE_SCALE_X, 44)];
        titleLabel.textColor = FontUIColorBlack;
        titleLabel.text = @"渠天下生意";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_navView addSubview:titleLabel];
        [_navView addSubview:self.searchButton];
    }
    return _navView;
    
}

-(UIButton *)searchButton{
    if (_searchButton == nil) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:[UIImage imageNamed:@"nav_btn_search_normal"] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"nav_btn_search_pressed"] forState:UIControlStateSelected];
        _searchButton.frame = CGRectMake(kScreenWidth-22*AUTO_SIZE_SCALE_X-20*AUTO_SIZE_SCALE_X, 11*AUTO_SIZE_SCALE_X+20, 22*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X);
        [_searchButton addTarget:self action:@selector(searchButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (ServiceViewModel *)cyclePageViewModel {
    if (_cyclePageViewModel == nil) {
        _cyclePageViewModel = [[ServiceViewModel alloc]init];
    }
    return _cyclePageViewModel;
}

- (ServiceViewModel *)serviceListViewModel {
    if (_serviceListViewModel == nil) {
        _serviceListViewModel = [[ServiceViewModel alloc]init];
    }
    return _serviceListViewModel;
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
    _pagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 175*AUTO_SIZE_SCALE_X);
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

-(IgnorHeaderTouchTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[IgnorHeaderTouchTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight) style:UITableViewStylePlain];
//        __weak __typeof(self) weakSelf = self;
        
//        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//        _baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////            [weakSelf loadlistData];
//        }];
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//        _baseTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshViewStart)];
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.backgroundColor = [UIColor clearColor];
        _baseTableView.showsVerticalScrollIndicator = NO;
        _baseTableView.bounces = NO;
        _baseTableView.delegate = self;
        _baseTableView.dataSource = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
    }
    return _baseTableView;
}


- (void)loadData {
    self.imageDatas = [NSMutableArray array];
    _pageControl.numberOfPages = self.imageDatas.count;
    [_pagerView reloadData];
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
    layout.itemSize = CGSizeMake(self.view.frame.size.width-40*AUTO_SIZE_SCALE_X    , 165*AUTO_SIZE_SCALE_X);
    layout.itemSpacing = 10*AUTO_SIZE_SCALE_X;
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
#pragma mark---- 实现代理方法
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
        height = self.pagerView.frame.size.height;
//        NSLog(@"section0 ----height---->%f",height);
    }else if(section==1){
        height = CGRectGetHeight(self.view.frame)-kNavHeight-kTabHeight;
    }
    return height;
}

#pragma mark--返回cell的模样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section  = indexPath.section;
    if (section ==0) {
        [cell.contentView addSubview:self.pagerView];
        [self.pagerView setNeedUpdateLayout];
    }else if(section==1){
        
        CellSubTabView *tableView2 = [CellSubTabView new];
//        [[CellSubTabView alloc] initWithTabConfigArray:nil];
        
        [tableView2 setWithViewMoel:self.serviceListViewModel WithSuperViewController:self];

        tableView2.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame)-kNavHeight-kTabHeight);
        [cell.contentView addSubview:tableView2];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
        CGFloat tabOffsetY = round([self.baseTableView rectForSection:1].origin.y);
        CGFloat offsetY = ((BaseTableView *)scrollView).contentOffset.y;
        _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
//    NSLog(@"滑动到tabOffsetY---------->%f",tabOffsetY);
//    NSLog(@"滑动到offsetY---------->%f",offsetY);
        if (offsetY+1>=tabOffsetY) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            _isTopIsCanNotMoveTabView = YES;
        }else{
            _isTopIsCanNotMoveTabView = NO;
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
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [MobClick beginLogPageView:kProjectListPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //    [self.comBoBoxView dimissPopView];
    [MobClick endLogPageView:kProjectListPage];
}
@end
