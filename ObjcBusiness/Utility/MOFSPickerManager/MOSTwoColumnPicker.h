//
//  MOSTwoColumnPicker.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOFSToolbar.h"
#import "TradeModel.h"

@interface MOSTwoColumnPicker : UIPickerView
@property (nonatomic, assign) NSInteger showTag;
@property (nonatomic, strong) MOFSToolbar *toolBar;
@property (nonatomic, strong) UIView *containerView;

- (void)show2ColumnTradePickerCommitBlock:(void(^)(NSString *valueStr, NSString *codeStr))commitBlock cancelBlock:(void(^)(void))cancelBlock;
@end
