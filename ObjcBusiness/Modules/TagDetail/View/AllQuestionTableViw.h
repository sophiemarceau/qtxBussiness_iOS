//
//  AllQuestionTableViw.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/10/25.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "YXTabItemBaseView.h"

@interface AllQuestionTableViw : YXTabItemBaseView{
    int current_page;
    int total_count;
    noContent * nocontent;
}
@property(nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong) noWifiView *failView;

@end
