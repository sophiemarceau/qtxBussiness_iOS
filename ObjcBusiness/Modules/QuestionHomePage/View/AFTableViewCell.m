//
//  AFTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AFTableViewCell.h"
#import "ExpertCollectionViewCell.h"
@implementation AFIndexedCollectionView

@end

@implementation AFTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(15*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 5*AUTO_SIZE_SCALE_X);
    layout.itemSize = CGSizeMake(160*AUTO_SIZE_SCALE_X ,
                                 203*AUTO_SIZE_SCALE_X);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[ExpertCollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(self.contentView.bounds.origin.x, self.contentView.bounds.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height-5*AUTO_SIZE_SCALE_X);
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    [self.collectionView reloadData];
}
@end
