//
//  SharedView.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/22.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "SharedView.h"
#import "JSShareItemButton.h"
#import <UMSocialCore/UMSocialManager.h>
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "SharedView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
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
#define SHARE_ITEM_SPACE                      30*AUTO_SIZE_SCALE_X
//第一行 item  base tag
#define ROW1BUTTON_TAG                        1000
//第二行 item base tag
#define ROW2BUTTON_TAG                        600
//item base tag
#define BUTTON_TAG                            700


@implementation SharedView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled  = YES;
        self.backgroundColor = [XNColor(0, 0, 0, 1) colorWithAlphaComponent:0.5];
        self.userInteractionEnabled = YES;
    }
    return self;
}

/**
 *  分享
 *
 *  @param content     内容
 *  @param resultBlock 结果
 */
- (void)initPublishContent:(id)content FlagWithDeleButton:(NSInteger)deleteButtonflag{
    _publishContent = content;
    [self initDataFlagWithDeleButton:deleteButtonflag];
    [self initShareUI];
}

-(void)initDataFlagWithDeleButton:(NSInteger)deleteButtonflag{
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
        _typeArray1 = @[@(ShareTypeSocialWechat),
                        @(ShareTypeSocialWechatTimeLine),
                        @(ShareTypeSocialQQ),
                        @(ShareTypeSocialQQZone),
                        ];
        
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
        _typeArray1 = @[@(ShareTypeSocialWechat),
                        @(ShareTypeSocialWechatTimeLine),
                        @(ShareTypeSocialQQ),
                        @(ShareTypeSocialQQZone),
                        ];
        
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
    
    /***************************** 添加底层self ********************************************/
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    
    
    
    [window addSubview:self];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)];
    [self addGestureRecognizer:tap1];
    
    /***************************** 添加分享shareBGView ***************************************/
    
    _shareBGView = [[UIView alloc] init];
    _shareBGView.frame = orginRect;
    _shareBGView.userInteractionEnabled = YES;
    _shareBGView.backgroundColor = [SHARE_BG_COLOR colorWithAlphaComponent:1];
    [self addSubview:_shareBGView];
    
    
    /****************************** 添加item ************************************************/
    for (int i = 0; i<_DataArray.count; i++) {
        UIScrollView *rowScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, i*(SHARE_SCROLLVIEW_HEIGHT+0.5), _shareBGView.width, SHARE_SCROLLVIEW_HEIGHT)];
        rowScrollView.directionalLockEnabled = YES;
        rowScrollView.showsVerticalScrollIndicator = NO;
        rowScrollView.showsHorizontalScrollIndicator = NO;
        rowScrollView.backgroundColor = [UIColor clearColor];
        [_shareBGView addSubview:rowScrollView];
        
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
            [button addTarget:self
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
    cancelLabel.frame = CGRectMake(0, _shareBGView.height-49*AUTO_SIZE_SCALE_X, _shareBGView.width, 49*AUTO_SIZE_SCALE_X);
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
    
    _shareBGView.userInteractionEnabled = YES;
    //    [shareBGView addSubview:cancleButton];
    [_shareBGView addSubview:cancelLabel];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNoe)];
    [cancelLabel addGestureRecognizer:tap2];
    /****************************** 动画 ********************************************/
    _shareBGView.alpha = 0;
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                         _shareBGView.frame = finaRect;
                         _shareBGView.alpha = 1;
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
    if (intV >= 0 && intV <= countRow1) {
//        NSLog(@"第1行");
        typeUI = [_typeArray1[intV] unsignedIntegerValue];
//        NSLog(@"第1行=====typeUI-----%ld",typeUI);
        
    } else if (intV1 >= 0 && intV1 <= countRow2){
//        NSLog(@"第2行");
        typeUI = [_typeArray2[intV1] unsignedIntegerValue];
//        NSLog(@"第2行=====typeUI-----%ld",typeUI);
    }
    
    NSDictionary *shareContent = (NSDictionary *)_publishContent;
    NSString *url = shareContent[@"url"];
    if (typeUI == ShareTypeSocialWechat) {
         [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }
    if (typeUI == ShareTypeSocialWechatTimeLine) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    if (typeUI == ShareTypeSocialQQ) {
        [self isQQInstall];
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
    
    if (typeUI == ShareTypeSocialQQZone) {
        [self isQQInstall];
        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
    }
    
    if (typeUI == ShareTypeCopy) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,url];
        [self.delegate SelectSharedTypeDelegateReturnPage:typeUI];
    }
    if (typeUI == ShareTypeDelete) {
        NSDictionary *dic = @{@"question_id":[NSString stringWithFormat:@"%ld",self.question_id],};
        [[RequestManager shareRequestManager] deleteQuestion:dic viewController:self.currentVC successData:^(NSDictionary *result) {
            if (IsSucess(result) == 1) {
                 [self.delegate SelectSharedTypeDelegateReturnPage:typeUI];
            }
           
        } failuer:^(NSError *error) {
            
        }];
    }
    if (typeUI == ShareTypeReport) {
         [self.delegate SelectSharedTypeDelegateReturnPage:typeUI];
    }
    
   

    [self dismissShareView];
}

-(void)isQQInstall{
    if (![QQApiInterface isQQInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您的设备没有安装QQ"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (void)dismissShareView{
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0;
                         CGRect blackFrame = [self frame];
                         blackFrame.origin.y = XNWindowHeight;
                         self.frame = blackFrame;
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                     }];
    
}

- (void)tapNoe{
//    NSLog(@"onclick");
    [self dismissShareView];
}


- (void)onclick:(UIButton *)sender{
//    NSLog(@"onclick");
}



//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //    NSString* thumbURL =  @"http://weixintest.ihk.cn/ihkwx_upload/heji/material/img/20160414/1460616012469.jpg";
    //built share parames
    
    NSDictionary *shareContent = (NSDictionary *)_publishContent;
    NSString *title            = shareContent[@"title"];
    NSString *desc             = shareContent[@"desc"];
    id image                   = shareContent[@"image"];
    NSString *url              = shareContent[@"url"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:image];
    
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@",BaseURLHTMLString,url];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.currentVC completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                if (self.fromWhereFlag == ShareTypeFromAnswerDetail) {
                    NSDictionary *dic = @{@"answer_id":[NSString stringWithFormat:@"%ld",self.answer_id]};
                    [[RequestManager shareRequestManager] shareAnswer:dic viewController:nil successData:^(NSDictionary *result) {
//                        NSLog(@"第shareAnswer行=====typeUI-----%@",result);
                        if (IsSucess(result) == 1) {
                            
                        }else{
                            
                        }
                    } failuer:^(NSError *error) {
                        
                    }];
                }
                if (self.fromWhereFlag == ShareTypeFromQuestionDetail) {
                    NSDictionary *dic = @{@"question_id":[NSString stringWithFormat:@"%ld",self.question_id],};
                    [[RequestManager shareRequestManager] addShareCount:dic viewController:nil successData:^(NSDictionary *result) {
//                          NSLog(@"第addShareCount行=====typeUI-----%@",result);
                        if (IsSucess(result) == 1) {
                            
                        }else{
                            
                        }
                    } failuer:^(NSError *error) {
                        
                    }];
                }
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}
@end
