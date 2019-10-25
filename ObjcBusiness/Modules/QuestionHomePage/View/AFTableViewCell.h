//
//  AFTableViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AFIndexedCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

static NSString *CollectionViewCellIdentifier = @"ExpertCollectionViewCell";

@interface AFTableViewCell : UITableViewCell
@property (nonatomic, strong) AFIndexedCollectionView *collectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;


@property (nonatomic, strong)UIImageView *headview;
@property (nonatomic, strong)UILabel *nameLabel,*desLabel;
@property (nonatomic, strong)UIButton *btn;

@end
