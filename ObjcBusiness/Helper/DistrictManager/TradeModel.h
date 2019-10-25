//
//  TradeModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChildTradeModel;
@interface TradeModel : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSMutableArray *list;

- (instancetype)initWithXML:(NSDictionary *)xml;
@end

@interface ChildTradeModel : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSMutableArray *list;

- (instancetype)initWithXML:(NSDictionary *)xml;

@end
