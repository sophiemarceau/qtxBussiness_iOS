//
//  SearchEnterpriseCell+SearchEnterpriseModel.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/9/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "SearchEnterpriseCell.h"

@interface SearchEnterpriseCell (SearchEnterpriseModel)
- (void)configureWithListEntity:(NSDictionary *)dic WithSelectKeyName:(NSString *)highStr;
@end
