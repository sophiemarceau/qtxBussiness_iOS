//
//  TextPlaceCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "TextPlaceCell.h"

@implementation TextPlaceCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(ResumeTableItem *)object{
    
    return 100*AUTO_SIZE_SCALE_X;
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
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.placeNameLabel];
    [self.contentView addSubview:self.placeImageView];
    [self.contentView addSubview:self.tagViews];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X,  0.5*AUTO_SIZE_SCALE_X));
    }];
    
    [self.placeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(14.5*AUTO_SIZE_SCALE_X);
        
        make.height.mas_equalTo(14*AUTO_SIZE_SCALE_X);
        
    }];
    
    [self.placeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.placeNameLabel.mas_right).offset(10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(14.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(14*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.tagViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(-39*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-(30+9+15)*AUTO_SIZE_SCALE_X, 22*AUTO_SIZE_SCALE_X));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.bottom.equalTo(self.mas_bottom).offset(-15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 14*AUTO_SIZE_SCALE_X));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(42.5*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(9*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X));
    }];
    
}

- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem{
    self.backgroundColor = [UIColor whiteColor];
    
    self.placeNameLabel.text = resumTableItem.placeName;
    [self.placeNameLabel sizeToFit];
    self.addressLabel.text = resumTableItem.addresString;
    if(resumTableItem.isHavePlacePic){
        self.placeImageView.hidden = NO;
        
    }else{
        self.placeImageView.hidden = YES;
    }
    
    NSArray *placePropertyArray = resumTableItem.placeArray;
    if (placePropertyArray != nil || placePropertyArray.count > 0 ) {
           for(NSInteger i = 0 ; i < placePropertyArray.count; i++){
               UIButton *butto = [UIButton buttonWithType:UIButtonTypeCustom];
               [butto setTitleColor:FontUIColorBlack forState:UIControlStateNormal];
               butto.enabled = NO;
               butto.backgroundColor = UIColorFromRGB(0xF2F2F2);
//               NSLog(@"------text------>%@",placePropertyArray[i]);
               [butto setTitle:placePropertyArray[i] forState:UIControlStateNormal];
               butto.layer.cornerRadius = 2.0f;
               butto.titleLabel.textAlignment = NSTextAlignmentCenter;
               butto.titleLabel.font = [UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X];
               [self.tagViews addSubview:butto];
               CGSize buttonsize = [self sizeForNoticeTitle:placePropertyArray[i] font:[UIFont systemFontOfSize:12*AUTO_SIZE_SCALE_X]];
//               NSLog(@"------buttonsize------>%@",NSStringFromCGSize(buttonsize));
               
               [butto mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.left.equalTo(self.tagViews.mas_left).offset((20*AUTO_SIZE_SCALE_X+buttonsize.width)*i);
                   make.top.equalTo(self.tagViews.mas_top).offset(0*AUTO_SIZE_SCALE_X);
                   make.size.mas_equalTo(CGSizeMake(10*AUTO_SIZE_SCALE_X+buttonsize.width, 22*AUTO_SIZE_SCALE_X));
               }];
           }
    }
}

- (UIImageView *)lineImageView{
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

-(UILabel *)placeNameLabel{
    if (_placeNameLabel == nil) {
        _placeNameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _placeNameLabel;
}

- (UIImageView *)placeImageView{
    if (_placeImageView == nil) {
        _placeImageView = [UIImageView new];
        _placeImageView.image = [UIImage imageNamed:@"me_resume_icon_shop_pic"];
    }
    return _placeImageView;
}

-(UILabel *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [CommentMethod initLabelWithText:@"ceshi" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
    }
    return _addressLabel;
}

- (UIView *)tagViews{
    if (_tagViews == nil) {
        _tagViews = [UIView new];
        _tagViews.backgroundColor = [UIColor clearColor];
        _tagViews.userInteractionEnabled = YES;
    }
    return _tagViews;
}

/**
 *  字符串获取属性
 *  @param text
 *  @param font
 *
 *  @return size
 */
- (CGSize)sizeForNoticeTitle:(NSString*)text font:(UIFont*)font{
//    CGRect screen = [UIScreen mainScreen].bounds;
//    CGFloat maxWidth = screen.size.width;
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, 22*AUTO_SIZE_SCALE_X);
    
    CGSize textSize = CGSizeZero;
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        CGRect rect = [text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
//        if (rect.size.width > self.tagViews.frame.size.width) {
//            
//        }else{
//            
//        }
            textSize = rect.size;
    } else{
        textSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    return textSize;
}




@end
