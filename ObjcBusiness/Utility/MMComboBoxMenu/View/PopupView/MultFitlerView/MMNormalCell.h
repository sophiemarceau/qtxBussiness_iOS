//
//  MMNormalCell.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMItem.h"

@interface MMNormalCell : UITableViewCell
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *selectedImageview;
@property (nonatomic, strong) MMItem *item;

-(void)resetFrame;
@end
