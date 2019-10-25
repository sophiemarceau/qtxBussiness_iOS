//
//  SelectTagViewController.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/12/5.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SelectTagViewController.h"
#import "ChooseCollectionViewCell.h"
#define CellId @"CellId"
@interface SelectTagViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    int current_page,total_count;
}
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *skipLabel;
@property(nonatomic,strong)UIButton *goHomePageButton;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)UICollectionView  *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong)NSDictionary * cellDic;//设置cell的identifier，防止重用
@property(nonatomic,strong)NSMutableArray * choosedArr;
@end

@implementation SelectTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _choosedArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.skipLabel];
    [self.view addSubview:self.goHomePageButton];
    [self loadData];
}

-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] searchTagDtosByRecommend:dic viewController:self successData:^(NSDictionary *result) {
        [LZBLoadingView dismissLoadingView];
        if (IsSucess(result) == 1) {
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"];
            
            if(![array isEqual:[NSNull null]] && array !=nil){
                if (array.count > 0) {
                    [self.data addObjectsFromArray:array];
                }
                [self.collectionView reloadData];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    } failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
         [LZBLoadingView dismissLoadingView];
    }];
}

-(void)OnClick:(UIButton *)sender{
    sender.enabled = NO;
    NSString *tagStr = @"";
    if (_choosedArr != nil) {
        if (_choosedArr.count > 0) {
            NSMutableArray *tagArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *tagDic in _choosedArr) {
                [tagArray addObject:tagDic[@"tag_id"]];
            }
            tagStr = [tagArray componentsJoinedByString:@","];
//            NSLog(@"tagArray-------------->%@",tagArray);
        }else{
            [[RequestManager shareRequestManager] tipAlert:@"请您至少选择一项" viewController:self];
            sender.enabled = YES;
            return;
        }
    }
//    NSLog(@"_choosedArr-------------->%@",_choosedArr);
    
//    NSLog(@"tagStr-------------->%@",tagStr);
    NSDictionary *dic = @{ @"tag_ids":tagStr };
    [[RequestManager shareRequestManager] collectTags:dic viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            [self dismissViewControllerAnimated:YES completion:NULL];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_LOGINSELECT object:nil userInfo:nil
             ];
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        sender.enabled = YES;
    } failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        sender.enabled = YES;
    }];
}

-(void)gotoSkip:(UITapGestureRecognizer *)sender{
    sender.enabled = NO;
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] skipTagsFlag:dic viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            [self dismissViewControllerAnimated:YES completion:NULL];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_LOGINSELECT object:nil userInfo:nil
             ];
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        sender.enabled = YES;
    } failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        sender.enabled = YES;
    }];
}

#pragma -Collection Delegate Datesource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", CellId, [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        [self.collectionView registerClass:[ChooseCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    ChooseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setSelectBgView:indexPath.row WithContentName:self.data[indexPath.row][@"tag_content"]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseCollectionViewCell * cell = (ChooseCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell UpdateCellWithState:!cell.isSelected];
    if (cell.isSelected) {
        [_choosedArr addObject:self.data[indexPath.row]];
    }else{
        [_choosedArr removeObject:self.data[indexPath.row]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self.navigationController setNavigationBarHidden:YES];
    [MobClick beginLogPageView:kTagsSelectPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kTagsSelectPage];
    [self.navigationController setNavigationBarHidden:NO];
}

//是否显示或隐藏视图底部的tabbar
- (BOOL)shouldHideBottomBarWhenPushed{
    return YES;
}

//是否显示导航回退按钮
- (BOOL)shouldShowGobackButton{
    return  YES;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 71*AUTO_SIZE_SCALE_X, kScreenWidth, 35*AUTO_SIZE_SCALE_X);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"请选择你感兴趣的标签";
        _titleLabel.font  = [UIFont boldSystemFontOfSize:25*AUTO_SIZE_SCALE_X];
        _titleLabel.textColor = FontUIColorBlack;
    }
    return _titleLabel;
}


-(UILabel *)skipLabel{
    if (_skipLabel == nil) {
        _skipLabel = [[UILabel alloc] init];
        _skipLabel.frame = CGRectMake(35*AUTO_SIZE_SCALE_X, kScreenHeight-28*AUTO_SIZE_SCALE_X-20*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
        _skipLabel.textAlignment = NSTextAlignmentLeft;
        _skipLabel.font  = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _skipLabel.textColor = RedUIColorC1;
        _skipLabel.text = @"跳过";
        _skipLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSkip:)];
        [_skipLabel addGestureRecognizer:tap1];
    }
    return _skipLabel;
}

-(UIButton *)goHomePageButton{
    if (_goHomePageButton == nil) {
        _goHomePageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _goHomePageButton.frame = CGRectMake(kScreenWidth-15*AUTO_SIZE_SCALE_X-210*AUTO_SIZE_SCALE_X, kScreenHeight-20*AUTO_SIZE_SCALE_X-50*AUTO_SIZE_SCALE_X, 210*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
        _goHomePageButton.layer.masksToBounds = YES;
        [_goHomePageButton setTitle:@"开启渠天下生意之旅" forState:UIControlStateNormal];
        _goHomePageButton.layer.cornerRadius = 25;
        [_goHomePageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_goHomePageButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        [_goHomePageButton setBackgroundImage:[CommentMethod createImageWithColor: RedUIColorC1] forState:UIControlStateDisabled];
        [_goHomePageButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _goHomePageButton;
}


-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 156*AUTO_SIZE_SCALE_X, kScreenWidth,kScreenHeight-156*AUTO_SIZE_SCALE_X-141*AUTO_SIZE_SCALE_X) collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        [_collectionView registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:@"collectioncell"];
//        [_collectionView registerClass:[MineCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionheader"];
//        [_collectionView registerClass:[MineCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"collectionfooter"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

- (UICollectionViewLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [UICollectionViewFlowLayout new];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake(70*AUTO_SIZE_SCALE_X, 70*AUTO_SIZE_SCALE_X);
        //定义每个UICollectionView 横向的间距
        _flowLayout.minimumLineSpacing = 15;
        //定义每个UICollectionView 纵向的间距
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0,25,30, 25);
//        _flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, (44+85+78+10)*AUTO_SIZE_SCALE_X);
//        _flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 70*AUTO_SIZE_SCALE_X);
    }
    return _flowLayout;
}

@end
