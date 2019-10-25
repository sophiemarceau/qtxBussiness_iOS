//
//  AddPolicyViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/12/11.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AddPolicyViewController.h"
#import "BaseTableView.h"
#import "MJDIYBackFooter.h"
#import "AddPolicyTableViewCell.h"
#import "MOFSPickerManager.h"
@interface AddPolicyViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    int current_page;
    int total_count;
    NSString *_mode_place_demands,*_mode_place_area,*_mode_area,*_mode_amount;
    NSString *modePlaceDemandsName,*modePlaceAreaName,*modeAreaName,*modeAmountName;
    MOFSPickerManager *mofPickerManager;
}
@property(nonatomic,strong)BaseTableView *baseTableView;
@property(nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong) noWifiView *failView;
@property (nonatomic,strong)NSMutableArray *intentionAmountMutableArray,*placeSizeMutableArray,*placeOfBusinessMutableArray;
@end

@implementation AddPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加盟政策";
    _mode_place_demands = _mode_place_area = _mode_area = _mode_amount = @"";
    modePlaceDemandsName = modePlaceAreaName = modeAreaName = modeAmountName = @"";
    _mode_place_demands =@"999999";
    modePlaceDemandsName =@"面向全国";
    if (self.cooperDic != nil) {
        _mode_place_demands = [self.cooperDic objectForKey:@"_mode_place_demands"];
        _mode_place_area = [self.cooperDic objectForKey:@"_mode_place_area"];
        _mode_area = [self.cooperDic objectForKey:@"_mode_area"];
        _mode_amount = [self.cooperDic objectForKey:@"_mode_amount"];
        modePlaceDemandsName = [self.cooperDic objectForKey:@"modePlaceDemandsName"];
        modePlaceAreaName = [self.cooperDic objectForKey:@"modePlaceAreaName"];
        modeAreaName = [self.cooperDic objectForKey:@"modeAreaName"];
        modeAmountName = [self.cooperDic objectForKey:@"modeAmountName"];
    }
    mofPickerManager = [[MOFSPickerManager alloc] init];
    [self initNavgation];
    [self initSubViews];
    [self loadData];
}

-(void)initNavgation{
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    rightBackItem.tintColor = RedUIColorC1;
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

-(void)saveButton{
    //防止按钮快速点击造成多次响应的避免方法
    //    [[selfclass] cancelPreviousPerformRequestsWithTarget:selfselector:@selector(todoSomething:)object:sender];
    //
    //    [self performSelector:@selector(todoSomething:)withObject:sender afterDelay:0.2f];
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(save)object:nil];
    [self performSelector:@selector(save) withObject:nil afterDelay:0.2f];
}

-(void)save{
    if (_mode_place_demands.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您所在的地区" viewController:self];
        self.baseTableView.userInteractionEnabled = YES;
    }
    if (_mode_place_area.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择客户所需场所面积" viewController:self];
        self.baseTableView.userInteractionEnabled = YES;
    }
    if (_mode_area.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择客户经营的场所类型" viewController:self];
        self.baseTableView.userInteractionEnabled = YES;
    }
    if (_mode_amount.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择客户至少要投入的金额" viewController:self];
        self.baseTableView.userInteractionEnabled = YES;
    }
    NSDictionary *dic = @{
                          @"_mode_place_demands":_mode_place_demands,
                          @"_mode_place_area":_mode_place_area,
                          @"_mode_area":_mode_area,
                          @"_mode_amount":_mode_amount,
                          };
//    NSLog(@"dic----->%@",dic);
    [self.delegate SelectComingPolicyDelegateReturnPage:dic];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews {
    [self.view addSubview:self.baseTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49*AUTO_SIZE_SCALE_X;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddPolicyTableViewCell *cell = [AddPolicyTableViewCell userStatusCellWithTableView:tableView];
    ResumeTableItem *itemtemp = self.data[indexPath.row];
    [cell setResumeTableItem:itemtemp];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [mofPickerManager showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *addressStr, NSString *zipcode) {
            NSString *address;
            NSArray *addresstemparray  = [addressStr componentsSeparatedByString:@"-"];
            if (addresstemparray.count>0) {
                if (addresstemparray.count == 3) {
                    if ([addresstemparray[addresstemparray.count-1] isEqualToString: addresstemparray[addresstemparray.count-2]]) {
                        address = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[addresstemparray.count-2]];
                    }else{
                        address = [NSString stringWithFormat:@"%@ %@ %@",addresstemparray[0],addresstemparray[1],addresstemparray[2]];
                    }
                }else if(addresstemparray.count == 2){
                    if ([addresstemparray[0] isEqualToString: addresstemparray[1]]) {
                        address = [NSString stringWithFormat:@"%@",addresstemparray[0]];
                    }else{
                        address = [NSString stringWithFormat:@"%@ %@",addresstemparray[0],addresstemparray[1]];
                    }
                }
            }
            AddPolicyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((AddPolicyTableViewCell *)cell).ValueLabel setText:address];
            NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
            _mode_area =temparray[temparray.count-1];
        } cancelBlock:^{
        }];
    }
    if (indexPath.row == 1) {
        NSMutableArray *placeList = [NSMutableArray new];
        for (NSDictionary *temp in self.placeOfBusinessMutableArray) {
            [placeList addObject:[temp objectForKey:@"name"]];
        }
        [mofPickerManager showPickerViewWithDataArray:placeList tag:2000 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            for (NSDictionary *temp in self.placeOfBusinessMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    _mode_place_demands = [temp objectForKey:@"code"] ;
                    break;
                }
            }
            AddPolicyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((AddPolicyTableViewCell *)cell).ValueLabel setText:string];
        } cancelBlock:^{
        }];
    }
    if (indexPath.row == 2) {
        NSMutableArray *opnnessList = [NSMutableArray new];
        for (NSDictionary *temp in self.placeSizeMutableArray) {
            [opnnessList addObject:[temp objectForKey:@"name"]];
        }
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:opnnessList tag:40000002 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            AddPolicyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((AddPolicyTableViewCell *)cell).ValueLabel setText:string];
            for (NSDictionary *temp in self.placeSizeMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    _mode_place_area = [temp objectForKey:@"code"];
                    break;
                }
            }
        } cancelBlock:^{}];
    }
    if (indexPath.row == 3) {
        NSMutableArray *placeList = [NSMutableArray new];
        for (NSDictionary *temp in self.intentionAmountMutableArray) {
            [placeList addObject:[temp objectForKey:@"name"]];
        }
        [mofPickerManager showPickerViewWithDataArray:placeList tag:2003 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            for (NSDictionary *temp in self.intentionAmountMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    _mode_amount= [temp objectForKey:@"code"] ;
                    break;
                }
            }
            AddPolicyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((AddPolicyTableViewCell *)cell).ValueLabel setText:string];
        } cancelBlock:^{
        }];
    }
}

- (void)reloadButtonClick:(UIButton *)sender {
    [self loadData];
}

- (void)loadData {
//    [LZBLoadingView showLoadingViewDefautRoundDotInView:nil];
//    [self.data removeAllObjects];
//    NSDictionary *dic = @{ @"question_id":[NSString stringWithFormat:@"%ld",self.question_id],};
//    [[RequestManager shareRequestManager] getTagDtoListByQuestionId:dic viewController:self successData:^(NSDictionary *result){
//        NSLog(@"getTagDtoListByQuestionId---result--->%@",result);
//        if (IsSucess(result) == 1) {
//            NSArray *array = [[result objectForKey:@"data"] objectForKey:@"result"] ;
//            if(![array isEqual:[NSNull null]] && array !=nil){
//                [self.data addObjectsFromArray:array];
//            }
//            [self.baseTableView reloadData];
//        }else{
//            if (IsSucess(result) == -1) {
//                [[RequestManager shareRequestManager] loginCancel:result];
//            }else{
//                [[RequestManager shareRequestManager] resultFail:result viewController:self];
//            }
//        }
//        self.failView.hidden = YES;
//        [LZBLoadingView dismissLoadingView];
//    }failuer:^(NSError *error){
//        [LZBLoadingView dismissLoadingView];
//        
//        self.failView.hidden = NO;
//        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self];
//    }];
    
    ResumeTableItem *itemA = [ResumeTableItem new];
    itemA.showtype = LabelText;
    itemA.name = @"面向地区";
    itemA.isUserInteractFlag = NO;
    itemA.isShowLineImageFlag = NO;//不隐藏.
    itemA.functionValue = modePlaceDemandsName;
    itemA.placeholderValue = @"请选择所在地区";
    
    ResumeTableItem *itemB = [ResumeTableItem new];
    itemB.showtype = LabelText;
    itemB.name = @"场所类型";
    itemB.isUserInteractFlag = NO;
    itemB.isShowLineImageFlag = NO;//不隐藏.
    itemB.functionValue = @"";
    itemB.placeholderValue = @"请选择场所类型";
    
    ResumeTableItem *itemC = [ResumeTableItem new];
    itemC.showtype = LabelText;
    itemC.name = @"场所面积";
    itemC.isUserInteractFlag = NO;
    itemC.isShowLineImageFlag = NO;//不隐藏.
    itemC.functionValue = @"";
    itemC.placeholderValue = @"请选择场所面积";
    
    ResumeTableItem *itemD = [ResumeTableItem new];
    itemD.showtype = LabelText;
    itemD.name = @"投入金额";
    itemD.isUserInteractFlag = NO;
    itemD.isShowLineImageFlag = NO;//不隐藏.
    itemD.functionValue = @"";
    itemD.placeholderValue = @"请选择投入金额";
    
    [self.data addObject:itemA];
    [self.data addObject:itemB];
    [self.data addObject:itemC];
    [self.data addObject:itemD];
    [self.baseTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kAddPolicyPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kAddPolicyPage];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

- (BOOL)shouldShowShadowImage{
    return  YES;
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
}

-(noWifiView *)failView{
    if (_failView == nil) {
        _failView = [[noWifiView alloc]initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight)];
        [_failView.reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _failView.hidden = YES;
    }
    return _failView;
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight  = (49)*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = YES;
    }
    return _baseTableView;
}


-(NSMutableArray *)intentionAmountMutableArray{
    if (_intentionAmountMutableArray == nil) {
        _intentionAmountMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_intentionAmountMutableArray addObject:@{@"code":@"1",@"name":@"1万以内"}];
        [_intentionAmountMutableArray addObject:@{@"code":@"2",@"name":@"1-5万"}];
        [_intentionAmountMutableArray addObject:@{@"code":@"3",@"name":@"5-20万"}];
        [_intentionAmountMutableArray addObject:@{@"code":@"4",@"name":@"20-50万"}];
        [_intentionAmountMutableArray addObject:@{@"code":@"5",@"name":@"50万以上"}];
    }
    return _intentionAmountMutableArray;
}

-(NSMutableArray *)placeSizeMutableArray{
    if (_placeSizeMutableArray == nil) {
        _placeSizeMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_placeSizeMutableArray addObject:@{
                                            @"code":@"0",
                                            @"name":@"默认"
                                            }];
        [_placeSizeMutableArray addObject:@{
                                            @"code":@"1",
                                            @"name":@"10㎡以内"
                                            }];
        [_placeSizeMutableArray addObject:@{
                                            @"code":@"2",
                                            @"name":@"10-30㎡"
                                            }];
        [_placeSizeMutableArray addObject:@{
                                            @"code":@"3",
                                            @"name":@"30-100㎡"
                                            }];
        [_placeSizeMutableArray addObject:@{
                                            @"code":@"4",
                                            @"name":@"100-300㎡"
                                            }];
        [_placeSizeMutableArray addObject:@{
                                            @"code":@"5",
                                            @"name":@"300㎡以上"
                                            }];
       
        
    }
    return _placeSizeMutableArray;
}

-(NSMutableArray *)placeOfBusinessMutableArray{
    if (_placeOfBusinessMutableArray == nil) {
        _placeOfBusinessMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"1",
                                                  @"name":@"不需要经营场所"
                                                  }];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"2",
                                                  @"name":@"街边店"
                                                  }];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"3",
                                                  @"name":@"写字楼"
                                                  }];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"4",
                                                  @"name":@"商场店"
                                                  }];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"5",
                                                  @"name":@"不限场所类型"
                                                  }];
    }
    return _placeOfBusinessMutableArray;
}
@end
