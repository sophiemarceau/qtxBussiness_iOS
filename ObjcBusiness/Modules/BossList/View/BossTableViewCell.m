//
//  BossTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BossTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BossCellFrame.h"
#import "ConversationViewController.h"
#import "LoginViewController.h"
@implementation BossTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"BossTableViewCell";
    BossTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[BossTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BGColorGray;
        [self _initView];
    }
    return self;
}

-(void)_initView{
    [self.contentView addSubview:self.CellBGView];
    [self.CellBGView addSubview:self.headImageView];
    [self.CellBGView addSubview:self.bossFlagImageView];
    [self.CellBGView addSubview:self.nameAndJobLabel];
    [self.CellBGView addSubview:self.directChatImageView];
    [self.CellBGView addSubview:self.subLabel];
    [self.CellBGView addSubview:self.locationImageView];
    [self.CellBGView addSubview:self.locationLabel];
    [self.CellBGView addSubview:self.tradeImageView];
    [self.CellBGView addSubview:self.tradeLabel];
    [self.CellBGView addSubview:self.lineImageView];
    [self.CellBGView addSubview:self.companyPicImageView];
    [self.CellBGView addSubview:self.companyNameLabel];
    [self.CellBGView addSubview:self.identifyIconImageView];
    [self.CellBGView addSubview:self.companySubLabel];
}


-(void)setBossCellFrame:(BossCellFrame *)bossCellFrame{
    bossCellFrame = bossCellFrame;
    self.CellBGView.frame = bossCellFrame.bgviewFrame;
    self.headImageView.frame = bossCellFrame.headFrame;
    self.bossFlagImageView.frame = bossCellFrame.bossFlagFrame;
    self.nameAndJobLabel.frame = bossCellFrame.nameAndJobFrame;
    self.directChatImageView.frame = bossCellFrame.directChatFrame;
    self.subLabel.frame = bossCellFrame.subFame;
    self.locationLabel.frame = bossCellFrame.locationStrFrame;
    self.locationImageView.frame = bossCellFrame.locationFrame;
    self.tradeLabel.frame = bossCellFrame.tradeStrFrame;
    self.tradeImageView.frame = bossCellFrame.tradeFrame;
    self.lineImageView.frame = bossCellFrame.lineFrame;
    self.companyPicImageView.frame = bossCellFrame.companyPicFrame;
    self.companyNameLabel.frame = bossCellFrame.companyNameFrame;
    self.companySubLabel.frame = bossCellFrame.companySubFrame;
    self.identifyIconImageView.frame = bossCellFrame.identifyIconFrame;
    
    BossModel *bossModel = bossCellFrame.bossModel;

    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:bossModel.headStr] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    self.nameAndJobLabel.text = bossModel.nameAndJobStr;
    self.subLabel.text = bossModel.subStr;
    self.locationLabel.text = bossModel.locationStr;
    self.tradeLabel.text = bossModel.tradeStr;
    self.companyNameLabel.text = bossModel.companyNameStr;
    [self.companyPicImageView sd_setImageWithURL:[NSURL URLWithString:bossModel.companyUrlStr]];
    self.companySubLabel.text = bossModel.companySubStr;
    //企业用户、代理人是否认证；0，没有认证；1，已认证；
    if (bossModel.bossFlag == 1) {
        self.bossFlagImageView.hidden = NO;
    }else{
        self.bossFlagImageView.hidden = YES;
    }
    //project_authentication：项目认证：项目认证：0、未认证；1、提交认证；2、认证未通过；3、通过认证；
    if (bossModel.officialFlag == 3) {
        self.identifyIconImageView.hidden = NO;
    }else{
        self.identifyIconImageView.hidden = YES;
    }
    
    self.user_id_str = bossModel.user_id_str;
    self.directChatImageView.tag = [bossModel.user_id_str integerValue];
    self.userID = bossModel.bossID;
   
}

-(void)gotoChatView:(UIButton *)sender{
    NSDictionary *dic = @{
                          @"user_id_to":[NSString stringWithFormat:@"%ld",self.userID],//会话对方用户ID
                          @"source":@"2",//最新一次对话，来源/方式，1，Android；2，iOS；3，H5；4，PC；5，系统；
                          };
    
    [[RequestManager shareRequestManager] saveImUser:dic viewController:self.superVC successData:^(NSDictionary *result) {
//        NSLog(@"userID---saveImUser---%@", result );
        if (IsSucess(result) == 1) {
            NSInteger flag = [[[result objectForKey:@"data"] objectForKey:@"result"] integerValue];
            if (flag == 1) {
                ConversationViewController *conversationVC = [[ConversationViewController alloc]init];
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = self.user_id_str;
                conversationVC.user_id = self.userID;
        
                conversationVC.title =[NSString stringWithFormat:@"与%@直聊中",self.bossName];
                conversationVC.hidesBottomBarWhenPushed = YES;
                 [self.superVC.navigationController pushViewController:conversationVC animated:YES];
            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self.superVC];
            }
        }
    } failuer:^(NSError *error) {
        
    }];
}

-(UIView *)CellBGView{
    if (_CellBGView == nil) {
        _CellBGView = [UIView new];
        _CellBGView.backgroundColor = [UIColor whiteColor];
    }
    return _CellBGView;
}

-(UIImageView *)headImageView{
    if(_headImageView == nil){
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 75/2*AUTO_SIZE_SCALE_X;
        _headImageView.layer.borderWidth= 0;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

-(UIImageView *)bossFlagImageView{
    if (_bossFlagImageView == nil) {
        _bossFlagImageView = [UIImageView new];
        _bossFlagImageView.image = [UIImage imageNamed:@"boss_icon_enterprise_certification"];
    }
    return _bossFlagImageView;
}

- (UILabel *)nameAndJobLabel {
    if (_nameAndJobLabel == nil) {
        _nameAndJobLabel = [[UILabel alloc]init];
        _nameAndJobLabel.backgroundColor = [UIColor clearColor];
        _nameAndJobLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        _nameAndJobLabel.textAlignment = NSTextAlignmentLeft;
        _nameAndJobLabel.numberOfLines = 0;
        _nameAndJobLabel.textColor = FontUIColorBlack;
    }
    return _nameAndJobLabel;
}

-(UIButton *)directChatImageView{
    if (_directChatImageView == nil) {
        _directChatImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_directChatImageView setBackgroundImage:[UIImage imageNamed:@"boss_chat_btn"] forState:UIControlStateNormal];
        [_directChatImageView setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        [_directChatImageView setTitle:@"直聊" forState:UIControlStateNormal];
        _directChatImageView.titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [_directChatImageView addTarget:self action:@selector(gotoChatView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _directChatImageView;
}

- (UILabel *)subLabel {
    if (_subLabel == nil) {
        _subLabel = [[UILabel alloc]init];
        _subLabel.backgroundColor = [UIColor clearColor];
        _subLabel.textAlignment = NSTextAlignmentLeft;
        _subLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _subLabel.textColor = FontUIColor757575Gray;
        _subLabel.numberOfLines = 0;
    }
    return _subLabel;
}

-(UIImageView *)locationImageView{
    if (_locationImageView == nil) {
        _locationImageView = [UIImageView new];
        _locationImageView.image = [UIImage imageNamed:@"boss_icon_label_position"];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _locationLabel.textColor = FontUIColor757575Gray;
        
    }
    return _locationLabel;
}

-(UIImageView *)tradeImageView{
    if (_tradeImageView == nil) {
        _tradeImageView = [UIImageView new];
        _tradeImageView.image = [UIImage imageNamed:@"boss_icon_label_industry"];
    }
    return _tradeImageView;
}

- (UILabel *)tradeLabel {
    if (_tradeLabel == nil) {
        _tradeLabel = [[UILabel alloc]init];
        _tradeLabel.backgroundColor = [UIColor clearColor];
        _tradeLabel.textAlignment = NSTextAlignmentLeft;
        _tradeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _tradeLabel.textColor = FontUIColor757575Gray;
    }
    return _tradeLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

-(UIImageView *)companyPicImageView{
    if (_companyPicImageView == nil) {
        _companyPicImageView = [UIImageView new];
        _companyPicImageView.size = CGSizeMake(34*AUTO_SIZE_SCALE_X, 34*AUTO_SIZE_SCALE_X);
        _companyPicImageView.layer.cornerRadius = 4.0f;
        _companyPicImageView.layer.masksToBounds = YES;
    }
    return _companyPicImageView;
}

-(UILabel *)companyNameLabel{
    if (_companyNameLabel == nil) {
        _companyNameLabel = [[UILabel alloc]init];
        _companyNameLabel.backgroundColor = [UIColor clearColor];
        _companyNameLabel.textAlignment = NSTextAlignmentLeft;
        _companyNameLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _companyNameLabel.textColor = FontUIColorBlack;
    }
    return _companyNameLabel;
}

-(UILabel *)companySubLabel{
    if (_companySubLabel == nil) {
        _companySubLabel = [[UILabel alloc]init];
        _companySubLabel.backgroundColor = [UIColor clearColor];
        _companySubLabel.textAlignment = NSTextAlignmentLeft;
        _companySubLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _companySubLabel.textColor = FontUIColor757575Gray;
    }
    return _companySubLabel;
}

-(UIImageView *)identifyIconImageView{
    if (_identifyIconImageView == nil) {
        _identifyIconImageView = [UIImageView new];
        _identifyIconImageView.image = [UIImage imageNamed:@"boss_icon_official_certification"];
        _identifyIconImageView.hidden = NO;
    }
    return _identifyIconImageView;
}
@end
