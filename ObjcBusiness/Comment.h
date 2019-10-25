//
//  Comment.h
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#ifndef Comment_h
#define Comment_h
#define BaseURLHTMLString @"http://m.qtxsy.com/"
//@"http://m-api-test.qtxsy.com"

#define BaseURLStringHTTPS                 @"https://app-api.qtxsy.com"
#define BaseURLString                      @"http://app-api.qtxsy.com"
//#define BaseURLString                   @"http://app-api-test.qtxsy.com"


#define UMENG_APPKEY                       @"597af890aed1796f89000e75"
#define RongCloudAPPKey                    @"c9kqb3rdcxdtj"
#define kWechatAppKey                      @"wx4cdd6507af074ba6" //wechat appkey
#define kWechatAppSecret                   @"f406a7a06a4db1bd99fba401abd7bf68" //wechat appsecret
#define kQQAppKey                          @"1106387424"
#define kWechatAppSecretURL                @"http://mobile.umeng.com/social"//wechat url
#define KJpushappKey                        @"7402d76fde52fc00e625d815"
#define KJpushchannel                       @"App Store"










#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RandomColorFromRGB [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define k_UIFont(font)  [UIFont systemFontOfSize:font]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define BlockS(blockSelf) __typeof(&*self)blockSelf = self;

#define IsSucess(result) [[result objectForKey:@"flag"] integerValue]
//#define IsSucessCode(result)  [[result objectForKey:@"code"] isEqualToString:@"0000"]?TRUE:FALSE
#define noIsKindOfNusll(result,key)   ![[(result) objectForKey:(key)] isKindOfClass:[NSNull class]]
//判断字符串是否为nil,如果是nil则设置为空字符串
#define CHECK_STRING_IS_NULL(txt) txt = !txt ? @"" : txt
//判断Server返回数据是否为NSNull 类型 txt为参数 type为类型,like NSString,NSArray,NSDictionary
#define CHECK_DATA_IS_NSNULL(param,type) param = [param isKindOfClass:[NSNull class]] ? [type new] : param
#define kDateFormatTime @"yyyy-MM-dd hh:mm:ss"
#define kDateFormatDay @"yyyy-MM-dd"

#define OBJ_IS_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]])
#define Number_IS_VALID(s) ([s isKindOfClass:[NSValue class]])
#if NDDEBUG
#define NDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NDLog(xx, ...)  ((void)0)
#endif

#define BUNDLE_DISPLAY_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define BGColorGray      UIColorFromRGB(0xf4f4f4)
#define RedUIColorC1     UIColorFromRGB(0xF93630)
#define FontUIColor999999Gray  UIColorFromRGB(0x999999)
#define FontUIColor757575Gray  UIColorFromRGB(0x757575)
#define FontUIColorF4F5F7Gray  UIColorFromRGB(0xF4F5F7 )
#define FontUIColorGray  UIColorFromRGB(0x666666)
#define FontUIColorBlack UIColorFromRGB(0x333333)
#define lineImageColor   UIColorFromRGB(0xdddddd)
#define blueImageColor UIColorFromRGB(0x189ceb)
#define blueLabelColor     UIColorFromRGB(0x2288ff)
#define MENU_BUTTON_WIDTH  80*AUTO_SIZE_SCALE_X
#define MIN_MENU_FONT  14.f
#define MAX_MENU_FONT  14.f


#define NetResponseSUCCESSType @"success"
#define NetResponseFAILUREType @"failure"

#define DEFAULTS [NSUserDefaults standardUserDefaults]

#define LAST_RUN_VERSION_KEY                @"first_run_version_of_application"
#define IS_UPDATE_VERSION                   @"IS_updateversion"
#define NOTIFICATION_NAME_ClassicTableView       @"ClassicTableView"
#define NOTIFICATION_NAME_AllQuestionTableViw       @"AllQuestionTableViw"
#define NOTIFICATION_NAME_RelateProjectTableViw       @"RelateProjectTableViw"
#define NOTIFICATION_NAME_commentView      @"commentView"
#define NOTIFICATION_NAME_SEARCHTAGLIST     @"seearchTagLists"
#define NOTIFICATION_NAME_showorHideHotTagView     @"showorHideHotTagView"
#define NOTIFICATION_NAME_LOGINSELECT       @"logSelect"
#define NOTIFICATION_NAME_USER_LOGOUT       @"userLogout" //退出登录
#define NOTIFICATION_NAME_QuitGuidePage       @"quitGuidePage" //退出
#define NOTIFICATION_SCROLL_TOP             @"scrolltop"
#define kGoTopNotificationName              @"goTop"//进入置顶命令
#define kLeaveTopNotificationName           @"leaveTop"//离开置顶命令
#define kfinishLoadingView                  @"finishLoadingView"
#define kProjectDetailToPost                @"delegatepdtop"

#define NOTIFICATION_UpdatePersonalInfo      @"postUpdatePersonalInfo" //
#define NOTIFICATION_ResumeHeaderView      @"resumesheaderview" //
#define NOTIFICATION_ResumeIntention       @"resumeintention" //
#define NOTIFICATION_ResumeExperience      @"resumeexperience" //
#define NOTIFICATION_Add_ResumePlace          @"addresumeplace" //
#define NOTIFICATION_Update_ResumePlace          @"updateresumeplace" //
#define NOTIFICATION_Remove_ResumePlace          @"removeresumeplace" //
#define NOTIFICATION_CompanySendMessage      @"CompanySendMessage " //
#define NOTIFICATION_kCLDisplayTagViewAddTagNotification  @"kCLDisplayTagViewAddTagNotification"
#define NOTIFICATION_ShareViewReturn       @"NOTIFICATION_ShareViewReturn" //退出

#define kCheckVersionInMainPage  @"checkVersion"
#define kgotoDetailPage          @"gotoDetailPage"
#define kAccountBindPage         @"AccountBindPage"
#define kLoginPage               @"LoginPage"
#define kGuideViewPage           @"GuideViewPage"
#define kAdvertisePage           @"AdvertisePage"
#define kAdvertiseWebPage        @"AdvertiseWebPage"
#define kProjectListPage         @"projectListPage"
#define kQuestionHomePage        @"QuestionHomePage"

#define kQuestionDetailPage       @"QuestionDetailPage"
#define kInviteExpertListPage       @"InviteExpertListPage"
#define kAnswerPage       @"AnswerPage"
#define kTagListPage       @"TagListPage"
#define kPersonalHomePage       @"PersonalHomePage"
#define KFollowerListPage @"FollowerListPage"
#define KWhoSeeMyHomePage @"WhoSeeMyHomePage"
#define kfansListPage       @"fansListPage"
#define kMyCollectPage      @"MyCollectPage"
#define kSearchResultPage      @"SearchResultPage"
#define kMyAnswerANDQuestionPage      @"MyAnswer&QuestionPage"
#define kTagDetailPage       @"TagDetailPage"
#define kLeaveMessageSubmitSuccessPage         @"LeavemessageSubmitSuccessPage"
#define kLeaveMessagePage         @"LeaveMessagePage"
#define kMyCenterPage            @"MyCenterPage"
#define kSettingPage             @"SettingPage"
#define kAboutUsPage             @"AboutUsPage"
#define kSettingPage             @"SettingPage"
#define kSearchEnterpriseViewPage @"SearchEnterpriseViewPage"
#define kLeaveMessageForProjectPage            @"LeaveMessageForProjectPage "
#define kEnterpriseInfoViewPage @"EnterpriseInfoViewPage"
#define kBossComingPage @"BossComingPage"
#define kProjectMessagePage             @"ProjectMessagePage"
#define kLeaveMessageClientInfoPage             @"LeaveMessageClientInfoPage"
#define kLeaveMessageDetailPage             @"LeaveMessageDetailPage"
#define kQuestTypeSelectPage             @"QuestTypeSelectPage"
#define kAddQuestCotentPage             @"AddQuestCotentPage"
#define kfeedbackPage             @"feedbackPage"
#define kPushCenterPage          @"PushCenterPage"
#define kScannerPagePage         @"ScannerPage"
#define kResumePage              @"ResumePage"
#define kPersoalInfoPage         @"PersoalInfoPage"
#define kBossListPage         @"BossListPage"
#define kBossDetailPage         @"BossDetailPage"
#define kBossProjectManagerPage         @"BossProjectManagerPage"
#define kPerfectPersonalInfoPage         @"PerfectPersonalInfoPage"
#define kConversationPage        @"ConversationPage"
#define kMessagePage             @"MessagePage"
#define kAccountBindPage              @"AccountBindPage"
#define kAnswerDetailPage             @"AnswerDetailPage"
#define kProjectDetailPage             @"ProjectDetailPage"
#define kMyScoresPage             @"MyScoresPage"
#define kSystemMessagePage          @"SystemMessagePage"
#define kgetDingListPage          @"getDingListPage"
#define kgetCommentListPage          @"getCommentListPage"
#define kChannelPage            @"ChannelPage"
#define kTagsSelectPage              @"TagsSelectPage"
#define kCreateProjectPage  @"CreateProjectPage"
#define kAddPolicyPage  @"AddPolicyPage"
#define tyCurrentWindow [[UIApplication sharedApplication].windows firstObject]
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define XNColor(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define XNWindowWidth        ([[UIScreen mainScreen] bounds].size.width)

#define XNWindowHeight       ([[UIScreen mainScreen] bounds].size.height)

#define XNFont(font)         [UIFont systemFontOfSize:(font)]

//这个是判断是否为手机设备
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && kScreenHeight == 812.0)
//iphone 8plus 7plus 6plus 和iPhone X的宽度都是一样的没有变化 只是高度是比例适配就可以了
#define kHeightForIphoneX     812
#define kHeightFor6OR7OR8     667
#define kWidthFor6sOR7OR8     375
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kNavHeight  (kScreenHeight != kHeightForIphoneX ? 64 : 88)
#define kTabHeight  (kScreenHeight != kHeightForIphoneX ? 49 : 83)
#define kSystemBarHeight  (kScreenHeight != kHeightForIphoneX ? 20 : 44)//系统栏
//其实说白了 iphone 7plus 6plus 8plus 还有iPhone X 都是用统一的 比例系数就可以解决适配的比例问题
#define AUTO_SIZE_SCALE_X (kScreenHeight != kHeightFor6OR7OR8 ? (kScreenWidth/kWidthFor6sOR7OR8) : 1.0)

#define BottomHeight Is_Iphone_X ? 34 : 0

#define pageMenuH 44*AUTO_SIZE_SCALE_X
#define scrollViewHeight kScreenHeight-kNavHeight-pageMenuH-kTabHeight

#define UI(x) UIAdapter(x)
#define UIRect(x,y,width,height) UIRectAdapter(x,y,width,height)

#endif /* Comment_h */
