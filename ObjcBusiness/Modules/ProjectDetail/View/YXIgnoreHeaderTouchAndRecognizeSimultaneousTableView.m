//
//  YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"

@implementation YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
