//
//  ClientView.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/23.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "YXTabItemBaseView.h"
#import "YX.h"

@implementation YXTabItemBaseView

-(void)renderUIWithInfo:(NSDictionary *)info{
    self.info = info;
    NSNumber *position = info[@"position"];
    int num = [position intValue];
    
    self.frame = CGRectMake(num*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTopBarHeight-kBottomBarHeight-kTabTitleViewHeight);
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.bounces = NO;
    [self addSubview:self.tableView];
    self.cellHeightDic = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kGoTopNotificationName object:nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
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

@end
