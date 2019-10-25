//
//  ChooseCollectionViewCell.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/12/6.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIButton *iconButton;
@property (nonatomic,strong)UIButton *duigouButton;
@property (nonatomic,strong)UILabel *functionNamelabel;

@property (nonatomic,assign)BOOL isSelected;
-(void)UpdateCellWithState:(BOOL)select;
-(void)setSelectBgView:(NSInteger)indexpathRow WithContentName:(NSString *)contentStr;
@end
