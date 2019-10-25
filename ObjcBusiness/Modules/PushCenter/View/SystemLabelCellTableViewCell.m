//
//  SystemLabelCellTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SystemLabelCellTableViewCell.h"

@implementation SystemLabelCellTableViewCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(SystemTableItem *)object{
//    NSLog(@"msg_page_to------->%@",object.msg_page_to);
    NSArray *temparray  = [object.msg_page_to componentsSeparatedByString:@"|"];
    if (temparray.count > 0 && [temparray[0] isEqualToString:@"0"]) {
            UILabel *templabel =  [[UILabel alloc] init];
            templabel.text = @"";
            templabel.textAlignment = NSTextAlignmentCenter;
            templabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
            templabel.textColor = FontUIColor757575Gray;

            templabel.backgroundColor = UIColorFromRGB(0xdddddd);
            
            templabel.frame =CGRectMake(0, 0, kScreenWidth-60*AUTO_SIZE_SCALE_X,0);
            [templabel setNumberOfLines:0];
            templabel.text = object.contentStr;
            [templabel sizeToFit];
            return (60*AUTO_SIZE_SCALE_X + 42*AUTO_SIZE_SCALE_X + templabel.frame.size.height +15*AUTO_SIZE_SCALE_X);
    }else{
        return (141.5+60)*AUTO_SIZE_SCALE_X;
    }
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"SystemLabelCellTableViewCell";
    SystemLabelCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[SystemLabelCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BGColorGray;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.contentLabel];
    [self.bgImageView addSubview:self.lineImageView];
    [self.bgImageView addSubview:self.checkLabel];
    [self.bgImageView addSubview:self.arrowImageView];
}

-(CGFloat)rowHeightForObject:(SystemTableItem *)resumTableItem{
    _resumTableItem = resumTableItem;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",resumTableItem.timeStr];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",resumTableItem.titleStr];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",resumTableItem.contentStr];
    
    self.timeLabel.frame = CGRectMake(120*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 135.5*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    self.titleLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth-60*AUTO_SIZE_SCALE_X,  42*AUTO_SIZE_SCALE_X);
    self.contentLabel.frame =CGRectMake( 15*AUTO_SIZE_SCALE_X,  42*AUTO_SIZE_SCALE_X, kScreenWidth-60*AUTO_SIZE_SCALE_X,0);
    NSArray *temparray  = [resumTableItem.msg_page_to componentsSeparatedByString:@"|"];
    if (temparray.count > 0 && [temparray[0] isEqualToString:@"0"]) {
        self.lineImageView.hidden = YES;
        self.checkLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.lineImageView.frame = CGRectZero;
        self.checkLabel.frame = CGRectZero;
        self.arrowImageView.frame = CGRectZero;
        self.bgImageView.userInteractionEnabled = NO;
        self.contentLabel.text = resumTableItem.contentStr;
        [self.contentLabel sizeToFit];
        self.contentLabel.frame =CGRectMake( self.contentLabel.frame.origin.x,  self.contentLabel.frame.origin.y, self.contentView.size.width,self.contentView.size.height);
        self.bgImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,  60*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, self.titleLabel.frame.size.height+self.contentLabel.frame.size.height+15*AUTO_SIZE_SCALE_X);
    }else{
        self.lineImageView.hidden = NO;
        self.checkLabel.hidden = NO;
        self.arrowImageView.hidden = NO;
        self.bgImageView.userInteractionEnabled = YES;
        self.contentLabel.text = resumTableItem.contentStr;
        self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x,  self.contentLabel.frame.origin.y, kScreenWidth-60*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X);
        
        self.lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,
                                              CGRectGetMaxY(self.contentLabel.frame)-0.5*AUTO_SIZE_SCALE_X+15*AUTO_SIZE_SCALE_X,
                                              kScreenWidth-60*AUTO_SIZE_SCALE_X,
                                              0.5*AUTO_SIZE_SCALE_X);
        self.checkLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,
                                           CGRectGetMaxY(self.lineImageView.frame),
                                           kScreenWidth-90*AUTO_SIZE_SCALE_X,
                                           44*AUTO_SIZE_SCALE_X);
        self.arrowImageView.frame = CGRectMake(kScreenWidth-30*AUTO_SIZE_SCALE_X-9*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X,
                                               CGRectGetMaxY(self.lineImageView.frame)+14.5*AUTO_SIZE_SCALE_X,
                                               9*AUTO_SIZE_SCALE_X,
                                               15*AUTO_SIZE_SCALE_X);
        self.bgImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,
                                            60*AUTO_SIZE_SCALE_X,
                                            kScreenWidth-30*AUTO_SIZE_SCALE_X,141.5*AUTO_SIZE_SCALE_X);
    }
    return self.bgImageView.frame.size.height+self.bgImageView.frame.origin.y;
}

- (void)setResumTableItem:(SystemTableItem *)resumTableItem{
    
    
    _resumTableItem = resumTableItem;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",resumTableItem.timeStr];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",resumTableItem.titleStr];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",resumTableItem.contentStr];
    
    self.timeLabel.frame = CGRectMake(120*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X, 135.5*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    self.titleLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth-60*AUTO_SIZE_SCALE_X,  42*AUTO_SIZE_SCALE_X);
    self.contentLabel.frame =CGRectMake( 15*AUTO_SIZE_SCALE_X,  42*AUTO_SIZE_SCALE_X, kScreenWidth-60*AUTO_SIZE_SCALE_X,0);
     NSArray *temparray  = [resumTableItem.msg_page_to componentsSeparatedByString:@"|"];
    if (temparray.count > 0 && [temparray[0] isEqualToString:@"0"]) {
        self.lineImageView.hidden = YES;
        self.checkLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.lineImageView.frame = CGRectZero;
        self.checkLabel.frame = CGRectZero;
        self.arrowImageView.frame = CGRectZero;
        self.bgImageView.userInteractionEnabled = NO;
        self.contentLabel.text = resumTableItem.contentStr;
        [self.contentLabel sizeToFit];
        self.contentLabel.frame =CGRectMake( self.contentLabel.frame.origin.x,  self.contentLabel.frame.origin.y, self.contentView.size.width,self.contentView.size.height);
        self.bgImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,  60*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, self.titleLabel.frame.size.height+self.contentLabel.frame.size.height+15*AUTO_SIZE_SCALE_X);
    }else{
        self.lineImageView.hidden = NO;
        self.checkLabel.hidden = NO;
        self.arrowImageView.hidden = NO;
        self.bgImageView.userInteractionEnabled = YES;
        self.contentLabel.text = resumTableItem.contentStr;
        self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x,  self.contentLabel.frame.origin.y, kScreenWidth-60*AUTO_SIZE_SCALE_X,40*AUTO_SIZE_SCALE_X);
        
        self.lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,
                                              CGRectGetMaxY(self.contentLabel.frame)-0.5*AUTO_SIZE_SCALE_X+15*AUTO_SIZE_SCALE_X,
                                              kScreenWidth-60*AUTO_SIZE_SCALE_X,
                                              0.5*AUTO_SIZE_SCALE_X);
        self.checkLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,
                                           CGRectGetMaxY(self.lineImageView.frame),
                                           kScreenWidth-90*AUTO_SIZE_SCALE_X,
                                           44*AUTO_SIZE_SCALE_X);
        self.arrowImageView.frame = CGRectMake(kScreenWidth-30*AUTO_SIZE_SCALE_X-9*AUTO_SIZE_SCALE_X-15*AUTO_SIZE_SCALE_X,
                                               CGRectGetMaxY(self.lineImageView.frame)+14.5*AUTO_SIZE_SCALE_X,
                                               9*AUTO_SIZE_SCALE_X,
                                               15*AUTO_SIZE_SCALE_X);
        self.bgImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,
                                            60*AUTO_SIZE_SCALE_X,
                                            kScreenWidth-30*AUTO_SIZE_SCALE_X,141.5*AUTO_SIZE_SCALE_X);
    }
}

//- (void)prepareForReuse{
//    [super prepareForReuse];
//
//
//    self.timeLabel = nil;
//    self.bgImageView = nil;
//    self.titleLabel = nil;
//    self.contentLabel = nil;
//    self.checkLabel = nil;
//    self.lineImageView = nil;
//    self.arrowImageView = nil;
//
//
//    //    self.bgroundView = nil;
//    //    self.titleLabel = nil;
//    //    self.tagView = nil;
//    //    self.investLabel = nil;
//    //    self.nameLabel = nil;
//    //    self.postionDesLabel = nil;
//    //
//    //    self.lineImageView = nil;
//    //    self.headImageView = nil;
//    //
//    //    self.picImageView = nil;
//    //    //涉及到里面还有自定义的子view的时候 要把它全部设置为空
//    //
//
//}
-(void)Onclick:(id)sender{
    NSString *string = self.resumTableItem.msg_page_to;
    NSArray *temparray  = [string componentsSeparatedByString:@"|"];
    if ( temparray.count ==2) {
        [self.delegate checkButtonOnclick:[temparray[1] integerValue]];
    }
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel  = [[UILabel alloc] init];
        _timeLabel.text = @"";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = UIColorFromRGB(0xdddddd);
        _timeLabel.layer.cornerRadius = 5.0f;
        _timeLabel.layer.masksToBounds = YES;
    }
    return _timeLabel;
}

-(UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [UIImageView new];
        _bgImageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * NewViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Onclick:)];
        
        [self.bgImageView addGestureRecognizer:NewViewtap];

    }
    return _bgImageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"系统提示";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _titleLabel.textColor =FontUIColorBlack;
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment =NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        _contentLabel.textColor = FontUIColor757575Gray;
        [self.contentLabel setNumberOfLines:0];
    }
    return _contentLabel;
}

-(UILabel *)checkLabel{
    if (_checkLabel == nil) {
        _checkLabel = [CommentMethod initLabelWithText:@"点击查看" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
    }
    return _checkLabel;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image =[UIImage imageNamed:@"list_icon_more"];
    }
    return _arrowImageView;
}

- (UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}



@end
