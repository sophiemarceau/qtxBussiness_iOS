//
//  DetailTextViewTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/12.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DetailTextViewTableViewCell.h"

@implementation DetailTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(ResumeTableItem *)object{
    return 184*AUTO_SIZE_SCALE_X;
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
    self.contentView.backgroundColor = BGColorGray;
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.remarksbgView];
    [self.remarksbgView addSubview:self.remarksTextView];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10*AUTO_SIZE_SCALE_X);
        make.left.equalTo(self.contentView.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (49.5)*AUTO_SIZE_SCALE_X));
    }];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(59.5*AUTO_SIZE_SCALE_X);
        make.left.equalTo(self.contentView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, (0.5)*AUTO_SIZE_SCALE_X));
    }];
    
    [self.remarksbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineImageView.mas_bottom).offset(0*AUTO_SIZE_SCALE_X);
        make.left.equalTo(self.contentView.mas_left).offset(0*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (134)*AUTO_SIZE_SCALE_X));
    }];
    [self.remarksTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarksbgView.mas_top).offset(0*AUTO_SIZE_SCALE_X);
        make.left.equalTo(self.remarksbgView.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, (134)*AUTO_SIZE_SCALE_X));
    }];
}

- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem{
//    self.backgroundColor = [UIColor whiteColor];
//    self.functionLabel.text = resumTableItem.name;
//    self.phoneTextField.text = resumTableItem.functionValue;
//    if (resumTableItem.isShowLineImageFlag) {
//        self.lineImageView.hidden = YES;
//    }else{
//        self.lineImageView.hidden = NO;
//    }
}


-(UILabel *)remarkLabel{
    if (_remarkLabel == nil) {
        _remarkLabel = [CommentMethod createLabelWithText:@"" TextColor:FontUIColorGray BgColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentLeft Font:14];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString
                                                  alloc] initWithString:@"项目详情"];
        NSUInteger length = [@"项目详情" length];
        NSMutableParagraphStyle *
        style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.firstLineHeadIndent = 15; //设置与尾部的距离
        style.alignment = NSTextAlignmentLeft;//靠右显示
        [attrString addAttribute:NSParagraphStyleAttributeName value:style
                           range:NSMakeRange(0, length)];
        _remarkLabel.attributedText = attrString;
    }
    return _remarkLabel;
}

- (UIView *)remarksbgView{
    if (_remarksbgView == nil) {
        _remarksbgView = [UIView new];
        _remarksbgView.backgroundColor = [UIColor whiteColor];
        //        _remarksbgView.frame = CGRectMake(0, 44*AUTO_SIZE_SCALE_X, kScreenWidth , 150*AUTO_SIZE_SCALE_X);
        [_remarksbgView addSubview:self.remarksTextView];
    }
    return _remarksbgView;
}

-(UITextView *)remarksTextView{
    if (_remarksTextView == nil) {
        _remarksTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _remarksTextView.layer.borderWidth = 0;
        _remarksTextView.font = [UIFont systemFontOfSize:14];
        _remarksTextView.layer.borderColor = [UIColor clearColor].CGColor;
        _remarksTextView.zw_placeHolder = @"请详细的描述该项目的内容细节与合作方式";
        _remarksTextView.zw_placeHolderColor = FontUIColor999999Gray;
        _remarksTextView.textColor = FontUIColorBlack;
        _remarksTextView.tintColor = RedUIColorC1;
    }
    return _remarksTextView;
}

-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
    }
    return _lineImageView;
}

@end
