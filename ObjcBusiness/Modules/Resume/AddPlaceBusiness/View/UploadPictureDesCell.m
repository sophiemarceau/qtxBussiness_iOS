//
//  UploadPictureDesCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/1.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "UploadPictureDesCell.h"

@implementation UploadPictureDesCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

-(void)initSubViews{
    [self.contentView addSubview:self.bgroundView];
    
    [self.bgroundView addSubview:self.titleLabel];
    [self.bgroundView addSubview:self.checkDemoLabel];
    
    

#pragma mark - 添加约束
    [self.bgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top .equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (32)*AUTO_SIZE_SCALE_X));
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(18*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/3*
                                         2*AUTO_SIZE_SCALE_X,14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.checkDemoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(19*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2,12*AUTO_SIZE_SCALE_X));
    }];

    
}

//涉及到tableviewcell的重用机制 所以要把它全部设置为空
- (void)prepareForReuse{
    self.bgroundView = nil;
    self.titleLabel = nil;
    self.checkDemoLabel = nil;

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


-(UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [CommentMethod initLabelWithText:@"店铺照片(选填，最多上传6张）" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _titleLabel;
}

-(UILabel *)checkDemoLabel{
    if(_checkDemoLabel == nil){
        _checkDemoLabel = [CommentMethod initLabelWithText:@"查看示例" textAlignment:NSTextAlignmentRight font:12 TextColor:RedUIColorC1];
    }
    return _checkDemoLabel;
}

@end
