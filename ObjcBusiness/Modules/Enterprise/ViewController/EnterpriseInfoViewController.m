//
//  EnterpriseInfoViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EnterpriseInfoViewController.h"
#import "BaseTableView.h"
#import "EnterpriseItem.h"
#import "EnterpriseInfoCell.h"
#import "EnterpriseTextViewIntroduceCell.h"
#import "EnterpriseUploadPictureCell.h"
#import "EnterpriseTextFieldSendMessageCell.h"
#import "EnterpriseInfoCell.h"
#import "CompanyBaseCell.h"
#import "SubmitButtonView.h"
#import "MOFSPickerManager.h"
#import "DistrictManager.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileUploadHelper.h"
#import "ScannerViewController.h"
#import "TOCropViewController.h"
@interface EnterpriseInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate>{
    NSString *nameStr,*jobTitleStr,*realNameStr,*telStr,*districtindex,*tradeStr,*companyTelStr,*compayDescStr,*companyLicenceStr,*cardStr,*verificationCodeStr;
    NSInteger selecttag;
    NSIndexPath *phoneindexpath;
    NSURL *refURL;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)BaseTableView *baseTableView;
@property (nonatomic,strong)NSMutableArray *tradeMutableArray;
@property (nonatomic,strong)SubmitButtonView *bottonButtonView;
@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle; //The cropping style
@property (nonatomic, strong) UIImage *image;
@end

@implementation EnterpriseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nameStr =jobTitleStr=realNameStr=telStr=districtindex=tradeStr=companyTelStr=compayDescStr=companyLicenceStr=cardStr=verificationCodeStr=@"";
    nameStr = self.companyNameStr;
    self.automaticallyAdjustsScrollViewInsets=NO;//scrollview预留空位
    [self initSubViews];
    [self loadData];
}

-(void)loadData{
    if (![self.companyId isEqualToString:@""]) {
        [self.dataArray removeAllObjects];
        
        NSMutableArray *groupArray1 = [NSMutableArray array];
        EnterpriseItem *item0 = [EnterpriseItem new];
        item0.name =@"企业名称";
        item0.UserInteractive = NO;
        item0.functionValue = self.companyNameStr;
        item0.showtype =  EnterpriseLabel;
        
        EnterpriseItem *item1 = [EnterpriseItem new];
        item1.name =@"公司职位";
        item1.UserInteractive = YES;
        item1.showtype =  EnterpriseLabel;
        
        EnterpriseItem *item2 = [EnterpriseItem new];
        item2.name =@"您的姓名";
        item2.UserInteractive = YES;
        item2.showtype =  EnterpriseLabel;
        
        
        [groupArray1 addObject:item0];
        [groupArray1 addObject:item1];
        [groupArray1 addObject:item2];
        
        EnterpriseItem *item3;
        EnterpriseItem *item4;
  
        item3 = [EnterpriseItem new];
        item3.name =@"您的手机号";
        item3.UserInteractive = YES;
        item3.showtype =  EnterpriseLabel;
        item3.issetNumberKeyboard =YES;
        NSString *iphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (iphone !=nil && iphone.length!=0) {
            item3.functionValue = iphone;
        }
        item4 = [EnterpriseItem new];
        item4.name =@"请输入验证码";
        item4.showtype =  EnterpriseTextFieldSendMessage;
        item4.isHiddenLine = YES;
        [groupArray1 addObject:item3];
        [groupArray1 addObject:item4];
 
        NSMutableArray *groupArray4 = [NSMutableArray array];
        EnterpriseItem *item40 = [EnterpriseItem new];
        item40.name =@"个人名片（个人名片、工牌、劳动合同等）";
        item40.functionValue = @"点击上传个人名片";
        item40.showtype = EnterpriseUploadPicture;
        [groupArray4 addObject:item40];

        [_dataArray addObject:groupArray1];
        [_dataArray addObject:groupArray4];
        [self.baseTableView reloadData];
    }
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

- (void)save:(UIButton *)button{
    button.enabled = NO;
    
    if (![self.companyId isEqualToString:@""]) {
        EnterpriseItem *item1 = [self.dataArray[0] objectAtIndex:1];
        jobTitleStr = item1.functionValue ;
        EnterpriseItem *item2 = [self.dataArray[0] objectAtIndex:2];
        realNameStr = item2.functionValue ;
        EnterpriseItem *item3 = [self.dataArray[0] objectAtIndex:3];
        telStr = item3.functionValue ;
        EnterpriseItem *item4 = [self.dataArray[0] objectAtIndex:4];
        verificationCodeStr = item4.functionValue ;
        if (nameStr.length == 0) {
            [[RequestManager shareRequestManager] tipAlert:@"企业名称不能为空" viewController:self];
            button.enabled = YES;
            return;
        }
        if (jobTitleStr.length == 0) {
            [[RequestManager shareRequestManager] tipAlert:@"请填写公司职位" viewController:self];
            button.enabled = YES;
            return;
        }
        if (realNameStr.length == 0) {
            [[RequestManager shareRequestManager] tipAlert:@"请填写您的姓名" viewController:self];
            button.enabled = YES;
            return;
        }
        if (telStr.length == 0) {
            [[RequestManager shareRequestManager] tipAlert:@"手机号不能为空" viewController:self];
            button.enabled = YES;
            return;
        }
        if (telStr.length> 11) {
            [[RequestManager shareRequestManager] tipAlert:@"手机号长度11位" viewController:self];
            button.enabled = YES;
            return;
        }
        if (verificationCodeStr.length == 0) {
            [[RequestManager shareRequestManager] tipAlert:@"验证码不能为空 请获取验证码" viewController:self];
            button.enabled = YES;
            return;
        }
        if (companyLicenceStr.length == 0) {
            [[RequestManager shareRequestManager] tipAlert:@"个人名片与营业执照 请您检查并选任一上传" viewController:self];
            button.enabled = YES;
            return;
        }
        NSDictionary *dic = @{
                              @"company_id":self.companyId,
                              @"c_jobtitle":jobTitleStr,
                              @"c_realname":realNameStr,
                              @"c_tel":telStr,
                              @"c_card":companyLicenceStr,
                              @"verification_code":verificationCodeStr
                              };
//        NSLog(@"dic--openCompanyFeature--->%@",dic);
        [[RequestManager shareRequestManager] openCompanyFeature:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"saveBusinessResume----->%@",result);
            if (IsSucess(result) == 1) {
//                int returnFLag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
                
                    NSString *qtxsy_auth = [[result objectForKey:@"data"] objectForKey:@"result"];
                    [DEFAULTS removeObjectForKey:@"qtxsy_auth"];
                    [DEFAULTS setObject:qtxsy_auth forKey:@"qtxsy_auth"];
                    [DEFAULTS synchronize];
                    [[RequestManager shareRequestManager] tipAlert:@"提交成功" viewController:self];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                
            }else{
                button.enabled = YES;
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
            button.enabled = YES;
        }];

        return;
    }
    EnterpriseItem *item1 = [self.dataArray[0] objectAtIndex:1];
    jobTitleStr = item1.functionValue ;
    
    EnterpriseItem *item2 = [self.dataArray[0] objectAtIndex:2];
    realNameStr = item2.functionValue ;
    
    EnterpriseItem *item3 = [self.dataArray[0] objectAtIndex:3];
    telStr = item3.functionValue ;
    
    EnterpriseItem *item44 = [self.dataArray[0] objectAtIndex:4];
    verificationCodeStr = item44.functionValue ;
    
    EnterpriseItem *item4 = [self.dataArray[1] objectAtIndex:2];
    companyTelStr = item4.functionValue ;
    
    
    EnterpriseItem *item5 = [self.dataArray[2] objectAtIndex:0];
    compayDescStr = item5.functionValue ;
    
    if (nameStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"企业名称不能为空" viewController:self];
        button.enabled = YES;
        return;
    }
    if (jobTitleStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写公司职位" viewController:self];
        button.enabled = YES;
        return;
    }
    if (realNameStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写您的姓名" viewController:self];
        button.enabled = YES;
        return;
    }
    if (telStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"手机号不能为空" viewController:self];
        button.enabled = YES;
        return;
    }
    if (telStr.length> 11) {
        [[RequestManager shareRequestManager] tipAlert:@"手机号长度11位" viewController:self];
        button.enabled = YES;
        return;
    }
    if (verificationCodeStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"验证码不能为空 请获取验证码" viewController:self];
        button.enabled = YES;
        return;
    }
    if (districtindex.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择企业所在地区" viewController:self];
        button.enabled = YES;
        return;
    }
    if (tradeStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择所属行业" viewController:self];
        button.enabled = YES;
        return;
    }
    if (companyTelStr.length> 8) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入正确的固定电话号码" viewController:self];
        button.enabled = YES;
        return;
    }
    if (compayDescStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写企业的一句话简单介绍" viewController:self];
        button.enabled = YES;
        return;
    }
    if (compayDescStr.length> 20) {
        [[RequestManager shareRequestManager] tipAlert:@"企业的简单介绍不能超过20个字" viewController:self];
        button.enabled = YES;
        return;
    }
    if (companyLicenceStr.length == 0 ) {
        if (cardStr.length ==0) {
            [[RequestManager shareRequestManager] tipAlert:@"个人名片与营业执照至少选其一，请您检查并上传" viewController:self];
            button.enabled = YES;
            return;
        }
    }
    NSDictionary *dic = @{
                          @"company_name":nameStr,
                          @"c_jobtitle":jobTitleStr,
                          @"c_realname":realNameStr,
                          @"c_tel":telStr,
                          @"company_area":districtindex,
                          @"company_industry":tradeStr,
                          @"_company_telephone":companyTelStr,
                          @"company_desc":compayDescStr,
                          @"_company_licence":companyLicenceStr,
                          @"_c_card":cardStr,
                          @"verification_code":verificationCodeStr
                          };
//    NSLog(@"dic----->%@",dic);
    [[RequestManager shareRequestManager] applyCompanyEntering:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"saveBusinessResume--applyCompanyEntering-->%@",result);
        if (IsSucess(result) == 1) {
            
            if (IsSucess(result)) {
                NSString *qtxsy_auth = [[result objectForKey:@"data"] objectForKey:@"result"];
                [DEFAULTS removeObjectForKey:@"qtxsy_auth"];
                [DEFAULTS setObject:qtxsy_auth forKey:@"qtxsy_auth"];
                [DEFAULTS synchronize];
                [[RequestManager shareRequestManager] tipAlert:@"提交成功" viewController:self];
                [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            button.enabled = YES;
        }
    } failuer:^(NSError *error) {
        button.enabled = YES;
    }];
}

-(void)returnListPage{
    [DEFAULTS setObject:@"2" forKey:@"userKind"];
    [DEFAULTS synchronize];
    _bottonButtonView.bottomPostButton.enabled = YES;
    ScannerViewController *vc = [[ScannerViewController alloc ] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initSubViews {
    self.title = @"企业信息";
    [self.view addSubview:self.baseTableView];
    
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EnterpriseItem *item = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    Class cls = [self cellClassAtIndexPath:indexPath];
    return [cls tableView:tableView rowHeightForObject:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*AUTO_SIZE_SCALE_X;
}

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
    EnterpriseItem *item = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    EnterpriseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self cellClassAtIndexPath:indexPath])];
    if (cell ==nil) {
        Class cls = [self cellClassAtIndexPath:indexPath];
        cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self cellClassAtIndexPath:indexPath])];
    }
    
    if ([item.name isEqualToString:@"您的手机号"]) {
        phoneindexpath = indexPath;
    }
    if ([item.name isEqualToString:@"请输入验证码"]) {
        [((EnterpriseTextFieldSendMessageCell *)cell).sendMessageButton addTarget:self action:@selector(getMessageCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([item.name isEqualToString:@"营业执照（复印件，并加盖公章)"]) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadCard:)];
        ((EnterpriseUploadPictureCell *)cell).headBGView.tag = indexPath.section;
        [((EnterpriseUploadPictureCell *)cell).headBGView  addGestureRecognizer:singleTap];
    }
    if ([item.name isEqualToString:@"个人名片（与营业执照至少任选其一）"]) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadCard:)];
         ((EnterpriseUploadPictureCell *)cell).headBGView.tag = indexPath.section;
        [((EnterpriseUploadPictureCell *)cell).headBGView  addGestureRecognizer:singleTap];
    }
    if ([item.name isEqualToString:@"个人名片（个人名片、工牌、劳动合同等）"]) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadCard:)];
        ((EnterpriseUploadPictureCell *)cell).headBGView.tag = indexPath.section;
        [((EnterpriseUploadPictureCell *)cell).headBGView  addGestureRecognizer:singleTap];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell setResumeTableItem:item];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnterpriseItem *item = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    //    selectindexPath = indexPath;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if ([item.name isEqualToString:@"企业地区"]) {
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *addressStr, NSString *zipcode) {
            NSString *address;
            NSArray *addresstemparray  = [addressStr componentsSeparatedByString:@"-"];
            //        NSLog(@"addresstemparray----%@",addresstemparray);
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
            EnterpriseInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((EnterpriseInfoCell *)cell).ValueLabel setText:address];
            item.functionValue = address;
            NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
            districtindex =temparray[temparray.count-1];
        } cancelBlock:^{
        }];
    }
    if ([item.name isEqualToString:@"所属行业"]) {
        NSMutableArray *tradList = [NSMutableArray new];
        for (NSDictionary *temp in self.tradeMutableArray) {
            [tradList addObject:[temp objectForKey:@"name"]];
        }
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:tradList tag:2000001 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            EnterpriseInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((EnterpriseInfoCell *)cell).ValueLabel setText:string];
            item.functionValue = string;
            for (NSDictionary *temp in self.tradeMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    tradeStr = [temp objectForKey:@"code"] ;
                    break;
                }
            }
        } cancelBlock:^{
        }];
    }
}


- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)getMessageCode:(UIButton *)sender{
    sender.enabled = NO;
    EnterpriseInfoCell *cell = [self.baseTableView cellForRowAtIndexPath:phoneindexpath];
    if (![self isMobileNumber:cell.ValueLabel.text]) {
        [[RequestManager shareRequestManager] tipAlert:@"请检查您输入的手机号是否正确" viewController:self];
        sender.enabled = YES;
        return;
    }
    telStr = cell.ValueLabel.text;
    NSDictionary *dic = @{@"tel":telStr};
    
    [[RequestManager shareRequestManager] GetVerifyCodeResult:dic viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CompanySendMessage object:nil userInfo:nil];
        }
        sender.enabled = YES;
    } failuer:^(NSError *error) {
        sender.enabled = YES;
    }];
}

#pragma mark - event response
- (void)uploadCard:(UITapGestureRecognizer *)sender
{
    NSLog(@"%ld",sender.view.tag );
    selecttag = sender.view.tag;
    [self photoMethod];
}


- (void)photoMethod{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 8.0f)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *addPhoneAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self useCamera];
            
        }];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self usePhoto];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [addPhoneAction setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [photoAction setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [cancelAction setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [actionSheet addAction:addPhoneAction];
        [actionSheet addAction:photoAction];
        [actionSheet addAction:cancelAction];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [actionSheet showInView:self.view];
#pragma clang diagnostic pop
    }
}


-(void)useCamera{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setDelegate:self];
        [imgPicker setAllowsEditing:NO];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
        imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
        [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
        //            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
    else
    {
        [self showAlertView:nil message:@"该设备没有照相机"];
    }
    
}

- (void)showAlertView:(NSString *)title message:(NSString *)msg
{
    CHECK_DATA_IS_NSNULL(title, NSString);
    CHECK_STRING_IS_NULL(title);
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:msg
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
}

-(void)usePhoto{
    //照片来源为相册
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:NO];
    self.croppingStyle = TOCropViewCroppingStyleDefault;
    //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
    imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
    [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
    
    //        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - 图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:image];
    
    cropController.delegate = self;
    
    // -- Uncomment these if you want to test out restoring to a previous crop setting --
    //cropController.angle = 90; // The initial angle in which the image will be rotated
    //cropController.imageCropFrame = CGRectMake(0,0,2848,4288); //The
    
    // -- Uncomment the following lines of code to test out the aspect ratio features --
    //cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare; //Set the initial aspect ratio as a square
    //cropController.aspectRatioLockEnabled = YES; // The crop box is locked to the aspect ratio and can't be resized away from it
    //cropController.resetAspectRatioEnabled = NO; // When tapping 'reset', the aspect ratio will NOT be reset back to default
    
    // -- Uncomment this line of code to place the toolbar at the top of the view controller --
    // cropController.toolbarPosition = TOCropViewControllerToolbarPositionTop;
    
    self.image = image;
    
    //If profile picture, push onto the same navigation stack
    if (self.croppingStyle == TOCropViewCroppingStyleCircular) {
        [picker pushViewController:cropController animated:YES];
    }
    else { //otherwise dismiss, and then present from the main controller
        [picker dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:cropController animated:YES completion:nil];
        }];
    }
    
    refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        UIImage *img;
        img =image;
        
        
        
        img = [img fixOrientation];
        NSString *fileName = [imageRep filename];
        
        if (fileName == nil)
        {
            // 要上传保存在服务器中的名称
            // 使用时间来作为文件名 2014-04-30 14:20:57.png
            // 让不同的用户信息,保存在不同目录中
            //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //            // 设置日期格式
            //            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            //            NSString *Name = [formatter stringFromDate:[NSDate date]];
            //
            //            fileName = [NSString stringWithFormat:@"%@%@", Name,@".jpg"];
            fileName = @"tempcapt.jpg";
        }
        //        NSLog(@"fileName--------%@",fileName);
        NSString *localFile = [FileUploadHelper PreUploadImagePath:img AndFileName:fileName];
        if([localFile isEqualToString:@""])
        {
            [self showHint:@"图片获取失败"];
            return;
        }
        //        NSLog(@"localFile--------%@",localFile);
        //        NSString *pathext = [NSString stringWithFormat:@".%@",[localFile pathExtension]];
        //        pathext = [pathext lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        NSData *imageData = [NSData dataWithContentsOfFile:localFile];
        
        NDLog(@"localFile = %@",localFile);
        
        NSDictionary *dic = @{};
        
        [[RequestManager shareRequestManager]SubmitImage:dic sendData:imageData WithFileName:fileName WithHeader:dic viewController:self successData:^(NSDictionary *result){
            EnterpriseUploadPictureCell *cell;
            cell = [self.baseTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selecttag]];
            if (selecttag == 1) {
                companyLicenceStr  = [[result objectForKey:@"data"] objectForKey:@"url"];
            }
            if (selecttag == 3) {
                companyLicenceStr  = [[result objectForKey:@"data"] objectForKey:@"url"];
            }
            if (selecttag == 4) {
                cardStr  = [[result objectForKey:@"data"] objectForKey:@"url"];
            }
            
            [((EnterpriseUploadPictureCell *)cell).headBGView setContentMode:UIViewContentModeScaleAspectFit];
            [((EnterpriseUploadPictureCell *)cell).headBGView sd_setImageWithURL:[NSURL URLWithString:[[result objectForKey:@"data"] objectForKey:@"url"]]];
            ((EnterpriseUploadPictureCell *)cell).headImageView.hidden = YES;
            ((EnterpriseUploadPictureCell *)cell).headBGLabel.hidden = YES;

            
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            [self hideHud];
        }];
        
        
        //发送更新头像的通知
        
        
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath{
    EnterpriseItem *item = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
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

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *groupArray1 = [NSMutableArray array];
        EnterpriseItem *item0 = [EnterpriseItem new];
        item0.name =@"企业名称";
        item0.UserInteractive = NO;
        item0.functionValue = self.companyNameStr;
        item0.showtype =  EnterpriseLabel;
        
        EnterpriseItem *item1 = [EnterpriseItem new];
        item1.name =@"公司职位";
        item1.UserInteractive = YES;
        item1.showtype =  EnterpriseLabel;
        
        EnterpriseItem *item2 = [EnterpriseItem new];
        item2.name =@"您的姓名";
        item2.UserInteractive = YES;
        item2.showtype =  EnterpriseLabel;
        
        
        [groupArray1 addObject:item0];
        [groupArray1 addObject:item1];
        [groupArray1 addObject:item2];
        
        EnterpriseItem *item3;
        EnterpriseItem *item4;
        NSString *iphone = [DEFAULTS objectForKey:@"userTelphone"];
        if (iphone !=nil && iphone.length!=0) {
            item3 = [EnterpriseItem new];
            item3.name =@"您的手机号";
            item3.UserInteractive = NO;
            item3.functionValue = iphone;
            item3.showtype =  EnterpriseLabel;
            item3.isHiddenLine = YES;
            item3.issetNumberKeyboard =YES;
            
        }else{
            item3 = [EnterpriseItem new];
            item3.name =@"您的手机号";
            item3.UserInteractive = YES;
            item3.showtype =  EnterpriseLabel;
            
        }
        item4 = [EnterpriseItem new];
        item4.name =@"请输入验证码";
        item4.showtype =  EnterpriseTextFieldSendMessage;
        item4.isHiddenLine = YES;
        [groupArray1 addObject:item3];
        [groupArray1 addObject:item4];
        NSMutableArray *groupArray2 = [NSMutableArray array];
        EnterpriseItem *item20 = [EnterpriseItem new];
        item20.name =@"企业地区";
        item20.UserInteractive = NO;
        item20.showtype =  EnterpriseLabel;
        
        EnterpriseItem *item21 = [EnterpriseItem new];
        item21.name =@"所属行业";
        item21.UserInteractive = NO;
        item21.showtype =  EnterpriseLabel;
        
        EnterpriseItem *item22 = [EnterpriseItem new];
        item22.name =@"固定电话（选填）";
        item22.isHiddenLine = YES;
        item22.UserInteractive = YES;
        item22.issetNumberKeyboard =YES;
        item22.functionValue = @"";
        item22.showtype =  EnterpriseLabel;
        [groupArray2 addObject:item20];
        [groupArray2 addObject:item21];
        [groupArray2 addObject:item22];
        
        NSMutableArray *groupArray3 = [NSMutableArray array];
        EnterpriseItem *item30 = [EnterpriseItem new];
        item30.name =@"企业介绍";
        item30.showtype = EnterpriseTextViewIntroduce;
        [groupArray3 addObject:item30];
        
        NSMutableArray *groupArray4 = [NSMutableArray array];
        EnterpriseItem *item40 = [EnterpriseItem new];
        item40.name =@"营业执照（复印件，并加盖公章)";
        item40.functionValue = @"点击上传企业执照";
        item40.showtype = EnterpriseUploadPicture;
        item40.functionValue = @"";
        [groupArray4 addObject:item40];
        
        NSMutableArray *groupArray5 = [NSMutableArray array];
        EnterpriseItem *item50 = [EnterpriseItem new];
        item50.name =@"个人名片（与营业执照至少任选其一）";
        item50.functionValue = @"点击上传个人名片";
        item50.showtype = EnterpriseUploadPicture;
        item50.functionValue = @"";
        [groupArray5 addObject:item50];
        
        
        [_dataArray addObject:groupArray1];
        [_dataArray addObject:groupArray2];
        [_dataArray addObject:groupArray3];
        [_dataArray addObject:groupArray4];
        [_dataArray addObject:groupArray5];
    }
    return _dataArray;
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil ) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:
                          CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - (kNavHeight)) style:UITableViewStyleGrouped];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _baseTableView.estimatedRowHeight  = (100)*AUTO_SIZE_SCALE_X;
        
        _baseTableView.bounces = NO;
        
        
        //        _baseTableView.rowHeight = UITableViewAutomaticDimension;
        
        //        [_baseTableView registerClass:[EditBusinessExperienceCell class] forCellReuseIdentifier:@"EditBusinessExperienceCell"];
        //        [_baseTableView registerClass:[CDZTableViewCell class] forCellReuseIdentifier:@"CDZTableViewCell"];
        //        [_baseTableView registerClass:[UploadPictureDesCell class] forCellReuseIdentifier:@"UploadPictureDesCell"];
        [_baseTableView setTableFooterView:self.bottonButtonView];
    }
    return _baseTableView;
}

-(SubmitButtonView *)bottonButtonView{
    if (_bottonButtonView == nil) {
        _bottonButtonView = [[SubmitButtonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64*AUTO_SIZE_SCALE_X) target:self action:@selector(savePost:) Title:@"确定提交"];
        [_bottonButtonView.bottomPostButton addTarget:self action:@selector(savePost:) forControlEvents:UIControlEventTouchUpInside];
        [_bottonButtonView.bottomPostButton setTitle:@"确定提交" forState:UIControlStateNormal];
        _bottonButtonView.backgroundColor = [UIColor clearColor];
    }
    return _bottonButtonView;
}

-(NSMutableArray *)tradeMutableArray{
    if (_tradeMutableArray == nil) {
        _tradeMutableArray = [NSMutableArray arrayWithCapacity:0];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kEnterpriseInfoViewPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kEnterpriseInfoViewPage];
}
@end

