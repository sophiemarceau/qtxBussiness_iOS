//
//  BossComingViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/7.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossComingViewController.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileUploadHelper.h"
#import "AttentionView.h"
#import "TOCropViewController.h"
#import "CreateProjectViewController.h"
#import "MOFSPickerManager.h"

@interface BossComingViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate,UITextFieldDelegate>{
    NSInteger selecttag;
    NSURL *refURL;
    
    NSString *_c_photo,*c_realname,*c_short_company_name,*c_jobtitle,*c_profiles,*c_area,*company_name,* _c_card;
     MOFSPickerManager *mofPickerManager;
}
@property(nonatomic,strong)UIView *headbgView;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *headLabel;
@property(nonatomic,strong)UITextField
*nameTextField,
*enterpriseTextField,
*jobTitleTextField,
*IntroduceTextField,
*companyFullNameTextField,
*locationTextField;
@property(nonatomic,strong)UILabel *postCartLabel,*cardPlusLabel;
@property(nonatomic,strong)UIImageView *lineImageView1;
@property(nonatomic,strong)UIImageView *lineImageView2;
@property(nonatomic,strong)UIImageView *lineImageView3;
@property(nonatomic,strong)UIImageView *lineImageView4;
@property(nonatomic,strong)UIImageView *verticalLineImageView;
@property(nonatomic,strong)UIImageView *cardImageView,*plusImageView;
@property(nonatomic,strong)UIView *postcatUploadbgView;
@property(nonatomic,assign)TOCropViewCroppingStyle croppingStyle; //The cropping style
@property(nonatomic,strong)UIImage *image;
@end

@implementation BossComingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mofPickerManager = [[MOFSPickerManager alloc] init];
    self.title = @"老板入驻";
    _c_card = _c_photo =c_realname = c_short_company_name = c_jobtitle = c_profiles = c_area  = company_name = @"";
    [self initNavgation];
    [self initSubViews];
}

-(void)goBack{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:
                          @"返回后内容将不会保存，您确定返回吗？"
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定", nil];
    [alert show];
//    NSString *nameTextFieldStr = self.nameTextField.text;
//    NSString *enterpriseTextFieldStr = self.enterpriseTextField.text;
//    NSString *jobTitleTextFieldStr = self.jobTitleTextField.text;
//    NSString *IntroduceTextFieldStr = self.IntroduceTextField.text;
//    NSString *companyFullNameTextFieldStr = self.companyFullNameTextField.text;
//    if (nameTextFieldStr.length != 0 || enterpriseTextFieldStr.length != 0 || jobTitleTextFieldStr.length != 0 || IntroduceTextFieldStr.length != 0 || companyFullNameTextFieldStr.length != 0 || _c_card.length != 0 || _c_photo.length != 0) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@""
//                              message:
//                              @"返回后内容将不会保存，您确定返回吗？"
//                              delegate:self
//                              cancelButtonTitle:@"取消"
//                              otherButtonTitles:@"确定", nil];
//        [alert show];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
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

-(void)save{
    
    c_realname = self.nameTextField.text;
    c_short_company_name = self.enterpriseTextField.text;
    c_jobtitle = self.jobTitleTextField.text;
    c_profiles = self.IntroduceTextField.text;
    
    company_name = self.companyFullNameTextField.text;
    if(c_realname.length == 0){
        [[RequestManager shareRequestManager] tipAlert:@"请填写真实姓名" viewController:self];
        return;
    }
    if(c_realname.length > 4){
        [[RequestManager shareRequestManager] tipAlert:@"真实姓名,不能超过4个字" viewController:self];
        return;
    }
    if (![CommentMethod IsChinese:c_realname]) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写真实姓名,姓名只能为汉字" viewController:self];
        return;
    }
    if(c_short_company_name.length == 0){
        [[RequestManager shareRequestManager] tipAlert:@"请填写企业简称" viewController:self];
        return;
    }
    if(c_short_company_name.length > 6){
        [[RequestManager shareRequestManager] tipAlert:@"职位名称不得超过6个汉字" viewController:self];
        return;
    }
    if(c_jobtitle.length == 0){
        [[RequestManager shareRequestManager] tipAlert:@"请填写职位" viewController:self];
        return;
    }
    if(c_jobtitle.length > 6){
        [[RequestManager shareRequestManager] tipAlert:@"职位名称不得超过6个汉字" viewController:self];
        return;
    }
    if(c_profiles.length == 0){
        [[RequestManager shareRequestManager] tipAlert:@"请填写一句话介绍（您的成就或优势等）" viewController:self];
        return;
    }
    if(c_profiles.length > 18){
        [[RequestManager shareRequestManager] tipAlert:@"一句话介绍不得超过18个汉字" viewController:self];
        return;
    }
    if (c_area.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择位置" viewController:self];
        return;
    }
    if(company_name.length == 0){
        [[RequestManager shareRequestManager] tipAlert:@"请填写企业全称" viewController:self];
        return;
    }
    if(company_name.length > 30){
        [[RequestManager shareRequestManager] tipAlert:@"企业全称不得超过30个汉字" viewController:self];
        return;
    }
    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
    NSDictionary *dic = @{
                          @"_c_photo":_c_photo,
                          @"c_realname":c_realname,
                          @"c_short_company_name":c_short_company_name,
                          @"c_jobtitle":c_jobtitle,
                          @"c_profiles":c_profiles,
                          @"c_area":c_area,
                          @"company_name":company_name,
                          @"_c_card":_c_card
                          };
    
    [[RequestManager shareRequestManager] applyBossEntering:dic
                                             viewController:self
                                                successData:^(NSDictionary *result) {
                                                    
                                                    if(IsSucess(result) == 1){
                                                        NSString *qtxsy_auth = [[result objectForKey:@"data"] objectForKey:@"result"];
                                                        [DEFAULTS removeObjectForKey:@"qtxsy_auth"];
                                                        [DEFAULTS setObject:qtxsy_auth forKey:@"qtxsy_auth"];
                                                        [DEFAULTS setObject:@"2" forKey:@"userKind"];
                                                        [DEFAULTS synchronize];
                                                        
                                                         [[RequestManager shareRequestManager] tipAlert:@" 已提交成功" viewController:self];
                                                         [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
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

-(void)returnListPage{
    
    CreateProjectViewController *vc = [[CreateProjectViewController alloc] init];
    vc.viewType = CreateProject;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)initSubViews{
    [self.view addSubview:self.headbgView];
    [self.headbgView addSubview:self.headImageView];
    [self.headbgView addSubview:self.headLabel];
    [self.headbgView addSubview:self.nameTextField];
    [self.headbgView addSubview:self.lineImageView1];
    [self.headbgView addSubview:self.enterpriseTextField];
    [self.headbgView addSubview:self.verticalLineImageView];
    [self.headbgView addSubview:self.jobTitleTextField];
    [self.headbgView addSubview:self.lineImageView2];
    [self.headbgView addSubview:self.IntroduceTextField];
    [self.headbgView addSubview:self.lineImageView3];
    [self.headbgView addSubview:self.locationTextField];
    
    [self.view addSubview:self.companyFullNameTextField];
    
    [self.view addSubview:self.postcatUploadbgView];
    [self.postcatUploadbgView addSubview:self.postCartLabel];
    [self.postcatUploadbgView addSubview:self.lineImageView4];
    [self.postcatUploadbgView addSubview:self.cardImageView];
    [self.cardImageView addSubview:self.plusImageView];
    [self.cardImageView addSubview:self.cardPlusLabel];
    
    self.headbgView.frame = CGRectMake(0, kNavHeight, kScreenWidth, 210*AUTO_SIZE_SCALE_X);
    
    self.headImageView.frame = CGRectMake(25*AUTO_SIZE_SCALE_X,25*AUTO_SIZE_SCALE_X,55*AUTO_SIZE_SCALE_X,55*AUTO_SIZE_SCALE_X);
    self.headLabel.frame = CGRectMake(0, 88, 105*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    
    self.nameTextField.frame = CGRectMake(105*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X, kScreenWidth-105*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.lineImageView1.frame = CGRectMake(105*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.nameTextField.frame)-1, kScreenWidth-105*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    
    self.enterpriseTextField.frame = CGRectMake(105*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.nameTextField.frame), kScreenWidth-105*AUTO_SIZE_SCALE_X -146.5*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.verticalLineImageView.frame = CGRectMake(CGRectGetMaxX(self.enterpriseTextField.frame)-1, CGRectGetMaxY(self.nameTextField.frame)+15*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    self.jobTitleTextField.frame = CGRectMake(CGRectGetMaxX(self.verticalLineImageView.frame)+10*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.nameTextField.frame), 146.5*AUTO_SIZE_SCALE_X-10*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.lineImageView2.frame = CGRectMake(105*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.enterpriseTextField.frame)-1, kScreenWidth-105*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    
    self.IntroduceTextField.frame = CGRectMake(105*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.jobTitleTextField.frame), kScreenWidth-105*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.lineImageView3.frame = CGRectMake(105*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.IntroduceTextField.frame)-1,kScreenWidth-105*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    
    self.locationTextField.frame = CGRectMake(105*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.IntroduceTextField.frame), kScreenWidth-105*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    
    self.companyFullNameTextField.frame  = CGRectMake(0, CGRectGetMaxY(self.headbgView.frame)+10*AUTO_SIZE_SCALE_X, kScreenWidth, 50*AUTO_SIZE_SCALE_X);

    self.postcatUploadbgView.frame = CGRectMake(0, CGRectGetMaxY(self.companyFullNameTextField.frame)+10*AUTO_SIZE_SCALE_X, kScreenWidth, 285*AUTO_SIZE_SCALE_X);
    self.postCartLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth - 30*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.lineImageView4.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X-1, kScreenWidth - 30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);

    self.cardImageView.frame = CGRectMake(25*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.postCartLabel.frame)+15*AUTO_SIZE_SCALE_X, 325*AUTO_SIZE_SCALE_X, 175*AUTO_SIZE_SCALE_X);
     self.cardImageView.image = [CommentMethod imageWithSize:_cardImageView.frame.size borderColor:FontUIColorGray borderWidth:0.5*AUTO_SIZE_SCALE_X];
    self.plusImageView.frame = CGRectMake(137.5*AUTO_SIZE_SCALE_X, 50.5*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
    self.cardPlusLabel.frame = CGRectMake(0,CGRectGetMaxY(self.plusImageView.frame)+7*AUTO_SIZE_SCALE_X, self.cardImageView.frame.size.width, 20*AUTO_SIZE_SCALE_X);
    
    AttentionView *sharedView;
    sharedView = [[AttentionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
   
}
#pragma mark - event response
- (void)onUserImageClick:(UITapGestureRecognizer *)sender{
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
        
        NSLog(@"localFile = %@",localFile);
        
        NSDictionary *dic = @{};
        
        [[RequestManager shareRequestManager]SubmitImage:dic sendData:imageData WithFileName:fileName WithHeader:dic viewController:self successData:^(NSDictionary *result){
            if (selecttag == 1000001) {
                _c_photo  = [[result objectForKey:@"data"] objectForKey:@"url"];
                
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_c_photo]];
            }
            if (selecttag == 1000002 || selecttag == 1000003) {
                _c_card  = [[result objectForKey:@"data"] objectForKey:@"url"];
                [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:_c_card]];
                self.plusImageView.hidden = YES;
                self.cardPlusLabel.hidden = YES;
            }
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            [self hideHud];
        }];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kBossComingPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kBossComingPage];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

- (BOOL)shouldShowShadowImage{
    return  YES;
}

-(UIView *)headbgView{
    if (_headbgView == nil) {
        _headbgView = [UIView new];
        _headbgView.backgroundColor = [UIColor whiteColor];
        _headbgView.userInteractionEnabled = YES;
    }
    return _headbgView;
}

-(UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [UIImageView new];
        self.headImageView.backgroundColor = [UIColor clearColor];
        self.headImageView.layer.cornerRadius = 55/2;
        self.headImageView.layer.borderWidth= 0;
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
        [self.headImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.tag = 1000001;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageClick:)];
        [self.headImageView addGestureRecognizer:singleTap];
        
    }
    return  _headImageView;
}

- (UILabel *)headLabel{
    if (_headLabel == nil) {
        _headLabel = [UILabel new];
        _headLabel.text = @"上传头像";
        _headLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _headLabel.textColor = FontUIColorBlack;
        _headLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headLabel;
}

-(UITextField *)nameTextField{
    if (_nameTextField == nil) {
        _nameTextField = [UITextField new];
        _nameTextField.placeholder = @"请填写真实姓名";
//        _nameTextField.delegate = self;
        _nameTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.tintColor = RedUIColorC1;
//        [_nameTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _nameTextField.backgroundColor = [UIColor clearColor];
    }
    return _nameTextField;
}

-(UIImageView *)lineImageView1{
    if (_lineImageView1 == nil) {
        _lineImageView1 = [UIImageView new];
        _lineImageView1.backgroundColor =lineImageColor;
    }
    return _lineImageView1;
}

- (UITextField *)enterpriseTextField {
    if (_enterpriseTextField == nil) {
        _enterpriseTextField =  [CommentMethod createTextFieldWithPlaceholder:@"请填写企业简称" TextColor:FontUIColorBlack Font:14 KeyboardType:UIKeyboardTypeDefault];
        _enterpriseTextField.tintColor = RedUIColorC1;
    }
    return _enterpriseTextField;
}

-(UIImageView *)verticalLineImageView{
    if (_verticalLineImageView == nil) {
        _verticalLineImageView = [UIImageView new];
        _verticalLineImageView.backgroundColor =lineImageColor;
    }
    return _verticalLineImageView;
}

- (UITextField *)jobTitleTextField {
    if (_jobTitleTextField == nil) {
        _jobTitleTextField =  [CommentMethod createTextFieldWithPlaceholder:@"请填写职位" TextColor:FontUIColorBlack Font:14 KeyboardType:UIKeyboardTypeDefault];
        _jobTitleTextField.tintColor = RedUIColorC1;
    }
    return _jobTitleTextField;
}

-(UIImageView *)lineImageView2{
    if (_lineImageView2 == nil) {
        _lineImageView2 = [UIImageView new];
        _lineImageView2.backgroundColor =lineImageColor;
    }
    return _lineImageView2;
}

- (UITextField *)IntroduceTextField {
    if (_IntroduceTextField == nil) {
        _IntroduceTextField =  [CommentMethod createTextFieldWithPlaceholder:@"请填写一句话介绍（你的成就或优势等）" TextColor:FontUIColorBlack Font:14 KeyboardType:UIKeyboardTypeDefault];
        _IntroduceTextField.tintColor = RedUIColorC1;
    }
    return _IntroduceTextField;
}

-(UIImageView *)lineImageView3{
    if (_lineImageView3 == nil) {
        _lineImageView3 = [UIImageView new];
        _lineImageView3.backgroundColor =lineImageColor;
    }
    return _lineImageView3;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1111111) {
        [self selectAreaCode];
        return NO;
    }
    return YES;
}

-(void)selectAreaCode{
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
        [self.locationTextField setText:address];
        NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
        c_area =temparray[temparray.count-1];
    } cancelBlock:^{
        
    }];
}
- (UITextField *)locationTextField{
    if (_locationTextField == nil) {
        _locationTextField =  [CommentMethod createTextFieldWithPlaceholder:@"请选择位置" TextColor:FontUIColorBlack Font:14 KeyboardType:UIKeyboardTypeDefault];
//        _locationTextField.userInteractionEnabled = NO;
//        _locationTextField addTarget:self action:@selector(locationOnclick) forControlEvents:
        _locationTextField.delegate = self;
        _locationTextField.tag = 1111111;
        
    }
    return _locationTextField;
}

- (UITextField *)companyFullNameTextField{
    if (_companyFullNameTextField == nil) {
        _companyFullNameTextField =  [CommentMethod createTextFieldWithPlaceholder:@"请填写企业全称" TextColor:FontUIColorBlack Font:14 KeyboardType:UIKeyboardTypeDefault];
        [CommentMethod setTextFieldLeftPadding:_companyFullNameTextField forWidth:15*AUTO_SIZE_SCALE_X];
        [CommentMethod setTextFieldRightPadding:_companyFullNameTextField forWidth:15*AUTO_SIZE_SCALE_X];
        _companyFullNameTextField.tintColor = RedUIColorC1;
        _companyFullNameTextField.backgroundColor = [UIColor whiteColor];
    }
    return _companyFullNameTextField;
}

- (UILabel *)postCartLabel{
    if (_postCartLabel == nil) {
        _postCartLabel = [UILabel new];
        _postCartLabel.text = @"个人名片（选填，仅用于身份验证，不会公开）";
        _postCartLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _postCartLabel.textColor = FontUIColorBlack;
        _postCartLabel.textAlignment = NSTextAlignmentLeft;
        _postCartLabel.backgroundColor = [UIColor whiteColor];
    }
    return _postCartLabel;
}

-(UIImageView *)lineImageView4{
    if (_lineImageView4 == nil) {
        _lineImageView4 = [UIImageView new];
        _lineImageView4.backgroundColor =lineImageColor;
    }
    return _lineImageView4;
}

-(UIImageView *)cardImageView{
    if (_cardImageView==nil) {
        _cardImageView = [UIImageView new];
        _cardImageView.backgroundColor = [UIColor whiteColor];
        _cardImageView.userInteractionEnabled = YES;
        _cardImageView.tag = 1000003;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageClick:)];
        [_cardImageView addGestureRecognizer:singleTap1];
    }
    return _cardImageView;
}

-(UILabel *)cardPlusLabel{
    if (_cardPlusLabel==nil) {
        self.cardPlusLabel = [UILabel new];
        self.cardPlusLabel.backgroundColor = [UIColor clearColor];
        self.cardPlusLabel.textColor = FontUIColorGray;
        self.cardPlusLabel.text =@"点击上传个人名片";
        self.cardPlusLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.cardPlusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cardPlusLabel;
}

- (UIImageView *)plusImageView {
    if (_plusImageView == nil) {
        _plusImageView = [UIImageView new];
        _plusImageView.userInteractionEnabled = YES;
        _plusImageView.image =[UIImage imageNamed:@"list_icon_upload"];
        _plusImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [_plusImageView setContentMode:UIViewContentModeScaleAspectFill];
        _plusImageView.clipsToBounds = YES;
        self.plusImageView.tag = 1000002;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageClick:)];
        [_plusImageView addGestureRecognizer:singleTap];
        
    }
    return _plusImageView;
}

-(UIView *)postcatUploadbgView{
    if (_postcatUploadbgView == nil) {
        _postcatUploadbgView = [UIView new];
        _postcatUploadbgView.backgroundColor = [UIColor whiteColor];
    }
    return _postcatUploadbgView;
}

- (BOOL)isFirstLaunch{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *lastRunVersion = [DEFAULTS objectForKey:@"first_run_version_of_application_attetntion"];
    if (!lastRunVersion) {
        [DEFAULTS setValue:@"0" forKey:@"IS_updateversion_attention"];
        [DEFAULTS setObject:currentVersion forKey:@"first_run_version_of_application_attetntion"];
        [DEFAULTS synchronize];
        return YES;
    }else if (![lastRunVersion isEqualToString:currentVersion]) {
        [DEFAULTS setValue:@"1" forKey:@"IS_updateversion_attention"];
        [DEFAULTS setObject:currentVersion forKey:@"first_run_version_of_application_attetntion"];
        [DEFAULTS synchronize];
        return YES;
    }
    [DEFAULTS setValue:@"0" forKey:@"IS_updateversion_attention"];
    [DEFAULTS synchronize];
    return NO;
}
@end
