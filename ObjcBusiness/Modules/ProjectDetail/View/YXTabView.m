//
//  YXTabView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "YXTabView.h"
#import "YXTabTitleView.h"
#import "YXTabItemBaseView.h"
#import "YX.h"
#import "ProjectIntrduceTableView.h"


#import "InvestmentDetailTableViw.h"
#import "CommentView.h"
#import "ClassicQuestionTableView.h"
#import "RelatedProjectlistView.h"
#import "AllQuestionTableViw.h"

@interface YXTabView()<UIScrollViewDelegate>

@property (nonatomic, strong) YXTabTitleView *tabTitleView;
@property (nonatomic, strong) UIScrollView *tabContentView;

@end

@implementation YXTabView
-(instancetype)initWithTabConfigArray:(NSArray *)tabConfigArray WithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kScreenHeight-kNavHeight);
        
        NSMutableArray *titleArray = [NSMutableArray array];
        for (int i=0; i<tabConfigArray.count; i++) {
            NSDictionary *itemDic = tabConfigArray[i];
            [titleArray addObject:itemDic[@"title"]];
        }
        _tabTitleView = [[YXTabTitleView alloc] initWithTitleArray:titleArray];
        
        __weak typeof(self) weakSelf = self;
        _tabTitleView.titleClickBlock = ^(NSInteger row){
//            NSLog(@"当前点击%zi",row);
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake(SCREEN_WIDTH*row, 0);
            }
            if(row == 0){
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_ClassicTableView object:nil];
            }
            if(row ==1){
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_AllQuestionTableViw object:nil];
            }
            if(row ==2){
                
                 [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_RelateProjectTableViw object:nil];
            }
        };
        
        [self addSubview:_tabTitleView];
        
        _tabContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabTitleView.frame), SCREEN_WIDTH, CGRectGetHeight(self.frame) - CGRectGetHeight(_tabTitleView.frame))];
        _tabContentView.contentSize = CGSizeMake(CGRectGetWidth(_tabContentView.frame)*titleArray.count, CGRectGetHeight(_tabContentView.frame));
        _tabContentView.pagingEnabled = YES;
        _tabContentView.bounces = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.delegate = self;
        [self addSubview:_tabContentView];
        
        for (int i=0; i<tabConfigArray.count; i++) {
            NSDictionary *info = tabConfigArray[i];
            NSString *clazzName = info[@"view"];
            Class clazz = NSClassFromString(clazzName);
            if([clazzName isEqualToString:@"ProjectIntrduceTableView"]){
                ProjectIntrduceTableView *itemBaseView = [[ProjectIntrduceTableView alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i]];
                [_tabContentView addSubview:itemBaseView];
            }else if([clazzName isEqualToString:@"InvestmentDetailTableViw"]) {
                InvestmentDetailTableViw *itemBaseView = [[clazz alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i]];
                [_tabContentView addSubview:itemBaseView];
            }else if([clazzName isEqualToString:@"ClassicQuestionTableView"]) {
                ClassicQuestionTableView *itemBaseView = [[clazz alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i] WithHeight:kScreenHeight-kNavHeight-kTabTitleViewHeight];
                [_tabContentView addSubview:itemBaseView];
            }else if([clazzName isEqualToString:@"RelatedProjectlistView"]) {
                RelatedProjectlistView *itemBaseView = [[clazz alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i] WithHeight:kScreenHeight-kNavHeight-kTabTitleViewHeight];
                [_tabContentView addSubview:itemBaseView];
            }
            else if([clazzName isEqualToString:@"AllQuestionTableViw"]) {
                AllQuestionTableViw *itemBaseView = [[clazz alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i] WithHeight:kScreenHeight-kNavHeight-kTabTitleViewHeight];
                [_tabContentView addSubview:itemBaseView];
            }else{
                CommentView *itemBaseView = [[clazz alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i]];
                [_tabContentView addSubview:itemBaseView];
            }
            
        }
    }
    return self;
}
-(instancetype)initWithTabConfigArray:(NSArray *)tabConfigArray{
    self = [super initWithFrame:CGRectZero];
    if (self) {                                             
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kScreenHeight-kNavHeight-kTabHeight);
        
        NSMutableArray *titleArray = [NSMutableArray array];
        for (int i=0; i<tabConfigArray.count; i++) {
            NSDictionary *itemDic = tabConfigArray[i];
            [titleArray addObject:itemDic[@"title"]];
        }
        _tabTitleView = [[YXTabTitleView alloc] initWithTitleArray:titleArray];
        
        __weak typeof(self) weakSelf = self;
        _tabTitleView.titleClickBlock = ^(NSInteger row){
//            NSLog(@"当前点击%zi",row);
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake(SCREEN_WIDTH*row, 0);
            }
            if(row == 0){
                
            }
            if(row ==1){
                
            }
            if(row ==2){
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_commentView object:nil];
                
            }
        };
        
        [self addSubview:_tabTitleView];
        
        _tabContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabTitleView.frame), SCREEN_WIDTH, CGRectGetHeight(self.frame) - CGRectGetHeight(_tabTitleView.frame))];
        _tabContentView.contentSize = CGSizeMake(CGRectGetWidth(_tabContentView.frame)*titleArray.count, CGRectGetHeight(_tabContentView.frame));
        _tabContentView.pagingEnabled = YES;
        _tabContentView.bounces = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.delegate = self;
        [self addSubview:_tabContentView];
        
        for (int i=0; i<tabConfigArray.count; i++) {
            NSDictionary *info = tabConfigArray[i];
            NSString *clazzName = info[@"view"];
            Class clazz = NSClassFromString(clazzName);
            if([clazzName isEqualToString:@"ProjectIntrduceTableView"]){
                ProjectIntrduceTableView *itemBaseView = [[ProjectIntrduceTableView alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i]];
                [_tabContentView addSubview:itemBaseView];
            }else if([clazzName isEqualToString:@"InvestmentDetailTableViw"]) {
                InvestmentDetailTableViw *itemBaseView = [[clazz alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i]];
                [_tabContentView addSubview:itemBaseView];
            }else{
                CommentView *itemBaseView = [[clazz alloc] init];
                [itemBaseView renderUIWithInfo:tabConfigArray[i]];
                [_tabContentView addSubview:itemBaseView];
            }
            
        }
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX/SCREEN_WIDTH;
    //NSLog(@"pageNum == %zi",pageNum);
    [_tabTitleView setItemSelected:pageNum];
}
@end
