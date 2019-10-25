//
//  SaveDeleteView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/8.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SaveDeleteView.h"

@implementation SaveDeleteView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BGColorGray;
        [self InitViews];

    }
    return self;
}
- (void)InitViews{
    
    [self addSubview:self.saveButton];
    [self addSubview:self.deleteButton];

    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(20*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(79*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X));
    }];
    
}

-(UIButton *)saveButton{
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = 8;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.tag = 1;
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[CommentMethod createImageWithColor:RedUIColorC1] forState:UIControlStateNormal];
//        [_saveButton setBackgroundImage:[CommentMethod createImageWithColor: [UIColor colorWithRed:249/255.0 green:54/255.0 blue:48/255.0 alpha:0.5/1.0]] forState:UIControlStateDisabled];
        
        _saveButton.enabled = YES;
    }
    return _saveButton;
}


-(UIButton *)deleteButton{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.layer.cornerRadius = 8;
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.tag = 2;
        [_deleteButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        [_deleteButton setBackgroundImage:[CommentMethod createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//        [_deleteButton setBackgroundImage:[CommentMethod createImageWithColor: [UIColor colorWithRed:249/255.0 green:54/255.0 blue:48/255.0 alpha:0.5/1.0]] forState:UIControlStateDisabled];
        
        _deleteButton.enabled = YES;
    }
    return _deleteButton;
}



@end
