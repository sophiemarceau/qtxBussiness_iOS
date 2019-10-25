//
//  LeaveMessageDetailViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "LeaveMessageDetailViewController.h"
#import "UITextView+ZWPlaceHolder.h"
@interface LeaveMessageDetailViewController (){
    NSString *phoneStr;
    NSString *str_message_id;
    
}
@property (nonatomic,strong)UIView *clientView,*remarkBgView;
@property (nonatomic,strong)UILabel *clientLabel;
@property (nonatomic,strong)UITextField *clientTextField;
@property (nonatomic,strong)UILabel *remarkLabel;
@property (nonatomic,strong)UITextView *remarksTextView;
@property (nonatomic,strong)UIButton *callPhoneButton;
@property (nonatomic,strong)UIImageView *lineImageView;
@end

@implementation LeaveMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"留言详情";
    [self initSubViews];
    [self loadData];
}

-(void)initSubViews{
    [self.view addSubview:self.clientView];
    [self.clientView addSubview:self.clientLabel];
    [self.clientView addSubview:self.clientTextField];
    [self.view addSubview:self.remarkLabel];
   
    [self.view addSubview:self.remarkBgView];
    [self.remarkBgView addSubview:self.remarksTextView];
    [self.view addSubview:self.callPhoneButton];
    [self.view addSubview:self.lineImageView];
    #pragma mark - 添加约束
    [self.clientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.view.mas_top).offset(kNavHeight+10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.clientLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clientView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.clientView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15*AUTO_SIZE_SCALE_X,50*AUTO_SIZE_SCALE_X));
    }];

    [self.clientTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.clientView.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.clientView.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-15*AUTO_SIZE_SCALE_X, (50)*AUTO_SIZE_SCALE_X));
    }];

    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clientView.mas_bottom).offset(10*AUTO_SIZE_SCALE_X);
        make.left.equalTo(self.view.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (49.5)*AUTO_SIZE_SCALE_X));
    }];

  

    [self.callPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,44*AUTO_SIZE_SCALE_X));
    }];
    
    [self.remarkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.view.mas_right).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.remarkLabel.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.callPhoneButton.mas_top).offset(-10*AUTO_SIZE_SCALE_X);
        
    }];
    [self.remarksTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkBgView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.remarkBgView.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.remarkBgView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.remarkBgView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        
    }];
    
}

-(void)loadData{
    NSDictionary *dic = @{@"message_id":[NSString stringWithFormat:@"%ld",self.message_id]};
    
    [[RequestManager shareRequestManager] getProjectMessageDto:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result ======>%@",result);
        if (IsSucess(result) == 1) {
            self.clientTextField.text  =  result[@"data"][@"dto"][@"message_user_name"];
            self.remarksTextView.text  =  result[@"data"][@"dto"][@"message_content"];
            str_message_id = [NSString stringWithFormat:@"%@",result[@"data"][@"dto"][@"str_message_id"]];
            [self.remarksTextView updatePlaceHolder];
            phoneStr = result[@"data"][@"dto"][@"message_user_tel"];
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

-(void)callPhoneNumber{
    NSDictionary *dic = @{
                          @"message_id":[NSString stringWithFormat:@"%ld",self.message_id],
                          @"str_message_id":str_message_id
                          };
    [[RequestManager shareRequestManager] getMessageUserTel:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result ======>%@",result);
        if (IsSucess(result) == 1) {
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",result[@"data"][@"result"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
                                     completionHandler:^(BOOL success) {
                                     }];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    [MobClick beginLogPageView:kLeaveMessageDetailPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kLeaveMessageDetailPage];
}

-(UIView *)clientView{
    if (_clientView == nil) {
        _clientView = [UIView new];
        _clientView.backgroundColor = [UIColor whiteColor];
    }
    return _clientView;
}

-(UILabel *)clientLabel{
    if (_clientLabel == nil) {
        _clientLabel = [CommentMethod createLabelWithText:@"客户姓名" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:14];
        
    }
    return _clientLabel;
}

-(UITextField *)clientTextField{
    if (_clientTextField == nil) {
        _clientTextField = [CommentMethod createTextFieldWithPlaceholder:@"" TextColor:FontUIColorBlack Font:14 KeyboardType:UIKeyboardTypeDefault];
        _clientTextField.textAlignment = NSTextAlignmentRight;
        _clientTextField.userInteractionEnabled = NO;
    }
    return _clientTextField;
}

-(UILabel *)remarkLabel{
    if (_remarkLabel == nil) {
        _remarkLabel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColorGray BgColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentLeft Font:14];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString
                                                  alloc] initWithString:@"备注"];
        NSUInteger length = [@"备注" length];
        NSMutableParagraphStyle *
        style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.firstLineHeadIndent = 15; //设置与尾部的距离
        style.alignment = NSTextAlignmentLeft;//靠右显示
        [attrString addAttribute:NSParagraphStyleAttributeName value:style
                           range:NSMakeRange(0, length)];
        _remarkLabel.attributedText = attrString;
        
    }
    return _remarkLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
        _lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 183.5*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5);
    }
    return _lineImageView;
}

-(UIView *)remarkBgView{
    if (_remarkBgView == nil) {
        _remarkBgView = [UIView new];
        _remarkBgView.backgroundColor = [UIColor whiteColor];
    }
    return _remarkBgView;
}

-(UITextView *)remarksTextView{
    if (_remarksTextView == nil) {
        _remarksTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _remarksTextView.layer.borderWidth = 0;
        _remarksTextView.font = [UIFont systemFontOfSize:14];
        _remarksTextView.layer.borderColor = [UIColor clearColor].CGColor;
        _remarksTextView.zw_placeHolder = @"";
        _remarksTextView.zw_placeHolderColor = FontUIColor999999Gray;
        _remarksTextView.textColor = FontUIColorBlack;
        _remarksTextView.tintColor = RedUIColorC1;
        _remarksTextView.userInteractionEnabled = NO;
    }
    return _remarksTextView;
}


-(UIButton *)callPhoneButton{
    if (_callPhoneButton == nil) {
        _callPhoneButton = [CommentMethod createButtonWithBackgroundColor:RedUIColorC1 Target:self Action:@selector(callPhoneNumber) Title:@"拨打电话" FontColor:[UIColor whiteColor] FontSize:16];
        _callPhoneButton.layer.masksToBounds = YES;
        _callPhoneButton.layer.cornerRadius = 4;
    }
    return _callPhoneButton;
}
@end
