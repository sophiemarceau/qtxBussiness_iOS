//
//  AnswerViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AnswerViewController.h"
#import "UIImage+SLImage.h"
#import "PlaceholderTextView.h"
#import "ImageTextAttachment.h"
#import "NSAttributedString+RichText.h"
#import "UIView+TYAlertView.h"
#import "IQKeyboardManager.h"
#import "FileUploadHelper.h"
#define ImageTag (@"[UIImageView]")
#define MaxLength (2000)
#define BARandomData arc4random_uniform(100)
#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface AnswerViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    NSInteger keyBoardHeight;
    UIView *_toolView;
    
    UIButton *cancleBtn;
    float image_h;
    NSString *_imageBizno;
    NSString *bizNosStr;
    
    UIImageView *anoymouimageView;
    
    
    BOOL _wasKeyboardManagerEnabled;
    UIImage *image;
}
@property (nonatomic,assign)CGFloat lineSapce;    //行间距
@property (nonatomic,copy)NSString *imageName;//图片名
@property (nonatomic,strong)NSData   *imageData;//图片流
@property (nonatomic,strong)PlaceholderTextView *messageInputView;
@property (nonatomic,assign)NSUInteger location;  //纪录变化的起始位置
@property (nonatomic,strong)NSMutableAttributedString *locationStr;
@property (nonatomic,strong)UIButton *anoymousButton;

@end

@implementation AnswerViewController

+(instancetype)ViewController
{
    
    AnswerViewController * ctrl = [[AnswerViewController alloc] initWithNibName:@"RichText" bundle:nil];
    
    return ctrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回答问题";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    image_h = 0;
    bizNosStr = @"";
    
    self.location=0;
    self.lineSapce=5;
    
    [self initNavgation];
    [self initSubViews];
//    [self loadData];
}

-(void)goBack{
    NSString *answerContent = self.messageInputView.text;
    
    if (answerContent.length != 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:
                              @"返回后内容将不会保存，您确定返回吗？"
                              
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
        
        
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
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

-(void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    rightBackItem.tintColor = RedUIColorC1;
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

-(void)initSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.messageInputView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, kScreenWidth - 30*AUTO_SIZE_SCALE_X, 75)];
    self.messageInputView.placeholder = @"请输入答案";
    self.messageInputView.tintColor = RedUIColorC1;
    self.messageInputView.placeholderColor = FontUIColor999999Gray;
    self.messageInputView.textColor = FontUIColorBlack;
    self.messageInputView.delegate = self;
    self.messageInputView.font = [UIFont systemFontOfSize:15];
    self.messageInputView.editable = YES;
    [self.messageInputView becomeFirstResponder];
    self.messageInputView.backgroundColor = [UIColor whiteColor];
    self.messageInputView.layer.masksToBounds = YES;
    self.messageInputView.layer.borderWidth =1.0;
    self.messageInputView.layer.cornerRadius =5.0;
    self.messageInputView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:self.messageInputView];
    
    NSRange wholeRange = NSMakeRange(0, self.messageInputView.textStorage.length);
    [self.messageInputView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [self.messageInputView.textStorage removeAttribute:NSForegroundColorAttributeName range:wholeRange];
    //字体颜色
    [self.messageInputView.textStorage addAttribute:NSForegroundColorAttributeName value:FontUIColorBlack range:wholeRange];
    
    //字体
    [self.messageInputView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X] range:wholeRange];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    _toolView  = [[UIView alloc]init];
    _toolView.backgroundColor = kUIColorFromRGB(0xf0f0f0);
    _toolView.frame = CGRectMake(0, kScreenHeight - kNavHeight, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
    
    [self.view addSubview:_toolView];
    
//    UIButton *losebtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    losebtn.frame = CGRectMake(kScreenWidth - 50, 0, 50, 50);
//    //[btn setBackgroundColor:[UIColor whiteColor]];
//    [losebtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//    [losebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [losebtn setTitle:@"完成" forState:UIControlStateNormal];
//    [_toolView addSubview:losebtn];
    
    
    
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setImage:[UIImage imageNamed:@"answer_icon_add_pic"] forState:UIControlStateNormal];
//    [imageBtn setTitle:@"图片" forState:UIControlStateNormal];
    imageBtn.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X);
    imageBtn.layer.cornerRadius = 17*AUTO_SIZE_SCALE_X;
    imageBtn.layer.masksToBounds = YES;
    [imageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:imageBtn];
    
    [_toolView addSubview:self.anoymousButton];
    self.anoymousButton.frame = CGRectMake(kScreenWidth-70*AUTO_SIZE_SCALE_X, 0, 55*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
//    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
//    cameraBtn.frame = CGRectMake(65, 0, 50, 50);
//    [cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_toolView addSubview:cameraBtn];
}

#pragma mark 取消
-(void)canclebtnBtnClick{
    self.messageInputView.text = @"";
}
#pragma mark 相册
-(void)imageBtnClick
{
    
    UIImagePickerController *photo = [[UIImagePickerController alloc] init];
    photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photo.delegate = self;
    photo.allowsEditing = YES;
    [self presentViewController:photo animated:YES completion:nil];
    
}
#pragma mark 相机
-(void)cameraBtnClick
{
    
    //判断是否可以打开相机，模拟器此功能无法使用
    if (![UIImagePickerController isSourceTypeAvailable:
          
          UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //    imagePicker.allowsEditing = YES;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark 弹下
-(void)btnClick
{
    [self.messageInputView resignFirstResponder];
}

#pragma mark -相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    image  = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    //图片保存时每一张图片都要由一个名字，而相册和拍照中返回的info是不同的，但不管如何，都要想办法给每张图片一个唯一的名字
    if (picker.sourceType ==UIImagePickerControllerSourceTypePhotoLibrary) {
        //获取每张图片的id，用来作为保存在沙盒中的文件名
        NSString *getsrc=[NSString stringWithFormat:@"%@",(NSString *)[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
        NSRange range={33,47};
        self.imageName=[NSString stringWithFormat:@"%@.jpg",[getsrc substringWithRange:range]];
    }
    if (picker.sourceType ==UIImagePickerControllerSourceTypeCamera) {
        self.imageName=[NSString stringWithFormat:@"%@.jpg",[[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"{Exif}"] objectForKey:@"DateTimeDigitized"]];
        self.imageName = [self.imageName stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
    }
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    self.imageName = [NSString stringWithFormat:@"%@%u.jpg",identifierForVendor,BARandomData];
//    [self saveImage:image WithName:self.imageName];
    
//    NSLog(@"imageName--------%@",self.imageName);
    image = [image fixOrientation];
    
    NSString *localFile = [FileUploadHelper PreUploadImagePath:image AndFileName:self.imageName];
//    NSLog(@"localFile = %@",localFile);
    NSData *imageData = [NSData dataWithContentsOfFile:localFile];
    
//    NSLog(@"imageData = %ld",imageData.length);
    
    NSDictionary *dic = @{};
    
    [[RequestManager shareRequestManager] SubmitImage:dic  sendData:imageData  WithFileName:self.imageName WithHeader:dic viewController:self successData:^(NSDictionary *result){
        if (IsSucess(result) == 1) {
            //适配屏幕宽度
            UIImage *image1 = [image scaleToSize:CGSizeMake(kScreenWidth, image.size.height*kScreenWidth/image.size.width)];
            image = [self compressImage:image toMaxFileSize:0.2];
            image_h = image1.size.height;
            ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
            
            image=[imageTextAttachment scaleImage:image withSize:CGSizeMake(kScreenWidth - 30,image_h)];
            //Set tag and image
            imageTextAttachment.image =image;
            
            
            //Set image size
            imageTextAttachment.imageSize = CGSizeMake(kScreenWidth - 30*AUTO_SIZE_SCALE_X,image_h);
            
            //Insert image image
            [self.messageInputView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                                              atIndex:self.messageInputView.selectedRange.location];
            //Move selection location
            self.messageInputView.selectedRange = NSMakeRange(self.messageInputView.selectedRange.location + 1, self.messageInputView.selectedRange.length);
            
            
            //设置字的设置
            [self setInitLocation];
            
            
            NSString *imageTagStr = [NSString stringWithFormat:@"<beginImgUrl>%@<endImgUrl>",result[@"data"][@"url"]];
//            NSLog(@"imageTagStr----->%@",imageTagStr);
            imageTextAttachment.imageTag = imageTagStr;
            //    ImageTag;
            
            //适配屏幕宽度
            [picker dismissViewControllerAnimated:YES completion:nil];
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
        [self.messageInputView becomeFirstResponder];
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
        [self hideHud];
    }];
}

//保存图片至沙盒
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imaName{
    //压缩图片
    self.imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    
    //从沙盒中获取文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imaName];
    //图片流写入沙盒
    BOOL flag =[self.imageData writeToFile:fullPathToFile atomically:YES];
    if (flag) {
//        NSLog(@"图片保存到沙盒成功");
    }
}

#pragma mark 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyBoardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:0.1 animations:^{
        self.messageInputView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,  15*AUTO_SIZE_SCALE_X , kScreenWidth -30*AUTO_SIZE_SCALE_X, kScreenHeight-keyBoardHeight -( (15 + 50)*AUTO_SIZE_SCALE_X + kNavHeight));
        _toolView.frame = CGRectMake(0, kScreenHeight-keyBoardHeight-50*AUTO_SIZE_SCALE_X - kNavHeight, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
    }];
}

#pragma mark 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.1 animations:^{
        self.messageInputView.frame = CGRectMake(15, 15, kScreenWidth -32, kScreenHeight - 15*AUTO_SIZE_SCALE_X - kNavHeight);
        _toolView.frame = CGRectMake(10*AUTO_SIZE_SCALE_X, kScreenHeight+50*AUTO_SIZE_SCALE_X,
                                     kScreenWidth,
                                     50*AUTO_SIZE_SCALE_X);
    }];
}

#pragma mark textViewDelegate
/**
 *  点击图片触发代理事件
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    //    NSLog(@"%@", textAttachment);
    return NO;
}

/**
 *  点击链接，触发代理事件
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [[UIApplication sharedApplication] openURL:URL];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{

}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

-(void)setStyle{
    //每次后拼装
    if (self.messageInputView.textStorage.length<self.location) {
        [self setInitLocation];
        return;
    }
    NSString * str=[self.messageInputView.text substringFromIndex:self.location];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = self.lineSapce;// 字体的行间距
    NSDictionary *attributes=nil;
    attributes = @{
                   NSFontAttributeName:[UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X],
                   NSForegroundColorAttributeName:FontUIColorBlack,
                   NSParagraphStyleAttributeName:paragraphStyle
                   };
    NSAttributedString * appendStr=[[NSAttributedString alloc] initWithString:str attributes:attributes];
    [self.locationStr appendAttributedString:appendStr];
    self.messageInputView.attributedText =self.locationStr;
    //重新设置位置
    self.location=self.messageInputView.textStorage.length;
}

-(void)setInitLocation{
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.messageInputView.attributedText];
    self.messageInputView.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    self.messageInputView.textColor = FontUIColorBlack;
    //重新设置位置
    self.location=self.messageInputView.textStorage.length;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

////导航条设置
//-(void)setNav
//{
//
//    self.title = @"填写文章内容";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    UIButton *goBack = [[UIButton alloc] init];//左边的返回按钮
//    [goBack setBackgroundImage:[UIImage imageNamed:@"newback"] forState:UIControlStateNormal];
//    [goBack addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
//    goBack.frame = CGRectMake(0, 0, 12, 20);
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBack];
//
//    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
//
//
//    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    finishBtn.frame = CGRectMake(0, 0, 50, 25);
//    [finishBtn setTitle:@"提交" forState:UIControlStateNormal];
//    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [finishBtn addTarget:self action:@selector(submitButton) forControlEvents:UIControlEventTouchUpInside];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
//
//}

- (void)goBackClick
{
    [self.navigationController  popViewControllerAnimated:YES];
}

#pragma mark 提交
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
    NSString *url =@"";
    NSArray * arr=[self.messageInputView.attributedText getArrayWithAttributed];
//    NSString * imagearr=[self.messageInputView.attributedText getPlainString];
    
    if (arr.count>0) {
//        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * dict in arr) {
            
            NSString *str;
            
            str = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
            
            
//            [titleArray addObject:str];
//
//
            url = [url stringByAppendingString:str];
        }
        NSString *contentStr = [url substringToIndex:[url length]-1];
//        NSString *contentStr = [titleArray componentsJoinedByString:@","];
//        NSLog(@"文章内容---------%@",contentStr);
        NSString *answer_is_anonymousStr ;
        if (self.anoymousButton.selected) {
            answer_is_anonymousStr = @"1";
        }else{
            answer_is_anonymousStr = @"0";
        }
        
        
        NSDictionary *dic = @{
                              @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],
                              @"answer_content":contentStr,
                              @"answer_is_anonymous":answer_is_anonymousStr
                               };
//        NSLog(@"dic----->%@",dic);
        [[RequestManager shareRequestManager] answerQuestion:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"dic--answerQuestion--->%@",result);
            if (IsSucess(result) == 1) {
                [[RequestManager shareRequestManager] tipAlert:@"发布成功" viewController:self];
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
}


-(void)returnListPage{
//    SubmitSuccessViewController *vc = [[SubmitSuccessViewController alloc] init];
    [self.navigationController popViewControllerAnimated:YES];
}

//    NSArray *array = _displayTagView.tags;
//    if (array.count > 0) {
//        tag_ids = [array componentsJoinedByString:@","];
//    }
//    if ( tag_ids.length == 0 ) {
//        [[RequestManager shareRequestManager] tipAlert:@"请选择您的标签" viewController:self];
//        return;
//    }
//    NSLog(@"save------tag_ids-------------%@", tag_ids);
//    NSDictionary *dic = @{@"question_content":self.questcontentStr,@"_question_content_supplemented":self.questcontentRemarkStr,@"tag_ids":tag_ids};
//    [[RequestManager shareRequestManager]  askQuestion:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"askQuestion------>%@",result);
//        if (IsSucess(result)) {
//            int intergral = [result[@"data"][@"result"][@"integral"] intValue];
//            question_id = [result[@"data"][@"result"][@"question_id"] intValue];
//            if (intergral != 0) {
//                NSString *msg = [NSString stringWithFormat:@"提交成功 首次提交获取%d积分",intergral];
//                [[RequestManager shareRequestManager] tipAlert:msg viewController:self];
//            }else{
//                [[RequestManager shareRequestManager] tipAlert:@"提交成功" viewController:self];
//            }
//            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
//        }
//    } failuer:^(NSError *error) {
//
//    }];
//}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [MobClick endLogPageView:kAnswerPage];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kAnswerPage];
}


//-(void)loadData{
//
//}

-(void)FlagAnoymousButtonClick:(UIButton *)sender{
    self.anoymousButton.selected = !self.anoymousButton.selected;
    if (self.anoymousButton.selected) {
        anoymouimageView.image = [UIImage imageNamed:@"answer_icon_anonymous_selected"];
    }else{
        anoymouimageView.image = [UIImage imageNamed:@"answer_icon_anonymous_normal"];
    }
}

-(UIButton *)anoymousButton{
    if (_anoymousButton == nil) {
        _anoymousButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _anoymousButton.backgroundColor = [UIColor clearColor];
        [_anoymousButton addTarget:self
                                action:@selector(FlagAnoymousButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        anoymouimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"answer_icon_anonymous_normal"]];
        [_anoymousButton addSubview:anoymouimageView];
        anoymouimageView.frame = CGRectMake(0, 17.5*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        UILabel *anoymousLabel = [[UILabel alloc] init];
        anoymousLabel.frame = CGRectMake(CGRectGetMaxX(anoymouimageView.frame)+5*AUTO_SIZE_SCALE_X, 0, 30*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X);
        [_anoymousButton addSubview:anoymousLabel];
        anoymousLabel.text = @"匿名";
        anoymousLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        anoymousLabel.textColor = FontUIColor999999Gray;
        anoymousLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _anoymousButton;
    
}
@end
