//
//  EditBusinessExperienceCell.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/8/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EditBusinessExperienceCell.h"

@implementation EditBusinessExperienceCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

-(void)initSubViews{
    [self.contentView addSubview:self.bgroundView];
    [self.bgroundView addSubview:self.lineImageView];
    [self.bgroundView addSubview:self.titleLabel];
    [self.bgroundView addSubview:self.arrowImageView];
    [self.bgroundView addSubview:self.contentTextField];
    
    
    
#pragma mark - 添加约束
    [self.bgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top .equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (50)*AUTO_SIZE_SCALE_X));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.bgroundView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(160*AUTO_SIZE_SCALE_X,50*AUTO_SIZE_SCALE_X));
    }];

    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.bgroundView.mas_top).offset(17.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];

    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.bgroundView.mas_right).offset(-34*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X));
    }];
    
}

//涉及到tableviewcell的重用机制 所以要把它全部设置为空
- (void)prepareForReuse{
    self.bgroundView = nil;
    self.titleLabel = nil;
    self.contentTextField = nil;
    self.arrowImageView = nil;
    self.lineImageView = nil;
        //涉及到里面还有自定义的子view的时候 要把它全部设置为空
    
    //    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(UIView *)bgroundView{
    if(_bgroundView == nil){
        _bgroundView = [[UIView alloc] init];
        _bgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _bgroundView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"list_icon_more"];
    }
    return _arrowImageView;
}

-(UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _titleLabel;
}

-(UITextField *)contentTextField{
    if (_contentTextField == nil ) {
        _contentTextField = [CommentMethod createTextFieldWithPlaceholder:@"" TextColor:FontUIColor999999Gray Font:14*AUTO_SIZE_SCALE_X KeyboardType:UIKeyboardTypeDefault];
        _contentTextField.textAlignment = NSTextAlignmentRight;
        _contentTextField.userInteractionEnabled =  NO;
    }
    return _contentTextField;
}

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}


@end
