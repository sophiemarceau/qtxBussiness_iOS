//
//  CDZCollectionViewCell.m
//  CDZCollectionInTableViewDemo
//
//  
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface CDZCollectionViewCell()


- (IBAction)delCell:(UIButton *)sender;

@end
@implementation CDZCollectionViewCell



- (IBAction)delCell:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didDelete:)]){
        [self.delegate didDelete:self];
    }
}

- (void)setItem:(CDZCollectionViewItem *)item{
    //  解析需要的数据
    if (item.delBtnHidden) {
        self.imageView.image = [UIImage imageNamed:item.imageStr];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.imageStr] placeholderImage:[UIImage imageNamed:@"person_default.png"]];
    }
    
    self.delButton.hidden = item.delBtnHidden;
}

@end
