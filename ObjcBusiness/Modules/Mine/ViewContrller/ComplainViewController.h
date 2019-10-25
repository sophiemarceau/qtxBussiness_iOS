//
//  ComplainViewController.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//
#import "BaseViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import <objc/runtime.h>
#import "PhotoCollectionViewCell.h"

@interface ComplainViewController : BaseViewController
@property (nonatomic,strong)UITextView *complainLabel;



@property (nonatomic,strong)UILabel *contactLabel;
@property (nonatomic,strong)UITextField *contactTextField;
@property (nonatomic,strong)UILabel *feedbackLabel;
//@property (nonatomic,strong)UIImageView *myReportView;
@property (nonatomic,strong)UIView *viewBgImage;
@property (nonatomic,strong)UIView *complainView;


//上传图片的button
@property (nonatomic, strong)UIImageView *photoBtn;
@property (nonatomic, strong)UICollectionView *collectionV;
@property (nonatomic, strong)UIView *collectionBGView;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;






@property (nonatomic,strong)UIImageView *plusImageView;

@property (nonatomic,strong)UILabel *defaultLabel;



@property (nonatomic,assign)NSInteger feedback_kind;
@property (nonatomic,assign)NSInteger reportFromID;
@property (nonatomic,assign)NSInteger reportType;


@property (nonatomic,assign)Boolean FromProjectFlag;
@end
