//
//  ComfirmEditViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ComfirmEditViewController.h"
#import "CreateProjectViewController.h"
@interface ComfirmEditViewController ()
@property(nonatomic,strong)UIImageView *attentionImageView;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIButton *gotoEditProjectButton;
@property(nonatomic,strong)UIButton *cancelButton;
@end

@implementation ComfirmEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑项目内容";
    [self.view addSubview:self.attentionImageView];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.gotoEditProjectButton];
}

-(void)gotoEditProjectView:(UIButton *)button{
    CreateProjectViewController *vc = [[CreateProjectViewController alloc] init];
    vc.viewType = EditProject;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIImageView *)attentionImageView{
    if (_attentionImageView == nil) {
        _attentionImageView = [UIImageView new];
        _attentionImageView.image = [UIImage imageNamed:@"form_icon_notice"];
        _attentionImageView.frame = CGRectMake((kScreenWidth-60*AUTO_SIZE_SCALE_X)/2, kNavHeight+75*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X);
    }
    return _attentionImageView;
}

-(UILabel *)descLabel{
    if (_descLabel == nil) {
        _descLabel = [CommentMethod createLabelWithText:@"确定编辑后，您的项目将会下线编辑完成后需要重新提交审核" TextColor:FontUIColorGray BgColor:[UIColor clearColor] TextAlignment:NSTextAlignmentCenter Font:17];
        _descLabel.textColor = FontUIColorBlack;
        _descLabel.numberOfLines = 2;
        _descLabel.frame = CGRectMake(60*AUTO_SIZE_SCALE_X, CGRectGetMaxY(self.attentionImageView.frame)+40*AUTO_SIZE_SCALE_X, kScreenWidth-120*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X);
    }
    return _descLabel;
}

-(UIButton *)gotoEditProjectButton{
    if (_gotoEditProjectButton == nil) {
        _gotoEditProjectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoEditProjectButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_gotoEditProjectButton setTitle:@"确定编辑" forState:UIControlStateNormal];
        _gotoEditProjectButton.layer.cornerRadius = 8;
        _gotoEditProjectButton.layer.masksToBounds = YES;
        [_gotoEditProjectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_gotoEditProjectButton setBackgroundImage:[CommentMethod createImageWithColor:RedUIColorC1] forState:UIControlStateNormal];
        [_gotoEditProjectButton addTarget:self action:@selector(gotoEditProjectView:) forControlEvents:UIControlEventTouchUpInside];
        _gotoEditProjectButton.frame = CGRectMake(195*AUTO_SIZE_SCALE_X, kScreenHeight-88*AUTO_SIZE_SCALE_X, 155*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
    }
    return _gotoEditProjectButton;
}

-(UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16*AUTO_SIZE_SCALE_X];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RedUIColorC1 forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 8;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderColor = RedUIColorC1.CGColor;
        _cancelButton.layer.borderWidth = 1;
        
        [_cancelButton setBackgroundImage:[CommentMethod createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(25*AUTO_SIZE_SCALE_X, kScreenHeight-88*AUTO_SIZE_SCALE_X,  155*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
    }
    return _cancelButton;
}

@end
