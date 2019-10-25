//
//  CellSubTabView.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/8/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CellSubTabView.h"
#import "TabMenuView.h"
#import "HomeListView.h"
#import "MMComBoBox.h"
#import "DistrictManager.h"
#import "AddressModel.h"
#import "Mantle.h"
#import "HomelistModel.h"
#import "ServiceViewModel.h"

@interface CellSubTabView()<MMComBoBoxViewDataSource, MMComBoBoxViewDelegate>

@property(nonatomic,strong)ServiceViewModel *homeListViewModel;

@property(nonatomic,strong) UIView *tabContentView;
@property(nonatomic,strong) HomeListView *homeListView;
@property (nonatomic, strong) MMComBoBoxView *tabTitleView;

@property (nonatomic, strong) NSMutableArray *mutableArray;

@property (nonatomic, assign) BOOL isMultiSelection;
@end
@implementation CellSubTabView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavHeight-kTabHeight);
        [self addSubview:self.tabTitleView];
        _tabContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabTitleView.frame), kScreenWidth, CGRectGetHeight(self.frame) - CGRectGetHeight(_tabTitleView.frame))];
        _tabContentView.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.tabContentView];
        _homeListView = [[HomeListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(_tabContentView.frame))];
        _homeListView.backgroundColor = [UIColor purpleColor];
        [_tabContentView addSubview:_homeListView];
        [self.tabTitleView reload];
    }
    return self;
}

-(instancetype)initWithTabConfigArray:(NSArray *)tabConfigArray{
    self = [super initWithFrame:CGRectZero];
    if (self) {
    }
    return self;
}

- (void)loadData{
    
}

-(void)setWithViewMoel:(ServiceViewModel *)viewModel WithSuperViewController:(UIViewController *)vc{
    self.homeListViewModel = viewModel;
    [self.homeListViewModel setBlockWithReturnBlock:^(id returnValue, ResopnseFlagState returnFlag,NSString* signalString) {
        if ([signalString isEqualToString:@""]) {
            if (returnFlag == ResponseSuccess) {
                
            }else{
                
            }
        }
        
    } WithErrorBlock:^(id errorCode,NSString *errorSignalString) {
        
    }];
}


#pragma --getter MMComBoBoxView
-(MMComBoBoxView *)tabTitleView{
    if (_tabTitleView == nil) {
        _tabTitleView = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _tabTitleView.dataSource = self;
        _tabTitleView.delegate = self;
    }
    return _tabTitleView;
}

#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.mutableArray.count;
}

- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.mutableArray[column];
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
        
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:YES titleName:@"排序" subtitleName:nil code:@"0"]];
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:NO titleName:@"最近" subtitleName:nil code:@"1"]];
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:NO titleName:@"金额" subtitleName:nil code:@"2"]];
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
        [[DistrictManager shareManger] setIsDifferentTrade:YES];
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
        MMCombinationItem *rootItem4 = [MMCombinationItem itemWithItemType:MMPopupViewDisplayTypeUnselected isSelected:NO titleName:@"筛选" subtitleName:nil];
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
                                @{@"code":@"1",@"value":@"真实项目"},
                                @{@"code":@"2",@"value":@"精品推荐"},
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
            if([title isEqualToString:@"推荐"]){
            
            }
//            NSLog(@"当title为%@时，所选字段为 %@---code---%@",rootItem.title ,title,codeStr);
            break;}
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
                for (MMSelectedPath *path in subArray) {
                    MMItem *firstItem = combineItem.childrenNodes[path.firstPath];
                    MMItem *secondItem = combineItem.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                    title = firstItem.title;
                    
                    [subtitles appendString:[NSString stringWithFormat:@"  %@",secondItem.title]];
                }
//                NSLog(@"当title为%@时，所选字段为 %@",title,subtitles);
            }];
            
            break;}
        default:
            break;
    }
}

@end
