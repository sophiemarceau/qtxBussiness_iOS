//
//  HomeListView.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/8/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "HomeListView.h"
#import "MJDIYBackFooter.h"

@implementation HomeListView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
 
        self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = BGColorGray;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight  = (130+10+44)*AUTO_SIZE_SCALE_X;
        self.tableView.bounces = YES;
//        __weak __typeof(self) weakSelf = self;
        
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakSelf loadlistData];
//                }];
         //设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(giveMeMoreData)];
        
        [self addSubview:self.tableView];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kGoTopNotificationName object:nil];
        
        _homeListArray = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"]];
        [self.tableView reloadData];
    }
    return self;
}

-(void)acceptMsg:(NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        self.canScroll = YES;
        self.tableView.scrollEnabled = YES;
        self.tableView.showsVerticalScrollIndicator = YES;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
        [scrollView setContentOffset:CGPointZero];
        self.canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.scrollEnabled = NO;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.homeListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (130+10+44)*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"homelistTableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    if (indexPath.row%2 == 1) {
//        cell.backgroundColor = [UIColor yellowColor];
//    }else{
//        cell.backgroundColor = [UIColor redColor];
//    }
    
    HomeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [(HomeListTableViewCell *)[HomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    if ([self.homeListArray count] > 0) {
//        HomeListModel *homeListModel =[self.homeListArray objectAtIndex:indexPath.row];
//        [cell configureWithHomeListEntity:homeListModel];
//    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//-(NSMutableArray *)homeListArray{
//    if (_homeListArray == nil) {
//        
//    }
//    return _homeListArray;
//}

- (void)giveMeMoreData{
//    NSLog(@"getMeMoreData");
}
@end
