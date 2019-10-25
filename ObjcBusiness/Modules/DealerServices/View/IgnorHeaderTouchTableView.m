//
//  IgnorHeaderTouchTableView.m
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/8/16.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "IgnorHeaderTouchTableView.h"

@implementation IgnorHeaderTouchTableView
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
