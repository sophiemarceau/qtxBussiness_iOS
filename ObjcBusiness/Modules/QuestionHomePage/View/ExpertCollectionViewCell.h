//
//  ExpertCollectionViewCell.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/24.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *headview,*headerFlagImageView;
@property (nonatomic, strong)UILabel *nameLabel ;
@property (nonatomic, strong)UILabel *desLabel;
@property (nonatomic, strong)UIButton * btn;
@end
