//
//  ResumeTableItem.h
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CellShowType) {
    ResumSelectText,
    ResumInput,
    ResumSelectWithMargin,
    ResumSelectPlace,
    ResumePersonalInfo,
    TextViewInput,
    ProjectPicUpload,
    LabelText,
    TextFieldText
};
@interface ResumeTableItem : NSObject
@property (nonatomic, assign) CellShowType showtype;

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) BOOL isShowLineImageFlag;
@property (nonatomic, assign) BOOL isUserInteractFlag;
@property (nonatomic, assign) BOOL isNumberKeyboardFlag;
@property (nonatomic, copy)   NSString *functionValue;
@property (nonatomic, copy)   NSString *placeholderValue;
@property (nonatomic, copy)   NSString *c_profiles;
@property (nonatomic, copy)   NSString *placeName;
@property (nonatomic, copy)   NSString *addresString;


@property (nonatomic, strong) NSArray *placeArray;
@property (nonatomic, assign) BOOL isHavePlacePic;

@property (nonatomic, assign) BOOL hiddenArrowImageView;


@property(nonatomic,strong)NSNumber *placeId;
@end
