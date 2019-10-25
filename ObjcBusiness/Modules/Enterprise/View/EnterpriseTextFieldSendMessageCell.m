//
//  EnterpriseTextFieldSendMessageCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EnterpriseTextFieldSendMessageCell.h"

@implementation EnterpriseTextFieldSendMessageCell
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(EnterpriseItem *)object{
    
    return 50*AUTO_SIZE_SCALE_X;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        i =60;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendsuccess) name:NOTIFICATION_CompanySendMessage object:nil];
    }
    return self;
}

- (void)initSubViews{
    [self.contentView addSubview:self.ValueLabel];
    [self.contentView addSubview:self.sendMessageButton];
    
    [self.ValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 50*AUTO_SIZE_SCALE_X));
    }];
    
    [self.sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X));
    }];
}

- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem{
    self.cellableItem = resumTableItem;
    self.backgroundColor = [UIColor whiteColor];
//    self.ValueLabel.placeholder = resumTableItem.name;
    self.ValueLabel.text = resumTableItem.functionValue;
    if(resumTableItem.isHiddenLine){
        self.lineImageView.hidden = YES;
    }else{
        self.lineImageView.hidden = NO;
    }
    
}

- (UITextField *)ValueLabel{
    if (_ValueLabel == nil) {
        _ValueLabel = [[UITextField alloc] init];
        _ValueLabel.placeholder = @"请输入验证码";
        _ValueLabel.keyboardType = UIKeyboardTypeNumberPad;
        _ValueLabel.textAlignment = NSTextAlignmentLeft;
        _ValueLabel.tintColor  =  RedUIColorC1;
        [_ValueLabel addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];

    }
    return _ValueLabel;
}

-(UIButton *)sendMessageButton{
    if (_sendMessageButton == nil) {
        _sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendMessageButton.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [_sendMessageButton setTitle:@"发送验证码" forState:UIControlStateNormal];
//        _sendMessageButton.tag = SendMessageButtonTag;
        [_sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendMessageButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF93630)] forState:UIControlStateNormal];
        [_sendMessageButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
        _sendMessageButton.layer.cornerRadius = 4;
        _sendMessageButton.layer.masksToBounds = YES;
        
        _sendMessageButton.enabled = YES;
    }
    return _sendMessageButton;
}

- (void)textFieldWithText:(UITextField *)textField{
    self.cellableItem.functionValue = textField.text;
}

-(void)sendsuccess
{
    [self.sendMessageButton removeFromSuperview];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runClock) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)runClock{
    self.timeLabel.text = [NSString stringWithFormat:@"%ld秒后重发",i];
    [self addSubview:self.timeLabel];
    //约束
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(10*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X));
    }];
    i--;
    if (i<0) {
        [self.timer invalidate];
        [self.timeLabel removeFromSuperview];
        [self addSubview:self.sendMessageButton];
        //约束
        [self.sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
            make.top.equalTo(self.mas_top).offset(10*AUTO_SIZE_SCALE_X);
            make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X));
        }];
        i=60;
    }

}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = FontUIColorBlack;
        self.timeLabel.backgroundColor = UIColorFromRGB(0xdddddd);
        self.timeLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.layer.cornerRadius = 18*AUTO_SIZE_SCALE_X;
    }
    return _timeLabel;
}
@end
