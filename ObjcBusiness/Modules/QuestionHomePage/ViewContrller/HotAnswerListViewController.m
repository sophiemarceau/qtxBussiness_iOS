//
//  HotAnswerListViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "HotAnswerListViewController.h"
#import "BaseTableView.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "UIImageView+WebCache.h"
#import "CusPageControlWithView.h"  // 自定义的Page视图
#import "QuestTableViewCellFrame.h"
#import "QuestTableCell.h"
#import "MJDIYBackFooter.h"
#import "AFTableViewCell.h"
#import "ProjectDetailViewController.h"
#import "QuestDetailViewController.h"
#import "AnswerDetailViewController.h"
#import "CusPageControlWithView.h"  // 自定义的Page视图
#import "ExpertCollectionViewCell.h"
#import "PersonalHomePageViewController.h"
#import "QuestListCell.h"
#import "WebContainViewController.h"

@interface HotAnswerListViewController ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,HeaderViewDelegate>{
    int current_page;
    int total_count;
      noContent * nocontent;
    CusPageControlWithView *pageControllDot;
}
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic,strong) NSMutableArray *listArray,*expertArray;
@property (nonatomic,strong)BaseTableView *basetTableView;
@property (nonatomic,strong) TYCyclePagerView *pagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *imagesList;
@property (nonatomic,strong) NSArray<NSString *> *imageNames;
@property (nonatomic,strong) NSMutableArray *imageDatas;
@property (nonatomic,strong) noWifiView *failView;
@end

@implementation HotAnswerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
    [self initSubViews];
    [self loadListContenFromHotData];
}

-(void)initSubViews{
    [self addPagerView];
    self.imageDatas = [NSMutableArray arrayWithCapacity:0];
    self.pageControl.numberOfPages = self.imageDatas.count;
    [self addPageControl];
    [self.pagerView reloadData];
    [self.pagerView setNeedUpdateLayout];
    [self.view addSubview:self.basetTableView];
    [self.view addSubview:self.failView];
    nocontent = [[noContent alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, scrollViewHeight)];
    nocontent.hidden = YES;
    [self.view addSubview:nocontent];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadButtonClick:(UIButton *)sender {
   [self loadListContenFromHotData];
}

-(void)loadCycleData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic2 = @{};
    [[RequestManager shareRequestManager] SearchAdDtoListResult:dic2 viewController:self successData:^(NSDictionary *result){
        if (IsSucess(result) == 1) {
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array != nil){
                [self.imageDatas removeAllObjects];
                [self.imageDatas addObjectsFromArray:array];
                self.pageControl.numberOfPages = self.imageDatas.count;
                if(self.imageDatas.count <= 1){
                    self.pagerView.isInfiniteLoop = NO;
                }else{
                    self.pagerView.isInfiniteLoop = YES;
                }
                [self.pagerView reloadData];
                [self.pagerView setNeedUpdateLayout];
                
                //取出来热门的列表
                [self.basetTableView setTableHeaderView:_pagerView];
            }
            [self loadExpertData];
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        
        }
         [LZBLoadingView dismissLoadingView];
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];

}


-(void)loadExpertData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic3 = @{};
    
    [[RequestManager shareRequestManager] recommendExpert:dic3 viewController:self successData:^(NSDictionary *result){
//        NSLog(@"recommendExpert------------result--------------->%@",result);
        if (IsSucess(result) == 1) {
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.expertArray removeAllObjects];
                [self.expertArray addObjectsFromArray:array];
            }
            if (self.expertArray.count > 0) {
                if (self.listArray.count > 4) {
                    [self.listArray insertObject:self.expertArray atIndex:4];
                }
            }
            [self.basetTableView reloadData];
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

//获取 热门选项项目 下的问答列表
-(void)loadListContenFromHotData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    

    NSDictionary *dic = @{
                          @"_currentPage":@"",
                          @"_pageSize":@"",
                          };
    [[RequestManager shareRequestManager] searchHotAnswerDtos:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"获取 热门选项项目 下的问答列表------------result--------------->%@",result);
        [self.basetTableView.mj_header endRefreshing];
        [self.basetTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.listArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    QuestModel *questModel = [QuestModel logisticsWithDict:dict];
                    QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                    cellFrame.questModel = questModel;
                    [self.listArray addObject:cellFrame];
                }
                if (self.listArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.listArray.count == total_count || self.listArray.count == 0) {
                    [self.basetTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self loadCycleData];
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
        [self.basetTableView.mj_header endRefreshing];
        [self.basetTableView.mj_footer endRefreshing];
        self.failView.hidden = NO;
        nocontent.hidden = YES;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}


-(void)moreLoadListContenFromHotData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];

    current_page++;

    NSString * page = [NSString stringWithFormat:@"%d",current_page];
    //        NSString * pageOffset = @"20";
    NSDictionary *dic = @{
                          @"_currentPage":page,
                          @"_pageSize":@"",

                          };
    [[RequestManager shareRequestManager] searchHotAnswerDtos:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"获取 热门选项项目 下的问答列表------------result--------------->%@",result);
        [self.basetTableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];

            if(![array isEqual:[NSNull null]] && array !=nil){

                NSMutableArray *mArray = [NSMutableArray new];
                

                for (NSDictionary *dict in array) {
                    QuestModel *questModel = [QuestModel logisticsWithDict:dict];
                    QuestTableViewCellFrame *cellFrame = [[QuestTableViewCellFrame alloc] init];
                    cellFrame.questModel = questModel;
                    [mArray addObject:cellFrame];
                }
                [self.listArray addObjectsFromArray:mArray];
                [self.basetTableView reloadData];
                if (self.expertArray.count > 0) {
                    if (self.listArray.count == total_count +1) {
                        [self.basetTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }else{
                    if (self.listArray.count == total_count) {
                        [self.basetTableView.mj_footer endRefreshingWithNoMoreData];
                    }
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
        self.failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

- (void)focusExperOnClick:(UIButton *)sender {
    NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
    NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
    if (userID) {
        if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
            NSDictionary *dic = @{
                                  @"user_id_followed":[NSString stringWithFormat:@"%ld",(long)sender.tag],
                                  };
            if (sender.selected) {
                [[RequestManager shareRequestManager] cancelConnection:dic viewController:self successData:^(NSDictionary *result){
//                    NSLog(@"result-----cancelConnection----%@",result);
                    if(IsSucess(result) == 1){
                        int flag = [[result objectForKey:@"data"][@"result"]  intValue];
                        if (flag == 0) {
                            [[RequestManager shareRequestManager] tipAlert:@"已取消关注" viewController:self];
                            sender.selected = !sender.selected;
                            [sender setTitle:@"关注" forState:UIControlStateNormal];
                        }else{
                            [[RequestManager shareRequestManager] resultFail:result viewController:self];
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
                    //            failView.hidden = NO;
                }];
            }else{
                [[RequestManager shareRequestManager] addConnection:dic viewController:self successData:^(NSDictionary *result){
//                    NSLog(@"sender-----addConnection----%@",result);
                    //            failView.hidden = YES;
                    if(IsSucess(result) == 1){
                        int flag = [[result objectForKey:@"data"][@"result"]  intValue];
                        [[RequestManager shareRequestManager] tipAlert:@"关注成功" viewController:self];
                        if (flag == 1) {
                            [sender setTitle:@"已关注" forState:UIControlStateSelected];
                            sender.selected = !sender.selected;
                        }
                        if (flag == 2) {
                            [sender setTitle:@"相互关注" forState:UIControlStateSelected];
                            sender.selected = !sender.selected;
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
                    //            failView.hidden = NO;
                }];
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
    }
}

-(void)gotohisHomePage:(UITapGestureRecognizer *)sender{
    [self gotoPersonalHomePageView:sender.view.tag];
}

-(void)gotoPersonalHomePageView:(NSInteger)userid{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    vc.user_id = userid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didSelectHeaderGotoHomePage:(NSInteger)userID{
    
    [self gotoPersonalHomePageView:userID];
}

#pragma mark BaseTableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.expertArray.count > 0){
        if ([self.listArray count] > 4) {
            if (indexPath.row == 4) {
                return 238*AUTO_SIZE_SCALE_X;
            }else{
                QuestTableViewCellFrame *questTableCellFrame =  [self.listArray objectAtIndex:indexPath.row];
                return questTableCellFrame.rowHeight;
            }
        }else{
            QuestTableViewCellFrame *questTableCellFrame =  [self.listArray objectAtIndex:indexPath.row];
            return questTableCellFrame.rowHeight;
        }
    }else{
        QuestTableViewCellFrame *questTableCellFrame =  [self.listArray objectAtIndex:indexPath.row];
        return questTableCellFrame.rowHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.expertArray.count > 0){
        if ([self.listArray count] > 4) {
            if (indexPath.row == 4) {
                static NSString *CellIdentifier = @"AFTableViewCell";
                AFTableViewCell *cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell){
                    cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    [(AFTableViewCell *)cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
                }
                NSInteger index = ((AFTableViewCell *)cell).collectionView.indexPath.row;
                CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
                [((AFTableViewCell *)cell).collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
                cell.backgroundColor = BGColorGray;
                return cell;
            }else{
                return  [self setCellRowAtIndexPath:indexPath tableView:tableView];
            }
        }else{
            return  [self setCellRowAtIndexPath:indexPath tableView:tableView];
        }
    }else{
        return  [self setCellRowAtIndexPath:indexPath tableView:tableView];
    }
}

-(UITableViewCell *)setCellRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    QuestTableCell *cell = [QuestTableCell userStatusCellWithTableView:tableView];
    cell.delegate = self;
    QuestTableViewCellFrame *questTableCellFrame =  [self.listArray objectAtIndex:indexPath.row];
    cell.questTableViewCellFrame = questTableCellFrame;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.expertArray.count > 0){
        if ([self.listArray count] > 4) {
            if (indexPath.row == 4) {
                
            }else{
                [self gotoAnswerView:indexPath];
            }
        }else{
            [self gotoAnswerView:indexPath];
        }
    }else{
        [self gotoAnswerView:indexPath];
    }
}

-(void)gotoAnswerView:(NSIndexPath *)indexPath{
    AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
    QuestTableViewCellFrame *questTableCellFrame =  [self.listArray objectAtIndex:indexPath.row];
    vc.answer_id = questTableCellFrame.questModel.answer_id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([cell isKindOfClass:[AFTableViewCell class]]) {
            [(AFTableViewCell *)cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
            NSInteger index = ((AFTableViewCell *)cell).collectionView.indexPath.row;
    
            CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
            [((AFTableViewCell *)cell).collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
        }
}

#pragma mark - UICollectionViewDataSource Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.expertArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ExpertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = self.expertArray[indexPath.row][@"c_nickname"];
    cell.desLabel.text =  self.expertArray[indexPath.row][@"c_expert_profiles"];
    [cell.headview sd_setImageWithURL:[NSURL URLWithString:self.expertArray[indexPath.row][@"c_photo"]] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    UITapGestureRecognizer * headviewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotohisHomePage:)];
    cell.headview.userInteractionEnabled = YES;
    cell.headview.tag  = [self.expertArray[indexPath.row][@"user_id"] integerValue];
    [cell.headview addGestureRecognizer:headviewtap];
    cell.btn.tag = [self.expertArray[indexPath.row][@"user_id"] integerValue];
    [cell.btn addTarget:self action:@selector(focusExperOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger userPosition_code =  [self.expertArray[indexPath.row][@"userPosition_code"] integerValue];
    
    
    if (userPosition_code == 0) {
        
        cell.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_expert_certification"];
    }
    if (userPosition_code == 1) {
        cell.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_enterprise_certification"];
    }
    if (userPosition_code == 2) {
        cell.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_default"];
    }
    if (userPosition_code == 3) {
        cell.headerFlagImageView.hidden = YES;
    }else{
        cell.headerFlagImageView.hidden = NO;
    }
    return cell;
}


#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.imageDatas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    [cell.cycleImageView sd_setImageWithURL:[self.imageDatas[index] objectForKey:@"ad_pic"]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    //    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSize = CGSizeMake(335*AUTO_SIZE_SCALE_X , 165*AUTO_SIZE_SCALE_X);
    layout.itemSpacing = 10*AUTO_SIZE_SCALE_X;
    layout.itemHorizontalCenter = YES;
    layout.layoutType = TYCyclePagerTransformLayoutNormal;
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
- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    NSString *ad_url = [self.imageDatas[index] objectForKey:@"ad_url"];
    if(ad_url !=nil && ![ad_url isEqualToString:@""]){
        WebContainViewController *vc = [[WebContainViewController alloc] init];
        vc.webViewurl = ad_url;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSInteger ad_jump_type_code = [[self.imageDatas[index] objectForKey:@"ad_jump_type_code"] integerValue];
    NSInteger ad_jump_id =[[self.imageDatas[index] objectForKey:@"ad_jump_id"] integerValue];
    if (ad_jump_type_code == 1) {
        ProjectDetailViewController *vc =  [[ProjectDetailViewController alloc] init];
        vc.project_id =ad_jump_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (ad_jump_type_code == 2) {
        QuestDetailViewController *vc =  [[QuestDetailViewController alloc] init];
        vc.question_id =ad_jump_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (ad_jump_type_code == 3) {
        //        NSString *userID = [DEFAULTS objectForKey:@"qtxsy_auth"];
        //        NSString *userTelphone = [DEFAULTS objectForKey:@"userTelphone"];
        //        if (userID) {
        //            if(userTelphone != nil && ![userTelphone isEqualToString:@""]){
        AnswerDetailViewController *vc = [[AnswerDetailViewController alloc] init];
        vc.answer_id = ad_jump_id;
        [self.navigationController pushViewController:vc animated:YES];
        //            }else{
        //                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"0"}];
        //            }
        //        }else{
        //            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil userInfo:@{@"gotoLogin": @"1"}];
        //        }
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        CGFloat horizontalOffset = scrollView.contentOffset.x;
        
        AFIndexedCollectionView *collectionView = (AFIndexedCollectionView *)scrollView;
        NSInteger index = collectionView.indexPath.row;
        self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
    }
}

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
    _pagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 165*AUTO_SIZE_SCALE_X);
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

-(BaseTableView *)basetTableView{
    if (_basetTableView == nil) {
        _basetTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, scrollViewHeight)];
        [_basetTableView registerClass:[QuestTableCell class] forCellReuseIdentifier:@"QuestTableCell"];
        [_basetTableView registerClass:[AFTableViewCell class] forCellReuseIdentifier:@"AFTableViewCell"];
        _basetTableView.delegate = self;
        _basetTableView.dataSource = self;
        _basetTableView.showsHorizontalScrollIndicator = NO;
        _basetTableView.showsVerticalScrollIndicator = YES;
        _basetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _basetTableView.backgroundColor = BGColorGray;
        __weak __typeof(self) weakSelf = self;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        _basetTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadListContenFromHotData];
        }];
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        _basetTableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreLoadListContenFromHotData)];
    }
    return _basetTableView;
}

-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
}

-(NSMutableArray *)expertArray{
    if (_expertArray == nil) {
        _expertArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _expertArray;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, scrollViewHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}
@end
