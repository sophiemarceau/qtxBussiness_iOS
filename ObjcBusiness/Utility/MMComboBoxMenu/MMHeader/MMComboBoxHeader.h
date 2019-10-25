//
//  MMHeader.h
//  MMPhotoView
//
//  Created by wyy on 16/11/10.
//  Copyright © 2016年 yyx. All rights reserved.
//

#ifndef MMHeader_h
#define MMHeader_h
#import "UIView+ComboBoxExtension.h"
#import "UIColor+ComboBoxExtension.h"

#define scale [UIScreen mainScreen].scale
static  NSString *titleSelectedColor = @"e83e41";
static const CGFloat  ButtonFontSize = 14.0f;
//MMPopupView
static const CGFloat PopupViewRowHeight = 44.0f;
static const CGFloat DistanceBeteewnPopupViewAndBottom =80.0f;
static const CGFloat PopupViewTabBarHeight = 40.0f;
static const CGFloat LeftCellHorizontalMargin = 10.0f;
static CGFloat LeftCellWidth = 100.0f;
static const CGFloat ShadowAlpha = 0.5;
//static const CGFloat
static  NSString *MainCellID = @"MainCellID";
static  NSString *SubCellID = @"SubCellID";
static const NSTimeInterval AnimationDuration= .25;
static const CGFloat ButtonHorizontalMargin = 10.0f;

/* fontSize*/
static const CGFloat MainTitleFontSize = 14.0f;
static const CGFloat SubTitleFontSize = 12.0f;
/* color */
static  NSString *CellBGColor = @"F8F8F8";
static  NSString *SelectedBGColor = @"F2F2F2";
static  NSString *UnselectedBGColor = @"FFFFFF";
//MMComBoBoxView

//MMCombinationFitlerView
static const CGFloat AlternativeTitleVerticalMargin = 10.0f;
static const CGFloat AlternativeTitleHeight = 31.0f;

static const CGFloat TitleVerticalMargin = 8.0f;
static const CGFloat TitleHeight  = 26.5;

static const CGFloat ItemHeight  = 30.0f;
static const CGFloat ItemWidth  = 80.0f;
static const CGFloat ItemHorizontalMargin = 10.0f;
static const CGFloat ItemHorizontalDistance = 5.0f;
//MMDropDownBox
static const CGFloat DropDownBoxFontSize = 12.0f;
static const CGFloat ArrowSide = 8.0f;
static const CGFloat Arrowheight = 4.0f;
static const CGFloat ArrowToRight = 26.5f;
static const CGFloat DropDownBoxTitleHorizontalToArrow = 5.0f;
static const CGFloat DropDownBoxTitleHorizontalToLeft  = 27.0f;
#define kScreenHeigth [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#endif /* MMHeader_h */
