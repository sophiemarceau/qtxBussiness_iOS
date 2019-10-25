//
//  MMMultiItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2017/4/10.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMItem.h"
typedef NS_ENUM(NSUInteger, MMPopupViewNumberoflayers) {
    MMPopupViewTwolayers,
    MMPopupViewThreelayers,
    MMPopupViewTwolayersOrThirdlayers,
};

@interface MMMultiItem : MMItem
@property (nonatomic, assign) MMPopupViewNumberoflayers numberOflayers;
@end
