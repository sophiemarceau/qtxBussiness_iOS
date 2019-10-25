//
//  ProjectViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ProjectViewController.h"
#import "MMComBoBox.h"
#import "DistrictManager.h"
#import "HomeListView.h"
#import "MJDIYBackFooter.h"
#import "SearchViewController.h"
#import "ProjectDetailViewController.h"
#import "PYSearch.h"
@interface ProjectViewController ()<MMComBoBoxViewDataSource, MMComBoBoxViewDelegate,UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDelegate>
{
    NSString *_sort;
    NSString *_mode_area;
    NSString *_mode_kind;
    NSString *_project_authentication;
    NSString *_project_industry;
    NSString *_project_recommend;
    NSString *_mode_place_demands;
    NSString *_mode_amount;
    
    NSString *_pageSize;
    
    int current_page;
    int total_count;
    noContent * nocontent;
}
@property (nonatomic, strong) UIView *navView;
@property (nonatomic,strong) BaseTableView *projectListView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) MMComBoBoxView *tabTitleView;
@property (nonatomic, strong) NSMutableArray *mutableArray,*hotTagListArray;
@property (nonatomic, assign) BOOL isMultiSelection;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)noWifiView *failView;
@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    current_page = 0;
    _sort=_mode_area=_mode_kind=_project_authentication=_project_industry=_project_recommend=_mode_place_demands=_mode_amount=_pageSize = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollerTableView) name:NOTIFICATION_SCROLL_TOP object:nil];
    [self initNavgation];
    [self initSubViews];
    [self loadData];
}

- (void)scrollerTableView{
    self.titleLabel.hidden = NO;
    self.searchButton.hidden = NO;
    self.tabTitleView.frame = CGRectMake(0, kNavHeight, kScreenWidth, self.tabTitleView.frame.size.height);
    self.projectListView.frame = CGRectMake(0, self.tabTitleView.frame.size.height+self.tabTitleView.frame.origin.y, kScreenWidth, kScreenHeight-(self.tabTitleView.frame.size.height+self.tabTitleView.frame.origin.y));
}

-(void)initNavgation{
    [self.view addSubview:self.navView];
}

-(void)initSubViews{
    [self.view addSubview:self.tabTitleView];
    [self.view addSubview:self.projectListView];
    [self.tabTitleView reload];
    
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, kNavHeight+self.tabTitleView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-self.tabTitleView.frame.size.height)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}

-(void)searchButtonOnClick:(id)sender{
    ((UIButton *)sender).enabled = NO;

    // 1. Create an Array of popular search
    NSMutableArray *hotArray = [NSMutableArray array];
    for (NSDictionary *tagDic  in self.hotTagListArray) {
        [hotArray addObject:tagDic[@"tag_content"]];
    }
    //    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotArray searchBarPlaceholder:@"请输入关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
//        NSLog(@"searchText------->%@",searchText);
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
    
    
    ((UIButton *)sender).enabled = YES;
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

- (void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.data removeAllObjects];
    
    [self.hotTagListArray removeAllObjects];
    current_page = 0;
    NSDictionary *dic = @{
                          @"_Keyword":@"",
                          @"_sort":_sort,
                          @"_mode_area":_mode_area,
                          @"_mode_kind":_mode_kind,
                          @"_project_authentication":_project_authentication,
                          @"_project_industry":_project_industry,
                          @"_project_recommend":_project_recommend,
                          @"_mode_place_demands":_mode_place_demands,
                          @"_mode_amount":_mode_amount,
                          @"_currentPage":@"",
                          @"_pageSize":@""
                          };
//    NSLog(@"dic---searchProjectDtos4App--->%@",dic);
    [[RequestManager shareRequestManager] searchProjectDtos4App:dic viewController:self successData:^(NSDictionary *result) {
        [LZBLoadingView dismissLoadingView];
        [self.projectListView.mj_header endRefreshing];
        [self.projectListView.mj_footer endRefreshing];
//        NSLog(@"result--searchProjectDtos4App--->%@",result);
        
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
//            NSLog(@"array--count--->%ld",array.count);
//            NSLog(@"total--count--->%d",total_count);
            if(![array isEqual:[NSNull null]] && array !=nil){
                 [self.data addObjectsFromArray:array];
            }
            [self.projectListView reloadData];
            if (self.data.count>0) {
                nocontent.hidden = YES;
            }else{
                nocontent.hidden = NO;
            }
            if (self.data.count == total_count || array.count == 0) {
                [self.projectListView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (self.data.count>0) {
                [self.projectListView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        self.failView.hidden = YES;
    } failuer:^(NSError *error) {
        self.failView.hidden = NO;
        nocontent.hidden = NO;
        [self.projectListView.mj_header endRefreshing];
         [self.projectListView.mj_footer endRefreshing];
         [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
    
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic5 = @{ @"tag_is_hot":@"0",@"tag_is_hotso":@"1" };
    [[RequestManager shareRequestManager] getTagDtoList:dic5 viewController:self successData:^(NSDictionary *result){
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.hotTagListArray addObjectsFromArray:array];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:self];
        }
        [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
    }];
}

- (void)giveMeMoreData{
    current_page++;
    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    NSDictionary *dic = @{
                          @"_Keyword":@"",
                          @"_sort":_sort,
                          @"_mode_area":_mode_area,
                          @"_mode_kind":_mode_kind,
                          @"_project_authentication":_project_authentication,
                          @"_project_industry":_project_industry,
                          @"_project_recommend":_project_recommend,
                          @"_mode_place_demands":_mode_place_demands,
                          @"_mode_amount":_mode_amount,
                          @"_currentPage":page,
                          @"_pageSize":@""
                          };
//    NSLog(@"dic------>%@",dic);
    [[RequestManager shareRequestManager] searchProjectDtos4App:dic viewController:self successData:^(NSDictionary *result) {
        
        [self.projectListView.mj_footer endRefreshing];
//        NSLog(@"result----->%@",result);
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count =  [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
                    [self.data addObjectsFromArray:array];
                }
            }
            [self.projectListView reloadData];
            if (self.data.count == total_count || self.data.count == 0) {
                [self.projectListView.mj_footer endRefreshingWithNoMoreData];
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
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [self.projectListView.mj_footer endRefreshing];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (130+10+44)*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"homelistTableViewCell";
    HomeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [(HomeListTableViewCell *)[HomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.data count] > 0) {
        [cell configureWithHomeListEntity:[self.data objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [MobClick event:kProjectDetailSlikBagListclick label:[NSString stringWithFormat:@"%@",[[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangTit"] ]];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kProjectDetailToPost object:nil userInfo:@{@"silk":
    //                                                                                                              [[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangUrl"],
    //                                                                                                          @"webdesc":
    //                                                                                                              [[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangTit"]
    //                                                                                                          }
    //
    //     ];
//    [MobClick event:kProjectListEvent label:[NSString stringWithFormat:@"%ld",[[[self.data objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue]]];
    
    ProjectDetailViewController * vc = [[ProjectDetailViewController alloc] init];
    vc.title =[[self.data  objectAtIndex:indexPath.row] objectForKey:@"project_name"];
    vc.project_id = [[[self.data objectAtIndex:indexPath.row] objectForKey:@"project_id"] integerValue];
    [self.navigationController pushViewController:vc animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            if([rootItem.title isEqualToString:@"地区"]){
                _mode_area = codeStr;
            }
            if([rootItem.title isEqualToString:@"行业"]){
                 _project_industry = codeStr;
            }
            
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
                    
                    if ([firstItem.title isEqualToString:@"合作模式"]) {
                        _mode_kind = subtitlesCode ;
                    }
                    if ([firstItem.title isEqualToString:@"项目认证"]) {
                        if ([subtitles isEqualToString:@"不限"]) {
                            _project_recommend = @"";
                            _project_authentication = @"";
                        }
                        if ([subtitles isEqualToString:@"官方认证"]) {
                            _project_recommend = @"";
                            _project_authentication = @"3";
                        }
                        if ([subtitles isEqualToString:@"精品推荐"]) {
                            _project_recommend = @"1";
                            _project_authentication = @"";
                        }
                    }
                    if ([firstItem.title isEqualToString:@"场所性质"]) {
                        _mode_place_demands = subtitlesCode ;
                    }
                    if ([firstItem.title isEqualToString:@"投入金额"]) {
                        _mode_amount = subtitlesCode ;
                    }
                }
//                NSLog(@"当title为%@时，所选字段为 %@-----code---%@",title,subtitles,subtitlesCode);
            }];
            [self.projectListView.mj_footer endRefreshing];
            [self loadData];
            break;}
        default:
            break;
    }
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
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:NO titleName:@"最近" subtitleName:nil code:@"2"]];
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:NO titleName:@"金额" subtitleName:nil code:@"3"]];
        [[DistrictManager shareManger] setIsDifferentDistrict:YES];
        [[DistrictManager shareManger] getData];
        NSArray *disArray =  [[DistrictManager shareManger] dataArr];
        //root 2
        MMMultiItem *rootItem2 = [MMMultiItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"地区"];
        rootItem2.numberOflayers = MMPopupViewTwolayersOrThirdlayers;
        rootItem2.displayType = MMPopupViewDisplayTypeMultilayer;
        for(int i = 0; i<disArray.count;i++){
            NSDictionary *addresses =  [disArray objectAtIndex:i];
            NSArray *citiesArray = [addresses objectForKey:@"children"];
            MMItem *item2_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:NO titleName:[addresses objectForKey:@"text"] subtitleName:nil code:[addresses objectForKey:@"value"]];
            item2_A.isSelected = (i == 0);
            [rootItem2 addNode:item2_A];
            if (citiesArray.count > 0) {
                for (int j = 0; j< citiesArray.count; j++) {
                    NSDictionary *cities =  [citiesArray objectAtIndex:j];
                    NSArray *districtsArray = [cities objectForKey:@"children"];
                    MMItem *item2_B = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:NO titleName:[cities objectForKey:@"text"] subtitleName:nil code:[cities objectForKey:@"value"]];
                    [item2_A addNode:item2_B];
                    item2_B.isSelected = (i == 0 && j == 0);
                    
                    if (districtsArray.count > 0) {
                        for (int k = 0; k<districtsArray.count; k++) {
                            NSDictionary *districtsDictionary =  [districtsArray objectAtIndex:k];
                            MMItem *item2_C = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:NO titleName:[districtsDictionary objectForKey:@"text"]subtitleName:nil code:[districtsDictionary objectForKey:@"value"]];
                            item2_C.isSelected = (i == 0 && j == 0 && k == 0);
                            [item2_B addNode:item2_C];
                        }
                    }
                }
            }
        }
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
        //root 4
        MMCombinationItem *rootItem4 = [MMCombinationItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:NO titleName:@"要求" subtitleName:nil];
        rootItem4.displayType = MMPopupViewDisplayTypeFilters;
        
        if (self.isMultiSelection)
            rootItem4.selectedType = MMPopupViewMultilSeMultiSelection;
        //        MMAlternativeItem *alternativeItem1 = [MMAlternativeItem itemWithTitle:@"只看免预约" isSelected:NO];
        //        MMAlternativeItem *alternativeItem2 = [MMAlternativeItem itemWithTitle:@"节假日可用" isSelected:YES];
        //        [rootItem4 addAlternativeItem:alternativeItem1];
        //        [rootItem4 addAlternativeItem:alternativeItem2];
        
        NSArray *tempArray20 =@[
                                @{@"code":@"",@"value":@"不限"},
                                @{@"code":@"1",@"value":@"商品经销"},
                                @{@"code":@"2",@"value":@"品牌代理"},
                                @{@"code":@"3",@"value":@"店铺加盟"},
                                ] ;
        
        NSArray *tempArray21 =@[
                                @{@"code":@"",@"value":@"不限"},
                                @{@"code":@"2",@"value":@"官方认证"},
                                @{@"code":@"1",@"value":@"精品推荐"},
                                ] ;
        
        NSArray *tempArray22 =@[
                                @{@"code":@"",@"value":@"不限"},
                                @{@"code":@"1",@"value":@"不需要"},
                                @{@"code":@"2",@"value":@"临街店铺"},
                                @{@"code":@"3",@"value":@"写字楼"},
                                @{@"code":@"4",@"value":@"商场店"},
                                ] ;
        
        NSArray *tempArray23 =@[
                                @{@"code":@"",@"value":@"不限"},
                                @{@"code":@"1",@"value":@"1万以内"},
                                @{@"code":@"2",@"value":@"1-5万"},
                                @{@"code":@"3",@"value":@"5-20万"},
                                @{@"code":@"4",@"value":@"20-50万"},
                                @{@"code":@"5",@"value":@"50万以上"},
                                ] ;
        NSArray *arr= @[
                        @{@"合作模式":tempArray20},
                        @{@"项目认证":tempArray21},
                        @{@"场所性质":tempArray22},
                        @{@"投入金额":tempArray23},
                        ];
        for (NSDictionary *itemDic in arr) {
            MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
            [rootItem4 addNode:item4_A];
            for (int i = 0; i <  [[itemDic.allValues lastObject] count]; i++) {
                NSString *title = [[itemDic.allValues lastObject][i] objectForKey:@"value"];
                MMItem *item4_B = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:NO titleName:title subtitleName:nil code:[[itemDic.allValues lastObject][i] objectForKey:@"code"]];
                //                [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:title];
                if (i == 0) {
                    item4_B.isSelected = YES;
                }
                [item4_A addNode:item4_B];
            }
        }
        [mutableArray addObject:rootItem1];
        [mutableArray addObject:rootItem2];
        [mutableArray addObject:rootItem3];
        [mutableArray addObject:rootItem4];
        _mutableArray  = [mutableArray copy];
    }
    return _mutableArray;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return NO;
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
    
    [MobClick endLogPageView:kProjectListPage];
     [self.tabTitleView dimissPopView];
}

#pragma mark - Getter
-(NSMutableArray *)hotTagListArray{
    if (_hotTagListArray == nil) {
        _hotTagListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotTagListArray;
}

-(UIView *)navView{
    if (_navView == nil) {
        _navView = [UIView new];
        _navView.frame = CGRectMake(0, 0, kScreenWidth, kNavHeight);
        _navView.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*AUTO_SIZE_SCALE_X, kSystemBarHeight, 100*AUTO_SIZE_SCALE_X, kNavHeight-kSystemBarHeight)];
        self.titleLabel.textColor = FontUIColorBlack;
        self.titleLabel.text = @"全部项目";
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_navView addSubview:self.titleLabel];
        [_navView addSubview:self.searchButton];
    }
    return _navView;
}

-(UIButton *)searchButton{
    if (_searchButton == nil) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:[UIImage imageNamed:@"nav_btn_search_normal"] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"nav_btn_search_pressed"] forState:UIControlStateSelected];
        _searchButton.frame = CGRectMake(kScreenWidth-22*AUTO_SIZE_SCALE_X-20*AUTO_SIZE_SCALE_X,  (kSystemBarHeight)+11*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X);
        [_searchButton addTarget:self action:@selector(searchButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

-(BaseTableView *)projectListView{
    if (_projectListView == nil) {
        _projectListView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight+self.tabTitleView.frame.size.height, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight-self.tabTitleView.frame.size.height)];
        _projectListView.dataSource = self;
        _projectListView.backgroundColor = BGColorGray;
        _projectListView.delegate = self;
        _projectListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _projectListView.estimatedRowHeight  = (130+10+44)*AUTO_SIZE_SCALE_X;
        _projectListView.bounces = YES;
                __weak __typeof(self) weakSelf = self;
        
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        _projectListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [weakSelf loadData];
                        }];
        //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _projectListView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
    }
    return _projectListView;
}


#pragma --getter MMComBoBoxView
-(MMComBoBoxView *)tabTitleView{
    if (_tabTitleView == nil) {
        _tabTitleView = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
        _tabTitleView.backgroundColor = [UIColor whiteColor];
        _tabTitleView.dataSource = self;
        _tabTitleView.delegate = self;
    }
    return _tabTitleView;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight - kTabHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    
    return _failView;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if(velocity.y>0)
    {
        self.titleLabel.hidden = YES;
        self.searchButton.hidden = YES;
        self.tabTitleView.frame = CGRectMake(0, 20, kScreenWidth, self.tabTitleView.frame.size.height);
        self.projectListView.frame = CGRectMake(0, self.tabTitleView.frame.size.height+self.tabTitleView.frame.origin.y, kScreenWidth, kScreenHeight-(self.tabTitleView.frame.size.height+self.tabTitleView.frame.origin.y)-kTabHeight);
        
    }
    
    else
        
    {
        self.titleLabel.hidden = NO;
        self.searchButton.hidden = NO;
        self.tabTitleView.frame = CGRectMake(0, kNavHeight, kScreenWidth, self.tabTitleView.frame.size.height);
        self.projectListView.frame = CGRectMake(0, self.tabTitleView.frame.size.height+self.tabTitleView.frame.origin.y, kScreenWidth, kScreenHeight-(self.tabTitleView.frame.size.height+self.tabTitleView.frame.origin.y)-kTabHeight);
        
    }
    
}


@end
