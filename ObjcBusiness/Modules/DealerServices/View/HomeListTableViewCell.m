//
//  HomeListTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/15.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "HomeListTableViewCell.h"

@implementation HomeListTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        self.backgroundColor = BGColorGray;
    }
    return self;
    
}

-(void)initSubViews{
    [self.contentView addSubview:self.bgroundView];
    [self.bgroundView addSubview:self.picImageView];
    [self.bgroundView addSubview:self.titleLabel];
    [self.bgroundView addSubview:self.tagView];
    [self.bgroundView addSubview:self.subLabel];
    [self.bgroundView addSubview:self.investLabel];
    [self.bgroundView addSubview:self.nameLabel];
    [self.bgroundView addSubview:self.postionDesLabel];
    
    [self.bgroundView addSubview:self.lineImageView];
    [self.bgroundView addSubview:self.headImageView];
    [self.bgroundView addSubview:self.headerFlagImageView];
    [self.bgroundView addSubview:self.verticalImageView];
    
    
    #pragma mark - 添加约束
    [self.bgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (130+44)*AUTO_SIZE_SCALE_X));
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X,100*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(130*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.picImageView.mas_left).offset(-20*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(15*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(17*AUTO_SIZE_SCALE_X);
    }];

    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.picImageView.mas_left).offset(-20*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(42*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(12*AUTO_SIZE_SCALE_X);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.picImageView.mas_left).offset(-20*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(64*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(14*AUTO_SIZE_SCALE_X);
    }];

    [self.investLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.picImageView.mas_left).offset(-20*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(100*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(18*AUTO_SIZE_SCALE_X);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.bgroundView.mas_bottom).offset(-9.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(25*AUTO_SIZE_SCALE_X,25*AUTO_SIZE_SCALE_X));
    }];
    
    [self.headerFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(36*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.bgroundView.mas_bottom).offset(-6.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(12*AUTO_SIZE_SCALE_X,12*AUTO_SIZE_SCALE_X));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.bgroundView.mas_bottom).offset(-16*AUTO_SIZE_SCALE_X);
        make.height.mas_equalTo(12*AUTO_SIZE_SCALE_X);
    }];
    
//    [self.verticalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLabel.mas_right).offset(4*AUTO_SIZE_SCALE_X);
//        make.bottom.equalTo(self.bgroundView.mas_bottom).offset(-16*AUTO_SIZE_SCALE_X);
//        make.size.mas_equalTo(CGSizeMake(0.5*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
//    }];
    
    [self.postionDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.bgroundView.mas_bottom).offset(-16*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-105*AUTO_SIZE_SCALE_X, 12*AUTO_SIZE_SCALE_X));
    }];
}

////涉及到tableviewcell的重用机制 所以要把它全部设置为空
- (void)prepareForReuse{
    [super prepareForReuse];
//    self.bgroundView = nil;
//    self.titleLabel = nil;
//    self.tagView = nil;
//    self.investLabel = nil;
//    self.nameLabel = nil;
//    self.postionDesLabel = nil;
//
//    self.lineImageView = nil;
//    self.headImageView = nil;
//
//    self.picImageView = nil;
//    //涉及到里面还有自定义的子view的时候 要把它全部设置为空
//
    [self.tagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(UIView *)bgroundView{
    if(_bgroundView == nil){
        _bgroundView = [[UIView alloc] init];
        _bgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _bgroundView;
}

-(UIImageView *)picImageView{
    if(_picImageView == nil){
        _picImageView = [UIImageView new];
        _picImageView.layer.cornerRadius = 20;
        _picImageView.layer.borderWidth= 1.0;
        _picImageView.layer.masksToBounds = YES;
        _picImageView.layer.borderColor = [UIColorFromRGB(0xEFEFEF) CGColor];
        _picImageView.layer.cornerRadius = 4;
    }
    return _picImageView;
    
}

-(UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:17 TextColor:FontUIColorBlack];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17*AUTO_SIZE_SCALE_X];
    }
    return _titleLabel;
}

-(UILabel *)subLabel{
    if (_subLabel == nil ) {
        _subLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorGray];
    }
    return _subLabel;
}

-(UIView *)tagView{
    if(_tagView == nil){
        _tagView = [[UIView alloc] init];
        
    }
    return _tagView;
}

-(UILabel *)investLabel{
    if(_investLabel == nil){
        _investLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15 TextColor:FontUIColorBlack];
    }
    return _investLabel;
}

-(UILabel *)nameLabel{
    if(_nameLabel == nil){
        _nameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorBlack];
        
    }
    return _nameLabel;
}

-(UILabel *)postionDesLabel{
    if(_postionDesLabel == nil){
        _postionDesLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12 TextColor:FontUIColorGray];
        
    }
    return _postionDesLabel;
}

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}
    
-(UIImageView *)headImageView{
    if(_headImageView == nil){
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 25/2*AUTO_SIZE_SCALE_X;
        _headImageView.layer.borderWidth= 0;
        _headImageView.layer.masksToBounds = YES;
        
    }
    return _headImageView;
}

-(UIImageView *)headerFlagImageView{
    if(_headerFlagImageView == nil){
        _headerFlagImageView = [UIImageView new];
    }
    return _headerFlagImageView;
}
@end
