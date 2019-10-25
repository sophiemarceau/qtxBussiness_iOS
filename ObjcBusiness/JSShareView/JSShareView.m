//
//  JSShareView.m
//  JSShareView

//


#import "JSShareView.h"
#import "JSShareItemButton.h"

#import "UIView+YYAdd.h"

//背景色
#define SHARE_BG_COLOR                        XNColor(244, 245, 247, 1)
//高
#define SHARE_BG_HEIGHT                       270*AUTO_SIZE_SCALE_X
//
#define SHARE_SCROLLVIEW_HEIGHT               (SHARE_BG_HEIGHT-49*AUTO_SIZE_SCALE_X)/2
//item宽
#define SHARE_ITEM_WIDTH                      44*AUTO_SIZE_SCALE_X
//左间距
#define SHARE_ITEM_SPACE_LEFT                 50*AUTO_SIZE_SCALE_X
//间距
#define SHARE_ITEM_SPACE                      33*AUTO_SIZE_SCALE_X
//第一行 item  base tag
#define ROW1BUTTON_TAG                        1000
//第二行 item base tag
#define ROW2BUTTON_TAG                        600
//item base tag
#define BUTTON_TAG                            700
//背景view tag
#define BG_TAG                                1234


static id _publishContent;
static JSShareView *shareView = nil;

@interface JSShareView ()
{
    NSArray *_DataArray;
    NSMutableArray *_ButtonTypeShareArray1;
    NSMutableArray *_ButtonTypeShareArray2;
    NSArray *_typeArray1;
    NSArray *_typeArray2;
}
@end

@implementation JSShareView

/**
 *  分享
 *
 *  @param content     内容
 *  @param resultBlock 结果
 */
+ (void)showShareViewWithPublishContent:(id)content FlagWithDeleButton:(NSInteger)deleteButtonflag{
    
    [[self alloc] initPublishContent:content FlagWithDeleButton:deleteButtonflag];
    
}
/**
 *  分享
 *
 *  @param content     内容
 *  @param resultBlock 结果
 */
- (void)initPublishContent:(id)content FlagWithDeleButton:(NSInteger)deleteButtonflag{
    
    
    _publishContent = content;
    if (!shareView) {
        shareView = [[JSShareView alloc] init];
    }
    [self initDataFlagWithDeleButton:deleteButtonflag];
    [self initShareUI];
    
    
}

- (void)initDataFlagWithDeleButton:(NSInteger)deleteButtonflag{
    
    
    if (deleteButtonflag == 0) {
        _DataArray = @[@{@(0):@[
                                 @{@"微信好友":@"share_icon_wechat"},
                                 @{@"朋友圈":@"share_icon_friends"}
                                 ,@{@"QQ":@"share_icon_qq"}
                                 ,@{@"QQ空间":@"share_icon_qq_space"}
                                 ]}
                       
                       ,@{@(1):@[@{@"复制链接":@"share_icon_copy_url"}
                                 ,@{@"举报":@"share_icon_report"}
                                 
                                 ]}];
        _typeArray1 = @[@(ShareTypeSocial),
                        @(ShareTypeSocial),
                        @(ShareTypeSocial),
                        @(ShareTypeSocial),
                        @(ShareTypeSocial)];
        
        _typeArray2 = @[@(ShareTypeCopy),
                        @(ShareTypeReport)];
    }else{
        _DataArray = @[@{@(0):@[
                                 @{@"微信好友":@"share_icon_wechat"},
                                 @{@"朋友圈":@"share_icon_friends"}
                                 ,@{@"QQ":@"share_icon_qq"}
                                 ,@{@"QQ空间":@"share_icon_qq_space"}
                                 ]}
                       
                       ,@{@(1):@[@{@"复制链接":@"share_icon_copy_url"}
                                 ,@{@"删除":@"share_icon_delete"}
                                 ,@{@"举报":@"share_icon_report"}
                                 ]}];
        _typeArray1 = @[@(ShareTypeSocial),
                        @(ShareTypeSocial),
                        @(ShareTypeSocial),
                        @(ShareTypeSocial),
                        @(ShareTypeSocial)];
        
        _typeArray2 = @[@(ShareTypeCopy),
                        @(ShareTypeDelete),
                        @(ShareTypeReport)];
    }
    
    
   
    
    
    _ButtonTypeShareArray1 = [NSMutableArray array];
    _ButtonTypeShareArray2 = [NSMutableArray array];
}

/**
 *  初始化视图
 */
- (void)initShareUI{
    
    CGRect orginRect = CGRectMake(0, XNWindowHeight, XNWindowWidth, SHARE_BG_HEIGHT);
    
    CGRect finaRect = orginRect;
    finaRect.origin.y =  XNWindowHeight-SHARE_BG_HEIGHT;
    
    /***************************** 添加底层bgView ********************************************/
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XNWindowWidth, XNWindowHeight)];
    bgView.backgroundColor = [XNColor(0, 0, 0, 1) colorWithAlphaComponent:0.5];
    bgView.tag = BG_TAG;
    [window addSubview:bgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(dismissShareView)];
    [bgView addGestureRecognizer:tap1];
    
    /***************************** 添加分享shareBGView ***************************************/
    
    UIView *shareBGView = [[UIView alloc] init];
    shareBGView.frame = orginRect;
    shareBGView.userInteractionEnabled = YES;
    shareBGView.backgroundColor = [SHARE_BG_COLOR colorWithAlphaComponent:1];
    [bgView addSubview:shareBGView];
    
    
    /****************************** 添加item ************************************************/
    for (int i = 0; i<_DataArray.count; i++) {
        UIScrollView *rowScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, i*(SHARE_SCROLLVIEW_HEIGHT+0.5), shareBGView.width, SHARE_SCROLLVIEW_HEIGHT)];
        rowScrollView.directionalLockEnabled = YES;
        rowScrollView.showsVerticalScrollIndicator = NO;
        rowScrollView.showsHorizontalScrollIndicator = NO;
        rowScrollView.backgroundColor = [UIColor clearColor];
        [shareBGView addSubview:rowScrollView];
        
        /* add item */
        NSArray *itemArray = _DataArray[i][@(i)];
        rowScrollView.contentSize = CGSizeMake((SHARE_ITEM_WIDTH+SHARE_ITEM_SPACE_LEFT+SHARE_ITEM_SPACE)*itemArray.count, SHARE_SCROLLVIEW_HEIGHT);
        //按钮数组
        for (NSDictionary *itemDict in itemArray) {
            NSInteger index           = [itemArray indexOfObject:itemDict];
            JSShareItemButton *button = [JSShareItemButton shareButton];
            CGFloat itemHeight        = SHARE_ITEM_WIDTH+15;
            CGFloat itemY             = (SHARE_SCROLLVIEW_HEIGHT-itemHeight)/2;
            
            NSInteger imageTag = 0;
            if (i == 0) {
                [_ButtonTypeShareArray1 addObject:button];
                imageTag = ROW1BUTTON_TAG+index;
            } else {
                imageTag = ROW2BUTTON_TAG+index;
                [_ButtonTypeShareArray2 addObject:button];
            }
            button = [[JSShareItemButton alloc] initWithFrame:CGRectMake(SHARE_ITEM_SPACE_LEFT+index*(SHARE_ITEM_WIDTH+SHARE_ITEM_SPACE), itemY+SHARE_ITEM_WIDTH, SHARE_ITEM_WIDTH, itemHeight)
                                                ImageName:[itemDict allValues][0]
                                                 imageTag:imageTag
                                                    title:[itemDict allKeys][0]
                                                titleFont:10
                                               titleColor:[UIColor blackColor]];
            
            button.tag = BUTTON_TAG+imageTag;
            [button addTarget:shareView
                       action:@selector(shareTypeClickIndex:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [rowScrollView addSubview:button];
            if (i == 0) {
                [_ButtonTypeShareArray1 addObject:button];
            } else {
                [_ButtonTypeShareArray2 addObject:button];
            }
            
        }
//        if (i == 0) {
//            /*line*/
//            UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(SHARE_ITEM_SPACE_LEFT, rowScrollView.height, shareBGView.width-SHARE_ITEM_SPACE_LEFT*2, 0.5)];
//            lineView.backgroundColor = XNColor(210, 210, 210, 1);
//            [shareBGView addSubview:lineView];
//        }
    }
    /****************************** 取消 ********************************************/
    UILabel *cancelLabel = [[UILabel alloc] init];
    cancelLabel.frame = CGRectMake(0, shareBGView.height-49*AUTO_SIZE_SCALE_X, shareBGView.width, 49*AUTO_SIZE_SCALE_X);
    cancelLabel.backgroundColor =[UIColor whiteColor];
    cancelLabel.userInteractionEnabled = YES;
    cancelLabel.text = @"取消";
    cancelLabel.textColor = [UIColor blackColor];
    cancelLabel.font = XNFont(16);
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
//    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancleButton.frame = CGRectMake(0, shareBGView.height-49*XNWidth_Scale, shareBGView.width, 49*XNWidth_Scale);
//    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
//    cancleButton.titleLabel.font = XNFont(16);
//    cancleButton.backgroundColor = [UIColor blueColor];
////    [[UIColor whiteColor] colorWithAlphaComponent:1];
//    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cancleButton addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
//    cancleButton.enabled = YES;
    
    shareBGView.userInteractionEnabled = YES;
//    [shareBGView addSubview:cancleButton];
    [shareBGView addSubview:cancelLabel];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(tapNoe)];
    [cancelLabel addGestureRecognizer:tap2];
    /****************************** 动画 ********************************************/
    shareBGView.alpha = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                         shareBGView.frame = finaRect;
                         shareBGView.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
    for (JSShareItemButton *button in _ButtonTypeShareArray1) {
        NSInteger idx = [_ButtonTypeShareArray1 indexOfObject:button];
        
        [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.52 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect buttonFrame = [button frame];
            buttonFrame.origin.y -= SHARE_ITEM_WIDTH;
            button.frame = buttonFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    for (JSShareItemButton *button in _ButtonTypeShareArray2) {
        NSInteger idx = [_ButtonTypeShareArray2 indexOfObject:button];
        
        [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.52 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect buttonFrame = [button frame];
            buttonFrame.origin.y -= SHARE_ITEM_WIDTH;
            button.frame = buttonFrame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)shareTypeClickIndex:(UIButton *)btn{
    
    NSInteger tag = btn.tag-BUTTON_TAG;
    NSInteger intV = tag % ROW1BUTTON_TAG;
    NSInteger intV1 = tag % ROW2BUTTON_TAG;
    NSInteger countRow1 = _typeArray1.count;
    NSInteger countRow2 = _typeArray2.count;
    
    // share type
    NSUInteger typeUI = 0;
    if (intV>=0&&intV<=countRow1) {
        NSLog(@"第一行");
        typeUI = [_typeArray1[intV] unsignedIntegerValue];
        
    } else if (intV1>=0&&intV1<=countRow2){
        NSLog(@"第2行");
        typeUI = [_typeArray2[intV1] unsignedIntegerValue];
    }
    
    //built share parames
    NSDictionary *shareContent = (NSDictionary *)_publishContent;
    NSString *text             = shareContent[@"text"];
    NSArray *image             = shareContent[@"image"];
    NSString *url              = shareContent[@"url"];
    
    
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:text
//                                     images:image
//                                        url:[NSURL URLWithString:url]
//                                      title:text
//                                       type:SSDKContentTypeAuto];
//
//    [ShareSDK share:typeUI
//         parameters:shareParams
//     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//
//         switch (state) {
//             case SSDKResponseStateSuccess:
//             {
//                 if (typeUI == SSDKPlatformTypeCopy) {
//                     NSLog(@"复制成功~");
//                 } else {
//                     NSLog(@"分享成功~");
//                 }
//             }
//                 break;
//             case SSDKResponseStateFail:
//             {
//                 NSLog(@"分享失败~");
//             }
//                 break;
//             case SSDKResponseStateCancel:
//             {
//                 NSLog(@"分享取消~");
//             }
//                 break;
//             default:
//                 break;
//         }
//     }];
    
    
    [self dismissShareView];
    
    
    
}

- (void)dismissShareView{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:BG_TAG];
    [UIView animateWithDuration:0.3
                     animations:^{
                         blackView.alpha = 0;
                         CGRect blackFrame = [blackView frame];
                         blackFrame.origin.y = XNWindowHeight;
                         blackView.frame = blackFrame;
                     }
                     completion:^(BOOL finished) {
                         
                         [blackView removeFromSuperview];

                     }];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ShareViewReturn object:nil];
}

- (void)tapNoe{
     NSLog(@"onclick");
    [self dismissShareView];
}


- (void)onclick:(UIButton *)sender{
    NSLog(@"onclick");
}


@end
