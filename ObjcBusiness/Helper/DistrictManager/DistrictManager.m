//
//  DistrictManager.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DistrictManager.h"
#import "AddressModel.h"

@implementation DistrictManager

+ (DistrictManager *)shareManger {
    static DistrictManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
        [manager getData];
        [manager getIndustryData];
    });
    return  manager;
}

- (void)getData {
//    self.isGettingData = YES;
    NSString *path ;
    if (self.isDifferentDistrict) {
        path = [[NSBundle mainBundle] pathForResource:@"city_data1" ofType:@"json"];
    }else{
        path = [[NSBundle mainBundle] pathForResource:@"city_data" ofType:@"json"];
    }
    
    NSData *fileData = [[NSData alloc]init];
    fileData = [NSData dataWithContentsOfFile:path];
    NSString *dataStr;
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    if (_dataArr.count != 0) {
        [_dataArr removeAllObjects];
    }
    @try {
        dataStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dataDictionary= [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *arr = [dataDictionary objectForKey:@"data"];
        [_dataArr addObjectsFromArray:arr];
//        for (int i = 0; i < arr.count; i++) {
//            AddressModel *model = [[AddressModel alloc] initWithXML:arr[i]];
//            
//            [_dataArr addObject:model];
//        }
//        self.isGettingData = NO;

    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)getIndustryData {
    //    self.isGettingData = YES;
    NSString *path ;
    if (self.isDifferentTrade) {
        path = [[NSBundle mainBundle] pathForResource:@"sys_industry1" ofType:@"json"];
    }else{
        path = [[NSBundle mainBundle] pathForResource:@"sys_industry" ofType:@"json"];
    }
    
    NSData *fileData = [[NSData alloc]init];
    fileData = [NSData dataWithContentsOfFile:path];
    NSString *dataStr;
    if (!_industryArray) {
        _industryArray = [NSMutableArray array];
    }
    if (_industryArray.count != 0) {
        [_industryArray removeAllObjects];
    }
    @try {
        dataStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dataDictionary= [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *arr = [dataDictionary objectForKey:@"data"];
        [_industryArray addObjectsFromArray:arr];
        //        for (int i = 0; i < arr.count; i++) {
        //            AddressModel *model = [[AddressModel alloc] initWithXML:arr[i]];
        //
        //            [_dataArr addObject:model];
        //        }
        //        self.isGettingData = NO;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
@end
