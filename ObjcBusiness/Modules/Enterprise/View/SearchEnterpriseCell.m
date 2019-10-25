//
//  SearchEnterpriseCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SearchEnterpriseCell.h"

@implementation SearchEnterpriseCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        self.backgroundColor = BGColorGray;
    }
    return self;
    
}

-(void)initSubViews{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.selectImageVIew];
    [self.contentView addSubview:self.flagBgView];
    [self.contentView addSubview:self.flagLabel];
    [self.flagBgView addSubview:self.flagImageView];
    #pragma mark - 添加约束
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_bottom).offset(-1*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,0.5*AUTO_SIZE_SCALE_X));
    }];

    [self.selectImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(13*AUTO_SIZE_SCALE_X,13*AUTO_SIZE_SCALE_X));
    }];
    
    [self.flagBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(17*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(48*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X));
    }];

    [self.flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagImageView.mas_right).offset(1*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.flagBgView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(32.5*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X));
    }];

    [self.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagBgView.mas_left).offset(2.5*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.flagBgView.mas_top).offset(1.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(12*AUTO_SIZE_SCALE_X,12*AUTO_SIZE_SCALE_X));
    }];
}

//涉及到tableviewcell的重用机制 所以要把它全部设置为空
- (void)prepareForReuse{
    [super prepareForReuse];
    self.nameLabel = nil;
    self.selectImageVIew = nil;
    self.flagImageView = nil;
    self.lineImageView = nil;
}

-(UILabel *)nameLabel{
    if(_nameLabel == nil){
        _nameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorBlack];
    }
    return _nameLabel;
}

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

-(UIImageView *)flagImageView{
    if(_flagImageView == nil){
        _flagImageView = [UIImageView new];
        _flagImageView.image = [UIImage imageNamed:@"icon_authentication_complete"];
        _flagImageView.size = CGSizeMake(12*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X);
    }
    return _flagImageView;
}

-(UIImageView *)selectImageVIew{
    if(_selectImageVIew == nil){
        _selectImageVIew = [UIImageView new];
        _selectImageVIew.image = [UIImage imageNamed:@"topbar_icon_complete_selected"];
    }
    return _selectImageVIew;
}

-(UILabel *)flagLabel{
    if(_flagLabel == nil){
        _flagLabel = [CommentMethod initLabelWithText:@"已认证" textAlignment:NSTextAlignmentCenter font:9 TextColor:RedUIColorC1];
    }
    return _flagLabel;
}

-(UIView *)flagBgView{
    if(_flagBgView == nil){
        _flagBgView = [UIView new];
        _flagBgView.layer.borderWidth = 1;
        _flagBgView.layer.borderColor = [RedUIColorC1 CGColor];
        _flagBgView.backgroundColor = [UIColor whiteColor];
        _flagBgView.layer.masksToBounds = YES;
        _flagBgView.layer.cornerRadius = 8.0f;
     
    }
    return _flagBgView;
}



@end
