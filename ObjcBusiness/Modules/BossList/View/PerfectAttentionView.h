//
//  PerfectAttentionView.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/20.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  BackToPersonViewDelegate<NSObject>
- (void)BackPersonViewDelegateReturnPage;
@end
@interface PerfectAttentionView : UIView
@property (nonatomic, strong) UIView  *shareBGView;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton  *gotoPersonalButton,*cancelButton;
@property (nonatomic, strong) UIImageView  *headView,*horizontalLineImageView,*verticallineImageView;
@property (nonatomic, weak)id <BackToPersonViewDelegate>delegate;
@end
