//
//  CommentView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CommentView.h"
#import "BaseTableViewCell.h"

#import "UIImageView+WebCache.h"
@implementation CommentView
-(void)renderUIWithInfo:(NSDictionary *)info{
    
    [super renderUIWithInfo:info];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableView:) name:NOTIFICATION_NAME_commentView object:nil];
    id obj = info[@"data"];
    if (![obj isKindOfClass:[NSString class]]) {
        NSMutableArray *mArray = info[@"data"];
        if (mArray.count > 0) {
            [self.listArray addObjectsFromArray:mArray];
        }
    }
    
    self.tableView.frame = self.bounds;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    [self.tableView addSubview:self.failView];
    self.failView.frame = self.bounds;
    nocontent = [[noContent alloc]initWithFrame:self.bounds];
    
    nocontent.hidden = YES;
    [self.tableView addSubview:nocontent];

    total_count = [info[@"total_count"] intValue];
    if (self.listArray.count == total_count || self.listArray.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"publicTableViewCell";
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UILabel *nameLabel ,*timeLabel;
    UIImageView *lineImageView,*headImageView;
    if (cell == nil) {
        cell = [(BaseTableViewCell *)[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        headImageView = [UIImageView new];
        headImageView.backgroundColor = [UIColor redColor];
        headImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X);
        headImageView.layer.cornerRadius = 40/2*AUTO_SIZE_SCALE_X;
        headImageView.layer.borderWidth= 1.0;
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [cell addSubview:headImageView];
        
        nameLabel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:15*AUTO_SIZE_SCALE_X];
        [cell addSubview:nameLabel];
        
        timeLabel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentRight Font:12*AUTO_SIZE_SCALE_X];
        [cell addSubview:timeLabel];
        
        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 70*AUTO_SIZE_SCALE_X-1, kScreenWidth-15, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [cell addSubview:lineImageView];
    }
    if ([self.info[@"data"] count] > 0) {
        nameLabel.text = [[self.listArray objectAtIndex:indexPath.row]  objectForKey:@"message_user_name"];
        [headImageView sd_setImageWithURL:[[self.listArray objectAtIndex:indexPath.row]  objectForKey:@"user_c_photo"] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
        timeLabel.text =  [[self.listArray objectAtIndex:indexPath.row]  objectForKey:@"message_createdtime"];
        nameLabel.frame = CGRectMake(65*AUTO_SIZE_SCALE_X,0,kScreenWidth/2-65*AUTO_SIZE_SCALE_X,70*AUTO_SIZE_SCALE_X);
        timeLabel.frame = CGRectMake(kScreenWidth/2,0,kScreenWidth/2-15*AUTO_SIZE_SCALE_X,70*AUTO_SIZE_SCALE_X);
        
        if ((int)indexPath.row==([self.listArray count]-1)) {
            lineImageView.hidden = YES;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kProjectDetailToPost object:nil userInfo:@{@"silk":
//                                                                                                              [[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangUrl"],
//                                                                                                          @"webdesc":
//                                                                                                              [[self.info[@"data"] objectAtIndex:indexPath.row] objectForKey:@"jinNangTit"]
//                                                                                                          }
//
//     ];
}








-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
    
}
-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic0 = @{
                           
                           @"project_id":[NSString stringWithFormat:@"%d",[self.info[@"project_id"] intValue]],
                           @"_currentPage":@"0",
                           @"_pageSize":@"",
                           };
    
    [[RequestManager shareRequestManager] searchProjectMessageDtos4Project:dic0 viewController:nil successData:^(NSDictionary *result){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self.listArray removeAllObjects];
                if (array.count > 0) {
                    [self.listArray addObjectsFromArray:array];
                }
            
                if (self.listArray.count>0) {
                    nocontent.hidden = YES;
                }else{
                    nocontent.hidden = NO;
                }
                if (self.listArray.count == total_count || self.listArray.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.tableView reloadData];
            }
            
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:nil];
            }
        }
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
        
    }failuer:^(NSError *error){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        nocontent.hidden = YES;
        self.failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
    }];
}

-(void)refreshTableView:(NSNotification *)notification{
    [self loadData];
}

-(void)moreData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    current_page++;
    
    NSString *page = [NSString stringWithFormat:@"%d",current_page];
    NSDictionary *dic0 = @{
                           @"project_id":[NSString stringWithFormat:@"%d",[self.info[@"project_id"] intValue]],
                           @"_currentPage":page,
                           @"_pageSize":@"",
                           };
    [[RequestManager shareRequestManager] searchProjectMessageDtos4Project:dic0 viewController:nil successData:^(NSDictionary *result){
        [self.tableView.mj_footer endRefreshing];
        if (IsSucess(result) == 1) {
            current_page = [[[result objectForKey:@"data"] objectForKey:@"current_page"] intValue];
            total_count = [[[result objectForKey:@"data"] objectForKey:@"total_count"] intValue];
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                
                
                if (array.count > 0) {
                    [self.listArray addObjectsFromArray:array];
                }
                
                
                
                if (self.listArray.count == total_count || self.listArray.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.tableView reloadData];
            }
            
        }else {
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:nil];
            }
        }
        [LZBLoadingView dismissLoadingView];
        self.failView.hidden = YES;
    }failuer:^(NSError *error){
        self.failView.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
    }];
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectZero];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}
@end
