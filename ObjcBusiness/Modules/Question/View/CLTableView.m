//
//  CLTableView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/17.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CLTableView.h"
#import "CLTagButton.h"
#import "CLTools.h"
@implementation CLTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self showUI];
    }
    return self;
}

- (void)showUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTagsStatus:) name:NOTIFICATION_NAME_SEARCHTAGLIST object:nil];
    self.backgroundColor = [UIColor whiteColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    //去掉垂直方向的滚动条
    self.showsVerticalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    //设置减速的方式， UIScrollViewDecelerationRateFast 为快速减速
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - 通知
- (void)reloadTagsStatus:(NSNotification *)notification {
    if (notification.object == nil) {
        NSString *tagContentStr = notification.userInfo[@"tag_content"];
        NSDictionary *dic = @{@"tag_content":tagContentStr};
        if (tagContentStr.length != 0) {
            [[RequestManager shareRequestManager] getLikeTagDtoLike:dic viewController:nil successData:^(NSDictionary *result) {
                if (IsSucess(result) == 1) {
                    [self.dataArray removeAllObjects];
//                    NSLog(@"getLikeTagDtoLike---------->%@",result);
                    NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
                    
                    if(![array isEqual:[NSNull null]] && array !=nil){
                        
                        [self.dataArray addObjectsFromArray:array];
                        
                    }
                    [self reloadData];
                    if (self.dataArray.count > 0) {
                        self.hidden = NO;
                    }else{
                        self.hidden = YES;
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_showorHideHotTagView object:nil userInfo:@{
                                                                                                                                         @"HotTagHiddenFlag":@(0),
                                                                                                                                         
                                                                                                                                         }];
                    }
                }else{
                    if (IsSucess(result) == -1) {
                        [[RequestManager shareRequestManager] loginCancel:result];
                    }else{
                        [[RequestManager shareRequestManager] resultFail:result viewController:nil];
                    }
                }
               
            } failuer:^(NSError *error) {
                
            }];
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*AUTO_SIZE_SCALE_X;
}

#pragma mark -UITableView dataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"posterTabelView";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        //取消cell的选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = lineImageColor;
    cell.textLabel.text = self.dataArray[indexPath.row][@"tag_content"];
    [cell.contentView addSubview:lineImageView];
    lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X-1, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    if ((int)indexPath.row == ([self.dataArray count]-1)) {
        lineImageView.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    self.selectIndexPath = indexPath;
//    [self.tagBtnDelegate tagtableDidSelected:self.dataArray[indexPath.row]];
    
   CLTagButton *disSelectButton = [CLTagButton initWithTagDesc:[self.dataArray[indexPath.row] objectForKey:@"tag_content"]];
    disSelectButton.tag = [[self.dataArray[indexPath.row] objectForKey:@"tag_id"] intValue];
    disSelectButton.tagSelected = YES;
   [[NSNotificationCenter defaultCenter] postNotificationName:kCLRecentTagViewTagClickNotification object:nil userInfo:@{kCLRecentTagViewTagClickKey: disSelectButton}];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_showorHideHotTagView object:nil userInfo:@{
                                                                                                                            @"HotTagHiddenFlag":@(0),
                                                                                                                            
                                                                                                                            }];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


//-(UIImageView *)lineImageView{
//    if(_lineImageView == nil){
//        _lineImageView = [UIImageView new];
//        _lineImageView.backgroundColor = lineImageColor;
//
//    }
//    return _lineImageView;
//}
@end
