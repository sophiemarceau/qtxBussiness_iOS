//
//  ChannelViewController.h
//  ObjcBusiness
//
//  Created by sophiemarceau_qu on 2017/11/13.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "BaseViewController.h"
@protocol  SelectChannelDelegate<NSObject>
- (void)didSelectDelegateReturnPage:(NSInteger)selectIndex FromIndex:(NSInteger)fromIndex;
@end
@interface ChannelViewController : BaseViewController
@property (nonatomic,strong)NSMutableArray *channelArray;
@property (nonatomic,assign)NSInteger currentSelect;
@property (nonatomic,weak)id<SelectChannelDelegate> delegate;
@end
