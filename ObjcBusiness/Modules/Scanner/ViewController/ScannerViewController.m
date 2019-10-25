//
//  ScannerViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ScannerViewController.h"
#import "ScanView.h"
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVMetaDataObject.h>
#import "ScanViewModel.h"

@interface ScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)ScanView *scanView;
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong)ScanViewModel *scanViewModel;
@end

@implementation ScannerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"登录企业后台网页版";
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.scanViewModel setBlockWithReturnBlock:^(id returnValue, ResopnseFlagState returnFlag, NSString *signalString) {
        
    } WithErrorBlock:^(id errorCode, NSString *errorSignalString) {
        
    }];
   
    [self initSubViews];
}

- (BOOL)shouldShowGobackButton{
    return  NO;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -Navigation
- (void)initNavgation{
    
}

#pragma mark -ScannerView
- (void)initScannerView{
    [self.view addSubview:self.scanView];
    [self.scanView startAnimation];
}

#pragma mark -Camera
- (void)initCamera{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    [self.captureSession beginConfiguration];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    //输入
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error == nil) {
        if ([self.captureSession canAddInput:captureInput]) {
            [self.captureSession addInput:captureInput];
        }
    }else{
//        NSLog(@"Input Error ------>%@",error);
    }
    //输出
    AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if ([self.captureSession canAddOutput:captureOutput]) {
        [self.captureSession addOutput:captureOutput];
        captureOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }

    //添加预览画面
    CALayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    layer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:layer];
    
    [self.captureSession commitConfiguration];
    
    [self.captureSession startRunning];
    
    
}

#pragma mark -TitleView
- (void)initSubViews{
    [self initBackButton];
    [self initNavgation];
    [self initCamera];
    [self initScannerView];
}

-(void)initBackButton{
    UIImage *goBackImage = nil;
    if (self.isModalButton){
        goBackImage =[UIImage imageNamed:@"login_icon_close"];
    }else{
        goBackImage =[UIImage imageNamed:@"nav_back_white"];
    }
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:goBackImage forState:UIControlStateNormal];
    [backButton sizeToFit];
    //点击事件
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    [[UIBarButtonItem alloc] initWithImage:goBackImage style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    leftBackItem.tintColor = UIColorFromRGB(0x1A1A1A);
    [leftBackItem setTitle:@""];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    //      self.navigationItem.leftBarButtonItems = @[negSpaceItem,leftBackItem];
    //      UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithImage:goBackImage style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    //        self.navigationItem.leftBarButtonItems = @[negSpaceItem,leftBackItem];
    //        if (highlightedImage != nil) {
    //
    //            [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    //        }
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    [self.navigationController setNavigationBarHidden:YES];
    [MobClick beginLogPageView:kScannerPagePage];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
 
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //    [self.navigationController setNavigationBarHidden:NO];
    [MobClick endLogPageView:kScannerPagePage];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
    [self.scanView stopAnimation];
}

- (ScanView *)scanView{
    if (_scanView == nil) {
        _scanView = [[ScanView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth,  kScreenHeight-kNavHeight) rectSize:CGSizeMake(260*AUTO_SIZE_SCALE_X, 260*AUTO_SIZE_SCALE_X) offsetY:0*AUTO_SIZE_SCALE_X];
        _scanView.backgroundColor = [UIColor clearColor];
        _scanView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _scanView;
}


#pragma mark- 扫码回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *uuid_qrcode =  nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if (metadata.type == AVMetadataObjectTypeQRCode) {
            uuid_qrcode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }
    if (uuid_qrcode != nil) {
//        NSLog(@"uuid_qrcode---->%@",uuid_qrcode);
        NSDictionary *dic =@{@"uuid_qrcode":uuid_qrcode};
        
        [[RequestManager shareRequestManager] confirmLoginByQRcode4APPRequest:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"uuid_qrcode--result-->%@",result);
            if (IsSucess(result)) {
                int returnFLag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
                if (returnFLag == 1) {
                    [[RequestManager shareRequestManager] tipAlert:@"扫码登录成功" viewController:self];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                }
            }else{
                [self.captureSession startRunning];
                [self.scanView startAnimation];
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
                
            }
           
        } failuer:^(NSError *error) {
        }];
    }
    [self.captureSession stopRunning];
    [self.scanView stopAnimation];
}

#pragma mark-
-(void)returnListPage{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
