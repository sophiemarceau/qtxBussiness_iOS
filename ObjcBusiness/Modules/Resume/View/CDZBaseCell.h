//
//  CDZBaseCell.h
//  CDZDifferenceCellDemo
//
//  Created by Nemocdz on 2017/1/2.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResumeTableItem;
@interface CDZBaseCell : UITableViewCell

@property (nonatomic,strong) ResumeTableItem *item;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(ResumeTableItem *)object;
- (void)setResumeTableItem:(ResumeTableItem *)resumTableItem;
@end
