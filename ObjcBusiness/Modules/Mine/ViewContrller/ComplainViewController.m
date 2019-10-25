//
//  ComplainViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ComplainViewController.h"
#import "UIImageView+WebCache.h"
#import "FileUploadHelper.h"
#import "TOCropViewController.h"
@interface ComplainViewController ()<UITextViewDelegate,
        UICollectionViewDelegate,UIGestureRecognizerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,UINavigationControllerDelegate,
TOCropViewControllerDelegate>{
    
    NSURL *refURL;
    
}
@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle; //The cropping style
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UILabel *wordCountLabel;

@end
@implementation ComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgation];
    [self initSubViews];
    if(self.feedback_kind == 0){
        self.title = @"反馈";
    }else{
        self.title = @"举报";
    }
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

-(void)saveButton{
    //防止按钮快速点击造成多次响应的避免方法
    //    [[selfclass] cancelPreviousPerformRequestsWithTarget:selfselector:@selector(todoSomething:)object:sender];
    //
    //    [self performSelector:@selector(todoSomething:)withObject:sender afterDelay:0.2f];
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(save)object:nil];
    [self performSelector:@selector(save) withObject:nil afterDelay:0.2f];
}

-(BOOL)isPhoneNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

- (void)save{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.complainLabel.text.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"投诉内容不能为空，请尽量详细的描述您的问题" viewController:self];
        return;
    }
    
    NSMutableString *picStr =[NSMutableString string];
    if (self.photoArrayM.count>1) {
        for (NSString *temp in self.photoArrayM) {
            [picStr appendFormat:@"%@,", temp];
        }
        [picStr deleteCharactersInRange:NSMakeRange(picStr.length-1, 1)];
    }else if(self.photoArrayM.count==1){
        picStr =self.photoArrayM[0];
    }else{
        
    }
    
    if (self.complainLabel.text.length > 150) {
        [[RequestManager shareRequestManager] tipAlert:@"投诉内容最多150个字" viewController:self];
        return;
    }
    
    if(self.contactTextField.text.length > 0){
        if (![self isPhoneNumber:self.contactTextField.text]) {
            [[RequestManager shareRequestManager] tipAlert:@"手机号输入有误" viewController:self];
            return;
        }
    }
    NSString *feedback_kindStr ;
    if(self.feedback_kind == 0){
        feedback_kindStr =@"0";
    }else{
        feedback_kindStr = [NSString stringWithFormat:@"%ld",self.feedback_kind];
    }
    NSDictionary *dic = @{
                          
                          @"feedback_content":self.complainLabel.text,
                          @"_feedback_pics":picStr,
                          @"_feedback_tel":self.contactTextField.text,
                          @"source":@"2",
                          @"feedback_kind":feedback_kindStr,
                          @"_feedback_obj_kind":[NSString stringWithFormat:@"%ld",self.reportType],
                          @"_feedback_obj_id":[NSString stringWithFormat:@"%ld",self.reportFromID],
                          
                          };
    
//    NSLog(@"dic----SubmitFeedbackResult-->%@",dic);
    [[RequestManager shareRequestManager] SubmitFeedbackResult:dic viewController:self successData:^(NSDictionary *result){
        if(IsSucess(result) == 1){
            if (result !=nil) {
                [[RequestManager shareRequestManager] tipAlert:@"提交成功，我们将在5个工作日内与您联系" viewController:self];
                [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
            
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        
    }];
    
}

-(void)returnListPage{
    if (self.FromProjectFlag) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initSubViews {
    self.title = @"反馈问题";

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.complainLabel];
    [self.view addSubview:self.wordCountLabel];
    [self.view addSubview:self.contactLabel];
    [self.view addSubview:self.contactTextField];
    [self.view addSubview:self.lineImageView];
    [self.view addSubview:self.feedbackLabel];
    

    //创建collectionView进行上传图片
    [self.view addSubview:self.collectionBGView];
    self.collectionBGView.frame = CGRectMake(0, kNavHeight+270.5*AUTO_SIZE_SCALE_X, kScreenWidth,75*AUTO_SIZE_SCALE_X + 36*AUTO_SIZE_SCALE_X);
    [self addCollectionViewPicture];
    

    //上传图片的button
    self.photoBtn = [UIImageView new];
    self.photoBtn.frame = CGRectMake(15 , 18*AUTO_SIZE_SCALE_X,75*AUTO_SIZE_SCALE_X, 75*AUTO_SIZE_SCALE_X);
    self.photoBtn.image = [self imageWithSize:self.photoBtn.frame.size borderColor:FontUIColorGray borderWidth:0.5*AUTO_SIZE_SCALE_X];
    self.photoBtn.userInteractionEnabled = YES;
    [self.photoBtn addSubview:self.plusImageView];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picureUpload:)];
    [self.photoBtn addGestureRecognizer:tap4];
    [self.collectionBGView addSubview:self.photoBtn];
    
}

-(void)picureUpload:(UITapGestureRecognizer *)sender{
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

#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArrayM.count == 0) {
        return 0;
    }
    else{
        return _photoArrayM.count;
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.photoV sd_setImageWithURL:[NSURL URLWithString:self.photoArrayM[indexPath.item]]  placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelImageView:)];
    cell.userInteractionEnabled = YES;
    cell.cancelImageView.tag =indexPath.item;
    cell.cancelImageView.userInteractionEnabled =  YES;
    [cell.cancelImageView addGestureRecognizer:tap4];
    return cell;
}

-(void)cancelImageView:(UITapGestureRecognizer *)sender{
    [self.photoArrayM removeObjectAtIndex:sender.view.tag];
    [self viewWillAppear:YES];
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
            //            NSLog(@"%@",[[result objectForKey:@"data"] objectForKey:@"url"]);
            [self.photoArrayM addObject:[[result objectForKey:@"data"] objectForKey:@"url"]];
            //选取完图片之后关闭视图
            //            NSLog(@"phtotArrayM----%@",self.photoArrayM);
            [self viewWillAppear:YES];
            
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
            [self hideHud];
            
            //        failView.hidden = NO;
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


//把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        
        return NO;
    }
    
    return YES;
}

#pragma mark dfd
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length <= 150) {
        
    }else{
        [self.view endEditing:YES];
    }
    return nil;
}

#pragma mark textField的字数限制
//在这个地方计算输入的字数

- (void)textViewDidChange:(UITextView *)textView
{
   
    NSString * temp = textView.text;
    if (textView.markedTextRange ==nil){
        while(1){
            if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 150 ) {
                break;
            }else{
                temp = [temp substringToIndex:temp.length-1];
                
            }
        }
        textView.text=temp;
        NSInteger wordCount = textView.text.length;
        self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/150",(long)wordCount];
    }
    [self wordLimit:textView];
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
    [MobClick beginLogPageView:kfeedbackPage];
    if (self.photoArrayM.count < 3) {
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(
                                         15*(self.photoArrayM.count + 1) + 75*AUTO_SIZE_SCALE_X * self.photoArrayM.count,
                                         18*AUTO_SIZE_SCALE_X,
                                         75*AUTO_SIZE_SCALE_X,
                                         75*AUTO_SIZE_SCALE_X
                                         );
        self.photoBtn.hidden = NO;
    }else{
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(0, 0, 0, 0);
        self.photoBtn.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kfeedbackPage];
}

-(void)addCollectionViewPicture{
    //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake(75*AUTO_SIZE_SCALE_X , 75*AUTO_SIZE_SCALE_X);
    flowL.sectionInset = UIEdgeInsetsMake(18*AUTO_SIZE_SCALE_X,15, 18*AUTO_SIZE_SCALE_X, 15);
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 75*AUTO_SIZE_SCALE_X + 36*AUTO_SIZE_SCALE_X) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor clearColor];
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [self.collectionBGView addSubview:_collectionV];
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}


-(UITextView *)complainLabel{
    if (_complainLabel == nil) {
        _complainLabel = [[UITextView alloc] initWithFrame:CGRectMake(25*AUTO_SIZE_SCALE_X, kNavHeight+25*AUTO_SIZE_SCALE_X, kScreenWidth-50*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_X)];
        _complainLabel.layer.borderWidth = 0;
        _complainLabel.font = [UIFont systemFontOfSize:14];
        _complainLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _complainLabel.zw_placeHolder = @"请详细描述您遇到的问题，如果需要图片，请上传图片";
        _complainLabel.zw_placeHolderColor = FontUIColor999999Gray;
        _complainLabel.textColor = FontUIColorBlack;
        _complainLabel.tintColor = RedUIColorC1;
        _complainLabel.delegate = self;
        
    }
    return _complainLabel;
}

-(UILabel *)wordCountLabel{
    if (_wordCountLabel == nil) {
        _wordCountLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:14 TextColor:FontUIColor999999Gray];
        _wordCountLabel.frame = CGRectMake(kScreenWidth-80*AUTO_SIZE_SCALE_X-25*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.complainLabel.frame)+5*AUTO_SIZE_SCALE_X, 80*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
        
    }
    return _wordCountLabel;
}

-(UILabel *)contactLabel{
    if (_contactLabel == nil) {
        _contactLabel = [CommentMethod initLabelWithText:@"联系方式（选填）" textAlignment:NSTextAlignmentLeft font:16 TextColor:FontUIColorBlack];
        _contactLabel.frame = CGRectMake(25*AUTO_SIZE_SCALE_X, kNavHeight+134*AUTO_SIZE_SCALE_X, kScreenWidth-50*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
        
        
    }
    return _contactLabel;
}

-(UILabel *)feedbackLabel{
    if (_feedbackLabel == nil) {
        _feedbackLabel = [CommentMethod initLabelWithText:@"反馈图片（选填）" textAlignment:NSTextAlignmentLeft font:16 TextColor:FontUIColorBlack];
        _feedbackLabel.frame = CGRectMake(25*AUTO_SIZE_SCALE_X, kNavHeight+240*AUTO_SIZE_SCALE_X, kScreenWidth-50*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
        
    }
    return _feedbackLabel;
}

- (UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
        [_lineImageView setFrame:CGRectMake(25*AUTO_SIZE_SCALE_X,  kNavHeight+209*AUTO_SIZE_SCALE_X, kScreenWidth-50*AUTO_SIZE_SCALE_X, 0.5)];
    }
    return _lineImageView;
}

- (UITextField *)contactTextField{
    if (_contactTextField == nil) {
        _contactTextField = [[UITextField alloc] init];
        _contactTextField.placeholder = @"用于通知反馈结果";
        _contactTextField.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _contactTextField.keyboardType = UIKeyboardTypeNumberPad;
        _contactTextField.textAlignment = NSTextAlignmentLeft;
        _contactTextField.tintColor  =  RedUIColorC1;
        _contactTextField.frame = CGRectMake(25*AUTO_SIZE_SCALE_X, kNavHeight+180*AUTO_SIZE_SCALE_X, kScreenWidth-50*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X);
        [_contactTextField addTarget:self action:@selector(fieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _contactTextField;
}

#pragma mark - 按钮点击事件
-(void)fieldChanged:(id)sender
{
    UITextField  *textField =  (UITextField*)sender;
    NSString * temp = textField.text;
    if (textField.markedTextRange ==nil){
        while(1){
            if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 11) {
                break;
            }else{
                temp = [temp substringToIndex:temp.length-1];
            }
        }
        textField.text=temp;
    }
    
}

- (UIView *)collectionBGView {
    if (_collectionBGView == nil) {
        _collectionBGView = [UIView new];
        _collectionBGView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionBGView;
}

- (NSMutableArray *)photoArrayM{
    if (_photoArrayM==nil) {
        _photoArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArrayM;
}

-(UIImageView *)plusImageView{
    if (_plusImageView == nil) {
        self.plusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X)];
        self.plusImageView.image =[UIImage imageNamed:@"list_icon_upload"];
    }
    return _plusImageView;
}

-(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
