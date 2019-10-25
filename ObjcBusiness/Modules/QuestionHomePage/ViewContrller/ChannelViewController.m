//
//  ChannelViewController.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/11/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ChannelViewController.h"
#import "ChannelCollectionViewCell.h"
#import "BaseNavView.h"

@interface ChannelViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic) NSMutableArray *channelMutableArray;
@property (strong,nonatomic) BaseNavView *navView;
@property (strong,nonatomic) UILabel *navLabel;
@property (strong,nonatomic) UIButton *gobackButton;
@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    
}
-(void)initSubViews{
    [self.view addSubview:self.navView];
    [self.view addSubview:self.collectionView];
}

-(void)gobackButtonOnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -Collection Delegate Datesource
//collectionCell方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChannelCollectionViewCell" forIndexPath:indexPath];
    if (self.currentSelect == indexPath.row) {
        cell.channelLabel.textColor = RedUIColorC1;
    }else{
        cell.channelLabel.textColor = FontUIColorBlack;
    }
    cell.channelLabel.text =  [NSString stringWithFormat:@"%@",[[self.channelArray objectAtIndex:(indexPath.row)] objectForKey:@"tag_content"]];
    
    return cell;
}

//cell个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.channelArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectDelegateReturnPage:indexPath.row FromIndex:self.currentSelect];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth,kScreenHeight-kNavHeight) collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ChannelCollectionViewCell class] forCellWithReuseIdentifier:@"ChannelCollectionViewCell"];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UICollectionViewLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [UICollectionViewFlowLayout new];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake((kScreenWidth-0.5*AUTO_SIZE_SCALE_X)/2, (15+34)*AUTO_SIZE_SCALE_X);
        //定义每个UICollectionView 横向的间距
        _flowLayout.minimumLineSpacing = 0.5*AUTO_SIZE_SCALE_X;
        //定义每个UICollectionView 纵向的间距
        _flowLayout.minimumInteritemSpacing = 0.5*AUTO_SIZE_SCALE_X;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0, 0);
        //        _flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, (44+85+78+10)*AUTO_SIZE_SCALE_X);
//        _flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 70*AUTO_SIZE_SCALE_X);
    }
    return _flowLayout;
}

- (BOOL)shouldShowGobackButton{
    return  NO;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kChannelPage];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [MobClick endLogPageView:kChannelPage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

-(BaseNavView *)navView{
    if (_navView == nil) {
        _navView = [[BaseNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        _navView.backgroundColor = [UIColor whiteColor];
        [_navView addSubview:self.navLabel];
        [_navView addSubview:self.gobackButton];
    }
    return _navView;
}
- (UILabel *)navLabel{
    if (_navLabel == nil) {
        _navLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, kSystemBarHeight, 100*AUTO_SIZE_SCALE_X, kNavHeight-kSystemBarHeight)];
        _navLabel.textColor = FontUIColorBlack;
        _navLabel.text = @"切换频道";
        _navLabel.textAlignment = NSTextAlignmentLeft;
        _navLabel.font = [UIFont systemFontOfSize:16];
    }
    return _navLabel;
}

-(UIButton *)gobackButton{
    if (_gobackButton == nil) {
        _gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gobackButton setImage:[UIImage imageNamed:@"qa_home_nav_close"] forState:UIControlStateNormal];
        [_gobackButton setImage:[UIImage imageNamed:@"qa_home_nav_close"] forState:UIControlStateSelected];
        _gobackButton.frame = CGRectMake(kScreenWidth-(44)*AUTO_SIZE_SCALE_X,  (kSystemBarHeight), 44*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
        [_gobackButton addTarget:self action:@selector(gobackButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gobackButton;
}
@end
