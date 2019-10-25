//
//  AddressModel.m
//  MOFSPickerManager
//
//  Created by lzqhoh@163.com on 16/8/31.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

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
            CityModel *model = [[CityModel alloc] initWithXML:arr[i]];
            [self.list addObject:model];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return self;
}

@end

@implementation CityModel

- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (instancetype)initWithXML:(NSDictionary *)xml {
    self.text = [xml objectForKey:@"text"];
    if ([xml objectForKey:@"value"]) {
        self.value =  [xml objectForKey:@"value"];
    }
    @try {
        NSArray *arr = [xml objectForKey:@"children"];
        for (int i = 0 ; i < arr.count ; i++ ) {
            DistrictModel *model = [[DistrictModel alloc] initWithXML:arr[i]];
            [self.list addObject:model];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return self;
}

@end

@implementation DistrictModel

- (instancetype)initWithXML:(NSDictionary *)xml{
    self.text = [xml objectForKey:@"text"];
    
    if ([xml objectForKey:@"value"]) {
        self.value = [xml objectForKey:@"value"];
    }
    return self;
}

@end
