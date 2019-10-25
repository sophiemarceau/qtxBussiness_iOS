//
//  SearchEnterpriseViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SearchEnterpriseViewController.h"
#import "BaseTableView.h"
#import "SearchEnterpriseCell.h"
#import "SearchEnterpriseCell+SearchEnterpriseModel.h"
#import "EnterpriseInfoViewController.h"

@interface SearchEnterpriseViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
}
@property(nonatomic,strong)UIView *searchEnterpriseView;
@property(nonatomic,strong)UITextField *searchEnterpriseTextField;
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)UIView *HeaderTableView;
@property(nonatomic,strong)UIImageView *lineImageView;
@property(nonatomic,strong)NSString *companyNameStr;
@property(nonatomic,strong)NSString *selectcompanyNameStr;
@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong)NSMutableArray *enterpriseNameListArray;


@property(nonatomic,strong)NSIndexPath *lastPath;
@end

@implementation SearchEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.companyNameStr = self.companyId = self.selectcompanyNameStr = @"";
    self.title = @"确定企业名称";
    self.automaticallyAdjustsScrollViewInsets=NO;//scrollview预留空位
    [self initNavgation];
    [self initSubViews];
}

#pragma mark TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.enterpriseNameListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*AUTO_SIZE_SCALE_X;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger oldRow = [self.lastPath row];
    static NSString * identifier = @"SearchEnterpriseCell";
    SearchEnterpriseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [(SearchEnterpriseCell *)[SearchEnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor =[UIColor whiteColor];
    if ([self.enterpriseNameListArray count] > 0) {
        [cell configureWithListEntity:[self.enterpriseNameListArray objectAtIndex:indexPath.row] WithSelectKeyName:self.companyNameStr];
    }
    if (row == oldRow && self.lastPath!=nil) {
        cell.selectImageVIew.hidden = NO;
    }else{
        cell.selectImageVIew.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger newRow = [indexPath row];
    
    NSInteger oldRow = (self.lastPath !=nil)?[self.lastPath row]:-1;
    if (newRow != oldRow) {
        SearchEnterpriseCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.selectImageVIew.hidden = NO;
        self.selectcompanyNameStr = newCell.nameLabel.text;
        self.companyId = [NSString stringWithFormat:@"%ld",[[self.enterpriseNameListArray[indexPath.row] objectForKey:@"company_id"] integerValue]];
        
        SearchEnterpriseCell *oldCell = [tableView cellForRowAtIndexPath:self.lastPath];
        oldCell.selectImageVIew.hidden = YES;
        self.lastPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldWithText:(UITextField *)textField{
    self.companyNameStr = textField.text;
    self.selectcompanyNameStr = self.companyId = @"";
    self.lastPath = nil;
    
    if(self.companyNameStr.length > 0){
        [self.enterpriseNameListArray removeAllObjects];
        [self.baseTableView reloadData];
        NSDictionary *dic = @{@"company_name":self.companyNameStr};
        [[RequestManager shareRequestManager] searchCompanySimpleDtosByCompanyName:dic viewController:self successData:^(NSDictionary *result) {
            if(IsSucess(result) == 1){
                NSArray *listArray = [[result objectForKey:@"data"] objectForKey:@"result"];
                if(![listArray isEqual:[NSNull null]] && listArray !=nil){
                    if (listArray.count > 0) {
                        [self.enterpriseNameListArray addObjectsFromArray:listArray];
                        self.baseTableView.hidden = NO;
                        [_baseTableView setTableHeaderView:self.HeaderTableView];
                        [self.baseTableView reloadData];
                    }
                }else{
                    self.baseTableView.hidden = YES;
                }
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)saveButton{
    //防止按钮快速点击造成多次响应的避免方法
    //    [[selfclass] cancelPreviousPerformRequestsWithTarget:selfselector:@selector(todoSomething:)object:sender];
    //
    //    [self performSelector:@selector(todoSomething:)withObject:sender afterDelay:0.2f];
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(save)object:nil];
    [self performSelector:@selector(save) withObject:nil afterDelay:0.2f];
}

- (void)save{
    [self.view endEditing:YES];
    self.companyNameStr = self.searchEnterpriseTextField.text;
    if (self.companyNameStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"企业名称不能为空" viewController:self];
        return;
    }else{
        if (self.selectcompanyNameStr.length != 0) {
                self.companyNameStr = self.selectcompanyNameStr;
        }else{
            for (NSDictionary *companyDic in self.enterpriseNameListArray) {
                if ([self.companyNameStr isEqualToString:companyDic[@"company_name"]]) {
                    [[RequestManager shareRequestManager] tipAlert:@"该企业已经注册，请修改名称或选择已有企业" viewController:self];
                    return;
                    break;
                }
            }
        }
    }
    NSDictionary *dic = @{@"company_name":self.companyNameStr};
    [[RequestManager shareRequestManager] getCompanyStatusByName:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"----------->%@",result);
        int flag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
        if (flag == 1) {
            [[RequestManager shareRequestManager] tipAlert:@"该企业信息正在审核中，平台工作人员将在一天内完成审核，您可以明天再进行此操作" viewController:self];
        }else{
            EnterpriseInfoViewController *vc = [[EnterpriseInfoViewController alloc] init];
            vc.companyId = self.companyId;
            vc.companyNameStr = self.companyNameStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failuer:^(NSError *error) {
        
    }];
}

- (void)initSubViews{
    [self.view addSubview:self.searchEnterpriseView];
    [self.searchEnterpriseView addSubview:self.searchEnterpriseTextField];
    [self.view addSubview:self.baseTableView];
}

- (void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    rightBackItem.tintColor = RedUIColorC1;
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil ) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:
                          CGRectMake(0, self.searchEnterpriseView.frame.origin.y+self.searchEnterpriseView.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight - (self.searchEnterpriseTextField.frame.origin.y+self.searchEnterpriseTextField.frame.size.height+10*AUTO_SIZE_SCALE_X))];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.tag = 100001;
        _baseTableView.bounces = NO;
    }
    return _baseTableView;
}

-(UITextField *)searchEnterpriseTextField{
    if (_searchEnterpriseTextField == nil ) {
        _searchEnterpriseTextField = [CommentMethod createTextFieldWithPlaceholder:@"请输入您所在的企业名称" TextColor:FontUIColor999999Gray Font:14*AUTO_SIZE_SCALE_X KeyboardType:UIKeyboardTypeDefault];
        _searchEnterpriseTextField.textAlignment = NSTextAlignmentLeft;
        _searchEnterpriseTextField.userInteractionEnabled =  YES;
        _searchEnterpriseTextField.backgroundColor = [UIColor whiteColor];
        _searchEnterpriseTextField.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,0,kScreenWidth-30*AUTO_SIZE_SCALE_X,50*AUTO_SIZE_SCALE_X);
        [_searchEnterpriseTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _searchEnterpriseTextField;
}

- (UIView *)HeaderTableView{
    if (_HeaderTableView == nil) {
        _HeaderTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44*AUTO_SIZE_SCALE_X)];
        UILabel *titleLabel = [CommentMethod createLabelWithText:@"选择已注册企业名称" TextColor:FontUIColor999999Gray BgColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentLeft Font:12];
        titleLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth-30*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
        [_HeaderTableView addSubview:titleLabel];
        _HeaderTableView.backgroundColor = [UIColor whiteColor];
        [_HeaderTableView addSubview:self.lineImageView];
        self.lineImageView.frame = CGRectMake(0, 44*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5*AUTO_SIZE_SCALE_X);
        
    }
    return _HeaderTableView;
}


- (UIView *)searchEnterpriseView{
    if (_searchEnterpriseView == nil) {
        _searchEnterpriseView = [UIView new];
        _searchEnterpriseView.backgroundColor = [UIColor whiteColor];
        _searchEnterpriseView.frame = CGRectMake(0, kNavHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
    }
    return _searchEnterpriseView;
}

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
        
    }
    return _lineImageView;
}

-(NSMutableArray *)enterpriseNameListArray{
    if (_enterpriseNameListArray == nil) {
        _enterpriseNameListArray = [NSMutableArray array];
    }
    return _enterpriseNameListArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kSearchEnterpriseViewPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kSearchEnterpriseViewPage];
}

@end
