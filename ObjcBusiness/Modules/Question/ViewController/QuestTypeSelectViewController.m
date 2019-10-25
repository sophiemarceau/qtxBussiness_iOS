//
//  QuestTypeSelectViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "QuestTypeSelectViewController.h"
#import "CLRecentTagView.h"
#import "CLDispalyTagView.h"
#import "CLTools.h"
#import "CLTagsModel.h"
#import "CLTableView.h"
#import "QuestDetailViewController.h"
#import "IQKeyboardManager.h"
@interface QuestTypeSelectViewController ()<UIGestureRecognizerDelegate,CLTableViewDelegate>{
    CLRecentTagView *_recentTagView;
    NSString *tag_ids;
    NSInteger question_id;
    
    
}
@property (nonatomic,strong)CLDispalyTagView *displayTagView;
@property (nonatomic,strong)CLTableView *searchResultTableView;
@property (nonatomic,strong)UIImageView *lineImageView;
@end

@implementation QuestTypeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提问";
    tag_ids = @"";
    [self initNavgation];
    [self loadData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showorHideHotTagView:) name:NOTIFICATION_NAME_showorHideHotTagView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showorHide:) name:NOTIFICATION_NAME_SEARCHTAGLIST object:nil];
}
#pragma mark - 通知
- (void)showorHide:(NSNotification *)notification {
    if (notification.object == nil) {
        NSString *tagContentStr = notification.userInfo[@"tag_content"];
        NSInteger tagCount = [notification.userInfo[@"count"] integerValue];
        if (tagContentStr.length != 0) {
            _searchResultTableView.hidden = NO;
            _recentTagView.hidden = YES;
        }else{
            _searchResultTableView.hidden = YES;
            _recentTagView.hidden = NO;
            if (tagCount >5) {
                _recentTagView.hidden = YES;
            }
            
        }
    }
}

- (void)showorHideHotTagView:(NSNotification *)notification {
    if (notification.object == nil) {
        
        NSInteger HotTagHiddenFlag = [notification.userInfo[@"HotTagHiddenFlag"] integerValue];
        if (HotTagHiddenFlag == 0) {
            
            _recentTagView.hidden = NO;
            _searchResultTableView.hidden = YES;
        }else{
            
            _recentTagView.hidden = YES;
            
            _searchResultTableView.hidden = NO;
        }

    }
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
    [self.view endEditing:YES];
    NSArray *array = _displayTagView.tags;
    if (array.count > 0) {
         tag_ids = [array componentsJoinedByString:@","];
    }
    if ( tag_ids.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您的标签" viewController:self];
        return;
    }
//    NSLog(@"save------tag_ids-------------%@", tag_ids);
    NSDictionary *dic = @{@"question_content":self.questcontentStr,@"_question_content_supplemented":self.questcontentRemarkStr,@"tag_ids":tag_ids};
    [[RequestManager shareRequestManager]  askQuestion:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"askQuestion------>%@",result);
        if (IsSucess(result) == 1) {
            int intergral = [result[@"data"][@"result"][@"integral"] intValue];
            question_id = [result[@"data"][@"result"][@"question_id"] intValue];
            if (intergral != 0) {
                NSString *msg = [NSString stringWithFormat:@"提交成功 首次提交获取%d积分",intergral];
                [[RequestManager shareRequestManager] tipAlert:msg viewController:self];
            }else{
                [[RequestManager shareRequestManager] tipAlert:@"提交成功" viewController:self];
            }
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    } failuer:^(NSError *error) {
         [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)returnListPage{
    NSArray * ctrlArray = self.navigationController.viewControllers;
//    NSLog(@"ctrlArray------->%@",ctrlArray);
    QuestDetailViewController *vc = [[QuestDetailViewController alloc] init];
    vc.title = @"问题详情";
    vc.question_id = question_id ;
    
   [self.navigationController setViewControllers:@[ctrlArray[0],vc] animated:YES];
}



-(void)loadData{
    NSDictionary *dic = @{ @"tag_is_hot":@"1",@"tag_is_hotso":@"0" };
    [[RequestManager shareRequestManager]  getTagDtoList:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"getTagDtoList------>%@",result);
        if (IsSucess(result) == 1) {
            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
            if(![array isEqual:[NSNull null]] && array !=nil){
                [self initSubViewsWhith:array];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    } failuer:^(NSError *error) {
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
    }];
}

-(void)initSubViewsWhith:(NSArray *)array{
    CLTagsModel *model = [[CLTagsModel alloc] init];
    model.title = @"热门标签:";
    model.tagsArray = array;
//  @[@"帅气", @"发发发生", @"酷爱的法师打发", @"111", @"这是一个设sad挨打大大多", @"撒打算发发发", @"dfsafafafasfaf"];
    self.tagsModelArray = @[
                            model,
                            //                             model1, model2
                            ];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.cornerRadius = 4;
    [CLTools sharedTools].cornerRadius = self.cornerRadius;
    
    _displayTagView = [[CLDispalyTagView alloc] initWithOriginalY:kNavHeight Font:kCLTagFont*AUTO_SIZE_SCALE_X];
    self.inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_displayTagView];
    
    _recentTagView = [[CLRecentTagView alloc] init];
    [self.view addSubview:_recentTagView];
    
    _recentTagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_displayTagView]-0-[_recentTagView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayTagView,_recentTagView)]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_recentTagView]-0-|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(_recentTagView)]];
    
    _recentTagView.tagsModel = self.tagsModelArray;
    
    _displayTagView.maxRows = self.maxRows;
    _displayTagView.maxStringAmount = self.maxStringAmount = 8;
    _displayTagView.normalTextColor = self.normalTextColor;
    _displayTagView.textFieldBorderColor = self.textFieldBorderColor;
    
    
    
    
    
    
    
    
    
    _recentTagView.hidden = NO;
    _searchResultTableView = [[CLTableView alloc] init];
    [self.view addSubview:_searchResultTableView];
    
    _searchResultTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_displayTagView]-0-[_searchResultTableView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayTagView,_searchResultTableView)]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_searchResultTableView]-0-|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(_searchResultTableView)]];
    _searchResultTableView.backgroundColor = [UIColor whiteColor];
    
    _searchResultTableView.hidden = YES;
    _searchResultTableView.tagBtnDelegate = self;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:kQuestTypeSelectPage];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [MobClick endLogPageView:kQuestTypeSelectPage];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
