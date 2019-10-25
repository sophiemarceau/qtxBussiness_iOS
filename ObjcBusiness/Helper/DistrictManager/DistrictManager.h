//
//  DistrictManager.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistrictManager : NSObject
@property (nonatomic, assign) Boolean isDifferentDistrict;
@property (nonatomic, assign) Boolean isDifferentTrade;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *industryArray;
+ (DistrictManager *)shareManger;

- (void)getData;
- (void)getIndustryData;
@end
