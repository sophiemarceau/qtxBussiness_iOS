//
//  JSShareItemButton.h
//  JSShareView
//


//

#import <UIKit/UIKit.h>

@interface JSShareItemButton : UIButton
+ (instancetype)shareButton;
- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName
                     imageTag:(NSInteger)imageTAG
                        title:(NSString *)title
                    titleFont:(CGFloat)titleFont
                   titleColor:(UIColor *)titleColor;
@end
