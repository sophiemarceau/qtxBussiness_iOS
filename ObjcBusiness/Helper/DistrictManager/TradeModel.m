//
//  TradeModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "TradeModel.h"

@implementation TradeModel
- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (instancetype)initWithXML:(NSDictionary *)xml {
    self.text = [xml objectForKey:@"text"];
    if ([xml objectForKey:@"value"]) {
        self.value = [xml objectForKey:@"value"];
    }
    @try {
        NSArray *arr = [xml objectForKey:@"children"];
        for (int i = 0 ; i < arr.count ; i++ ) {
            ChildTradeModel *model = [[ChildTradeModel alloc] initWithXML:arr[i]];
            [self.list addObject:model];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return self;
}

@end

@implementation ChildTradeModel

- (instancetype)initWithXML:(NSDictionary *)xml{
    self.text = [xml objectForKey:@"text"];
    
    if ([xml objectForKey:@"value"]) {
        self.value = [xml objectForKey:@"value"];
    }
    return self;
}
@end
