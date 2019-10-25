//
//  AddQuestCotentControllerViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/16.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AddQuestCotentControllerViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "QuestTypeSelectViewController.h"

@interface AddQuestCotentControllerViewController ()<UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextViewDelegate>{
    UIBarButtonItem *rightBackItem;
}
@property(nonatomic,strong)UITextField *questionTextField;
@property(nonatomic,strong)UIImageView *lineImageView;
@property(nonatomic,strong)UITextView *remarksTextView;
@end

@implementation AddQuestCotentControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提问";
    [self initNavgation];
    [self initSubViews];
}

-(void)initSubViews{
    [self.view addSubview:self.questionTextField];
    [self.questionTextField addSubview:self.lineImageView];
    [self.view addSubview:self.remarksTextView];
}

-(void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    rightBackItem.tintColor = FontUIColor999999Gray;
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

- (void)save{
    NSString *questStr = self.questionTextField.text;
    if ( questStr.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请输入您想要提问的问题" viewController:self];
        return;
    }
    if ( questStr.length > 0 && questStr.length > 50 ) {
        [[RequestManager shareRequestManager] tipAlert:@"您想要提问的问题 不得超过50个字" viewController:self];
        return;
    }
    NSString *questRemarkStr = self.remarksTextView.text;
    if ( questRemarkStr.length > 150 ) {
        [[RequestManager shareRequestManager] tipAlert:@"备注不超过150个汉字" viewController:self];
        return;
    }
    
    QuestTypeSelectViewController *vc = [[QuestTypeSelectViewController alloc] init];
    vc.questcontentStr = questStr;
    vc.questcontentRemarkStr = questRemarkStr;
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)goBack{
    NSString *questStr = self.questionTextField.text;
    NSString *questRemarkStr = self.remarksTextView.text;
    if (questStr.length != 0 || questRemarkStr.length != 0) {
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

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
        _lineImageView.frame = CGRectMake(0, 60*AUTO_SIZE_SCALE_X-1, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    }
    return _lineImageView;
}

- (UITextField *)questionTextField{
    if (_questionTextField == nil) {
        _questionTextField = [[UITextField alloc] init];
        _questionTextField.placeholder = @"请输入问题";
        [_questionTextField setValue:FontUIColor999999Gray forKeyPath:@"_placeholderLabel.textColor"];
        _questionTextField.font = [UIFont boldSystemFontOfSize:15*AUTO_SIZE_SCALE_X];
        _questionTextField.keyboardType = UIKeyboardTypeDefault;
        _questionTextField.textAlignment = NSTextAlignmentLeft;
        _questionTextField.tintColor  =  RedUIColorC1;
        [_questionTextField addTarget:self action:@selector(textViewDidChange:) forControlEvents:UIControlEventEditingChanged];
        _questionTextField.backgroundColor =  [UIColor whiteColor];
        _questionTextField.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, kNavHeight, kScreenWidth-30*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X);
        [_questionTextField becomeFirstResponder];
    }
    return _questionTextField;
}

-(UITextView *)remarksTextView{
    if (_remarksTextView == nil) {
        _remarksTextView = [[UITextView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, kNavHeight+60*AUTO_SIZE_SCALE_X+15*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 200*AUTO_SIZE_SCALE_X)];
        _remarksTextView.layer.borderWidth = 0;
        _remarksTextView.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        _remarksTextView.layer.borderColor = [UIColor clearColor].CGColor;
        _remarksTextView.zw_placeHolder = @"(选填)如有需要，请输入问题的补充";
        _remarksTextView.zw_placeHolderColor = FontUIColor999999Gray;
        _remarksTextView.textColor = FontUIColorBlack;
        _remarksTextView.tintColor = RedUIColorC1;
        _remarksTextView.delegate = self;
    }
    return _remarksTextView;
}

- (void)textFieldWithText:(UITextField *)textField{
    if (textField.markedTextRange ==nil){
//        NSLog(@"textField:%@", textField.text);
        if (textField.text.length != 0 ) {
            rightBackItem.tintColor = RedUIColorC1;
        }else{
            rightBackItem.tintColor = FontUIColor999999Gray;
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
//        NSLog(@"questionTextField:%@", textView.text);
        if (textView.text.length != 0 ) {
            rightBackItem.tintColor = RedUIColorC1;
        }else{
            rightBackItem.tintColor = FontUIColor999999Gray;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:kAddQuestCotentPage];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAddQuestCotentPage];
    
}
@end
