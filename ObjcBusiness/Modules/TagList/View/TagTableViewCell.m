//
//  TagTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/23.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "TagTableViewCell.h"

@implementation TagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"TagTableViewCell";
    TagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[TagTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.arrowImageView];
    
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 49*AUTO_SIZE_SCALE_X));
    }];
   
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kScreenWidth/2);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 49*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(48*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(30)*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(17*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"tag_content"]];
    self.numLabel.text =
    [NSString stringWithFormat:@"%@人收藏   %@个问题"
     ,dataDic[@"tag_collection_count"],dataDic[@"tag_question_count"]];
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
        _nameLabel.textColor = FontUIColorBlack;
    }
    return _nameLabel;
}

- (UILabel *)numLabel {
    if (_numLabel == nil) {
        _numLabel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColor999999Gray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentLeft Font:12*AUTO_SIZE_SCALE_X];
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.numberOfLines = 0;
        _numLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
    }
    return _numLabel;
}
     


-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

     - (UIImageView *)arrowImageView{
         if (_arrowImageView == nil) {
             _arrowImageView = [UIImageView new];
             _arrowImageView.image = [UIImage imageNamed:@"list_icon_more"];
         }
         return _arrowImageView;
     }

@end
