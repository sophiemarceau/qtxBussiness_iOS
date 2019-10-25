//
//  BaseModel.h
//  YourBusiness
//
//  Created by sophiemarceau_qu on 2017/7/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCopying>
- (instancetype) initWithDictionary: (NSDictionary *)dict;
@end
