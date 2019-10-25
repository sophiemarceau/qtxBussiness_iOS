//
//  ProjectMessageCell+ProjecMessagetModel.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ProjectMessageCell+ProjecMessagetModel.h"

@implementation ProjectMessageCell (ProjecMessagetModel)
- (void)configureWithListEntity:(NSDictionary *)tempModel{
    self.nameLabel.text = tempModel[@"project_name"];
    self.messageCountLabel.text = [NSString stringWithFormat:@"%d",[tempModel[@"projectExtDto"][@"pe_message_count"] intValue]];
    
}
@end
