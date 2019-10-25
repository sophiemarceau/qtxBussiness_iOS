//
//  CreateProjectViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "CreateProjectViewController.h"
#import "BaseTableView.h"
#import "BaseViewController.h"
#import "CDZBaseCell.h"
#import "TextWthInputFieldCell.h"
#import "TextWithMarginCell.h"
#import "TextWithLineCell.h"
#import "ResumeTableItem.h"
#import "BottomButtonView.h"
#import "MOFSPickerManager.h"
#import "TextPlaceCell.h"
#import "BaseTableView.h"
#import "UIImageView+WebCache.h"
#import "ResumePersonalInfoCell.h"
#import "DistrictManager.h"
#import "CreateProjectHeaderView.h"
#import "DetailTextViewTableViewCell.h"
#import "LabelTableViewCell.h"
#import "TextFieldBaseCell.h"
#import "AddPolicyViewController.h"
#import "ComingSuccedViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileUploadHelper.h"
#import "AttentionView.h"
#import "TOCropViewController.h"
#import "MOFSPickerManager.h"
#import "UIImageView+WebCache.h"
#import "DistrictManager.h"

@interface CreateProjectViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate,SelectComingPolicyDelegate>{
    NSDictionary *dtoDictionary;
    MOFSPickerManager *mofPickerManager;
    NSString *projectLogo_Str;//项目图片
    NSString *projectName_Str;//项目名称
    NSString *intention_industry;//项目所属行业code
    NSString *project_introductStr;//项目介绍
    NSString *projectDetail_noteStr;//项目详情
    NSString *_mode_place_demands;
    NSString *_mode_place_area ;
    NSString *_mode_area ;
    NSString *_mode_amount;
    NSURL *refURL;
    NSIndexPath * selectindexPath;
    NSArray *industryArray;
    NSDictionary *cooperDic;
}
@property (nonatomic,strong) BaseTableView *Tableview;
@property (nonatomic,strong) NSMutableArray *projectMutableArray;
@property (nonatomic,strong) NSMutableArray *placesMutableArray,*placeOfBusinessMutableArray;
@property (nonatomic,strong) NSMutableArray *opennessMutableArray;
@property (nonatomic,strong) NSMutableArray *intentionAmountMutableArray;


@property (nonatomic,strong) noWifiView *failView;
@property (nonatomic,assign) TOCropViewCroppingStyle croppingStyle; //The cropping style
@property (nonatomic,strong) UIImage *image;

@end

@implementation CreateProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mofPickerManager = [[MOFSPickerManager alloc] init];
    if (self.viewType == CreateProject) {
        self.title = @"创建项目";
    }else{
        self.title = @"编辑项目";
    }
    projectLogo_Str=projectName_Str=intention_industry=project_introductStr=projectDetail_noteStr = _mode_place_demands =_mode_place_area =_mode_area = _mode_amount = @"";
    
    [self initNavgation];
    [self initSubViews];
    [self loadData];
}

#pragma mark TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projectMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResumeTableItem *item ;
    item = self.projectMutableArray[indexPath.row];
    Class cls = [self cellClassAtIndexPath:item];
    return [cls tableView:tableView rowHeightForObject:self.projectMutableArray[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResumeTableItem *item ;
    item = self.projectMutableArray[indexPath.row];
    CDZBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
    if (!cell) {
        Class cls = [self cellClassAtIndexPath:item];
        cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
    }

    cell.backgroundColor = BGColorGray;
    [cell setResumeTableItem:self.projectMutableArray[indexPath.row]];
//    ResumeTableItem *itemtemp = self.projectMutableArray[indexPath.row];
//    if ([item.name isEqualToString:@"联系方式（可选）"]) {
//        [((TextWthInputFieldCell *)cell).phoneTextField setText:itemtemp.functionValue];
//        [((TextWthInputFieldCell *)cell).phoneTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResumeTableItem *item = self.projectMutableArray[indexPath.row];
    selectindexPath = indexPath;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (item.showtype == ProjectPicUpload) {
        [self photoMethod];
    }
    if ([item.name isEqualToString:@"所属行业"]) {
        [mofPickerManager show2CloumnTradePickerWithTitle:@"" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *TradeStr, NSString *zipcode) {
            NSString *tradeString;
            NSArray *addresstemparray  = [TradeStr componentsSeparatedByString:@"-"];
            if (addresstemparray.count>0) {
                if(addresstemparray.count == 2){
                    if ([addresstemparray[0] isEqualToString: addresstemparray[1]]) {
                        tradeString = [NSString stringWithFormat:@"%@",addresstemparray[0]];
                    }else{
                        tradeString = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[1]];
                    }
                }
            }
            CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((LabelTableViewCell *)cell).ValueLabel setText:tradeString];
            NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
            intention_industry =temparray[temparray.count-1];
        } cancelBlock:^{
        }];
    }
    if ([item.name isEqualToString:@"加盟政策(可选)"]) {
        AddPolicyViewController *vc = [[AddPolicyViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
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
        
//        NSLog(@"localFile = %@",localFile);
        
        NSDictionary *dic = @{};
        
        [[RequestManager shareRequestManager]SubmitImage:dic sendData:imageData WithFileName:fileName WithHeader:dic viewController:self successData:^(NSDictionary *result){
            CDZBaseCell *cell = [self.Tableview cellForRowAtIndexPath:selectindexPath];
            [((CreateProjectHeaderView *)cell).projectImageView sd_setImageWithURL: [NSURL URLWithString:[[result objectForKey:@"data"] objectForKey:@"url"]]];
            projectLogo_Str = [[result objectForKey:@"data"] objectForKey:@"url"];
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

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

-(void)loadData{
    if(self.viewType ==CreateProject){
        ResumeTableItem *itemA = [ResumeTableItem new];
        itemA.showtype = ProjectPicUpload;
        itemA.isShowLineImageFlag = NO;//不隐藏.
        itemA.functionValue = @"";
        
        ResumeTableItem *itemB = [ResumeTableItem new];
        itemB.showtype = LabelText;
        itemB.name = @"项目名称";
        itemB.isUserInteractFlag = YES;
        itemB.isShowLineImageFlag = NO;//不隐藏.
        itemB.isNumberKeyboardFlag = NO;
        itemB.functionValue = @"";
        itemB.placeholderValue = @"15字以内，提交后不可更改";
        
        ResumeTableItem *itemC = [ResumeTableItem new];
        itemC.showtype = LabelText;
        itemC.name = @"所属行业";
        itemC.isShowLineImageFlag = NO;//不隐藏
        itemC.isUserInteractFlag = NO;
        itemC.functionValue = @"";
        itemC.placeholderValue = @"请选择所属行业，提交后不可更改";
        
        ResumeTableItem *itemD = [ResumeTableItem new];
        itemD.showtype = LabelText;
        itemD.name = @"一句话介绍";
        itemD.isShowLineImageFlag = NO;//隐藏
        itemD.isUserInteractFlag = YES;
        itemD.isNumberKeyboardFlag = NO;
        itemD.functionValue = @"";
        itemD.placeholderValue = @"请简单的介绍下您的项目";
        
        ResumeTableItem *itemE = [ResumeTableItem new];
        itemE.showtype = TextFieldText;
        itemE.name = @"加盟政策(可选)";
        itemE.isShowLineImageFlag = YES;
        itemE.functionValue =  @"";
        itemE.placeholderValue = @"未添加";
        
        ResumeTableItem *itemF = [ResumeTableItem new];
        itemF.showtype = TextViewInput;
        itemF.isShowLineImageFlag = YES;
        itemF.functionValue =  projectDetail_noteStr = @"";
        
        [self.projectMutableArray addObject:itemA];
        [self.projectMutableArray addObject:itemB];
        [self.projectMutableArray addObject:itemC];
        [self.projectMutableArray addObject:itemD];
        [self.projectMutableArray addObject:itemE];
        [self.projectMutableArray addObject:itemF];
        [self.Tableview reloadData];
    }else{
        [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
        [self.projectMutableArray removeAllObjects];
        NSDictionary *dic = @{};
        [[RequestManager shareRequestManager] getBossProjectDtoByUserId:dic viewController:self successData:^(NSDictionary *result) {
            if (IsSucess(result) == 1) {
                dtoDictionary = [[result objectForKey:@"data"] objectForKey:@"result"];
                if(![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil){
                    ResumeTableItem *itemA = [ResumeTableItem new];
                    itemA.showtype = ProjectPicUpload;
                    itemA.isShowLineImageFlag = NO;//不隐藏.
                    itemA.functionValue = @"";
                    
                    ResumeTableItem *itemB = [ResumeTableItem new];
                    itemB.showtype = LabelText;
                    itemB.name = @"项目名称";
                    itemB.isUserInteractFlag = YES;
                    itemB.isShowLineImageFlag = NO;//不隐藏.
                    itemB.isNumberKeyboardFlag = NO;
                    itemB.functionValue = projectName_Str = [NSString stringWithFormat:@"%@",dtoDictionary[@"project_name"]];
                    itemB.placeholderValue = @"15字以内，提交后不可更改";
                    
                    ResumeTableItem *itemC = [ResumeTableItem new];
                    itemC.showtype = LabelText;
                    itemC.name = @"所属行业";
                    itemC.isShowLineImageFlag = NO;//不隐藏
                    itemC.isUserInteractFlag = NO;
                    itemC.functionValue = [NSString stringWithFormat:@"%@",dtoDictionary[@"project_industry_name"]];
                    itemC.placeholderValue = @"请选择所属行业，提交后不可更改";
                    project_introductStr =  [NSString stringWithFormat:@"%@",dtoDictionary[@"project_industry"]];
                    
                    ResumeTableItem *itemD = [ResumeTableItem new];
                    itemD.showtype = LabelText;
                    itemD.name = @"一句话介绍";
                    itemD.isShowLineImageFlag = NO;//隐藏
                    itemD.isUserInteractFlag = YES;
                    itemD.isNumberKeyboardFlag = NO;
                    itemD.functionValue = projectDetail_noteStr = [NSString stringWithFormat:@"%@",dtoDictionary[@"project_slogan"]];
                    itemD.placeholderValue = @"请简单的介绍下您的项目";
                    
                    ResumeTableItem *itemE = [ResumeTableItem new];
                    itemE.showtype = TextFieldText;
                    itemE.name = @"加盟政策(可选)";
                    itemE.isShowLineImageFlag = YES;
                    itemE.functionValue = @"";
                    itemE.placeholderValue = @"未添加";
                    cooperDic =  dtoDictionary[@"projectCooperationModeDto"];
                    if (cooperDic != nil) {
                        itemE.functionValue =  @"已添加";
                        _mode_place_demands = [cooperDic objectForKey:@"_mode_place_demands"];
                        _mode_place_area = [cooperDic objectForKey:@"_mode_place_area"];
                        _mode_area = [cooperDic objectForKey:@"_mode_area"];
                        _mode_amount = [cooperDic objectForKey:@"_mode_amount"];
                    }
                    
                    ResumeTableItem *itemF = [ResumeTableItem new];
                    itemF.showtype = TextViewInput;
                    itemF.isShowLineImageFlag = YES;
                    itemF.functionValue = projectDetail_noteStr = dtoDictionary[@"project_content"];
                    
                    [self.projectMutableArray addObject:itemA];
                    [self.projectMutableArray addObject:itemB];
                    [self.projectMutableArray addObject:itemC];
                    [self.projectMutableArray addObject:itemD];
                    [self.projectMutableArray addObject:itemE];
                    [self.projectMutableArray addObject:itemF];
                    
                    [self.Tableview reloadData];
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
}

-(void)SelectComingPolicyDelegateReturnPage:(NSDictionary *)returnDictionary{
    if (returnDictionary != nil) {
        TextFieldBaseCell *cell4 = [self.Tableview cellForRowAtIndexPath: [NSIndexPath indexPathForRow:4  inSection:0]];
        cell4.ValueLabel.text = @"已添加";
        
        _mode_place_demands = [returnDictionary objectForKey:@"_mode_place_demands"];
        _mode_place_area = [returnDictionary objectForKey:@"_mode_place_area"];
        _mode_area = [returnDictionary objectForKey:@"_mode_area"];
        _mode_amount = [returnDictionary objectForKey:@"_mode_amount"];
    }else{
        
        TextFieldBaseCell *cell4 = [self.Tableview cellForRowAtIndexPath: [NSIndexPath indexPathForRow:4  inSection:0]];
        cell4.ValueLabel.text = @"";
        cell4.ValueLabel.placeholder = @"未添加";
         _mode_place_demands =_mode_place_area =_mode_area = _mode_amount = @"";
    }
}
- (void)saveButton:(UIButton *)button{
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
    self.Tableview.userInteractionEnabled = NO;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    CDZBaseCell *cell0 = [self.Tableview cellForRowAtIndexPath: [NSIndexPath indexPathForRow:1  inSection:0]];
    projectName_Str = ((LabelTableViewCell *)cell0).ValueLabel.text;//项目名称
    CDZBaseCell *cell3 = [self.Tableview cellForRowAtIndexPath: [NSIndexPath indexPathForRow:3  inSection:0]];
    project_introductStr = ((LabelTableViewCell *)cell3).ValueLabel.text;//项目介绍
    
//    NSString *whetherAddPolicyStr;//是否添加加盟政策
    CDZBaseCell *cell5 = [self.Tableview cellForRowAtIndexPath: [NSIndexPath indexPathForRow:5  inSection:0]];
    NSString *projectDetail_noteStr = ((DetailTextViewTableViewCell *)cell5).remarksTextView.text;//项目详情
    
    if (projectLogo_Str.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请上传项目logo" viewController:self];
        self.Tableview.userInteractionEnabled = YES;
        button.enabled = YES;
        return;
    }
    
    if (projectName_Str.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写项目名称" viewController:self];
        self.Tableview.userInteractionEnabled = YES;
        button.enabled = YES;
        return;
    }
    
    if (projectName_Str.length > 15) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写项目名称,不得超过15个字" viewController:self];
        self.Tableview.userInteractionEnabled = YES;
        button.enabled = YES;
        return;
    }
    
    if (intention_industry.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择项目所属行业" viewController:self];
        self.Tableview.userInteractionEnabled = YES;
        button.enabled = YES;
        return;
    }
    
    if (project_introductStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请简单介绍下您的项目" viewController:self];
        self.Tableview.userInteractionEnabled = YES;
        button.enabled = YES;
        return;
    }
    
    if (project_introductStr.length > 20) {
        [[RequestManager shareRequestManager] tipAlert:@"请简单的介绍下您的项目,不得超过20个字" viewController:self];
        self.Tableview.userInteractionEnabled = YES;
        button.enabled = YES;
        return;
    }
    
    if (projectDetail_noteStr.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写项目详情" viewController:self];
        self.Tableview.userInteractionEnabled = YES;
        button.enabled = YES;
        return;
    }
    NSDictionary *dic = @{
                          @"project_name":projectName_Str,
                          @"project_industry":intention_industry,
                          @"project_slogan":project_introductStr,
                          @"project_cover_pic":projectLogo_Str,
                          @"project_content":projectDetail_noteStr,
                          @"_mode_place_demands":_mode_place_demands,
                          @"_mode_place_area":_mode_place_area,
                          @"_mode_area":_mode_area,
                          @"_mode_amount":_mode_amount,
                          };
//    NSLog(@"dic----->%@",dic);
    [[RequestManager shareRequestManager] createProject4Boss:dic viewController:self successData:^(NSDictionary *result) {
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
    ComingSuccedViewController *vc = [[ComingSuccedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    self.Tableview.userInteractionEnabled = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kCreateProjectPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kCreateProjectPage];
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

-(void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton:)];
    rightBackItem.tintColor = RedUIColorC1;
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)initSubViews{
    [self.view addSubview:self.Tableview];
}

//-(CreateProjectHeaderView *)HeaderTableView{
//    if (_HeaderTableView == nil) {
//        _HeaderTableView = [[CreateProjectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (44+155+10)*AUTO_SIZE_SCALE_X)];
//    }
//    return _HeaderTableView;
//}


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
        [self.Tableview registerClass:[CreateProjectHeaderView class] forCellReuseIdentifier:NSStringFromClass([CreateProjectHeaderView class])];
        [self.Tableview registerClass:[DetailTextViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DetailTextViewTableViewCell class])];
    }
    return _Tableview;
}

-(NSMutableArray *)projectMutableArray{
    if (_projectMutableArray == nil) {
        _projectMutableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _projectMutableArray;
}

@end
