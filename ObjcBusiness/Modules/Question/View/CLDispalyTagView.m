//
//  CLDispalyTagView.m
//  CLTageViewDemo
//
//  Created by Criss on 2017/4/20.
//  Copyright © 2017年 Criss. All rights reserved.
//

#import "CLDispalyTagView.h"
#import "CLTools.h"
#import "CLTagButton.h"


@class CLTagTextField;
@protocol CLTagTextFieldDelegate <NSObject>

- (void)tagTextFieldDeleteCharacter:(CLTagTextField *)tagTextField;

@end
@interface CLTagTextField : UITextField

@property (weak, nonatomic) id<CLTagTextFieldDelegate> tfDelegate;

@end

@implementation CLTagTextField

- (void)deleteBackward {
    if ([self.tfDelegate respondsToSelector:@selector(tagTextFieldDeleteCharacter:)]) {
        [self.tfDelegate tagTextFieldDeleteCharacter:self];
    }
    [super deleteBackward];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x+(self.layer.cornerRadius?:3), bounds.origin.y, bounds.size.width-(self.layer.cornerRadius?:3), bounds.size.height);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x+(self.layer.cornerRadius?:3), bounds.origin.y, bounds.size.width-(self.layer.cornerRadius?:3), bounds.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIScrollView *view in self.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            CGPoint offset = view.contentOffset;
            if (offset.y != 0)
            {
                offset.y = 0;
                view.contentOffset = offset;
            }
            break;
        }
    }
}

@end

@interface CLDispalyTagView () <UITextFieldDelegate, CLTagTextFieldDelegate, CLTagButtonDelegate>

@property (strong, nonatomic) CAShapeLayer *border;
@property (strong, nonatomic) NSMutableArray<CLTagButton *> *tagBtnArrayM; // 标签


@end

@implementation CLDispalyTagView {
    CLTagTextField *_inputField;
    CLTagButton *_selectedBtn;
    UIMenuController *_menuController;
    
    CGFloat _originalWidth;
    CGFloat _tagHeight;
    NSInteger _rowsOfTags;
    
    BOOL _textFieldIsEditting;
    BOOL _textFieldIsDeleting;
    BOOL _textFieldEndEditting;
}

- (instancetype)initWithOriginalY:(CGFloat)originalY Font:(CGFloat)fontSize; {
    _inputField = [[CLTagTextField alloc] init];
    _inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    _inputField.returnKeyType = UIReturnKeyDone;
    _inputField.placeholder = @"请至少输入或选择一个标签";
    _inputField.borderStyle = UITextBorderStyleNone;
    _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inputField.autocorrectionType = UITextAutocorrectionTypeNo;
    _inputField.tintColor = RedUIColorC1;
    fontSize? (_inputField.font = [UIFont systemFontOfSize:fontSize]): nil;
    [_inputField sizeToFit];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:_inputField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTagDisplayView:) name:kCLRecentTagViewTagClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
    
    return [self initWithFrame:CGRectMake(0, originalY, [UIScreen mainScreen].bounds.size.width, _inputField.bounds.size.height + kCLDistance * 2 + kCLTextFieldGap)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *iconimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"questions_icon_label"]];
    [self addSubview:iconimageView];
    
    iconimageView.frame = CGRectMake(kCLTagViewHorizontaGap*AUTO_SIZE_SCALE_X, 22.5*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
    self.backgroundColor = [UIColor whiteColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self addSubview:_inputField];
    _inputField.delegate = self;
    _inputField.tfDelegate = self;
    _tagHeight = _inputField.bounds.size.height + kCLTextFieldGap;
    if (![CLTools sharedTools].cornerRadius) {
        [CLTools sharedTools].cornerRadius = _tagHeight * 0.5;
    }
    _inputField.layer.cornerRadius = [CLTools sharedTools].cornerRadius;
    _originalWidth = [self tagWidthWithText:_inputField.placeholder];
    if (kCLTagViewWidth > _originalWidth) {
        _originalWidth = kCLTagViewWidth;
    }
    _inputField.frame = CGRectMake(38*AUTO_SIZE_SCALE_X, kCLDistance, _originalWidth, _tagHeight);
}

// 判断是否包含中文
- (BOOL) deptNameInputShouldChineseWithString:(NSString *)string{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

- (CGFloat)tagWidthWithText:(NSString *)text {
    return [text sizeWithAttributes:@{NSFontAttributeName:_inputField.font}].width + _tagHeight;
}

#pragma mark - 通知方法

- (void)menuControllerDidHide:(NSNotification *)notification {
    _selectedBtn.selected = NO;
    _selectedBtn = nil;
}

- (void)reloadTagDisplayView:(NSNotification *)notification {
    CLTagButton *tagBtn = notification.userInfo[kCLRecentTagViewTagClickKey];
//    NSLog(@"reloadTagDisplayView------%@-----------tagID------>%ld", tagBtn.titleLabel.text,tagBtn.tag);
    if (tagBtn.tagSelected) {
        if (_inputField.text.length != 0) {
            _textFieldIsEditting = YES;
        }
        
        [self addTagWithTag:tagBtn.titleLabel.text WithTagID:tagBtn.tag];
        _textFieldIsEditting = NO;
    }else {
        [self removeTagWithTag:[NSString stringWithFormat:@"%ld",tagBtn.tag]];
    }
    _selectedBtn.selected = NO;
}

- (void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
//    NSLog(@"textField------->%@",textField.text);
    
    
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_SEARCHTAGLIST object:nil userInfo:@{
                                                                                                                      @"tag_content": textField.text,
                                                                                                                      @"count":@(self.tagBtnArrayM.count),
                                                                                                                      }];

    
    
    if (textField.text.length == 0) {
        self.border.lineWidth = 0;
    }
    
    if (_textFieldIsDeleting) {
        _textFieldIsDeleting = NO;
        [self reloadTextField:textField allStr:textField.text];
        [self textFieldDashesWithTextField:textField];
        return;
    }
    
    NSInteger maxLength = self.maxStringAmount?:10;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            [self reloadTextField:textField allStr:textField.text];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
        
    }
    [self textFieldDashesWithTextField:textField];
    [self layoutIfNeeded];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_selectedBtn) {
        _selectedBtn.selected = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "] && textField.text.length == 0) {
        return NO;
    }
    
    if ([string isEqualToString:@""]) {
        _textFieldIsDeleting = YES;
        return YES;
    }
    
    if (textField.text.length == 0 && _selectedBtn) {
        _selectedBtn.selected = NO;
        _selectedBtn = nil;
    }
    
    NSInteger maxLength = self.maxStringAmount?:10;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    if (![lang isEqualToString:@"zh-Hans"]) {
        if (textField.text.length + string.length > maxLength) {
            return NO;
        }
    }else {
        if (![self deptNameInputShouldChineseWithString:string]) {
            return YES;
        }
    }
    NSString *allStr = [textField.text stringByAppendingString:string];
    return [self reloadTextField:textField allStr:allStr];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSLog(@"textFieldShouldReturn");
    if (textField.text.length == 0) {
        return YES;
    }
    if (textField.text.length != 0) {
//        NSDictionary *dic = @{@"tag_content":textField};
//        [[RequestManager shareRequestManager] getLikeTagDtoLike:dic viewController:nil successData:^(NSDictionary *result) {
//            NSLog(@"result---textFieldShouldReturn-getLikeTagDtoLike---->%@",result);
//            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"list"];
//            if(![array isEqual:[NSNull null]] && array !=nil){
//                if (array.count > 0) {
//                    for (NSDictionary *tempdic in array) {
//                        if ([tempdic[@"tag_content"]  isEqualToString:textField.text]) {
//                            [[RequestManager shareRequestManager] tipAlert:@"有相同标签请从列表中选择该标签" viewController:nil];
//                            return ;
//                        }
//                    }
//                }
//            }
            NSDictionary *addtagdic = @{@"tag_content":textField.text};
            [[RequestManager shareRequestManager] addTag:addtagdic viewController:nil successData:^(NSDictionary *result) {
//                NSLog(@"addTag------>%@",result);
                if (IsSucess(result) == 1) {
                    [self addTagWithTag:textField.text WithTagID:[result[@"data"][@"result"] intValue]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCLDisplayTagViewAddTagNotification object:kCLDisplayTagViewAddTagObject userInfo:@{kCLDisplayTagViewAddTagKey : textField.text}];
                    if (self.tagBtnArrayM.count >= 5) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_showorHideHotTagView object:nil userInfo:@{
                                                                                                                                                @"HotTagHiddenFlag":@(0),
                                                                                                                                                
                                                                                                                                                }];
                    }
                    textField.text = @"";
                    self.border.lineWidth = 0;
                }else{
                    if (IsSucess(result) == -1) {
                        [[RequestManager shareRequestManager] loginCancel:result];
                    }else{
                        [[RequestManager shareRequestManager] resultFail:result viewController:nil];
                    }
                }
            } failuer:^(NSError *error) {
                
            }];
//        } failuer:^(NSError *error) {
//
//        }];
    }
    
    
//    [self addTagWithTag:textField.text];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:kCLDisplayTagViewAddTagNotification object:kCLDisplayTagViewAddTagObject userInfo:@{kCLDisplayTagViewAddTagKey : textField.text}];
//
//    textField.text = @"";
   
    
    return YES;
}

// 更新textField的frame
- (BOOL)reloadTextField:(UITextField *)textField allStr:(NSString *)allStr {
    CGFloat width = [self tagWidthWithText:allStr];
    CGRect rect = textField.frame;
    if (width > self.bounds.size.width - kCLTagViewHorizontaGap * 2) {
        return YES;
    }
    
    if (width > _originalWidth) {
        rect.size.width = width;
    }else {
        rect.size.width = _originalWidth;
    }
    textField.frame = rect;
    _textFieldIsEditting = YES;
    [self reloadTagViewPreTag:self.tagBtnArrayM.lastObject currentTagBtn:textField];
    _textFieldIsEditting = NO;
    return YES;
}

- (void)addTagWithTag:(NSString *)text  WithTagID:(NSInteger)tagNumber{
    if (![self.tagCache objectForKey:[NSString stringWithFormat:@"%ld",tagNumber]]) {
        if(self.tagBtnArrayM.count >= 5){
            return;
        }
        CLTagButton *tagBtn = [[CLTagButton alloc] initWithTextField:_inputField];
        CGFloat width = [self tagWidthWithText:text];
        [tagBtn setTitle:text forState:UIControlStateNormal];
        tagBtn.frame = CGRectMake(_inputField.frame.origin.x, _inputField.frame.origin.y, width, tagBtn.bounds.size.height);
        [self reloadTagViewPreTag:self.tagBtnArrayM.lastObject currentTagBtn:tagBtn];
        tagBtn.tagBtnDelegate = self;
        tagBtn.tag = tagNumber;
        [self addSubview:tagBtn];
        [self.tagBtnArrayM addObject:tagBtn];
        [self.tagCache setObject:tagBtn forKey:[NSString stringWithFormat:@"%ld",tagNumber]];
        [self reloadTagViewPreTag:tagBtn currentTagBtn:_inputField];
        [self textFieldDashesWithTextField:_inputField];
//        NSLog(@"addTagWithTag-----%@------>%ld--------tag======>%ld",text,self.tagBtnArrayM.count,tagBtn.tag);
        if(self.tagBtnArrayM.count >= 5){
            [_inputField resignFirstResponder];
            _inputField.hidden = YES;
            _inputField.userInteractionEnabled = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_kCLDisplayTagViewAddTagNotification object:nil userInfo:@{NOTIFICATION_kCLDisplayTagViewAddTagNotification: @"0"}];
        }else{
            _inputField.hidden = NO;
            _inputField.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_kCLDisplayTagViewAddTagNotification object:nil userInfo:@{NOTIFICATION_kCLDisplayTagViewAddTagNotification: @"1"}];
        }
    }
}

- (void)removeTagWithTag:(NSString *)tag {
//    NSLog(@"removeTagWithTag-----------------tagID------>%@",tag);
    CLTagButton *tagbtn = [self.tagCache objectForKey:tag];
    NSInteger index = [self.tagBtnArrayM indexOfObject:tagbtn];
    [self.tagCache removeObjectForKey:tag];
    [self.tagBtnArrayM[index] removeFromSuperview];
    [self.tagBtnArrayM removeObjectAtIndex:index];
    if(self.tagBtnArrayM.count >= 5){
        _inputField.hidden = YES;
        _inputField.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_kCLDisplayTagViewAddTagNotification object:nil userInfo:@{NOTIFICATION_kCLDisplayTagViewAddTagNotification: @"0"}];
    }else{
        _inputField.hidden = NO;
        _inputField.userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_kCLDisplayTagViewAddTagNotification object:nil userInfo:@{NOTIFICATION_kCLDisplayTagViewAddTagNotification: @"1"}];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kCLTagViewTagDeleteNotification object:nil userInfo:@{kCLTagViewTagDeleteKey: tagbtn}];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_showorHideHotTagView object:nil userInfo:@{
                                                                                                                            @"HotTagHiddenFlag":@(0),
                                                                                                                            
                                                                                                                            }];
    if (index == self.tagBtnArrayM.count) {
        [self reloadTagViewPreTag:self.tagBtnArrayM.lastObject currentTagBtn:_inputField];
        return;
    }
    for (NSInteger i = index; i < self.tagBtnArrayM.count; i ++) {
        [self reloadTagViewPreTag:i?self.tagBtnArrayM[i - 1]:nil currentTagBtn:self.tagBtnArrayM[i]];
    }
    [self reloadTagViewPreTag:self.tagBtnArrayM.lastObject currentTagBtn:_inputField];
    
}

- (void)reloadTagViewPreTag:(UIView *)preTagBtn currentTagBtn:(UIView *)currentTagBtn {

    if ([currentTagBtn isKindOfClass:[CLTagTextField class]]) {
        if (!_textFieldIsEditting) {
            CGRect rect = currentTagBtn.frame;
            rect.size.width = _originalWidth;
            currentTagBtn.frame = rect;
        }
    }
    
    CGFloat preTaling = preTagBtn? CGRectGetMaxX(preTagBtn.frame) : 28*AUTO_SIZE_SCALE_X;
    CGFloat preBottom = preTagBtn? CGRectGetMaxY(preTagBtn.frame) : 0;
    CGFloat preY = preTagBtn? preTagBtn.frame.origin.y : kCLDistance;
    
    if (preTaling + kCLTagViewHorizontaGap * 2 + currentTagBtn.bounds.size.width > self.bounds.size.width) {
        currentTagBtn.frame = CGRectMake(38*AUTO_SIZE_SCALE_X, preBottom + kCLTextFieldsVerticalGap, currentTagBtn.frame.size.width, currentTagBtn.frame.size.height);
        
    }else {
        currentTagBtn.frame = CGRectMake(preTaling + kCLTextFieldsHorizontalGap, preY, currentTagBtn.frame.size.width, currentTagBtn.frame.size.height);
        
    }
    
    if ([currentTagBtn isKindOfClass:[CLTagTextField class]]) {
        
        CGFloat tagViewHeight = self.contentSize.height;
        CGFloat tagViewExpectHeight = CGRectGetMaxY(currentTagBtn.frame) + kCLDistance;
        if (tagViewExpectHeight > tagViewHeight) {
            _rowsOfTags ++;
        }
        
        if (tagViewExpectHeight < tagViewHeight) {
            _rowsOfTags --;
        }
        
        self.contentSize = CGSizeMake(self.frame.size.width, tagViewExpectHeight);
        if (_rowsOfTags > (self.maxRows?:3)) {
            self.showsVerticalScrollIndicator = YES;
            // 滑动到底部
            CGRect bottomRect = CGRectMake(0, self.contentSize.height - 1 , 1, 1);
            [self scrollRectToVisible:bottomRect animated:NO];
            return;
        }
        self.showsVerticalScrollIndicator = NO;
        if (tagViewHeight != tagViewExpectHeight) {
            CGRect tagViewRect = self.frame;
            tagViewRect.size.height = tagViewExpectHeight;
            self.frame = tagViewRect;
        }

    }
    
    if (self.tagBtnArrayM.count == 5) {
         CLTagButton *tagbtn = self.tagBtnArrayM.lastObject;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(tagbtn.frame)+kCLDistance);
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_selectedBtn) {
        _selectedBtn.selected = NO;
        _selectedBtn = nil;
    }
    [_inputField becomeFirstResponder];
}

#pragma mark - CLTagButtonDelegate
- (void)tagButtonDelete:(CLTagButton *)tagBtn {
    [self removeTagWithTag:[NSString stringWithFormat:@"%ld",tagBtn.tag]];
    if (_inputField.text.length) {
        [_inputField becomeFirstResponder];
    }
    _selectedBtn = nil;
}

- (void)tagButtonDidSelected:(CLTagButton *)tagBtn {
    _selectedBtn.isNotSelf = YES;
    _selectedBtn.selected = NO;
    _selectedBtn = tagBtn.isSelected? tagBtn: nil;
    if (!tagBtn.selected) {
        [_inputField becomeFirstResponder];
    }
}

#pragma mark - CLTagTextFieldDelegate
- (void)tagTextFieldDeleteCharacter:(CLTagTextField *)tagTextField {
    _textFieldIsDeleting = YES;
    if (tagTextField.text.length ==0) {
        if (self.tagBtnArrayM.count > 0) {
            CLTagButton *lastBtn = self.tagBtnArrayM.lastObject;
            if (!lastBtn.isSelected) {
                lastBtn.selected = YES;
                _selectedBtn = lastBtn;
            }else {
                _selectedBtn.selected = NO;
                [self removeTagWithTag:[NSString stringWithFormat:@"%ld",lastBtn.tag]];
            }
        }
    }
}

#pragma mark - 虚线边框
- (void)textFieldDashesWithTextField:(UITextField *)textField {
    textField.borderStyle =  UITextBorderStyleNone;
    if (self.border) {
        if (self.border.lineWidth == 0 && textField.text.length != 0) {
            self.border.lineWidth = kCLDashesBorderWidth;
        }
        self.border.path = [UIBezierPath bezierPathWithRoundedRect:textField.bounds cornerRadius:textField.layer.cornerRadius].CGPath;
        return;
    }
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = self.textFieldBorderColor.CGColor?:cl_colorWithHex(0xdadadd).CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRoundedRect:textField.bounds cornerRadius:textField.layer.cornerRadius].CGPath;
    
    border.frame = textField.bounds;
    
    if (_inputField.text.length == 0) {
        border.lineWidth = 0;
    }else {
        border.lineWidth = kCLDashesBorderWidth;
    }
    
    border.lineCap = @"round";
    
    border.lineDashPattern = @[@4, @2];
    self.border = border;
    
    [textField.layer addSublayer:border];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)tags {
    
    
    return [self.tagCache allKeys];
}

//- (void)setLabels:(NSArray<NSString *> *)labels {
//    _labels = labels;
//    for (NSString *des in labels) {
//        [self addTagWithTag:des];
//    }
//}

#pragma mark - lazy
- (NSMutableArray<CLTagButton *> *)tagBtnArrayM {
    if (!_tagBtnArrayM) {
        _tagBtnArrayM = [NSMutableArray array];
    }
    return _tagBtnArrayM;
}

- (NSMutableDictionary *)tagCache {
    if (!_tagCache) {
        _tagCache = [[NSMutableDictionary alloc] init];
    }
    return _tagCache;
}
@end
