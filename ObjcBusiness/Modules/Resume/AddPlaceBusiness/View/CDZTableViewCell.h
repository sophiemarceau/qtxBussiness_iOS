//
//  CDZTableViewCell.h
//  CDZCollectionInTableViewDemo
//
//  Created by Nemocdz on 2017/1/21.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDZTableViewCellDelegate<NSObject>
- (void)didChangeCell:(UITableViewCell *)cell pushHeight:(CGFloat)height returnPictureArray:(NSArray *)picArrays;

- (void)didSelectPhtot;
@end

@interface CDZTableViewCell : UITableViewCell<UIImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,assign) id<CDZTableViewCellDelegate> delegate;
@property (nonatomic,strong) UIViewController *myselfController;
- (void)setPicsArray:(NSArray *)picArray;
@end
