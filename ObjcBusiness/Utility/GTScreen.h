//
//  GTScreen.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2019/10/23.
//  Copyright © 2019 屈小波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static inline NSInteger UIAdapter(float x)
{
    //屏幕宽度按比例适配
    CGFloat scale = 414 / kScreenWidth;
    return (NSInteger)x / scale;
}

static inline CGRect UIRectAdapter(x,y,width,height){
    return CGRectMake(UIAdapter(x), UIAdapter(y), UIAdapter(width), UIAdapter(height));
}

@interface GTScreen : NSObject

@end

NS_ASSUME_NONNULL_END
