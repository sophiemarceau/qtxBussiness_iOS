//
//  PerfectPersonalInfoViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//
#import "PerfectPersonalInfoViewController.h"
#import "BaseViewController.h"
#import "CDZBaseCell.h"
#import "PersonalViewController.h"
#import "TextWthInputFieldCell.h"
#import "TextWithMarginCell.h"
#import "TextWithLineCell.h"
#import "ResumeTableItem.h"
#import "BottomButtonView.h"
#import "MOFSPickerManager.h"
#import "UITextView+ZWPlaceHolder.h"
#import "TextPlaceCell.h"
#import "EditBusinessIntentViewController.h"
#import "EditBusinessExpViewController.h"
#import "AddBusinessPlaceViewController.h"
#import "BaseTableView.h"
#import "UIImageView+WebCache.h"
#import "ResumePersonalInfoCell.h"
#import "DistrictManager.h"
#import "DetailTextViewTableViewCell.h"
#import "CreateProjectHeaderView.h"
#import "LabelTableViewCell.h"
#import "TextFieldBaseCell.h"
@interface PerfectPersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *dtoDictionary;
    
    NSString* phoneindex;//联系方式
    NSString *intention_amountIndex;//投资金额
    NSString  *tradeStr;//行业
    NSString *intention_noteStr;//备注说明
    NSString* districtindex;//您的位置
    NSString* businessPlaceIndex;//是否有经营场所
    NSString* intention_industry;//意向行业code

    MOFSPickerManager *mofPickerManager;
    
//    NSIndexPath *selectindexPath;
}
@property (nonatomic,strong)BaseTableView *HeaderTableView;
@property (nonatomic,strong)BaseTableView *Tableview;
@property (nonatomic,strong)BottomButtonView *bottonButtonView;
@property (nonatomic,strong)UIView *inforFooterView;
@property (nonatomic,strong)NSMutableArray *resumeMutableArray;
@property (nonatomic,strong)NSMutableArray *placesMutableArray,*placeOfBusinessMutableArray;
@property (nonatomic,strong)NSMutableArray *opennessMutableArray;
@property (nonatomic,strong)NSMutableArray *intentionAmountMutableArray;
@property (nonatomic,strong)NSMutableArray *majortradeMutableArray;
@property (nonatomic,strong)NSMutableArray *tradeMutableArray;
@property (nonatomic,strong)UILabel *remarkLabel;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UITextView * remarksTextView;
@property (nonatomic,strong)UIView *remarksbgView;
@property (nonatomic,strong)noWifiView *failView;
@end

@implementation PerfectPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mofPickerManager = [[MOFSPickerManager alloc] init];
    intention_amountIndex = phoneindex = districtindex = businessPlaceIndex = @"";
    self.title = @"完善个人信息";
    self.automaticallyAdjustsScrollViewInsets=NO;//scrollview预留空位
    [self initNavgation];
    [self initSubViews];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHeadView:) name:NOTIFICATION_UpdatePersonalInfo object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshHeadView:(NSNotification *)notification{
    ResumeTableItem *itemA = self.resumeMutableArray[0];
    itemA.showtype = ResumePersonalInfo;
    itemA.name = [DEFAULTS objectForKey:@"userNickName"];
    itemA.functionValue = [DEFAULTS objectForKey:@"userPortraitUri"];
    itemA.c_profiles = [DEFAULTS objectForKey:@"c_profiles"];
    [self.Tableview reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0  inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}
-(void)loadData{
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    [self.resumeMutableArray removeAllObjects];
    [[RequestManager shareRequestManager] getSimpleBusinessResumeDto:nil viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"getSimpleBusinessResumeDto----->%@",result);
        if (IsSucess(result) == 1) {
            dtoDictionary = [[result objectForKey:@"data"] objectForKey:@"dto"];
            
            if(![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil){
                
                ResumeTableItem *itemA = [ResumeTableItem new];
                itemA.showtype = ResumePersonalInfo;
                itemA.name = [DEFAULTS objectForKey:@"userNickName"];
                itemA.functionValue = [DEFAULTS objectForKey:@"userPortraitUri"];
                itemA.c_profiles = [DEFAULTS objectForKey:@"c_profiles"];
                
                
                ResumeTableItem *itemB = [ResumeTableItem new];
                itemB.showtype = ResumInput;
                itemB.name = @"联系方式（选填）";
                itemB.isShowLineImageFlag = NO;//不隐藏.
                itemB.functionValue =  [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_tel"]];
                phoneindex =  [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_tel"]];
                
                ResumeTableItem *itemC = [ResumeTableItem new];
                itemC.showtype = ResumSelectText;
                itemC.name = @"主营行业";
                itemC.isShowLineImageFlag = NO;//不隐藏
                tradeStr = [NSString stringWithFormat:@"%@",dtoDictionary[@"experience_industry"]];
                NSString *experience_industry_name = [NSString stringWithFormat:@"%@",dtoDictionary[@"experience_industry_name"]];
                
                itemC.functionValue = experience_industry_name;
                if ([experience_industry_name isEqualToString:@"(null)"]) {
                    itemC.functionValue = @"请选择您主要从事的行业";
                    experience_industry_name =@"";
                    tradeStr = @"";
                }

                
                ResumeTableItem *itemD = [ResumeTableItem new];
                itemD.showtype = ResumSelectText;
                itemD.name = @"您的位置";
                itemD.isShowLineImageFlag = NO;//隐藏
                districtindex = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_area"]];
                NSString *areaString = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_area_name"]];
                itemD.functionValue = areaString;
                if ([areaString isEqualToString:@""]) {
                    itemD.functionValue = @"请选择所在地区";
                }
                
                ResumeTableItem *itemE = [ResumeTableItem new];
                itemE.showtype = ResumSelectText;
                itemE.name = @"场所信息";
                itemE.isShowLineImageFlag = YES;
                businessPlaceIndex = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_is_place_code"]];
                if ([businessPlaceIndex isEqualToString:@"0"]) {
                    itemE.functionValue =  @"是否有经营场所";
                }else{
                    if ([businessPlaceIndex isEqualToString:@"1"]) {
                        itemE.functionValue =  @"无经营场所";
                    }else{
                        itemE.functionValue = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_is_place_name"]];
                    }
                }
                
                ResumeTableItem *itemF  = [ResumeTableItem new];
                itemF.showtype = ResumSelectWithMargin;
                itemF.name = @"意向行业";
                intention_industry = [NSString stringWithFormat:@"%@",dtoDictionary[@"intention_industry"]];
                NSString *intention_industry_name = [NSString stringWithFormat:@"%@",dtoDictionary[@"intention_industry_name"]];
                itemF.functionValue = intention_industry_name;
                if ([intention_industry_name isEqualToString:@"(null)"]) {
                    itemF.functionValue = @"请选择您意向的主要行业";
                    intention_industry =@"";
                }
                if ([intention_industry isEqualToString:@"999999"]) {
                    itemF.functionValue = @"不限行业";
                }
                
                ResumeTableItem *itemG  = [ResumeTableItem new];
                itemG.showtype = ResumSelectText;
                itemG.name = @"投入金额";
                itemG.isShowLineImageFlag = YES;
                itemG.functionValue = @"请选择投入金额";
                intention_amountIndex = [NSString stringWithFormat:@"%@",dtoDictionary[@"intention_amount_code"]];
                NSString *intention_amountIndex_Str = [NSString stringWithFormat:@"%@",dtoDictionary[@"intention_amount_name"]];
                itemG.functionValue = intention_amountIndex_Str;
                if ([intention_amountIndex_Str isEqualToString:@"(null)"]) {
                    itemG.functionValue = @"请选择投入金额";
                    intention_amountIndex =@"";
                }
                
                [self.resumeMutableArray addObject:itemA];
                [self.resumeMutableArray addObject:itemB];
                [self.resumeMutableArray addObject:itemC];
                [self.resumeMutableArray addObject:itemD];
                [self.resumeMutableArray addObject:itemE];
                [self.resumeMutableArray addObject:itemF];
                [self.resumeMutableArray addObject:itemG];
                [self.Tableview reloadData];
                self.remarksTextView.text = intention_noteStr = [NSString stringWithFormat:@"%@",dtoDictionary[@"intention_note"]];
                [self.remarksTextView updatePlaceHolder];
            }else{
                ResumeTableItem *itemA = [ResumeTableItem new];
                itemA.showtype = ResumePersonalInfo;
                itemA.name = [DEFAULTS objectForKey:@"userNickName"];
                itemA.functionValue = [DEFAULTS objectForKey:@"userPortraitUri"];
                itemA.c_profiles = [DEFAULTS objectForKey:@"c_profiles"];
                
                ResumeTableItem *itemB = [ResumeTableItem new];
                itemB.showtype = ResumInput;
                itemB.name = @"联系方式（可选）";
                itemB.isShowLineImageFlag = NO;//不隐藏.
                
                ResumeTableItem *itemC = [ResumeTableItem new];
                itemC.showtype = ResumSelectText;
                itemC.name = @"主营行业";
                itemC.isShowLineImageFlag = NO;//不隐藏
                itemC.functionValue = @"请选择您主要从事的行业";
                
                
                ResumeTableItem *itemD = [ResumeTableItem new];
                itemD.showtype = ResumSelectText;
                itemD.name = @"您的位置";
                itemD.isShowLineImageFlag = NO;//隐藏
                itemD.functionValue = @"请选择所在地区";
                
                
                ResumeTableItem *itemE = [ResumeTableItem new];
                itemE.showtype = ResumSelectText;
                itemE.name = @"场所信息";
                itemE.isShowLineImageFlag = YES;
                itemE.functionValue =  @"是否有经营场所";
                
                
                ResumeTableItem *itemF  = [ResumeTableItem new];
                itemF.showtype = ResumSelectWithMargin;
                itemF.name = @"意向行业";
                itemF.functionValue = @"请选择您意向的主要行业";
                
                
                ResumeTableItem *itemG  = [ResumeTableItem new];
                itemG.showtype = ResumSelectText;
                itemG.name = @"投入金额";
                itemG.isShowLineImageFlag = YES;
                itemG.functionValue = @"请选择投入金额";
               
                
                [self.resumeMutableArray addObject:itemA];
                [self.resumeMutableArray addObject:itemB];
                [self.resumeMutableArray addObject:itemC];
                [self.resumeMutableArray addObject:itemD];
                [self.resumeMutableArray addObject:itemE];
                [self.resumeMutableArray addObject:itemF];
                [self.resumeMutableArray addObject:itemG];
                [self.Tableview reloadData];
                self.remarksTextView.text = intention_noteStr = @"";
                [self.remarksTextView updatePlaceHolder];
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
        
        self.failView.hidden = NO;
        
        [LZBLoadingView dismissLoadingView];
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

- (void)savePost:(UIButton *)button{
    //防止按钮快速点击造成多次响应的避免方法
    //    [[selfclass] cancelPreviousPerformRequestsWithTarget:selfselector:@selector(todoSomething:)object:sender];
    //
    //    [self performSelector:@selector(todoSomething:)withObject:sender afterDelay:0.2f];
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(save:)object:button];
    [self performSelector:@selector(save:) withObject:button afterDelay:0.2f];
}

-(BOOL)isPhoneNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

- (void)save:(UIButton *)button{
    button.enabled = NO;
    self.Tableview.userInteractionEnabled = NO;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    intention_noteStr = self.remarksTextView.text;
    
    if (phoneindex.length > 0) {
        if (![self isPhoneNumber:phoneindex]) {
            [[RequestManager shareRequestManager] tipAlert:@"手机号输入有误" viewController:self];
            self.Tableview.userInteractionEnabled = YES;
            button.enabled = YES;
            return;
        }
    }
    
    
    if (tradeStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您主要从事的行业" viewController:self];
        self.Tableview.userInteractionEnabled = YES;
        button.enabled = YES;
        return;
    }
    if (districtindex.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您所在的地区" viewController:self];
        button.enabled = YES;
        self.Tableview.userInteractionEnabled = YES;
        return;
    }
    if ([districtindex isEqualToString:@"999999"] ||[districtindex isEqualToString:@"000000"]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您所在的地区" viewController:self];
        button.enabled = YES;
        self.Tableview.userInteractionEnabled = YES;
        return;
    }
    if ([businessPlaceIndex isEqualToString:@""]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您是否有经营场所" viewController:self];
        button.enabled = YES;
        self.Tableview.userInteractionEnabled = YES;
        return;
    }
    if (intention_industry.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择你的意向行业" viewController:self];
        button.enabled = YES;
        self.Tableview.userInteractionEnabled = YES;
        return;
    }
    if (intention_amountIndex.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择你想投入金额" viewController:self];
        button.enabled = YES;
        self.Tableview.userInteractionEnabled = YES;
        return;
    }
    
    if (intention_noteStr.length > 150) {
        [[RequestManager shareRequestManager] tipAlert:@"备注内容不得超过150字" viewController:self];
        button.enabled = YES;
        self.Tableview.userInteractionEnabled = YES;
        return;
    }
    NSDictionary *dic = @{
                          @"_resume_tel":phoneindex,
                          @"intention_amount":intention_amountIndex,
                          @"intention_industry":intention_industry,
                          @"_intention_note":intention_noteStr,
                          @"resume_area":districtindex,
                          @"resume_is_place":businessPlaceIndex,
                          @"experience_industry":tradeStr,
                          };
//    NSLog(@"dic----->%@",dic);
    [[RequestManager shareRequestManager] saveSimpleBusinessResume:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"saveBusinessResume----->%@",result);
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
        button.enabled = YES;
    } failuer:^(NSError *error) {
        button.enabled = YES;
        self.Tableview.userInteractionEnabled = YES;
    }];
}

-(void)returnListPage{
    [self.navigationController popViewControllerAnimated:YES];
     self.Tableview.userInteractionEnabled = YES;
}

#pragma mark TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resumeMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeTableItem *item ;
    item = self.resumeMutableArray[indexPath.row];
    Class cls = [self cellClassAtIndexPath:item];
    return [cls tableView:tableView rowHeightForObject:self.resumeMutableArray[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeTableItem *item ;
    item = self.resumeMutableArray[indexPath.row];
    CDZBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
    if (!cell) {
        Class cls = [self cellClassAtIndexPath:item];
        cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
    }
    cell.backgroundColor = BGColorGray;
    [cell setResumeTableItem:self.resumeMutableArray[indexPath.row]];
    ResumeTableItem *itemtemp = self.resumeMutableArray[indexPath.row];
    if ([item.name isEqualToString:@"联系方式（可选）"]) {
        [((TextWthInputFieldCell *)cell).phoneTextField setText:itemtemp.functionValue];
        [((TextWthInputFieldCell *)cell).phoneTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    }
    return cell;
}

- (void)textFieldWithText:(UITextField *)textField{
    NSString * temp = textField.text;
    if (textField.markedTextRange ==nil){
        while(1){
            if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 11) {
                break;
            }else{
                temp = [temp substringToIndex:temp.length-1];
            }
        }
        phoneindex = textField.text=temp;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeTableItem *item = self.resumeMutableArray[indexPath.row];
//    selectindexPath = indexPath;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (indexPath.row == 0) {
        PersonalViewController *vc = [[PersonalViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([item.name isEqualToString:@"您的位置"]) {
        [mofPickerManager showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *addressStr, NSString *zipcode) {
            NSString *address;
            NSArray *addresstemparray  = [addressStr componentsSeparatedByString:@"-"];
            if (addresstemparray.count>0) {
                if (addresstemparray.count == 3) {
                    if ([addresstemparray[addresstemparray.count-1] isEqualToString: addresstemparray[addresstemparray.count-2]]) {
                        address = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[addresstemparray.count-2]];
                    }else{
                        address = [NSString stringWithFormat:@"%@ %@ %@",addresstemparray[0],addresstemparray[1],addresstemparray[2]];
                    }
                }else if(addresstemparray.count == 2){
                    if ([addresstemparray[0] isEqualToString: addresstemparray[1]]) {
                        address = [NSString stringWithFormat:@"%@",addresstemparray[0]];
                    }else{
                        address = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[1]];
                    }
                    
                }
            }
            //        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
            CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((TextWithMarginCell *)cell).ValueLabel setText:address];
            NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
            districtindex =temparray[temparray.count-1];
        } cancelBlock:^{ 
        }];
    }
    
    if ([item.name isEqualToString:@"场所信息"]) {
        NSMutableArray *placeList = [NSMutableArray new];
        for (NSDictionary *temp in self.placeOfBusinessMutableArray) {
            [placeList addObject:[temp objectForKey:@"name"]];
        }
        [mofPickerManager showPickerViewWithDataArray:placeList tag:2000 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            
            for (NSDictionary *temp in self.placeOfBusinessMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    businessPlaceIndex = [temp objectForKey:@"code"] ;
                    break;
                }
            }
            CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((TextWithLineCell *)cell).ValueLabel setText:string];
        } cancelBlock:^{
        }];
    }
    
    
    
    
    if ([item.name isEqualToString:@"主营行业"]) {
        NSMutableArray *tradList = [NSMutableArray new];
        for (NSDictionary *temp in self.majortradeMutableArray) {
            [tradList addObject:[temp objectForKey:@"name"]];
        }
        [mofPickerManager showPickerViewWithDataArray:tradList tag:2001 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((TextWithLineCell *)cell).ValueLabel setText:string];
            for (NSDictionary *temp in self.majortradeMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    tradeStr = [temp objectForKey:@"code"] ;
                    break;
                }
            }
        } cancelBlock:^{
            
        }];
    }
    
    if ([item.name isEqualToString:@"意向行业"]) {
        NSMutableArray *tradList = [NSMutableArray new];
        for (NSDictionary *temp in self.tradeMutableArray) {
            [tradList addObject:[temp objectForKey:@"name"]];
        }
        [mofPickerManager showPickerViewWithDataArray:tradList tag:2002 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((TextWithLineCell *)cell).ValueLabel setText:string];
            for (NSDictionary *temp in self.tradeMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    intention_industry = [temp objectForKey:@"code"] ;
                    break;
                }
            }
        } cancelBlock:^{
            
        }];
    }
    
    
    
    if ([item.name isEqualToString:@"投入金额"]) {
        NSMutableArray *placeList = [NSMutableArray new];
        for (NSDictionary *temp in self.intentionAmountMutableArray) {
            [placeList addObject:[temp objectForKey:@"name"]];
        }
        [mofPickerManager showPickerViewWithDataArray:placeList tag:2003 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            for (NSDictionary *temp in self.intentionAmountMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    intention_amountIndex = [temp objectForKey:@"code"] ;
                    break;
                }
            }
            CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((TextWithLineCell *)cell).ValueLabel setText:string];
        } cancelBlock:^{
        }];
    }
}

- (Class)cellClassAtIndexPath:(ResumeTableItem *)nowItem{
    switch (nowItem.showtype) {
        case ResumSelectText:{
            return [TextWithLineCell class];
        }
        case ResumInput:{
            return [TextWthInputFieldCell class];
        }
        case ResumSelectWithMargin:{
            return [TextWithMarginCell class];
        }
        case ResumSelectPlace:{
            return [TextPlaceCell class];
        }
        case ResumePersonalInfo:{
            return [ResumePersonalInfoCell class];
        }
        case TextViewInput:{
            return [DetailTextViewTableViewCell class];
        }
        case ProjectPicUpload:{
            return [CreateProjectHeaderView class];
        }
        case TextFieldText:{
            return [TextFieldBaseCell class];
        }
        case LabelText:{
            return [LabelTableViewCell class];
        }
        default:{
            break;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initNavgation{
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePost:)];
    rightBackItem.tintColor = RedUIColorC1;
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)initSubViews{
    [self.view addSubview:self.Tableview];
}

-(BaseTableView *)Tableview{
    if (_Tableview == nil) {
        _Tableview = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        self.Tableview.delegate = self;
        self.Tableview.dataSource = self;
        self.Tableview.bounces = NO;
        self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.Tableview.showsVerticalScrollIndicator = NO;
        self.Tableview.backgroundColor = BGColorGray;
        [self.Tableview registerClass:[ResumePersonalInfoCell class] forCellReuseIdentifier:NSStringFromClass([ResumePersonalInfoCell class])];
        [self.Tableview registerClass:[TextWithMarginCell class] forCellReuseIdentifier:NSStringFromClass([TextWithMarginCell class])];
        [self.Tableview registerClass:[TextWthInputFieldCell class] forCellReuseIdentifier:NSStringFromClass([TextWthInputFieldCell class])];
        [self.Tableview setTableHeaderView:self.HeaderTableView];
        [self.Tableview setTableFooterView:self.inforFooterView];
    }
    return _Tableview;
}

-(UIView *)inforFooterView{
    if (_inforFooterView == nil ) {
        _inforFooterView = [UIView new];
        _inforFooterView.frame = CGRectMake(0, 0, kScreenWidth, 161*AUTO_SIZE_SCALE_X);
        _inforFooterView.backgroundColor = BGColorGray;
        [_inforFooterView addSubview:self.remarkLabel];
        [_inforFooterView addSubview:self.lineImageView];
        [_inforFooterView addSubview:self.remarksbgView];
        [self.remarksbgView addSubview:self.remarksTextView];
        
        [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inforFooterView.mas_top).offset(10*AUTO_SIZE_SCALE_X);
            make.left.equalTo(self.inforFooterView.mas_left).offset(0*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, (49.5)*AUTO_SIZE_SCALE_X));
        }];
        [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inforFooterView.mas_top).offset(59.5*AUTO_SIZE_SCALE_X);
            make.left.equalTo(self.inforFooterView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, (0.5)*AUTO_SIZE_SCALE_X));
        }];
        
        [self.remarksbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineImageView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
            make.left.equalTo(self.inforFooterView.mas_left).offset(0*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, (101)*AUTO_SIZE_SCALE_X));
        }];
        [self.remarksTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remarksbgView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
            make.left.equalTo(self.remarksbgView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, (60)*AUTO_SIZE_SCALE_X));
        }];
    }
    return _inforFooterView;
}

-(UILabel *)remarkLabel{
    if (_remarkLabel == nil) {
        _remarkLabel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColorGray BgColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentLeft Font:14];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString
                                                  alloc] initWithString:@"备注"];
        NSUInteger length = [@"备注" length];
        NSMutableParagraphStyle *
        style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.firstLineHeadIndent = 15; //设置与尾部的距离
        style.alignment = NSTextAlignmentLeft;//靠右显示
        [attrString addAttribute:NSParagraphStyleAttributeName value:style
                           range:NSMakeRange(0, length)];
        _remarkLabel.attributedText = attrString;
        
    }
    return _remarkLabel;
}

- (UIView *)remarksbgView{
    if (_remarksbgView == nil) {
        _remarksbgView = [UIView new];
        _remarksbgView.backgroundColor = [UIColor whiteColor];
//        _remarksbgView.frame = CGRectMake(0, 44*AUTO_SIZE_SCALE_X, kScreenWidth , 150*AUTO_SIZE_SCALE_X);
        [_remarksbgView addSubview:self.remarksTextView];
    }
    return _remarksbgView;
}

-(UITextView *)remarksTextView{
    if (_remarksTextView == nil) {
        _remarksTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _remarksTextView.layer.borderWidth = 0;
        _remarksTextView.font = [UIFont systemFontOfSize:14];
        _remarksTextView.layer.borderColor = [UIColor clearColor].CGColor;
        _remarksTextView.zw_placeHolder = @"150字以内，例：我在北京市朝阳区建外大街19号有家经营酒类的临街店铺，每天客流量大约在150人左右，每日流水至少15000元";
        _remarksTextView.zw_placeHolderColor = FontUIColor999999Gray;
        _remarksTextView.textColor = FontUIColorBlack;
        _remarksTextView.tintColor = RedUIColorC1;
        
    }
    return _remarksTextView;
}

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

-(NSMutableArray *)placeOfBusinessMutableArray{
    if (_placeOfBusinessMutableArray == nil) {
        _placeOfBusinessMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"1",
                                                  @"name":@"无经营场所"
                                                  }];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"3",
                                                  @"name":@"街边店"
                                                  }];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"4",
                                                  @"name":@"写字楼"
                                                  }];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"5",
                                                  @"name":@"商场店"
                                                  }];
    }
    return _placeOfBusinessMutableArray;
}

-(NSMutableArray *)opennessMutableArray{
    if (_opennessMutableArray == nil) {
        _opennessMutableArray = [NSMutableArray arrayWithCapacity:0];
        
        [_opennessMutableArray addObject:@{
                                           @"code":@"2",
                                           @"name":@"对意向行业的项目开放"
                                           }];
        [_opennessMutableArray addObject:@{
                                           @"code":@"1",
                                           @"name":@"对所有项目开放"
                                           }];
        [_opennessMutableArray addObject:@{
                                           @"code":@"3",
                                           @"name":@"不开放"
                                           }];
    }
    return _opennessMutableArray;
}


-(NSMutableArray *)intentionAmountMutableArray{
    if (_intentionAmountMutableArray == nil) {
        _intentionAmountMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_intentionAmountMutableArray addObject:@{@"code":@"1",@"name":@"1万以内"}];
        [_intentionAmountMutableArray addObject:@{@"code":@"2",@"name":@"1-5万"}];
        [_intentionAmountMutableArray addObject:@{@"code":@"3",@"name":@"5-20万"}];
        [_intentionAmountMutableArray addObject:@{@"code":@"4",@"name":@"20-50万"}];
        [_intentionAmountMutableArray addObject:@{@"code":@"5",@"name":@"50万以上"}];
    }
    return _intentionAmountMutableArray;
}

-(NSMutableArray *)tradeMutableArray{
    if (_tradeMutableArray == nil) {
        _tradeMutableArray = [NSMutableArray arrayWithCapacity:0];
        [[DistrictManager shareManger] setIsDifferentTrade:YES];
        [[DistrictManager shareManger] getIndustryData];
        NSArray *industryArray =  [[DistrictManager shareManger] industryArray];
        for(int i = 0; i<industryArray.count;i++){
            [_tradeMutableArray addObject:@{
                                            @"code":[[industryArray objectAtIndex:i] objectForKey:@"value"],
                                            @"name":[[industryArray objectAtIndex:i] objectForKey:@"text"]
                                            }];
        }
    }
    return _tradeMutableArray;
}

-(NSMutableArray *)majortradeMutableArray{
    if (_majortradeMutableArray == nil) {
        _majortradeMutableArray = [NSMutableArray arrayWithCapacity:0];
        
        [_majortradeMutableArray addObjectsFromArray:self.tradeMutableArray];
        [_majortradeMutableArray removeObjectAtIndex:0];
    }
    return _majortradeMutableArray;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight )];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

-(NSMutableArray *)resumeMutableArray{
    if (_resumeMutableArray == nil) {
        _resumeMutableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _resumeMutableArray;
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [MobClick beginLogPageView:kPerfectPersonalInfoPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:kPerfectPersonalInfoPage];
}
@end
