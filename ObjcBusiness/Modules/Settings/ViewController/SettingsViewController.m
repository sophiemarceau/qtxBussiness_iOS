//
//  SettingsViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SettingsViewController.h"
#import "BaseTableViewCell.h"
#import "SearchEnterpriseViewController.h"
#import "BossComingViewController.h"
#import "CreateProjectViewController.h"
#import "ComplainViewController.h"
#import "SVProgressHUD.h"
#import "LBClearCacheTool.h"
#import "AboutusViewController.h"
#import "JPUSHService.h"
#import "ComfirmEditViewController.h"
#import <RongIMLib/RongIMLib.h>
#define filePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *myTableView;
    NSArray *mydata;
}
@property(nonatomic,strong)UIButton *quitButton;
@property(nonatomic,strong)UIView *tableheaderView;
@end

@implementation SettingsViewController
static NSInteger seq = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    mydata = @[@"问题反馈",@"关于我们",@"清除缓存"];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.bounces = NO;
    myTableView.dataSource = self;
    myTableView.estimatedRowHeight =(50)*AUTO_SIZE_SCALE_X+1;
    
    
    [self.view addSubview:myTableView];
    [self.view addSubview:self.quitButton];
    
    [myTableView setTableHeaderView:self.tableheaderView];
//    if (![userkind isEqualToString:@"2"]) {
//        [myTableView setTableHeaderView:self.tableheaderView];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mydata.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*AUTO_SIZE_SCALE_X;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"basetableviewCell";
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [(BaseTableViewCell *)[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = BGColorGray;
    UIView *bgView = [UIView new];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
    [cell.contentView addSubview:bgView];
    
    UILabel *nameLabel =  [CommentMethod createLabelWithText:@"" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:15*AUTO_SIZE_SCALE_X];
    nameLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth-60*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    nameLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    nameLabel.textColor = FontUIColorBlack;
    [bgView addSubview:nameLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5)];
    lineImageView.backgroundColor = lineImageColor;
    [bgView addSubview:lineImageView];
    nameLabel.text = mydata[indexPath.row];
    if (indexPath.row == 0 || indexPath.row ==1) {
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-9*AUTO_SIZE_SCALE_X-15, 17.5*AUTO_SIZE_SCALE_X, 9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X)];
        arrowImageView.image = [UIImage imageNamed:@"list_icon_more"];
        [bgView addSubview:arrowImageView];
    }
    if (indexPath.row == 2) {
        lineImageView.hidden = YES;
        NSString *fileSize = [LBClearCacheTool getCacheSizeWithFilePath:filePath];
        if ([fileSize integerValue] == 0) {
            nameLabel.text = @"清除缓存";
        }else {
            nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",mydata[indexPath.row],fileSize];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row==0&&indexPath.section==0) {
//        SearchEnterpriseViewController *vc = [[SearchEnterpriseViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    if ( indexPath.row==0 ) {
        ComplainViewController *vc = [[ComplainViewController alloc] init];
        vc.feedback_kind = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ( indexPath.row==1 ) {
        AboutusViewController* vc = [[AboutusViewController alloc] init];
        vc.title =@"关于我们";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ( indexPath.row==2 ) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定清除缓存吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //创建一个取消和一个确定按钮
        UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //清除缓存
            BOOL isSuccess = [LBClearCacheTool clearCacheWithFilePath:filePath];
            if (isSuccess) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"清除成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
        }];
        [actionCancle setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [actionOk setValue:FontUIColorBlack forKey:@"titleTextColor"];
        //将取消和确定按钮添加进弹框控制器
        [alert addAction:actionCancle];
        [alert addAction:actionOk];
        //添加一个文本框到弹框控制器
        
        
        //显示弹框控制器
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}
- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

//是否显示视图底部导航栏的线
- (BOOL)shouldShowShadowImage{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kSettingPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kSettingPage];
}

-(UIButton *)quitButton{
    if (_quitButton==nil) {
        self.quitButton = [UIButton new];
        self.quitButton.frame = CGRectMake(25*AUTO_SIZE_SCALE_X, kScreenHeight-88*AUTO_SIZE_SCALE_X,  kScreenWidth-50*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
        [self.quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.quitButton.titleLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        self.quitButton.backgroundColor = RedUIColorC1;
        [self.quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.quitButton.layer.cornerRadius = 4;
    }
    return _quitButton;
}

-(void)quitButtonClick{
    //可更新
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要退出么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
        
    }
    if(buttonIndex == 1)
    {
        NSString *qtx_quth = [DEFAULTS objectForKey:@"qtxsy_auth"] ;
        NSDictionary *dic = @{ @"qtxsy_auth":qtx_quth,};
        [[RequestManager shareRequestManager] QuitToBlank4MachineIdentificationCodeResult:dic viewController:self successData:^(NSDictionary *result){
            if(IsSucess(result)){
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
                 [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                 [[RCIMClient sharedRCIMClient] logout];
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    NSString *responseStr  = [NSString stringWithFormat:@"\n\n code:%ld content:%@ seq:%ld", iResCode, iAlias, seq];
//                    NSLog(@"resopnse------>%@",responseStr);
                } seq:[self seq]];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"qtxsy_auth"];
//            [[NSUserDefaults standardUserDefaults]  synchronize];
//            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NAME_USER_LOGOUT object:nil];
        }];
        
    }
}

- (NSInteger)seq {
    return ++ seq;
}

-(void)SearchEnterpriseView{

    NSString *userkind = [DEFAULTS objectForKey:@"userKind"];
    if (![userkind isEqualToString:@"2"]) {
        BossComingViewController *vc = [[BossComingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        CreateProjectViewController *vc = [[CreateProjectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UIView *)tableheaderView{
    if (_tableheaderView == nil ) {
        _tableheaderView = [UIView new];
        _tableheaderView.frame = CGRectMake(0, 0, kScreenWidth, 60*AUTO_SIZE_SCALE_X);
        UIView *bgView = [UIView new];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        bgView.frame = CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
        [_tableheaderView addSubview:bgView];
        
        UILabel *nameLabel =  [CommentMethod createLabelWithText:@"老板入驻" TextColor:FontUIColorBlack BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:15*AUTO_SIZE_SCALE_X];
        nameLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth-60*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
        nameLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        nameLabel.textColor = FontUIColorBlack;
        [bgView addSubview:nameLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X-0.5, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5)];
        lineImageView.backgroundColor = lineImageColor;
        [bgView addSubview:lineImageView];
        
        UITapGestureRecognizer * touchtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SearchEnterpriseView)];
        bgView.userInteractionEnabled = YES;
        [bgView addGestureRecognizer:touchtap];
    }
    return _tableheaderView;
}

@end
