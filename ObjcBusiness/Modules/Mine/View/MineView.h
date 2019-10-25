//
//  MineView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineCollectionHeaderView.h"
#import "MineCollectionFooterView.h"

@interface MineView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong) UICollectionView *centerView;

//@property (nonatomic,strong) UIView *customServiceView;
@property (nonatomic,strong) NSMutableArray *collectionMutableArray;

@property (nonatomic,strong) MineCollectionHeaderView *collectionHeaderView;
@end
