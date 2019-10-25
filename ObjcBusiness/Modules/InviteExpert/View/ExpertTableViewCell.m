//
//  ExpertTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ExpertTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ExpertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"ExpertTableViewCell";
    ExpertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[ExpertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.headerFlagImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.expertDesLAbel];
    [self.contentView addSubview:self.expertButton];
    [self.contentView addSubview:self.lineImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(40*AUTO_SIZE_SCALE_X, 40*AUTO_SIZE_SCALE_X));
    }];
    
    [self.headerFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(43*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(43*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(65*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(19*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(65+78+15+15)*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.expertDesLAbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(65*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(39*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(65+78+15+15)*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
    
    [self.expertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(78*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(69*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(30)*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
}

-(void)setDataDic:(NSDictionary *)dataDic{
//    NSLog(@"dataDic ------>%@",dataDic);
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"c_photo"]] placeholderImage:[UIImage imageNamed:@"anonymous_head_default"]];
    self.nameLabel.text = dataDic[@"c_nickname"];
    self.expertDesLAbel.text = dataDic[@"c_expert_profiles"];
    self.expertButton.tag = [dataDic[@"user_id"] intValue];
    
    int alreadyFlag = [dataDic[@"is_invited"] intValue];
//    NSLog(@"self.expertButton.tag ------>%ld",self.expertButton.tag);
    if (alreadyFlag == 1) {
        
        self.expertButton.enabled = NO;
        
        [_expertButton setTitle:@"已邀请" forState:UIControlStateNormal];
        [_expertButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF4F5F7)] forState:UIControlStateNormal];
        [_expertButton setTitleColor:FontUIColor999999Gray forState:UIControlStateNormal];
    }else{
        
        self.expertButton.enabled = YES;
        [_expertButton setTitle:@"邀请" forState:UIControlStateNormal];
        
        [_expertButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF4F5F7)] forState:UIControlStateNormal];
        
        [_expertButton setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
    }
    
    
    NSInteger userPosition_code = [dataDic[@"userPosition_code"] integerValue];
    
    if (userPosition_code == 0) {
        
        self.headerFlagImageView.image = [UIImage imageNamed:@"me_icon_expert_certification"];
    }
                                   
    if (userPosition_code == 1) {
        self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_complete_blue"];
    }
    if (userPosition_code == 2) {
        
        self.headerFlagImageView.image = [UIImage imageNamed:@"icon_authentication_default"];
    }
    if (userPosition_code == 3) {
        
        self.headerFlagImageView.hidden = YES;
    }else{
        self.headerFlagImageView.hidden = NO;
    }
}
-(void)ButtonOnclick:(UIButton *)sender{
    
    NSDictionary *dic = @{
                          @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],
                          @"user_id_invited":[NSString stringWithFormat:@"%ld",sender.tag],
                          };
//    NSLog(@"inviteAnswer----dic-->%@",dic);
    [[RequestManager shareRequestManager] inviteAnswer:dic viewController:nil successData:^(NSDictionary *result) {
//        NSLog(@"inviteAnswer------>%@",result);
        if (IsSucess(result) == 1) {
            sender.enabled = NO;
            [_expertButton setTitle:@"已邀请" forState:UIControlStateNormal];
            [_expertButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF4F5F7)] forState:UIControlStateNormal];
            [_expertButton setTitleColor:FontUIColor999999Gray forState:UIControlStateNormal];
            [[RequestManager shareRequestManager] tipAlert:@"已邀请该用户回答" viewController:self.superVC];
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

-(UIImageView *)headerImageView{
    if (_headerImageView == nil) {
        _headerImageView = [UIImageView new];
        _headerImageView.backgroundColor = [UIColor clearColor];
        _headerImageView.layer.cornerRadius = 40/2*AUTO_SIZE_SCALE_X;
        _headerImageView.layer.borderWidth= 0.0;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    return _headerImageView;
}

-(UIImageView *)headerFlagImageView{
    if (_headerFlagImageView == nil) {
        _headerFlagImageView = [UIImageView new];
        _headerFlagImageView.backgroundColor = [UIColor clearColor];
    }
    return _headerFlagImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont boldSystemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _nameLabel.textColor = FontUIColorBlack;
    }
    return _nameLabel;
}

- (UILabel *)expertDesLAbel {
    if (_expertDesLAbel == nil) {
        _expertDesLAbel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:12*AUTO_SIZE_SCALE_X];
        _expertDesLAbel.textAlignment = NSTextAlignmentLeft;
        _expertDesLAbel.numberOfLines = 0;
        _expertDesLAbel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    }
    return _expertDesLAbel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

-(UIButton *)expertButton{
    if (_expertButton == nil) {
        _expertButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _expertButton.frame = CGRectMake(kScreenWidth-166*AUTO_SIZE_SCALE_X, 0, 166*AUTO_SIZE_SCALE_X, kTabHeight);
        [_expertButton setTitle:@"邀请" forState:UIControlStateNormal];
       
        [_expertButton setBackgroundImage:[CommentMethod createImageWithColor:UIColorFromRGB(0xF4F5F7)] forState:UIControlStateNormal];
        
        [_expertButton setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
        
        _expertButton.titleLabel.font = [UIFont boldSystemFontOfSize:14*AUTO_SIZE_SCALE_X];
        [_expertButton addTarget:self action:@selector(ButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        _expertButton.layer.cornerRadius = 15*AUTO_SIZE_SCALE_X;
        _expertButton.layer.masksToBounds = YES;
     
    }
    return _expertButton;
}
@end
