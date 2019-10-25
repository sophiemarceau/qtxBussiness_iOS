//
//  MOSTwoColumnPicker.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/18.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "MOSTwoColumnPicker.h"

@interface MOSTwoColumnPicker () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger selectedIndex_parent;
@property (nonatomic, assign) NSInteger selectedIndex_children;
@property (nonatomic, assign) BOOL isGettingData;
@property (nonatomic, strong) void (^getDataCompleteBlock)(void);
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation MOSTwoColumnPicker

- (instancetype)initWithFrame:(CGRect)frame {
    
    self.semaphore = dispatch_semaphore_create(1);
    
    [self initToolBar];
    [self initContainerView];
    
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, self.toolBar.frame.size.height, UISCREEN_WIDTH, 216);
    } else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.delegate = self;
        self.dataSource = self;
        
        [self initBgView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self getData];
            dispatch_queue_t queue = dispatch_queue_create("my.current.queue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_barrier_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadAllComponents];
                });
            });
        });
    }
    return self;
}

- (void)initToolBar {
    self.toolBar = [[MOFSToolbar alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 44)];
    self.toolBar.translucent = NO;
}

- (void)initContainerView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.containerView.userInteractionEnabled = YES;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWithAnimation)]];
}

- (void)initBgView {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT - self.frame.size.height - 44, UISCREEN_WIDTH, self.frame.size.height + self.toolBar.frame.size.height)];
}


- (void)show2ColumnTradePickerCommitBlock:(void(^)(NSString *valueStr, NSString *codeStr))commitBlock cancelBlock:(void(^)(void))cancelBlock{
    [self showWithAnimation];
    __weak typeof(self) weakSelf = self;
    self.toolBar.cancelBlock = ^ {
        if (cancelBlock) {
            [weakSelf hiddenWithAnimation];
            cancelBlock();
        }
    };
    self.toolBar.commitBlock = ^ {
        if (commitBlock) {
            [weakSelf hiddenWithAnimation];
            if (weakSelf.dataArr.count > 0) {
                TradeModel *addressModel = weakSelf.dataArr[weakSelf.selectedIndex_parent];
                ChildTradeModel *cityModel;
                if (addressModel.list.count > 0) {
                    cityModel = addressModel.list[weakSelf.selectedIndex_children];
                }
                NSString *address;
                NSString *zipcode;
                if (!cityModel) {
                    address = [NSString stringWithFormat:@"%@",addressModel.text];
                    zipcode = [NSString stringWithFormat:@"%@",addressModel.value];
                } else {
                    address = [NSString stringWithFormat:@"%@-%@",addressModel.text,cityModel.text];
                    zipcode = [NSString stringWithFormat:@"%@-%@",addressModel.value,cityModel.value];
                }
                commitBlock(address, zipcode);
            }
        }
    };
}

- (void)showWithAnimation {
    [self addViews];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGFloat height = self.bgView.frame.size.height;
    self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT - height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
    
}

- (void)hiddenWithAnimation {
    CGFloat height = self.bgView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self hiddenViews];
    }];
}

- (void)addViews {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.containerView];
    [window addSubview:self.bgView];
    [self.bgView addSubview:self.toolBar];
    [self.bgView addSubview:self];
}

- (void)hiddenViews {
    [self removeFromSuperview];
    [self.toolBar removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.containerView removeFromSuperview];
}

- (void)getData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sys_industry2" ofType:@"json"];
    NSData *fileData = [[NSData alloc]init];
    fileData = [NSData dataWithContentsOfFile:path];
    NSString *dataStr;
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    if (_dataArr.count != 0) {
        [_dataArr removeAllObjects];
    }
    @try {
        dataStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dataDictionary= [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *arr = [dataDictionary objectForKey:@"data"];
        
        for (int i = 0; i < arr.count; i++) {
            TradeModel *model = [[TradeModel alloc] initWithXML:arr[i]];
            [_dataArr addObject:model];
        }
        self.isGettingData = NO;
        if (self.getDataCompleteBlock) {
            self.getDataCompleteBlock();
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    TradeModel *addressModel;
    if (self.dataArr.count > 0) {
        addressModel = self.dataArr[self.selectedIndex_parent];
    }
    
    ChildTradeModel *cityModel;
    if (addressModel && addressModel.list.count > 0) {
        cityModel = addressModel.list[self.selectedIndex_children];
    }
    if (self.dataArr.count != 0) {
        if (component == 0) {
            return self.dataArr.count;
        } else if (component == 1) {
            return addressModel == nil ? 0 : addressModel.list.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        TradeModel *addressModel = self.dataArr[row];
        return addressModel.text;
    } else if (component == 1) {
        TradeModel *addressModel = self.dataArr[self.selectedIndex_parent];
        ChildTradeModel *cityModel = addressModel.list[row];
        return cityModel.text;
    } else {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.selectedIndex_parent = row;
            self.selectedIndex_children = 0;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:NO];
            break;
        case 1:
            self.selectedIndex_children = row;
            break;
        
        default:
            break;
    }
}

- (void)dealloc {
    
}

@end
