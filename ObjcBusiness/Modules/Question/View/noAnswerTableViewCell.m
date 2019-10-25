//
//  noAnswerTableViewCell.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/19.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "noAnswerTableViewCell.h"

@implementation noAnswerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self _initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)_initView
{

}

-(void)setNoAnswermodel:(noAnswermodel *)noAnswermodel{
    self.contentView.backgroundColor =[UIColor redColor];
   
//
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.noneLabel).offset(20);
//    }];
}

//-(void)layoutSubviews{
//
//    [super layoutSubviews];
//
//
//
//}
@end
