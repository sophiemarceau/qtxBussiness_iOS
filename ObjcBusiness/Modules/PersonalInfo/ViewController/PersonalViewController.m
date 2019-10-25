//
//  PersonalViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalHeaderView.h"
#import "PersonalVIewModel.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileUploadHelper.h"
#import "MOFSPickerManager.h"

@interface PersonalViewController ()<UIActionSheetDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
     MOFSPickerManager *mofPickerManager;
    NSString *c_area;
}
@property (nonatomic,strong)PersonalHeaderView *headerView;
@property (nonatomic,strong)PersonalVIewModel *personalViewModel;
@property (nonatomic,strong)NSString *us_photo,*userNickName,*c_profiles;




@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     mofPickerManager = [[MOFSPickerManager alloc] init];
    self.c_profiles = self.us_photo = self.userNickName = c_area = @"";
    __block PersonalViewController *blockSelf = self;
    [self.personalViewModel setBlockWithReturnBlock:^(id returnValue, ResopnseFlagState returnFlag, NSString *signalString) {
        if (IsSucess(returnValue)) {
            int returnFLag = [[[returnValue objectForKey:@"data"] objectForKey:@"result"] intValue];
            if (returnFLag == 1) {
                [[RequestManager shareRequestManager] tipAlert:@"保存成功" viewController:blockSelf];
                
                [blockSelf performSelector:@selector(returnListPage) withObject:blockSelf afterDelay:2.0];
            }
        }
    } WithErrorBlock:^(id errorCode, NSString *errorSignalString) {
        
    }];
    [self initNavgation];
    [self initSubViews];
}
-(void)returnListPage{
    NSArray * ctrlArray = self.navigationController.viewControllers;
//    NSLog(@"ctrlArray----------->%@",ctrlArray);
    
//    [self.navigationController setViewControllers:@[ctrlArray[0],ctrlArray[1],vc] animated:YES];
    [DEFAULTS setObject:self.userNickName forKey:@"userNickName"];
    [DEFAULTS setObject:self.us_photo forKey:@"userPortraitUri"];
    [DEFAULTS setObject:self.c_profiles forKey:@"c_profiles"];
    [DEFAULTS synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UpdatePersonalInfo object:nil userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    rightBackItem.tintColor = RedUIColorC1;
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
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
    [self.headerView.userNameTextField resignFirstResponder];
    [self.headerView.introduceTextField resignFirstResponder];
    [self.headerView.remarksTextView resignFirstResponder];
    NSString *introduceStr = self.headerView.remarksTextView.text;
    if (self.headerView.userNameTextField.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，长度不能超过12位请您重新输入" viewController:self];
        return;
    }
    
    if (self.headerView.userNameTextField.text.length >6) {
        [[RequestManager shareRequestManager] tipAlert:@"您的输入名字，长度不能超过不超过6个汉字请您重新输入" viewController:self];
        return;
    }
    
    if(self.headerView.introduceTextField.text.length == 0){
        [[RequestManager shareRequestManager] tipAlert:@"您的一句话介绍，不能为空，请您重新输入" viewController:self];
        return;
    }
    
    if(self.headerView.introduceTextField.text.length > 15){
        [[RequestManager shareRequestManager] tipAlert:@"您的一句话介绍，不能超过不超过15个汉字请您重新输入" viewController:self];
        return;
    }
    
    if (self.headerView.remarksTextView.text.length >300 ) {
        [[RequestManager shareRequestManager] tipAlert:@"您输入的详细介绍，长度不能超过12位请您重新输入" viewController:self];
        return;
    }
    
    self.userNickName = self.headerView.userNameTextField.text;
    self.c_profiles = self.headerView.introduceTextField.text;
    
    NSDictionary *dic = @{
                          @"c_nickname":self.headerView.userNameTextField.text,
                          @"c_photo":_us_photo,
                          @"c_profiles":self.c_profiles,
                          @"_c_description":introduceStr,
                          @"_c_area":c_area,
                          };
    [self.personalViewModel saveUserInformation:dic];
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [self photoMethod];
}

-(void)getSelectLocationOnClick:(UIButton *)sender{
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
        [self.headerView.locationdTextField setText:address];
        NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
        c_area =temparray[temparray.count-1];
    } cancelBlock:^{
    }];
}

- (void)photoMethod{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 8.0f)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *addPhoneAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //照片来源为相机
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
                //                [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
                //            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                [self presentViewController:imgPicker animated:YES completion:nil];
            }
            
        }];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //照片来源为相册
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
            //            imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
            //            [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
            
            //        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
            [self presentViewController:imgPicker animated:YES completion:nil];

          
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消提现" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [actionSheet showInView:self.view];
#pragma clang diagnostic pop
    }
}

#pragma mark - 图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        UIImage *img;
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            img = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
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
        
//        NSLog(@"localFile = %@",localFile);
        
        NSDictionary *dic = @{};

        [[RequestManager shareRequestManager] SubmitImage:dic  sendData:imageData  WithFileName:fileName WithHeader:dic viewController:self successData:^(NSDictionary *result){
            
            [self.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:[[result objectForKey:@"data"] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
            _us_photo = [[result objectForKey:@"data"] objectForKey:@"url"];
            
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            [self hideHud];
        }];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^(void)
     {
         //         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)initSubViews {
    self.title = @"完善个人信息";
    [self.view addSubview:self.headerView];
    [self.headerView.locationdButton addTarget:self action:@selector(getSelectLocationOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _us_photo = [DEFAULTS objectForKey:@"userPortraitUri"];
    [self.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:[DEFAULTS objectForKey:@"userPortraitUri"]] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    self.headerView.userNameTextField.text = [DEFAULTS objectForKey:@"userNickName"];
    self.c_profiles = [DEFAULTS objectForKey:@"c_profiles"];
   
    if (![self.c_profiles isEqualToString:@""]) {
        self.headerView.introduceTextField.text = [DEFAULTS objectForKey:@"c_profiles"];
    }else{
        self.headerView.introduceTextField.text = @"";
    }
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
//        NSLog(@"GetUserInfoResult------>%@",result);
        if (IsSucess(result) == 1) {
            NSDictionary *resultDic = [[result objectForKey:@"data"] objectForKey:@"result"];
            NSString *description = [resultDic objectForKey:@"c_description"];
            NSString *areacode = [resultDic objectForKey:@"c_area"];
            NSString *cAreaName = [resultDic objectForKey:@"cAreaName"];
            self.headerView.remarksTextView.text = description;
            [self.headerView.remarksTextView updatePlaceHolder];
            [self.headerView.locationdTextField setText:cAreaName];
            c_area =areacode;
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        [LZBLoadingView dismissLoadingView];
    } failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [LZBLoadingView dismissLoadingView];
    }];
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
    //    [self.navigationController setNavigationBarHidden:YES];
    [MobClick beginLogPageView:kPersoalInfoPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO];
    [MobClick endLogPageView:kPersoalInfoPage];
}

-(PersonalHeaderView *)headerView{
    if (_headerView == nil ) {
        _headerView = [[PersonalHeaderView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight- kNavHeight)];
        _headerView.headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
        [_headerView.headerImageView addGestureRecognizer:tap1];
    }
    return _headerView;
}

-(PersonalVIewModel *)personalViewModel{
    if (_personalViewModel == nil) {
        _personalViewModel = [[PersonalVIewModel alloc] init];
    }
    return _personalViewModel;
}

@end
