//
//  LeaveMessageViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/22.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "LeaveMessageViewController.h"
#import "BaseTableView.h"
#import "EnterpriseItem.h"
#import "EnterpriseInfoCell.h"
#import "EnterpriseTextViewIntroduceCell.h"
#import "EnterpriseUploadPictureCell.h"
#import "EnterpriseTextFieldSendMessageCell.h"
#import "UITextView+ZWPlaceHolder.h"
#import <objc/runtime.h>
#import "SubmitSuccessViewController.h"

@interface LeaveMessageViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *contactName;
    NSString *phoneStr;
    NSString *_message_content;
    
}
@property (nonatomic,strong)UIView *headerView,*footerView;
@property (nonatomic,strong)UIView *headerbgView,*footerbgView;
@property (nonatomic,strong)UILabel *headerLabel,*remarkLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UILabel *headerDesLabel;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)BaseTableView *baseTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITextView *remarksTextView;
@end

@implementation LeaveMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contactName=phoneStr=_message_content=@"";
    [self initNavgation];
    [self initSubViews];
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

- (void)initSubViews {
    self.title = @"项目留言";
    [self.view addSubview:self.baseTableView];
    
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
    _message_content =_remarksTextView.text;
    if (contactName.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写联系人姓名" viewController:self];
        return;
    }
    if (contactName.length >6) {
        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，长度不能超过不超过6个汉字请您重新输入" viewController:self];
        return;
    }
    if (phoneStr.length ==0) {
        [[RequestManager shareRequestManager] tipAlert:@"您的手机号不能为空" viewController:self];
        return;
    }
    if (phoneStr.length <11) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写正确的手机号" viewController:self];
        return;
    }
    if (_message_content.length >150) {
        [[RequestManager shareRequestManager] tipAlert:@"备注内容不得超过150字" viewController:self];
        return;
    }
    NSDictionary *dic = @{
                          @"project_id":[NSString stringWithFormat:@"%ld",self.project_id],
                          @"message_user_name":contactName,
                          @"message_user_tel":phoneStr,
                          @"_message_content":_message_content,
                          };
//    NSLog(@"dic------->%@",dic);
    [[RequestManager shareRequestManager] createProjectMessage:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result---------------->%@",result);
        if (IsSucess(result) == 1) {
            [[RequestManager shareRequestManager] tipAlert:@"保存成功" viewController:self];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
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

-(void)returnListPage{
    SubmitSuccessViewController *vc = [[SubmitSuccessViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textFieldWithText:(UITextField *)textField{
    if (textField.tag == 0) {
        contactName = textField.text;
    }else{
        NSString * temp = textField.text;
        if (textField.markedTextRange ==nil){
            while(1){
                if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 11) {
                    break;
                }else{
                    temp = [temp substringToIndex:temp.length-1];
                }
            }
            phoneStr = textField.text=temp;
        }
        
    }
    
}

-(void)CancelOnClick{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancel)object:nil];
    [self performSelector:@selector(cancel) withObject:nil afterDelay:0.2f];
   
}

- (void)cancel{
    self.headerView.hidden = YES;
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    [self.baseTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return YES;
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EnterpriseItem *item = [self.dataArray objectAtIndex:indexPath.row];
    Class cls = [self cellClassAtIndexPath:indexPath];
    return [cls tableView:tableView rowHeightForObject:item];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10*AUTO_SIZE_SCALE_X;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = BGColorGray
    ;
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EnterpriseItem *item = [self.dataArray objectAtIndex:indexPath.row];
    EnterpriseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self cellClassAtIndexPath:indexPath])];
    if (cell ==nil) {
        Class cls = [self cellClassAtIndexPath:indexPath];
        cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self cellClassAtIndexPath:indexPath])];
    }
    ((EnterpriseInfoCell *)cell).ValueLabel.tag = indexPath.row;
     [((EnterpriseInfoCell *)cell).ValueLabel addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    cell.backgroundColor = [UIColor whiteColor];
    [cell setResumeTableItem:item];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath{
    EnterpriseItem *item = [self.dataArray objectAtIndex:indexPath.row];
    switch (item.showtype) {
        case EnterpriseLabel:{
            return [EnterpriseInfoCell class];
        }
            break;
        case EnterpriseTextViewIntroduce:{
            return [EnterpriseTextViewIntroduceCell class];
        }
            break;
        case EnterpriseTextFieldSendMessage:{
            return [EnterpriseTextFieldSendMessageCell  class];
        }
            break;
        case EnterpriseUploadPicture:{
            return [EnterpriseUploadPictureCell class];
        }
            break;
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kLeaveMessagePage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:kLeaveMessagePage];
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil ) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:
                          CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - (kNavHeight))];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.tag = 100001;
        _baseTableView.bounces = NO;
        [_baseTableView setTableHeaderView:self.headerView];
        [_baseTableView setTableFooterView:self.footerView];
    }
    return _baseTableView;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        EnterpriseItem *item0 = [EnterpriseItem new];
        item0.name =@"联系姓名";
        
        item0.placeholder = @"请输入您的姓名";
        item0.UserInteractive = YES;
        item0.functionValue = contactName;
        item0.showtype =  EnterpriseLabel;
        
        EnterpriseItem *item1 = [EnterpriseItem new];
        item1.name =@"联系方式";
        item1.placeholder = @"请输入手机号";
        item1.UserInteractive = YES;
        item1.issetNumberKeyboard = YES;
        item1.showtype =  EnterpriseLabel;
        item1.isHiddenLine = YES;
        [_dataArray addObject:item0];
        [_dataArray addObject:item1];
    }
    return _dataArray;
}

-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [UIView new];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 124*AUTO_SIZE_SCALE_X);
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:self.headerbgView];
        
    }
    return _headerView;
}


-(UIView *)headerbgView{
    if (_headerbgView == nil) {
        _headerbgView = [UIView new];
        _headerbgView.frame = CGRectMake(0, 0, kScreenWidth, 114*AUTO_SIZE_SCALE_X);
        _headerbgView.backgroundColor = [UIColor whiteColor];
        [_headerbgView addSubview:self.headerLabel];
        [_headerbgView addSubview:self.headerDesLabel];
        [_headerbgView addSubview:self.cancelButton];
    }
    return _headerbgView;
}

-(UILabel *)headerLabel{
    if (_headerLabel == nil) {
        _headerLabel = [CommentMethod initLabelWithText:@"隐私安全保障" textAlignment:NSTextAlignmentCenter font:14 TextColor:FontUIColorBlack];

        
        _headerLabel.frame = CGRectMake((kScreenWidth-100*AUTO_SIZE_SCALE_X)/2, 25*AUTO_SIZE_SCALE_X, 100*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
        
    }
    return _headerLabel;
}

-(UILabel *)headerDesLabel{
    if (_headerDesLabel == nil) {
        _headerDesLabel = [CommentMethod initLabelWithText:@"渠天下生意平台保证您个人信息的隐私安全，不会泄露给任何您未主动留言的项目。" textAlignment:NSTextAlignmentCenter font:14 TextColor:FontUIColorGray];
        _headerDesLabel.numberOfLines = 2;
//        [CommentMethod createLabelWithText:@"渠天下生意平台保证您个人信息的隐私安全，不会泄露给任何您未主动留言的项目。" TextColor:FontUIColorGray  BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter Font:14];
        _headerDesLabel.frame = CGRectMake(40*AUTO_SIZE_SCALE_X, 49*AUTO_SIZE_SCALE_X, kScreenWidth-80*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X);
        
    }
    return _headerDesLabel;
}


-(UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"prompt_btn_close"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"prompt_btn_close"] forState:UIControlStateDisabled];
        [_cancelButton addTarget:self action:@selector(CancelOnClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(345*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X);
        
    }
    return _cancelButton;
}


-(UIView *)footerView{
    if (_footerView == nil) {
        _footerView = [UIView new];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 184.5*AUTO_SIZE_SCALE_X);
        _footerView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:self.footerbgView];

    }
    return _footerView;
}


-(UIView *)footerbgView{
    if (_footerbgView == nil) {
        _footerbgView = [UIView new];
        _footerbgView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X, kScreenWidth, 174.5*AUTO_SIZE_SCALE_X);
        _footerbgView.backgroundColor = [UIColor whiteColor];
        [_footerbgView addSubview:self.remarkLabel];
        [_footerbgView addSubview:self.remarksTextView];
        [_footerbgView addSubview:self.lineImageView];
    }
    return _footerbgView;
}

-(UILabel *)remarkLabel{
    if (_remarkLabel == nil) {
        _remarkLabel = [CommentMethod createLabelWithText:@"备注（选填）" TextColor:FontUIColorBlack  BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:14];
        _remarkLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
    }
    return _remarkLabel;
}


-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
        _lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 51*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    }
    return _lineImageView;
}

-(UITextView *)remarksTextView{
    if (_remarksTextView == nil) {
        _remarksTextView = [[UITextView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 124*AUTO_SIZE_SCALE_X)];
        _remarksTextView.layer.borderWidth = 0;
        _remarksTextView.font = [UIFont systemFontOfSize:14];
        _remarksTextView.layer.borderColor = [UIColor clearColor].CGColor;
        _remarksTextView.zw_placeHolder = @"例：我在北京市朝阳区建外大街19号有家经营酒类的临街店铺，每天客流量大约在150人左右，每日流水至少15000元";
        _remarksTextView.zw_placeHolderColor = FontUIColor999999Gray;
        _remarksTextView.textColor = FontUIColorBlack;
        _remarksTextView.tintColor = RedUIColorC1;
        
    }
    return _remarksTextView;
}
@end
