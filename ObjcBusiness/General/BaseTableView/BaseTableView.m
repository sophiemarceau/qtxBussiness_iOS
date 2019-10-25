//
//  PosterTableView.m
//
//
//
//  Copyright (c)  All rights reserved.
//

#import "BaseTableView.h"


@interface BaseTableView()
//{
//    MJRefreshHeaderView *_header;
//    MJRefreshFooterView *_foot;
//}
@end

@implementation BaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self _initViews:frame];
    }
    return  self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self _initViews:self.frame];

}

-(void)_initViews:(CGRect)frame
{
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    //去掉垂直方向的滚动条
    self.showsVerticalScrollIndicator = NO;
    
    self.delegate = self;
    self.dataSource = self;
    
    //设置减速的方式， UIScrollViewDecelerationRateFast 为快速减速
    self.decelerationRate = UIScrollViewDecelerationRateFast;

    self.backgroundColor = [UIColor clearColor];
   
}

#pragma mark -UITableView dataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identify = @"posterTabelView";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        //取消cell的选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor grayColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.selectIndexPath = indexPath;
}


@end
