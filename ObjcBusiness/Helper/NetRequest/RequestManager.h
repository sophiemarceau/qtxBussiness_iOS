//
//  RequestManager.h
//  YourBusiness
//
//  Created by 屈小波 on 2017/7/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^SuccessData)(NSDictionary *result);
typedef void(^ErrorData)( NSError *error);

@interface RequestManager : NSObject

@property (nonatomic,assign) BOOL hasNetWork;

+(RequestManager *)shareRequestManager;
-(NSString *)opendUDID;
#pragma mark - 退出登录需要删除本地的账号缓存
-(void)loginCancel:(NSDictionary *)resultDic;
#pragma md5 加密
-(NSString *)md5:(NSString *)str;
//-(NSString *)opendUDID;
#pragma 取消请求
- (void)cancelAllRequest;

//#pragma jsonString JSON格式的字符串 @return 返回字典
//-(NSArray *)dictionaryWithJsonString:(NSString *)jsonString;

#pragma mark - 错误提示语言
- (void)tipAlert:(NSString *)results  viewController:(UIViewController *)controller;
- (void)tipAlert:(NSString *)results;
//- (void)resultFail:(NSDictionary *)result;
- (void)resultFail:(NSDictionary *)result  viewController:(UIViewController *)controller;


#pragma mark - 获取验证码
- (void)GetVerifyCodeResult:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - APP确认登录PC企业端
- (void)confirmLoginByQRcode4APPRequest:(NSDictionary *)dataDic
                         viewController:(UIViewController *)controller
                            successData:(SuccessData)success
                                failuer:(ErrorData)errors;

#pragma mark - QQ登录APP
- (void)login4APPByOpenidQqRequest:(NSDictionary *)dataDic
                         viewController:(UIViewController *)controller
                            successData:(SuccessData)success
                                failuer:(ErrorData)errors;

#pragma mark - 微信登录APP
- (void)login4APPByOpenidWxRequest:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark - 手机号登录APP
- (void)LoginUserRequest:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 更新用户个人信息
- (void)UpdateUserInfoResult:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 通过userID 获取 UserInfo
- (void)GetGetRongYunTokenResult:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 获取当前登录用户的用户信息详情
- (void)GetUserInfoResult:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 退出登录APP前，调用此接口清除推送消息用的机器码
- (void)QuitToBlank4MachineIdentificationCodeResult:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 获取打开APP时的加载图片（及对应跳转的Url）
- (void)getfirstFigure:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark -4.6.3	APP首页推荐项目列表
- (void)SearchPromotingProjectsResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors;

#pragma mark - 通过userID 获取 浏览数 收藏数 沟通数
- (void)GetAllKindsOfNumbersClientInfoResult:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 通过userID Enterperise 获取 浏览数 收藏数 沟通数
- (void)GetAllKindsOfNumbersEnterpriseInfoResult:(NSDictionary *)dataDic
                                  viewController:(UIViewController *)controller
                                     successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 通过userID 获取 是否生意简历完成
- (void)GetUserIsFinishBusinessResumeResult:(NSDictionary *)dataDic
                             viewController:(UIViewController *)controller
                                successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 初始化简历
- (void)initBusinessResume:(NSDictionary *)dataDic
                             viewController:(UIViewController *)controller
                                successData:(SuccessData)success failuer:(ErrorData)errors;
#pragma mark - 获取用户生意简历
- (void)getUserBusinessResume:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 编辑生意简历意向信息
- (void)editBusinessResumeIntention:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 关闭生意经验
- (void)closeResumeExperience:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 删除生意简历场所信息
- (void)deleteBusinessResumePlace:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 我的页面里面的 是否显示完善生意简历提示
- (void)isPerfectBusinessResume:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 更新生意简历场所信息
- (void)updateBusinessResumePlace:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 添加生意简历场所信息
- (void)addBusinessResumePlace:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 添加生意经验
- (void)addResumeExperience:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 保存生意简历
- (void)saveBusinessResume:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 获取生意简历场所信息
- (void)getBusinessResumePlace:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 获取生意简历意向信息
- (void)getBusinessResumeIntention:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 根据关键词模糊查询企业名称，获取企业ID、名称信息列表
- (void)searchCompanySimpleDtosByCompanyName:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 申请企业入驻
- (void)applyCompanyEntering:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 选择已入驻企业，开通企业功能
- (void)openCompanyFeature:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 根据企业名称获取企业入驻状态
- (void)getCompanyStatusByName:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 获取项目列表
- (void)searchProjectDtos4App:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 获取项目详情
- (void)getProjectDto4App:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 根据项目 ID  获取留言列表
- (void)searchProjectMessageDtos4Project:(NSDictionary *)dataDic
                          viewController:(UIViewController *)controller
                             successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark - 取消项目收藏
- (void)cancelProjectCollect:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark -添加用户收藏项目
- (void)addProjectCollect:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark -新建留言
- (void)createProjectMessage:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success failuer:(ErrorData)errors;

#pragma mark -提交反馈信息
- (void)SubmitFeedbackResult:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;
#pragma mark -获取用户上过线的项目
- (void)getOnlineAndOfflineProjectDtoListByUserId:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark -获取留言详情
- (void)getProjectMessageDto:(NSDictionary *)dataDic
                                   viewController:(UIViewController *)controller
                                      successData:(SuccessData)success
                                          failuer:(ErrorData)errors;
#pragma mark -获取留言手机号
- (void)getMessageUserTel:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark -添加或修改个人信息
- (void)saveSimpleBusinessResume:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors;

#pragma mark -获取个人信息
- (void)getSimpleBusinessResumeDto:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark -首页最新问题
- (void)searchLatestQuestionDtos:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors;
#pragma mark -    首页-热门
- (void)searchHotAnswerDtos:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 获取标签 （读取首页标签或者读取搜索页推荐标签）
- (void)getTagDtoList:(NSDictionary *)dataDic
       viewController:(UIViewController *)controller
          successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark -获取 banner 展示数据集合
- (void)SearchAdDtoListResult:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

#pragma mark -首页-根据标签获取问题
- (void)searchQuestionDtosByTag:(NSDictionary *)dataDic
                 viewController:(UIViewController *)controller
                    successData:(SuccessData)success
                        failuer:(ErrorData)errors;

#pragma mark -首页-获取推荐专家
- (void)recommendExpert:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark -提问
- (void)askQuestion:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark -添加标签
- (void)addTag:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 模糊搜索标签
- (void)getLikeTagDtoLike:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;


#pragma mark - 问题详情
- (void)getQuestionDetail:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark - 获取问题下的答案
- (void)searchAnswerDtosByQuestionId:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors;

#pragma mark - 取消收藏问题
- (void)cancelCollectQuestion:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors;
#pragma mark - 收藏问题
- (void)collectQuestion:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 获取专家列表
- (void)searchExpert:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;

#pragma mark -  邀请专家回答
- (void)inviteAnswer:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;

#pragma mark - 回答问题 提交
- (void)answerQuestion:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark -问题所属标签列表
- (void)getTagDtoListByQuestionId:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark -添加关注
- (void)addConnection:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;
#pragma mark -取消关注
- (void)cancelConnection:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark - 标签下的精品回答
- (void)searchBoutiqueAnswerQuestionDtos:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark -  获取相关项目
- (void)searchOnlinProjectDtosByTagIdResult:(NSDictionary *)dataDic
                       viewController:(UIViewController *)controller
                          successData:(SuccessData)success
                              failuer:(ErrorData)errors;
#pragma mark -  收藏标签
- (void)collectTag:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors;
#pragma mark -  收藏标签
- (void)cancelCollectTag:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
              failuer:(ErrorData)errors;

#pragma mark -  个人主页 获取 个人相关信息
- (void)getUserCHomePageDto:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark -  个人主页 获取问答列表
- (void)searchAnswerDtosByUserId:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors;

#pragma mark -  个人主页 获取问答列表 (我的)
- (void)searchMyQuestionDtos:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark -  个人主页 获取提问列表
- (void)searchQuestionDtosByUserId:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;
#pragma mark -  获取答案列表 (我的)
- (void)searchMyAnswerDtos:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;
#pragma mark -  个人主页获取项目列表
- (void)searchOnlinProjectDtosByUserId:(NSDictionary *)dataDic
                        viewController:(UIViewController *)controller
                           successData:(SuccessData)success
                               failuer:(ErrorData)errors;

#pragma mark -  获取两个人的关注关系
- (void)getConnectionStatus:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark -  获取未读系统消息的数量
- (void)getSysMsgUnReadCount:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;

#pragma mark - 系统消息置为已读
- (void)updateSysMsgToRead:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark -#pragma mark - 未读赞相关消息置为已读
- (void)updateDingToRead:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;

#pragma mark - 未读的评论消息置为已读
- (void)updateCommentToRead:(NSDictionary *)dataDic
             viewController:(UIViewController *)controller
                successData:(SuccessData)success
                    failuer:(ErrorData)errors;

#pragma mark - 获取列表里 各种未读选项里面的 未读消息 数量
- (void)getUnReadCountDto:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark -  获取系统消息列表
- (void)searchSysMsgDtos:(NSDictionary *)dataDic
              viewController:(UIViewController *)controller
                 successData:(SuccessData)success
                     failuer:(ErrorData)errors;


#pragma mark -  收到的评论列表
- (void)searchCommentDtosByUserId:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;

#pragma mark -  收到的赞列表
- (void)searchDingDtosByUserId:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;

#pragma mark -  我的粉丝列表
- (void)searchMyFansConnectionDtos:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;

#pragma mark -  他的粉丝列表
- (void)searchHisFansConnectionDtos:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;


#pragma mark -  查看我的关注列表
- (void)searchMyAttentionConnectionDtos:(NSDictionary *)dataDic
                    viewController:(UIViewController *)controller
                       successData:(SuccessData)success
                           failuer:(ErrorData)errors;

#pragma mark -  查看他的关注列表
- (void)searchHisAttentionConnectionDtos:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors;


#pragma mark -  收藏问题
- (void)searchQuestionDtosCollection:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors;

#pragma mark -  收藏答案
- (void)searchCollectionAnswerDtosByUserId:(NSDictionary *)dataDic
                            viewController:(UIViewController *)controller
                               successData:(SuccessData)success
                                   failuer:(ErrorData)errors;

#pragma mark -  收藏项目
- (void)searchCollectionProjectDtosByUserId4App:(NSDictionary *)dataDic
                             viewController:(UIViewController *)controller
                                successData:(SuccessData)success
                                    failuer:(ErrorData)errors;

#pragma mark -  收藏标签
- (void)searchCollectionTagDtosByUserId:(NSDictionary *)dataDic
                         viewController:(UIViewController *)controller
                            successData:(SuccessData)success
                                failuer:(ErrorData)errors;
#pragma mark -  模糊搜索问题
- (void)searchLikeQuestionDtos:(NSDictionary *)dataDic
                         viewController:(UIViewController *)controller
                            successData:(SuccessData)success
                                failuer:(ErrorData)errors;


#pragma mark -  获取热门搜索项目
- (void)searcHotSearchProjectDtoList:(NSDictionary *)dataDic
                viewController:(UIViewController *)controller
                   successData:(SuccessData)success
                       failuer:(ErrorData)errors;

#pragma mark -  搜索用户
- (void)searchUserCSimpleInfoDtos:(NSDictionary *)dataDic
                      viewController:(UIViewController *)controller
                         successData:(SuccessData)success
                             failuer:(ErrorData)errors;

#pragma mark -  删除问题
- (void)deleteQuestion:(NSDictionary *)dataDic
                   viewController:(UIViewController *)controller
                      successData:(SuccessData)success
                          failuer:(ErrorData)errors;
#pragma mark -    标签详情
- (void)getTagDto:(NSDictionary *)dataDic
   viewController:(UIViewController *)controller
      successData:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark -  用户绑定手机号
- (void)bindTel:(NSDictionary *)dataDic
 viewController:(UIViewController *)controller
    successData:(SuccessData)success
        failuer:(ErrorData)errors;

#pragma mark -    分享问题
- (void)addShareCount:(NSDictionary *)dataDic
   viewController:(UIViewController *)controller
      successData:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark -    分享答案
- (void)shareAnswer:(NSDictionary *)dataDic
   viewController:(UIViewController *)controller
      successData:(SuccessData)success
          failuer:(ErrorData)errors;

#pragma mark -    答案详情
- (void)getAnswerDetail:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 获未认证项目数量
- (void)getAnauthorizedProjectCount:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors;
#pragma mark -    检查产品版本更新
- (void)getVersionInfo:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark -    获取用户是否显示推荐标签页面
- (void)getChooseTagsFlag:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors;

#pragma mark -    获取推荐关注标签
- (void)searchTagDtosByRecommend:(NSDictionary *)dataDic
        viewController:(UIViewController *)controller
           successData:(SuccessData)success
               failuer:(ErrorData)errors;

#pragma mark -    跳过推荐关注标签页
- (void)skipTagsFlag:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark -    收藏多个标签
- (void)collectTags:(NSDictionary *)dataDic
                  viewController:(UIViewController *)controller
                     successData:(SuccessData)success
                         failuer:(ErrorData)errors;
#pragma mark -	上传图片
- (void)SubmitImage:(NSDictionary *)dataDic sendData:(NSData *)sendData WithFileName:(NSString *)filename WithHeader:(NSDictionary *)header
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;







#pragma mark -创建老板项目
- (void)createProject4Boss:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;

#pragma mark -编辑老板项目
- (void)updateProject4Boss:(NSDictionary *)dataDic
            viewController:(UIViewController *)controller
               successData:(SuccessData)success
                   failuer:(ErrorData)errors;

#pragma mark -老板入驻
- (void)applyBossEntering:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

#pragma mark - 获取老板列表
- (void)searchBossProjectDtos:(NSDictionary *)dataDic
     viewController:(UIViewController *)controller
        successData:(SuccessData)success
            failuer:(ErrorData)errors;

#pragma mark - 根据登录用户ID 获取老板项目信息
- (void)getBossProjectDtoByUserId:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

//#pragma mark - 根据用户 ID 获取上线老板项目信息
//- (void)getOnlineBossProjectDtoByUserId:(NSDictionary *)dataDic
//                   viewController:(UIViewController *)controller
//                      successData:(SuccessData)success
//                          failuer:(ErrorData)errors;

#pragma mark - 根据用户 ID 获取项目数量
- (void)getProjectCountByUserId:(NSDictionary *)dataDic
               viewController:(UIViewController *)controller
                  successData:(SuccessData)success
                      failuer:(ErrorData)errors;

#pragma mark - 保存融云会话用户记录
- (void)saveImUser:(NSDictionary *)dataDic
           viewController:(UIViewController *)controller
              successData:(SuccessData)success
                  failuer:(ErrorData)errors;



#pragma mark - 根据一个或多个用户ID混淆串拼接的字符串，查询并返回用户基本信息
- (void)searchUserCListDtoByUserIds:(NSDictionary *)dataDic
    viewController:(UIViewController *)controller
       successData:(SuccessData)success
           failuer:(ErrorData)errors;

#pragma mark - 看过我的
- (void)searchUserViews:(NSDictionary *)dataDic
                     viewController:(UIViewController *)controller
                        successData:(SuccessData)success
                            failuer:(ErrorData)errors;

#pragma mark - 添加查看关系
- (void)saveUserView:(NSDictionary *)dataDic
      viewController:(UIViewController *)controller
         successData:(SuccessData)success
             failuer:(ErrorData)errors;

#pragma mark - 获取融云App Key
- (void)getRongcloudAppKey:(NSDictionary *)dataDic
         viewController:(UIViewController *)controller
            successData:(SuccessData)success
                failuer:(ErrorData)errors;

#pragma mark - 看过我的数量
- (void)countUserViewNum:(NSDictionary *)dataDic
          viewController:(UIViewController *)controller
             successData:(SuccessData)success
                 failuer:(ErrorData)errors;
@end
