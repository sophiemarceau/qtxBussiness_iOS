//
//  MineView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MineView.h"
#import "UIView+ComboBoxExtension.h"
#import "MineViewModel.h"
#import "MineCollectionViewCell.h"

@interface MineView ()
@property(nonatomic,strong)MineViewModel *mineViewModel;

@end

@implementation MineView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = BGColorGray;
        self.collectionMutableArray = [NSMutableArray arrayWithCapacity:0];
        self.frame = frame;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    [self addSubview:self.centerView];
    //    [self addSubview:self.headerView];
//    [self addSubview:self.resumeView];
//    [self addSubview:self.centerView];
//    [self addSubview:self.customServiceView];
}

//-(void)NewGuideViewTaped:(UITapGestureRecognizer *)sender
//{
//    [UIView animateWithDuration:0.35 animations:^{
//        self.resumeView.frame = CGRectMake(0, 0, kScreenWidth, 0);
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//    NSLog(@"frame--resumeView--->%@",self.resumeView);
//
//}

-(void)setMineViewModel:(MineViewModel *)mineViewModel{
    self.mineViewModel = mineViewModel;
    [self.mineViewModel setBlockWithReturnBlock:^(id returnValue, ResopnseFlagState returnFlag, NSString *signalString) {
        
    } WithErrorBlock:^(id errorCode, NSString *errorSignalString) {
        
    }];
}

//-(void)layoutSubviews{
//    
//    self.headerView.frame = CGRectMake(0, self.resumeView.bottom, kScreenWidth, 85+78*AUTO_SIZE_SCALE_X);
//    self.centerView.frame = CGRectMake(0, self.headerView.bottom+10*AUTO_SIZE_SCALE_X, kScreenWidth, 85+78*AUTO_SIZE_SCALE_X);
//    self.customServiceView.frame = CGRectMake(0, self.centerView.bottom+10*AUTO_SIZE_SCALE_X, kScreenWidth, 60*AUTO_SIZE_SCALE_X);
//}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"count-------->%d",self.collectionMutableArray.count);
    return [self.collectionMutableArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.iconImageView.image = [self.collectionMutableArray[indexPath.item] objectForKey:@"iconImage"];
    cell.functionNamelabel.text = [self.collectionMutableArray[indexPath.item] objectForKey:@"iconLabel"];
    return cell;
    
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    _index = indexPath.item;
    
    
//    [self confiMenuWithSelectRow:_index];
//    [self.delegate PullDownMenu:self didSelectRowAtColumn:_currentSelectedMenudIndex row:indexPath.row];
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MineCollectionHeaderView *mineCollectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionheader" forIndexPath:indexPath];
        return mineCollectionHeaderView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        MineCollectionFooterView *customerServiceView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionfooter" forIndexPath:indexPath];
        return customerServiceView;
    }
    return nil;
}


- (UICollectionView *)centerView{
    if (_centerView == nil) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.itemSize = CGSizeMake(187.5*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X);
        //        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 1*AUTO_SIZE_SCALE_X;
        //        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 1*AUTO_SIZE_SCALE_X;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0,0, 0.5*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
        _centerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height) collectionViewLayout:flowLayout];
        _centerView.backgroundColor = BGColorGray;
        _centerView.scrollEnabled = YES;
        _centerView.dataSource = self;
        _centerView.delegate = self;
        [_centerView registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//        [_centerView registerClass:[MineCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionheader"];
//        [_centerView registerClass:[MineCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"collectionfooter"];
//        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, (44+85+78+10)*AUTO_SIZE_SCALE_X);
//        flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 70*AUTO_SIZE_SCALE_X);
    }
    return _centerView;
}




@end
