//
//  ProjectMessageCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ProjectMessageCell.h"

@implementation ProjectMessageCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

-(void)initSubViews{
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.messageCountLabel];
    [self.contentView addSubview:self.arrowImageView];
   
    #pragma mark - 添加约束
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_bottom).offset(-1*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,0.5*AUTO_SIZE_SCALE_X));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/3*2,50*AUTO_SIZE_SCALE_X));
    }];
    [self.messageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(60*AUTO_SIZE_SCALE_X, (50)*AUTO_SIZE_SCALE_X));
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(17.5*AUTO_SIZE_SCALE_X);
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, (15)*AUTO_SIZE_SCALE_X));
    }];
}


//涉及到tableviewcell的重用机制 所以要把它全部设置为空
- (void)prepareForReuse{
    [super prepareForReuse];
    self.nameLabel = nil;
    self.lineImageView = nil;
    self.messageCountLabel = nil;
    self.arrowImageView = nil;
    //涉及到里面还有自定义的子view的时候 要把它全部设置为空
    //    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(UIImageView *)arrowImageView{
    if(_arrowImageView == nil){
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"list_icon_more"];
    }
    return _arrowImageView;
    
}

-(UILabel *)nameLabel{
    if(_nameLabel == nil){
        _nameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _nameLabel;
}

-(UILabel *)messageCountLabel{
    if(_messageCountLabel == nil){
        _messageCountLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentRight font:14 TextColor:FontUIColorBlack];
    }
    return _messageCountLabel;
}

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

@end
