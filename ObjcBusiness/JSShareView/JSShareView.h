//
//  JSShareView.h
//  JSShareView
//

//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ShareType) {
    ShareTypeSocial = 0, //社交分享
    ShareTypeCopy,     //系统
    ShareTypeDelete,
    ShareTypeReport,
};

@protocol JSShareViewiewDelegate<NSObject>

- (void)JSShareViewiewDidSelected:(ShareType)shareType;

@end


@interface JSShareView : UIView

@property (nonatomic , assign)id<JSShareViewiewDelegate> delegate;
/**
 *  分享
 *
 *  @param content     @{@"text":@"",@"image":@[],@"url":@""}
 *  @param resultBlock 结果
 */
+ (void)showShareViewWithPublishContent:(id)content FlagWithDeleButton:(NSInteger)deleteButtonflag;
/**
 *  分享
 *
 *  @param content     @{@"text":@"",@"image":@[],@"url":@""}
 *  @param resultBlock 结果
 */
- (void)initPublishContent:(id)content FlagWithDeleButton:(NSInteger)deleteButtonflag;




@end
