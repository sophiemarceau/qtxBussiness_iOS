//
//  CLRecentTagView.m
//  CLTageViewDemo
//
//  Created by Criss on 2017/4/20.
//  Copyright © 2017年 Criss. All rights reserved.
//

#import "CLRecentTagView.h"
#import "CLTagView.h"
#import "CLTools.h"
#import "CLTagsModel.h"
#import "CLTagButton.h"

@interface CLRecentTagView ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *lineImageView;
@end

@implementation CLRecentTagView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self showUI];
    }
    return self;
}

- (void)showUI {
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(IsUserInteractionEnabled:) name:NOTIFICATION_kCLDisplayTagViewAddTagNotification object:nil];
//    self.backgroundColor = cl_colorWithHex(0xf0eff3);
    self.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.lineImageView];
    self.scrollView.scrollEnabled = NO;
}

- (void)setTagsModel:(NSArray<CLTagsModel *> *)tagsModel {
    CLTagView *lastTagView;
    CLTagView *perTagView;
    for (int i = 0; i < tagsModel.count; i ++) {
        CLTagView *tagView = [[CLTagView alloc] init];
        [self.scrollView addSubview:tagView];
        
        tagView.frame = CGRectMake(0, !i?:(CGRectGetMaxY(perTagView.frame) + kCLDistance), 0, CGRectGetMaxY(tagsModel[i].tagBtnArray.lastObject.frame)+ kCLDistance + kCLHeadViewdHeight);
        tagView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
        tagView.displayTags = self.displayTags;
        tagView.tags = tagsModel[i];
    
        perTagView = tagView;
        if (i == tagsModel.count - 1) {
            lastTagView = tagView;
        }
    }
    
    CGSize scrollContenSize = self.scrollView.contentSize;
    scrollContenSize.height = CGRectGetMaxY(lastTagView.frame);
    self.scrollView.contentSize = scrollContenSize;
    
}


-(UIImageView *)lineImageView{
    if(_lineImageView == nil){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = lineImageColor;
        _lineImageView.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 0.5*AUTO_SIZE_SCALE_X);
    }
    return _lineImageView;
}


- (void)IsUserInteractionEnabled:(NSNotification *)notification {
    NSString *flag = notification.userInfo[NOTIFICATION_kCLDisplayTagViewAddTagNotification];
//    NSLog(@"flag------YES----->%@",flag);
    if ([flag isEqualToString:@"0"]) {
        self.userInteractionEnabled = NO;
        self.scrollView.userInteractionEnabled = NO;
//        NSLog(@"userInteractionEnabled");
    }
    if ([flag isEqualToString:@"1"]) {
        self.userInteractionEnabled = YES;
        self.scrollView.userInteractionEnabled = YES;
        
//        NSLog(@"userInteractionEnabled------YES");
    }
    
    
}
@end
