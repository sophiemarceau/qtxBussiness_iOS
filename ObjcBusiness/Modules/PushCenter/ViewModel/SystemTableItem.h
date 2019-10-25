//
//  SystemTableItem.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/30.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CellShowType) {
    SystemPicMessage,
    SystemLabelMessage
};
@interface SystemTableItem : NSObject

@property (nonatomic, copy)   NSString *titleStr;
@property (nonatomic, assign) NSInteger msg_kind;
@property (nonatomic, assign) NSInteger user_id_receiver;
@property (nonatomic, strong) NSString *msg_page_to;
@property (nonatomic, copy)   NSString *timeStr;



@property (nonatomic, copy)   NSString *picStr;
@property (nonatomic, copy)   NSString *contentStr;

@property (nonatomic, assign) CellShowType showtype;
@property (nonatomic, strong) NSString *cellIdentifier;

@end
