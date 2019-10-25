//
//  MineViewController.m
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//
#import "UIBarButtonItem+Badge.h"
#import "MineViewController.h"
#import "MineCollectionViewCell.h"
#import "MineCollectionHeaderView.h"
#import "MineCollectionFooterView.h"
#import "MineViewModel.h"
#import "SettingsViewController.h"
#import "PushCenterViewController.h"
#import "ResumeViewController.h"
#import "UIImageView+WebCache.h"
#import "MineModel.h"
#import "ResumeTempletViewController.h"
#import "SearchEnterpriseViewController.h"
#import "ScannerViewController.h"
#import "SubmitSuccessViewController.h"
#import "LeaveMessageViewController.h"
#import "PerfectPersonalInfoViewController.h"
#import "ProjectMessageViewController.h"
#import "PersonalHomePageViewController.h"
#import "GetDingListViewController.h"
#import "FollowerListViewController.h"
#import "FansListViewController.h"
#import "MyCollectViewController.h"
#import "MyQuestionAnswerViewController.h"
#import "JSBadgeView.h"
#import "MyScoresViewController.h"
#import "PersonalViewController.h"
#import "ProjectManagerViewController.h"

@interface MineViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TaglistButtonDelegate>{
    NSString *c_profiles;
    NSString *userNickName;
    NSURL *userPortraitUri ;
    NSString *company_id;
    NSString *c_tel;
    int isExpertFlag;
    int iscac_status_codeFlag;
    NSInteger showHiddenFlag;
    int messageCountNum;
}

@property (strong,nonatomic) MineViewModel *myCenterViewModel;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *collectionMutableArray;
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic) MineCollectionHeaderView *mineCollectionHeaderView;
@property (strong,nonatomic) MineCollectionFooterView *customerServiceView;
@property (assign,nonatomic) Boolean isPerfectBusinessResume;
@property (strong,nonatomic) NSString *userKindStr;
@property (nonatomic,strong)JSBadgeView *badgeView;
@property (nonatomic,strong)noWifiView *failView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavgation];
    [self initSubViews];
    
    
//    __block MineViewController *blockSelf = self;
//    [self.myCenterViewModel setBlockWithReturnBlock:^(id returnValue, ResopnseFlagState returnFlag, NSString *signalString) {
//        if ([signalString isEqualToString:@"isPerfectBusinessResume"]) {
//            if (returnFlag ==ResponseSuccess) {
//                int returnFLag = [[[returnValue objectForKey:@"data"] objectForKey:@"result"] intValue];
//                if (returnFLag == 1) {
//                    blockSelf.isPerfectBusinessResume = returnFLag;
//                    NSLog(@"--isPerfectBusinessResume-------%@",returnValue);
//                    blockSelf.mineCollectionHeaderView.resumeView.hidden = YES;
//                    blockSelf.mineCollectionHeaderView.resumeView.frame = CGRectMake(0, 0, kScreenWidth, 0);
//                    blockSelf.mineCollectionHeaderView.frame = CGRectMake(0, 0, kScreenWidth, (85+78+10)*AUTO_SIZE_SCALE_X);
//                    
//                    [blockSelf.collectionView reloadData];
//                }else{
//                }
//            }
//        }
//        if ([signalString isEqualToString:@"getManyNumbersToClientView"]) {
//            if (returnFlag ==ResponseSuccess) {
//                MineModel *mineModel = (MineModel *) returnValue;
//                NSArray *NumbersArray = @[mineModel.browseNum,mineModel.collectNum,mineModel.communicateNum];
//                [blockSelf.mineCollectionHeaderView.headerView setLabelText:NumbersArray];
//            }
//        }
//        if ([signalString isEqualToString:@"getManyNumbersToEnterpirseView"]) {
//            if (returnFlag ==ResponseSuccess) {
//                MineModel *mineModel = (MineModel *) returnValue;
//                NSArray *NumbersArray = @[mineModel.browseNum,mineModel.collectNum,mineModel.communicateNum];
//                [blockSelf.mineCollectionHeaderView.headerView setLabelText:NumbersArray];
//            }
//        }
//    }WithErrorBlock:^(id errorCode, NSString *errorSignalString) {
//        
//    }];
    
}

-(void)ButtonDidSelected:(UIButton *)tagBtn{
    if (tagBtn.tag == 0) {
        GetDingListViewController   *vc = [[GetDingListViewController alloc] init];
        vc.title = @"收到的赞";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tagBtn.tag == 1) {
        FollowerListViewController   *vc = [[FollowerListViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tagBtn.tag == 2) {
        [self gotoFanseView];
    }
}

-(void)gotoFanseView{
    FansListViewController   *vc = [[FansListViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loadData{
    company_id =@"";
    [self GetUserInfoResult];
    [self getSystemMessageCout];
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

//-(void)getHiddenShowView{
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    NSDictionary *dic =@{};
//    [[RequestManager shareRequestManager] getAnauthorizedProjectCount:dic viewController:self successData:^(NSDictionary *result) {
//        _collectionView.hidden = NO;
//        NSLog(@"result ===getAnauthorizedProjectCount===>%@",result);
//        if (IsSucess(result) == 1) {
//            showHiddenFlag = [[[result objectForKey:@"data"] objectForKey:@"result"] integerValue];
//            if (showHiddenFlag == 0) {
//                self.mineCollectionHeaderView.resumeView.hidden = YES;
//                self.mineCollectionHeaderView.resumeView.frame = CGRectMake(0, 0, kScreenWidth, 0);
//            }
//        }else{
//            if (IsSucess(result) == -1) {
//                [[RequestManager shareRequestManager] loginCancel:result];
//            }else{
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            }
//        }
//        [self.collectionView reloadData];
//        self.failView.hidden = YES;
//        [LZBLoadingView dismissLoadingView];
//    } failuer:^(NSError *error) {
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//        self.failView.hidden = NO;
//        _collectionView.hidden = NO;
//        [LZBLoadingView dismissLoadingView];
//    }];
//}

-(void)getSystemMessageCout{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic =@{};
    [[RequestManager shareRequestManager] getUnReadCountDto:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result ===getSysMsgUnReadCount===>%@",result);
        if (IsSucess(result) == 1) {
            NSDictionary *dto = [[result objectForKey:@"data"] objectForKey:@"result"];
            messageCountNum = [[dto objectForKey:@"totalUnReadCount"]  intValue];
            
            
            
            self.navigationItem.leftBarButtonItem.badgeBGColor = RedUIColorC1;
            
            if (messageCountNum == 0) {
                self.navigationItem.leftBarButtonItem.badgeValue = @"";
            }else{
                self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%d",messageCountNum];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        self.failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    } failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        self.failView.hidden = NO;
        [LZBLoadingView dismissLoadingView];
    }];
}

-(void)GetUserInfoResult{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    
    NSString *user_id_str = [DEFAULTS objectForKey:@"user_id_str"];
    if (!user_id_str) {
        user_id_str  = @"";
    }
    NSDictionary *dic = @{
                          @"user_id_str":user_id_str,
                          @"_isReturnCompanyInfo":@"1",
                          @"_isReturnExt":@"1"
                          };
    [[RequestManager shareRequestManager] GetUserInfoResult:dic viewController:self successData:^(NSDictionary *result) {
        _collectionView.hidden = NO;
//        NSLog(@"GetUserInfoResult------>%@",result);
        if (IsSucess(result) == 1) {
            NSDictionary *resultDic = [[result objectForKey:@"data"] objectForKey:@"result"];
            
            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_tel"]] forKey:@"userTelphone"];
            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_photo"]] forKey:@"userPortraitUri"];
            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_nickname"]] forKey:@"userNickName"];
            [DEFAULTS setObject:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"c_profiles"]] forKey:@"c_profiles"];
            [DEFAULTS synchronize];
            //（1，普通用户；2，企业用户；3，平台运营)
            self.userKindStr = [DEFAULTS objectForKey:@"userKind"];
            userNickName = [DEFAULTS objectForKey:@"userNickName"];
            userPortraitUri = [DEFAULTS objectForKey:@"userPortraitUri"];
            c_profiles = [DEFAULTS objectForKey:@"c_profiles"];
            
            NSDictionary *userCExtDto =  [resultDic objectForKey:@"userCExtDto"];
            if(![userCExtDto isEqual:[NSNull null]] && userCExtDto !=nil){
                NSString *dingNum = [userCExtDto objectForKey:@"uce_ding_count"];
                NSString *collectNum = [userCExtDto objectForKey:@"uce_connection_count"];
                NSString *fansNum = [userCExtDto objectForKey:@"uce_fans_count"];
                NSArray *NumbersArray = @[dingNum,collectNum,fansNum];
                [self.mineCollectionHeaderView.tabbarView setLabelText:NumbersArray];
                self.mineCollectionHeaderView.tabbarView.barlistButtonDelegate = self;
            }
            if(![[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"company_id"]] isEqualToString:@"0"]){
                isExpertFlag = [[resultDic objectForKey:@"c_is_expert_code"] intValue];
                iscac_status_codeFlag = [[resultDic objectForKey:@"cac_status_code"] intValue];
                company_id = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"company_id"]];
            }
            
            [self.collectionMutableArray removeAllObjects];
            if ([self.userKindStr isEqualToString: @"1"]) {
                [self.collectionMutableArray addObjectsFromArray:@[
                                                                   @{@"iconImage":@"me_icon_me_information",@"iconLabel":@"个人信息"},
                                                                   @{@"iconImage":@"me_icon_collection",@"iconLabel":@"我的收藏"},
                                                                   @{@"iconImage":@"me_icon_qa",@"iconLabel":@"我的问答"},
                                                                   @{@"iconImage":@"me_icon_integral",@"iconLabel":@"我的积分"}
                                                                   ]];
                //        [self.myCenterViewModel isPerfectBusinessResume];
                //        [self.myCenterViewModel getManyNumbersToClientView];
            }
            if ([self.userKindStr isEqualToString: @"2"]) {
                [self.collectionMutableArray addObjectsFromArray:@[
                                                                   @{@"iconImage":@"me_icon_me_information",@"iconLabel":@"个人信息"},
                                                                   @{@"iconImage":@"me_icon_collection",@"iconLabel":@"我的收藏"},
                                                                   @{@"iconImage":@"me_icon_qa",@"iconLabel":@"我的问答"},
                                                                   @{@"iconImage":@"me_icon_integral",@"iconLabel":@"我的积分"},
                                                                   @{@"iconImage":@"me_icon_answer",@"iconLabel":@"项目管理"},
//                                                                   @{@"iconImage":@"me_icon_qr_code",@"iconLabel":@"登录网页端"},
                                                                   ]];
                //        [self.myCenterViewModel getManyNumbersToEnterpirseView];
            }
            NSString *description = [resultDic objectForKey:@"c_description"];
            if(description == nil ||[description isEqualToString:@""]){
                showHiddenFlag = 1;
            }else{
                showHiddenFlag = 0;
            }
            if (showHiddenFlag == 0) {
                self.mineCollectionHeaderView.resumeView.hidden = YES;
                self.mineCollectionHeaderView.resumeView.frame = CGRectMake(0, 0, kScreenWidth, 0);
            }else{
                UITapGestureRecognizer *tagR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPersonalFinish)];
                self.mineCollectionHeaderView.resumeView.userInteractionEnabled = YES;
                [self.mineCollectionHeaderView.resumeView addGestureRecognizer:tagR];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        
        
        
        [self.collectionView reloadData];
        self.failView.hidden = YES;
        [LZBLoadingView dismissLoadingView];
    } failuer:^(NSError *error) {
        self.failView.hidden = NO;
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initNavgation{
    UIImage *image = [UIImage imageNamed:@"me_nav_btn_news_normal"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(gotoPushCenter) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    navLeftButton.tintColor = UIColorFromRGB(0x1A1A1A);
    [navLeftButton setTitle:@""];
    self.navigationItem.leftBarButtonItem = navLeftButton;
    
    
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIImage *settingImage = [UIImage imageNamed:@"me_nav_btn_set_up_normal"];
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithImage:settingImage style:UIBarButtonItemStylePlain target:self action:@selector(gotoSetting)];
    rightBackItem.tintColor = UIColorFromRGB(0x1A1A1A);
    [rightBackItem setTitle:@""];
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
}

-(void)gotoSetting{
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoPushCenter{
    PushCenterViewController  *vc = [[PushCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//-(void)NewGuideViewTaped:(UITapGestureRecognizer *)sender
//{
//    [self gotoResumeViewController];
//}

-(void)gotoPersonalInfo{
    PerfectPersonalInfoViewController *vc = [[PerfectPersonalInfoViewController alloc] init];
    vc.title = @"个人主页";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoPersonalFinish{
    PersonalViewController *vc = [[PersonalViewController alloc] init];
    vc.title = @"个人主页";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoPersonalHomePage{
    PersonalHomePageViewController *vc = [[PersonalHomePageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//-(void)gotoResumeViewController{
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchForResume"]){
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchForResume"];
//        //第一次浏览生意模板
//        [[RequestManager shareRequestManager] initBusinessResume:nil viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"result----initBusinessResume---->%@",result);
//            if ([result[@"flag"] integerValue] == 1 ) {
//                ResumeTempletViewController *vc = [[ResumeTempletViewController alloc] init];
//                vc.title = @"生意简历模板展示";
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        } failuer:^(NSError *error) {
//        }];
//    }else{
//        ResumeViewController *vc = [[ResumeViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
-(void)ServicePhoneViewTaped:(UITapGestureRecognizer *)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4009001135"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
     completionHandler:^(BOOL success) {
     }];
}

-(void)gotoPersonal:(UITapGestureRecognizer *)sender{
    PersonalViewController *vc = [[PersonalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initSubViews {
    [self.view addSubview:self.collectionView];
}

#pragma -Collection Delegate Datesource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    
    cell.iconImageView.image = [UIImage imageNamed:[self.collectionMutableArray[indexPath.item] objectForKey:@"iconImage"]];
    cell.functionNamelabel.text = [self.collectionMutableArray[indexPath.item] objectForKey:@"iconLabel"];
    
    return cell
    ;
}

//header 或者 footer方法
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        self.mineCollectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionheader" forIndexPath:indexPath];
        [self.mineCollectionHeaderView.headerView.userNameLabel setText:userNickName];
        if (![c_profiles isEqualToString:@""]) {
            [self.mineCollectionHeaderView.headerView.userSubLabel setText:c_profiles];
        }else{
             [self.mineCollectionHeaderView.headerView.userSubLabel setText:@"用一句话介绍一下你吧"];
        }
        [self.mineCollectionHeaderView.headerView.headerImageView sd_setImageWithURL:userPortraitUri placeholderImage:nil];
        self.mineCollectionHeaderView.userInteractionEnabled = YES;
        UITapGestureRecognizer *collect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPersonal:)];
        self.mineCollectionHeaderView.headerView.userSubLabel.userInteractionEnabled = YES;
        [self.mineCollectionHeaderView.headerView.userSubLabel addGestureRecognizer:collect];
        UITapGestureRecognizer *collectnametap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPersonal:)];
        self.mineCollectionHeaderView.headerView.userNameLabel.userInteractionEnabled = YES;
        [self.mineCollectionHeaderView.headerView.userNameLabel addGestureRecognizer:collectnametap];
        UITapGestureRecognizer *gotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPersonal:)];
        self.mineCollectionHeaderView.headerView.headerImageView.userInteractionEnabled = YES;
        [self.mineCollectionHeaderView.headerView.headerImageView addGestureRecognizer:gotoTap];
//        [self.mineCollectionHeaderView.resumeView.resumeButton addTarget:self action:@selector(NewGuideViewTaped:) forControlEvents:UIControlEventTouchUpInside];
       
        UITapGestureRecognizer * NewViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPersonalHomePage)];
        self.mineCollectionHeaderView.resumeView.userInteractionEnabled = YES;
//        [self.mineCollectionHeaderView.resumeView addGestureRecognizer:NewViewtap];
         [self.mineCollectionHeaderView.headerView.personalPageLabel addGestureRecognizer:NewViewtap];
        
//        NSLog(@"isExpertFlag------>%d",isExpertFlag);
//        NSLog(@"iscac_status_codeFlag------>%d",iscac_status_codeFlag);
        if (isExpertFlag == 1) {
            self.mineCollectionHeaderView.headerView.expertFlagImageView.hidden = NO;
        }
        if (iscac_status_codeFlag == 1) {
            self.mineCollectionHeaderView.headerView.companyFlagImageView.hidden = NO;
        }
        return self.mineCollectionHeaderView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        self.customerServiceView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionfooter" forIndexPath:indexPath];
        UITapGestureRecognizer * NewViewtap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ServicePhoneViewTaped:)];
        self.mineCollectionHeaderView.resumeView.userInteractionEnabled = YES;
        [self.customerServiceView addGestureRecognizer:NewViewtap1];
        return self.customerServiceView;
    }
    return nil;
}

//cell个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionMutableArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    if ([_delegate respondsToSelector:@selector(pagerView:didSelectedItemCell:atIndex:)]) {
//        [_delegate pagerView:self didSelectedItemCell:cell atIndex:indexPath.item];
//    }
    if ([[[self.collectionMutableArray objectAtIndex:indexPath.row] objectForKey:@"iconLabel"] isEqualToString:@"个人信息"]) {
        [self gotoPersonalInfo];
    }
//    if ([[[self.collectionMutableArray objectAtIndex:indexPath.row] objectForKey:@"iconLabel"] isEqualToString:@"生意简历"]) {
//        [self gotoResumeViewController];
//    }
    
    if ([[[self.collectionMutableArray objectAtIndex:indexPath.row] objectForKey:@"iconLabel"] isEqualToString:@"发布项目"]) {
        
        if([company_id isEqualToString:@""]){
            SearchEnterpriseViewController *vc = [[SearchEnterpriseViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ScannerViewController *vc = [[ScannerViewController alloc ] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if ([[[self.collectionMutableArray objectAtIndex:indexPath.row] objectForKey:@"iconLabel"] isEqualToString:@"项目管理"]) {
        ProjectManagerViewController *vc = [[ProjectManagerViewController alloc ] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([[[self.collectionMutableArray objectAtIndex:indexPath.row] objectForKey:@"iconLabel"] isEqualToString:@"登录网页端"]) {
        
        ScannerViewController *vc = [[ScannerViewController alloc ] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([[[self.collectionMutableArray objectAtIndex:indexPath.row] objectForKey:@"iconLabel"] isEqualToString:@"我的收藏"]) {
        
        MyCollectViewController *vc = [[MyCollectViewController alloc ] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([[[self.collectionMutableArray objectAtIndex:indexPath.row] objectForKey:@"iconLabel"] isEqualToString:@"我的问答"]) {
        
        MyQuestionAnswerViewController *vc = [[MyQuestionAnswerViewController alloc ] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([[[self.collectionMutableArray objectAtIndex:indexPath.row] objectForKey:@"iconLabel"] isEqualToString:@"我的积分"]) {
        
        MyScoresViewController *vc = [[MyScoresViewController alloc ] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (showHiddenFlag == 0) {
         return CGSizeMake(kScreenWidth, (85+78+10)*AUTO_SIZE_SCALE_X);
    }
     return CGSizeMake(kScreenWidth, (44+85+78+10)*AUTO_SIZE_SCALE_X);
}

#pragma mark - Getter
- (MineViewModel *)myCenterViewModel {
    if (_myCenterViewModel == nil) {
        _myCenterViewModel = [[MineViewModel alloc]init];
    }
    return _myCenterViewModel;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth,kScreenHeight-kTabHeight-kNavHeight) collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:@"collectioncell"];
        [_collectionView registerClass:[MineCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionheader"];
        [_collectionView registerClass:[MineCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"collectionfooter"];
        _collectionView.backgroundColor = BGColorGray;
        _collectionView.hidden = YES;
    }
    return _collectionView;
}

- (UICollectionViewLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [UICollectionViewFlowLayout new];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake((kScreenWidth-0.5*AUTO_SIZE_SCALE_X)/2, 70*AUTO_SIZE_SCALE_X);
        //定义每个UICollectionView 横向的间距
        _flowLayout.minimumLineSpacing = 0.5*AUTO_SIZE_SCALE_X;
        //定义每个UICollectionView 纵向的间距
        _flowLayout.minimumInteritemSpacing = 0.5*AUTO_SIZE_SCALE_X;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0, 0);
//        _flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, (44+85+78+10)*AUTO_SIZE_SCALE_X);
        _flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 70*AUTO_SIZE_SCALE_X);
    }
    return _flowLayout;
}

-(NSMutableArray *)collectionMutableArray{
    if (_collectionMutableArray == nil) {
        _collectionMutableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _collectionMutableArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kMyCenterPage];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kMyCenterPage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self loadData];
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight - kTabHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}
@end
