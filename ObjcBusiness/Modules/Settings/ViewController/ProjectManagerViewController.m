//
//  ProjectManagerViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ProjectManagerViewController.h"
#import "CreateProjectViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+textStringToSize.h"
#import "ComfirmEditViewController.h"

@interface ProjectManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property  (nonatomic,strong)UIView *headBGView;
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIImageView *expertFlagImageView;
@property (nonatomic,strong)UIImageView *enterpriseFlagImageView;
@property (nonatomic,strong)UILabel *companyAndJobLabel;
@property (nonatomic,strong)UILabel *introduceLabel;
@property (nonatomic,strong)UIImageView *locationImageView;
@property (nonatomic,strong)UILabel *locationLabel;
@property (nonatomic,strong)UIImageView *tradeImageView;
@property (nonatomic,strong)UILabel *tradeLabel;

@property (nonatomic,strong)UIView *projectBGView;
@property (nonatomic,strong)UIImageView *projectLogoImageView;
@property (nonatomic,strong)UILabel *projectNameLabel;
@property (nonatomic,strong)UILabel *projectIntroduceLabel;
@property (nonatomic,strong)UIImageView *identifyIconImageView;

@property(nonatomic,strong)UIView *detailIntroduceView;
@property(nonatomic,strong)UILabel *detailContentLabel;
@property(nonatomic,strong)UILabel *detailButton;

@property(nonatomic,strong)UITableView *basetableView;

@property(nonatomic,strong)UIView *tableviewheaderview;

@property(nonatomic,strong)UIButton *gotoEditButton;
@end



@implementation ProjectManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目管理";
    [self initSubViews];
    [self loadData];
}
-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] getUserCHomePageDto:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"result---getUserCHomePageDto--->%@",result);
        if (IsSucess(result) == 1) {
            NSDictionary *dictionary = result[@"data"][@"result"];
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dictionary[@"c_photo"]] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
            self.nameLabel.text = dictionary[@"c_realname"];
            NSString *jobStr =  dic[@"c_jobtitle"];
            NSString *c_short_company_name = dictionary[@"c_short_company_name"];
            if (jobStr == nil) {
                jobStr = @"";
            }
            if (c_short_company_name == nil) {
                c_short_company_name = @"";
            }
            self.companyAndJobLabel.text = [NSString stringWithFormat:@"%@ %@",c_short_company_name,jobStr];
            self.introduceLabel.text = dictionary[@"c_profiles"];
            self.locationLabel.text = dictionary[@"cAreaName"];
            
            NSString *locationNameStr =  dictionary[@"cAreaName"];
            CGSize locationStrSize = [NSString sizeWithText:locationNameStr maxSize:CGSizeMake(kScreenWidth - CGRectGetMaxX(self.headImageView.frame) -10*AUTO_SIZE_SCALE_X -20*AUTO_SIZE_SCALE_X-62*AUTO_SIZE_SCALE_X -15*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X) font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
            self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.locationImageView.frame),
                                                                 CGRectGetMaxY(self.introduceLabel.frame) +5*AUTO_SIZE_SCALE_X,
                                                                 locationStrSize.width,
                                                                 locationStrSize.height);
            self.tradeImageView.frame = CGRectMake(CGRectGetMaxX(self.locationLabel.frame)+20*AUTO_SIZE_SCALE_X, self.locationImageView.origin.y, 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
            
            self.tradeLabel.frame = CGRectMake(CGRectGetMaxX(self.tradeImageView.frame), CGRectGetMaxY(self.introduceLabel.frame) +5*AUTO_SIZE_SCALE_X, kScreenWidth- (self.tradeLabel.frame.origin.x)-15*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X);
            self.tradeLabel.text = dictionary[@"project_industry_name"];
            [self loadProjectData];
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            [LZBLoadingView dismissLoadingView];
        }
    }failuer:^(NSError *error){
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)loadProjectData{
    NSDictionary *dic = @{};
    [[RequestManager shareRequestManager] getBossProjectDtoByUserId:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result------>%@",result);
        if (IsSucess(result) == 1) {
            NSDictionary *dtoDictionary = [[result objectForKey:@"data"] objectForKey:@"result"];
            if(![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil){
                [self.projectLogoImageView sd_setImageWithURL:[NSURL URLWithString:dtoDictionary[@"project_cover_pic"]] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
                self.projectNameLabel.text = dtoDictionary[@"project_name"];
                self.projectIntroduceLabel.text = dtoDictionary[@"project_slogan"];
                NSInteger identifyFlag = [dtoDictionary[@"project_status_code"] integerValue];
                // 1、未上线；2、上线待审核；3、上线中；4、已下线；5、已删除；
                if (identifyFlag == 2) {
                    self.gotoEditButton.enabled = NO;
                }else{
                    self.gotoEditButton.enabled = YES;
                }
                //project_authentication：项目认证：项目认证：0、未认证；1、提交认证；2、认证未通过；3、通过认证；
                NSInteger officialFlag = [dtoDictionary[@"project_authentication_code"] integerValue];
                if (officialFlag == 3) {
                    self.identifyIconImageView.hidden = NO;
                }
                self.detailContentLabel.text = dtoDictionary[@"projectDetailsDto"][@"project_content"];
                [self.detailContentLabel sizeToFit];
                self.detailContentLabel.frame = CGRectMake(self.detailContentLabel.frame.origin.x, self.detailContentLabel.frame.origin.y, self.detailContentLabel.frame.size.width, self.detailContentLabel.frame.size.height);
                self.detailIntroduceView.frame = CGRectMake(0, self.detailIntroduceView.frame.origin.y, kScreenWidth, CGRectGetMaxY(self.detailContentLabel.frame)+15*AUTO_SIZE_SCALE_X);
                self.tableviewheaderview.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.detailIntroduceView.frame)+10*AUTO_SIZE_SCALE_X);
                self.tableviewheaderview.hidden = NO;
                self.basetableView.hidden = NO;
                self.gotoEditButton.hidden = NO;
                [self.basetableView setEstimatedSectionHeaderHeight:self.tableviewheaderview.frame.size.height];
                self.basetableView.tableHeaderView = self.tableviewheaderview;
                [self.basetableView reloadData];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        [LZBLoadingView dismissLoadingView];
    } failuer:^(NSError *error) {
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)initSubViews{
    [self.tableviewheaderview addSubview:self.headBGView];
    [self.headBGView addSubview:self.headImageView];
    [self.headBGView addSubview:self.nameLabel];
    [self.headBGView addSubview:self.expertFlagImageView];
    [self.headBGView addSubview:self.enterpriseFlagImageView];
    [self.headBGView addSubview:self.companyAndJobLabel];
    [self.headBGView addSubview:self.introduceLabel];
    [self.headBGView addSubview:self.locationImageView];
    [self.headBGView addSubview:self.locationImageView];
    [self.headBGView addSubview:self.locationLabel];
    [self.headBGView addSubview:self.tradeImageView];
    [self.headBGView addSubview:self.tradeLabel];
    
    [self.tableviewheaderview addSubview:self.projectBGView];
    [self.projectBGView addSubview:self.projectLogoImageView];
    [self.projectBGView addSubview:self.projectNameLabel];
    [self.projectBGView addSubview:self.projectIntroduceLabel];
    [self.projectBGView addSubview:self.identifyIconImageView];
    
    [self.tableviewheaderview addSubview:self.detailIntroduceView];
    [self.detailIntroduceView addSubview:self.detailContentLabel];
    
    [self.view addSubview:self.basetableView];
    [self.view addSubview:self.gotoEditButton];
    self.tableviewheaderview.hidden = YES;
    self.basetableView.hidden = YES;
    self.gotoEditButton.hidden = YES;
}

-(void)ButtonOnclick:(UIButton *)sender{
    ComfirmEditViewController *vc = [[ComfirmEditViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TableView代理
#pragma mark -UITableView dataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//是否显示视图底部导航栏的线
- (BOOL)shouldShowShadowImage{
    return  NO;
}
- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kBossProjectManagerPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kBossProjectManagerPage];
}

-(UIView *)tableviewheaderview{
    if (_tableviewheaderview == nil) {
        _tableviewheaderview = [UIView new];
    }
    return _tableviewheaderview;
}

-(UIView *)headBGView{
    if (_headBGView == nil) {
        _headBGView = [UIView new];
        _headBGView.backgroundColor = [UIColor whiteColor];
        _headBGView.frame = CGRectMake(0, 0, kScreenWidth, 130*AUTO_SIZE_SCALE_X);
    }
    return _headBGView;
}

-(UIImageView *)headImageView{
    if(_headImageView == nil){
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 100/2*AUTO_SIZE_SCALE_X;
        _headImageView.layer.borderWidth= 0;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X);
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:20 TextColor:FontUIColorBlack];
        _nameLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 65*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    }
    return _nameLabel;
}

- (UIImageView *)expertFlagImageView {
    if (_expertFlagImageView == nil) {
        _expertFlagImageView = [UIImageView new];
        _expertFlagImageView.image =[UIImage imageNamed:@"boss_details_icon_enterprise_certification"];
        _expertFlagImageView.hidden = YES;
        _expertFlagImageView.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+8*AUTO_SIZE_SCALE_X, 19*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _expertFlagImageView;
}

- (UIImageView *)enterpriseFlagImageView {
    if (_enterpriseFlagImageView == nil) {
        _enterpriseFlagImageView = [UIImageView new];
        _enterpriseFlagImageView.image =[UIImage imageNamed:@"boss_details_icon_expert_certification"];
        _enterpriseFlagImageView.hidden = YES;
        _enterpriseFlagImageView.frame = CGRectMake(CGRectGetMaxX(_expertFlagImageView.frame)+8*AUTO_SIZE_SCALE_X, 19*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _enterpriseFlagImageView;
}

- (UILabel *)companyAndJobLabel {
    if (_companyAndJobLabel == nil) {
        _companyAndJobLabel = [[UILabel alloc]init];
        _companyAndJobLabel.backgroundColor = [UIColor clearColor];
        _companyAndJobLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _companyAndJobLabel.textAlignment = NSTextAlignmentLeft;
        _companyAndJobLabel.numberOfLines = 0;
        _companyAndJobLabel.textColor = FontUIColorBlack;
        _companyAndJobLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, CGRectGetMaxY(_nameLabel.frame)+4*AUTO_SIZE_SCALE_X, kScreenWidth-125*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _companyAndJobLabel;
}

-(UILabel *)introduceLabel{
    if (_introduceLabel == nil) {
        _introduceLabel = [[UILabel alloc]init];
        _introduceLabel.textColor = FontUIColor757575Gray;
        _introduceLabel.textAlignment = NSTextAlignmentLeft;
        _introduceLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _introduceLabel.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, CGRectGetMaxY(_companyAndJobLabel.frame)+5*AUTO_SIZE_SCALE_X, kScreenWidth-125*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X, 16.5*AUTO_SIZE_SCALE_X);
    }
    return _introduceLabel;
}

-(UIImageView *)locationImageView{
    if (_locationImageView == nil) {
        _locationImageView = [UIImageView new];
        _locationImageView.image = [UIImage imageNamed:@"boss_icon_label_position"];
        _locationImageView.frame = CGRectMake(125*AUTO_SIZE_SCALE_X, CGRectGetMaxY(_introduceLabel.frame)+6.5*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _locationLabel.textColor = FontUIColor757575Gray;
    }
    return _locationLabel;
}

-(UIImageView *)tradeImageView{
    if (_tradeImageView == nil) {
        _tradeImageView = [UIImageView new];
        _tradeImageView.image = [UIImage imageNamed:@"boss_icon_label_industry"];
    }
    return _tradeImageView;
}

- (UILabel *)tradeLabel {
    if (_tradeLabel == nil) {
        _tradeLabel = [[UILabel alloc]init];
        _tradeLabel.backgroundColor = [UIColor clearColor];
        _tradeLabel.textAlignment = NSTextAlignmentLeft;
        _tradeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _tradeLabel.textColor = FontUIColor757575Gray;
    }
    return _tradeLabel;
}

-(UIView *)projectBGView{
    if (_projectBGView == nil) {
        _projectBGView = [UIView new];
        _projectBGView.backgroundColor = [UIColor whiteColor];
        _projectBGView.frame = CGRectMake(0, CGRectGetMaxY(self.headBGView.frame)+10*AUTO_SIZE_SCALE_X, kScreenWidth, 105*AUTO_SIZE_SCALE_X);
    }
    return _projectBGView;
}

-(UIImageView *)projectLogoImageView{
    if(_projectLogoImageView == nil){
        _projectLogoImageView = [UIImageView new];
        _projectLogoImageView.layer.cornerRadius = 75/2*AUTO_SIZE_SCALE_X;
        _projectLogoImageView.layer.borderWidth= 0;
        _projectLogoImageView.layer.masksToBounds = YES;
        _projectLogoImageView.layer.cornerRadius = 4;
        _projectLogoImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X);
    }
    return _projectLogoImageView;
}

- (UILabel *)projectNameLabel {
    if (_projectNameLabel == nil) {
        _projectNameLabel = [[UILabel alloc]init];
        _projectNameLabel.backgroundColor = [UIColor clearColor];
        _projectNameLabel.textAlignment = NSTextAlignmentLeft;
        _projectNameLabel.font = [UIFont systemFontOfSize:17*AUTO_SIZE_SCALE_X];
        _projectNameLabel.textColor = FontUIColorBlack;
        _projectNameLabel.frame = CGRectMake(100*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, kScreenWidth-115*AUTO_SIZE_SCALE_X, 24*AUTO_SIZE_SCALE_X);
    }
    return _projectNameLabel;
}
- (UILabel *)projectIntroduceLabel {
    if (_projectIntroduceLabel == nil) {
        _projectIntroduceLabel = [[UILabel alloc]init];
        _projectIntroduceLabel.backgroundColor = [UIColor clearColor];
        _projectIntroduceLabel.textAlignment = NSTextAlignmentLeft;
        _projectIntroduceLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _projectIntroduceLabel.textColor = FontUIColor757575Gray;
        _projectIntroduceLabel.frame = CGRectMake(100*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.projectNameLabel.frame)+3*AUTO_SIZE_SCALE_X, kScreenWidth - 115*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    }
    return _projectIntroduceLabel;
}

-(UIImageView *)identifyIconImageView{
    if (_identifyIconImageView == nil) {
        _identifyIconImageView = [UIImageView new];
        _identifyIconImageView.image = [UIImage imageNamed:@"boss_icon_official_certification"];
        _identifyIconImageView.hidden = YES;
        _identifyIconImageView.frame = CGRectMake(100*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.projectNameLabel.frame)+5*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    }
    return _identifyIconImageView;
}

-(UIView *)detailIntroduceView{
    if (_detailIntroduceView == nil) {
        _detailIntroduceView = [UIView new];
        _detailIntroduceView.backgroundColor = [UIColor whiteColor];
        UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 18*AUTO_SIZE_SCALE_X, 4*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X)];
        redview.backgroundColor = RedUIColorC1;
        [_detailIntroduceView addSubview:redview];
        
        UILabel *detailLabel = [CommentMethod initLabelWithText:@"项目详情" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
        detailLabel.frame = CGRectMake(27*AUTO_SIZE_SCALE_X, 11.5*AUTO_SIZE_SCALE_X, kScreenWidth-27*AUTO_SIZE_SCALE_X, 21*AUTO_SIZE_SCALE_X);
        [_detailIntroduceView addSubview:detailLabel];
        [_detailIntroduceView addSubview:self.detailContentLabel];
        
        
        
        _detailIntroduceView.frame = CGRectMake(0, CGRectGetMaxY(self.projectBGView.frame)+10*AUTO_SIZE_SCALE_X, kScreenWidth, 149*AUTO_SIZE_SCALE_X);
    }
    return _detailIntroduceView;
}

-(UILabel *)detailContentLabel{
    if (_detailContentLabel == nil) {
        _detailContentLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
        _detailContentLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0);
        _detailContentLabel.numberOfLines = 0;
    }
    return _detailContentLabel;
}

-(UITableView *)basetableView{
    if (_basetableView == nil) {
        _basetableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight,kScreenWidth, kScreenHeight-kNavHeight-kTabHeight) style:UITableViewStylePlain];
        _basetableView.backgroundColor = [UIColor clearColor];
        _basetableView.delegate = self;
        _basetableView.dataSource = self;
        _basetableView.showsVerticalScrollIndicator = NO;
        _basetableView.bounces = NO;
        _basetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_basetableView];
    }
    return _basetableView;
}

-(UIButton *)gotoEditButton{
    if (_gotoEditButton == nil) {
        _gotoEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoEditButton.frame = CGRectMake(0, kScreenHeight-kTabHeight, kScreenWidth,49*AUTO_SIZE_SCALE_X);
        [_gotoEditButton setTitle:@"项目审核" forState:UIControlStateNormal];
        [_gotoEditButton setBackgroundImage:[CommentMethod createImageWithColor:RedUIColorC1] forState:UIControlStateNormal];
        [_gotoEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gotoEditButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        
        [_gotoEditButton setTitle:@"该项目审核中，无法操作" forState:UIControlStateDisabled];
        [_gotoEditButton setBackgroundImage:[CommentMethod createImageWithColor:RedUIColorC1] forState:UIControlStateDisabled];
        [_gotoEditButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        [_gotoEditButton addTarget:self action:@selector(ButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoEditButton;
}
@end
