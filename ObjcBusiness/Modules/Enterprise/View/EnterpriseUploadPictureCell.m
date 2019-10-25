//
//  EnterpriseUploadPictureCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EnterpriseUploadPictureCell.h"

@implementation EnterpriseUploadPictureCell



+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(EnterpriseItem *)object{
    
    return 265*AUTO_SIZE_SCALE_X;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self.contentView addSubview:self.functionLabel];
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.headBGView];
    [self.headBGView addSubview:self.headImageView];
    [self.headBGView addSubview:self.headBGLabel];
    
    [self.functionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 49.5*AUTO_SIZE_SCALE_X));
    }];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(49*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,  0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.headBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(65*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-50*AUTO_SIZE_SCALE_X,  175*AUTO_SIZE_SCALE_X));
    }];

    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBGView.mas_left).offset(137.5*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headBGView.mas_top).offset(50.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(50*AUTO_SIZE_SCALE_X,  50*AUTO_SIZE_SCALE_X));
    }];

    [self.headBGLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBGView.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.headBGView.mas_top).offset(110.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-50*AUTO_SIZE_SCALE_X,  14*AUTO_SIZE_SCALE_X));
    }];
    
}

- (void)setResumeTableItem:(EnterpriseItem *)resumTableItem{
    self.backgroundColor = [UIColor whiteColor];
    self.functionLabel.text = resumTableItem.name;
    self.headBGLabel.text = resumTableItem.functionValue;
}

- (UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}



-(UILabel *)functionLabel{
    if (_functionLabel == nil) {
        _functionLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _functionLabel;
}


- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        self.headImageView = [UIImageView new];
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.image =[UIImage imageNamed:@"list_icon_upload"];
        self.headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self.headImageView setContentMode:UIViewContentModeScaleAspectFill];
        self.headImageView.clipsToBounds = YES;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageClick:)];
//        [self.headImageView addGestureRecognizer:singleTap];
        
    }
    return _headImageView;
}

-(UIImageView *)headBGView{
    if (_headBGView==nil) {
        self.headBGView = [UIImageView new];
        self.headBGView.backgroundColor = [UIColor whiteColor];
        self.headBGView.userInteractionEnabled = YES;
        
    }
    return _headBGView;
}

-(UILabel *)headBGLabel{
    if (_headBGLabel==nil) {
        self.headBGLabel = [UILabel new];
        self.headBGLabel.backgroundColor = [UIColor clearColor];
        self.headBGLabel.textColor = UIColorFromRGB(0xadadad);
        self.headBGLabel.text =@"";
        self.headBGLabel.font = [UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X];
        self.headBGLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headBGLabel;
}

- (void)drawRect:(CGRect)rect{
    self.headBGView.image = [self imageWithSize:self.headBGView.frame.size borderColor:FontUIColorGray borderWidth:0.5*AUTO_SIZE_SCALE_X];
}

#pragma mark - view 添加虚线边框
-(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
