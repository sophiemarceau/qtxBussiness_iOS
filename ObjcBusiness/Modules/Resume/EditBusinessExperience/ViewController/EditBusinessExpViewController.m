//
//  EditBusinessExpViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EditBusinessExpViewController.h"
#import "BaseTableView.h"
#import "EditBusinessExperienceCell.h"
#import "EditBusinessModel.h"
#import "EditBusinessExperienceCell+EditBusinessModel.h"
#import "MOFSPickerManager.h"
#import "DistrictManager.h"
#import "YLAwesomeData.h"
#import "YLDataConfiguration.h"
#import "YLAwesomeSheetController.h"


@interface EditBusinessExpViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *tradeStr,*timeStr,*clientTypeStr,*clientNumStr,*clientFlow;
}
@property (nonatomic,strong)UISwitch *onOffSwitch;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UILabel *switchDesLabel;
@property (nonatomic,strong)UIView *onOffSwitchbgView;
@property (nonatomic,strong)BaseTableView *baseTableView;
@property (nonatomic,strong)NSMutableArray *baseMutableArray;

@property (nonatomic,strong)NSMutableArray *tradeMutableArray;
@property (nonatomic,strong)NSMutableArray *clientTypeMutableArray;
@property (nonatomic,strong)NSMutableArray *clientNumbersMutableArray;
@property (nonatomic,strong)NSMutableArray *clientFlowMutableArray;
@end

@implementation EditBusinessExpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑生意经验";
    [self initNavgation];
    
    [self initSubViews];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)loadData{
    tradeStr =timeStr=clientTypeStr=clientNumStr=clientFlow = @"";
    EditBusinessModel *editBusinessModel1  = [EditBusinessModel new];
    editBusinessModel1.functionnameStr = @"主要从事行业";
    editBusinessModel1.placenameStr = @"请选择您从事的主要行业";
    EditBusinessModel *editBusinessModel2  = [EditBusinessModel new];
    editBusinessModel2.functionnameStr = @"从事该行业时间";
    editBusinessModel2.placenameStr = @"请选择从事该行业时间";
    EditBusinessModel *editBusinessModel3  = [EditBusinessModel new];
    editBusinessModel3.functionnameStr = @"客户类型";
    editBusinessModel3.placenameStr = @"请选择客户类型";
    EditBusinessModel *editBusinessModel4  = [EditBusinessModel new];
    editBusinessModel4.functionnameStr = @"常客数量（选填)";
    editBusinessModel4.placenameStr = @"请选择老客户数量";
    EditBusinessModel *editBusinessModel5  = [EditBusinessModel new];
    editBusinessModel5.functionnameStr = @"客流量（选填）";
    editBusinessModel5.placenameStr = @"请选择客流量";
    [self.baseMutableArray addObject:editBusinessModel1];
    [self.baseMutableArray addObject:editBusinessModel2];
    [self.baseMutableArray addObject:editBusinessModel3];
    [self.baseMutableArray addObject:editBusinessModel4];
    [self.baseMutableArray addObject:editBusinessModel5];
    
    if ([self.resumeIsExperience isEqualToString:@"1"]) {
        [self.onOffSwitch setOn:YES animated:YES];
        self.baseTableView.hidden = NO;
        
    }
    if ([self.resumeIsExperience isEqualToString:@"2"]) {
        [self.onOffSwitch setOn:YES animated:YES];
        self.baseTableView.hidden = NO;
        
        for (NSDictionary *temp in self.tradeMutableArray) {
            if ( [[temp objectForKey:@"code"] isEqualToString:self.BusinessExperienceDic[@"experience_industry"]]) {
                tradeStr = [temp objectForKey:@"code"] ;
                editBusinessModel1.contentStr = [temp objectForKey:@"name"] ;
                break;
            }
        }
        editBusinessModel2.contentStr = [NSString stringWithFormat:@"%@-%@",self.BusinessExperienceDic[@"experience_starttime"],self.BusinessExperienceDic[@"experience_endtime"]];
        timeStr = editBusinessModel2.contentStr;
        
        
         NSString *kindvalue = [NSString stringWithFormat:@"%@",self.BusinessExperienceDic[@"experience_customer_kind"]];
        for (NSDictionary *temp in self.clientTypeMutableArray) {
            if ( [[temp objectForKey:@"code"] isEqualToString:kindvalue]) {
                
                clientTypeStr = [temp objectForKey:@"code"] ;
                editBusinessModel3.contentStr = [temp objectForKey:@"name"] ;
                break;
            }
        }

        NSString *text1;
        NSString *value1 = [NSString stringWithFormat:@"%@",self.BusinessExperienceDic[@"experience_customer_num"]];
        for (NSDictionary *temp in self.clientNumbersMutableArray) {
            if ( [[temp objectForKey:@"code"] isEqualToString:value1]) {
                text1 =[temp objectForKey:@"name"];
                break;
            }
        }
        NSString *text2;
        NSString *value2 = [NSString stringWithFormat:@"%@",self.BusinessExperienceDic[@"experience_flow_time"]];
        
        if ([value2 isEqualToString:@"1"]) {
            text2 = @"天";
        }else{
            text2 = @"月";
        }
        
        editBusinessModel4.contentStr = [NSString stringWithFormat:@"%@/%@",text1,text2];
        clientNumStr = [NSString stringWithFormat:@"%@/%@",self.BusinessExperienceDic[@"experience_customer_num"],self.BusinessExperienceDic[@"experience_flow_time"]];
        NSString *clientNumvalue = [NSString stringWithFormat:@"%@",self.BusinessExperienceDic[@"experience_flow_num"]];
        for (NSDictionary *temp in self.clientFlowMutableArray) {
            if ( [[temp objectForKey:@"code"] isEqualToString:clientNumvalue]) {
                clientFlow = [temp objectForKey:@"code"] ;
                editBusinessModel5.contentStr = [temp objectForKey:@"name"] ;
                break;
            }
        }
    }
    
    if([self.resumeIsExperience isEqualToString:@"3"]){
        [self.onOffSwitch setOn:NO animated:YES];
        self.baseTableView.hidden = YES;
        return;
    }
   
    [self.baseTableView reloadData];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

- (void)initNavgation{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
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

- (void)save{
    BOOL isButtonOn = [self.onOffSwitch isOn];
    if (!isButtonOn) {
        NSDictionary *dic = @{@"resume_id":self.resumeId};
        [[RequestManager shareRequestManager] closeResumeExperience:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"closeResumeExperience----->%@",result);
            if (IsSucess(result) == 1) {
                int returnFLag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
                if (returnFLag == 1) {
                    NSDictionary *returnDic = @{
                                                @"businessExperienceIndex":@"3",
                                                
                                                };
                    [[RequestManager shareRequestManager] tipAlert:@"关闭成功" viewController:self];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ResumeExperience object:nil userInfo:returnDic];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                }
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
        } failuer:^(NSError *error) {
            
        }];
        return;
    }
    
    if (tradeStr.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您主要从事的行业" viewController:self];
        return;
    }
    if (timeStr.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择你主营行业的时间" viewController:self];
        return;
    }
    NSArray *timeArray = [timeStr componentsSeparatedByString:@"-"];
   
    NSString *time1 =  timeArray[1];
    NSString *time0 = timeArray[0];
    if ([time1 isEqualToString:@"至今"]) {
        time1 = @"2017";
    }
    if ([time0 isEqualToString:@"1990年以前"]) {
        time1 = @"1989";
    }
    if ([time1 intValue] < [time0 intValue]) {
        [[RequestManager shareRequestManager] tipAlert:@"请检查行业的时间  初始年份要小于结束年份" viewController:self];
        return;
    }
    
    if (clientTypeStr.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择客户类型" viewController:self];
        return;
    }

     NSArray *clientNumStrArray = [clientNumStr componentsSeparatedByString:@"/"];
   
    NSDictionary *dic = @{
                          @"resume_id":self.resumeId,
                          @"experience_industry":tradeStr,
                          @"experience_starttime":timeArray[0],
                          @"experience_endtime":timeArray[1],
                          @"experience_customer_kind":clientTypeStr,
                          @"_experience_customer_num":clientNumStrArray[0],
                          @"_experience_flow_time":clientNumStrArray[1],
                          @"_experience_flow_num": clientFlow
                          };
//    NSLog(@"dic----->%@",dic);
    [[RequestManager shareRequestManager] addResumeExperience:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"addResumeExperience----->%@",result);
        
        if (IsSucess(result) == 1) {
//            int returnFLag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
//            if (returnFLag == 1) {
            NSDictionary *returnDic = @{
                                        @"businessExperienceIndex":@"2",
                                        
                                        };
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ResumeExperience object:nil userInfo:returnDic];
            [[RequestManager shareRequestManager] tipAlert:@"保存成功" viewController:self];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
//            }
        }else{
            if (IsSucess(result) == -1) {
                [[RequestManager shareRequestManager] loginCancel:result];
            }else{
                [[RequestManager shareRequestManager] resultFail:result viewController:self];
            }
        }
    } failuer:^(NSError *error) {
        
    }];
}

-(void)returnListPage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        self.baseTableView.hidden = NO;
    }else {
        self.baseTableView.hidden = YES;
        

    }
}

#pragma mark TableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baseMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*AUTO_SIZE_SCALE_X;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"EditBusinessExperienceCell";
    EditBusinessExperienceCell *cell = (EditBusinessExperienceCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[EditBusinessExperienceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        //取消cell的选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if ([self.baseMutableArray count] > 0) {
        EditBusinessModel *editBusinessModel =[self.baseMutableArray objectAtIndex:indexPath.row];
        [cell configureWithListEntity:editBusinessModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EditBusinessModel *editBusinessModel =[self.baseMutableArray objectAtIndex:indexPath.row];
    if(indexPath.row == 0){
        NSMutableArray *tradList = [NSMutableArray new];
        for (NSDictionary *temp in self.tradeMutableArray) {
            [tradList addObject:[temp objectForKey:@"name"]];
        }
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:tradList tag:2000001 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
            for (NSDictionary *temp in self.tradeMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    tradeStr = [temp objectForKey:@"code"] ;
                    break;
                }
            }
        } cancelBlock:^{
            
        }];
    }
    if(indexPath.row == 1){
        EditBusinessExperienceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *contentString = ((EditBusinessExperienceCell *)cell).contentTextField.text;
        
        NSArray *selectedData ;
        NSArray *selectearray ;

        if (![timeStr isEqualToString:@""]) {
            selectedData = [contentString componentsSeparatedByString:@"-"];
             YLAwesomeData *data = nil;
            if ([selectedData[0] isEqualToString:@"1990年以前"]) {
               
                data = [[YLAwesomeData alloc]initWithId:1989 name:[NSString stringWithFormat:@"%@", selectedData[0]]];
            }else{
                data = [[YLAwesomeData alloc]initWithId:[selectedData[0] intValue] name:[NSString stringWithFormat:@"%@", selectedData[0]]];
            }
            
            NSDateComponents *dateComponents = [self currentDateComponents];
            NSInteger year = dateComponents.year;
            YLAwesomeData *data1 = nil;
            if ([selectedData[1] isEqualToString:@"至今"]) {
                
                data1 = [[YLAwesomeData alloc]initWithId:year name:[NSString stringWithFormat:@"%@", selectedData[1]]];
            }else{
                data1 = [[YLAwesomeData alloc]initWithId:[selectedData[1] intValue] name:[NSString stringWithFormat:@"%@", selectedData[1]]];
            }
            selectearray = @[data,data1];
        }
        
        
        NSDictionary *data = [self testDic];
        
        YLDataConfiguration *config = [[YLDataConfiguration alloc]initWithData:data selectedData:selectearray];
        YLAwesomeSheetController *sheet = [[YLAwesomeSheetController alloc]initWithTitle:@"" config:config callBack:^(NSArray *selectedData) {
            
            [((EditBusinessExperienceCell *)cell).contentTextField setText:[selectedData componentsJoinedByString:@"-"]];
            timeStr = [selectedData componentsJoinedByString:@"-"];
        }];
        [sheet showInController:self];
    }
    
    if(indexPath.row == 2){
        NSMutableArray *clientTypeList = [NSMutableArray new];
        for (NSDictionary *temp in self.clientTypeMutableArray) {
            [clientTypeList addObject:[temp objectForKey:@"name"]];
        }
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:clientTypeList tag:2000002 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
            for (NSDictionary *temp in self.clientTypeMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    clientTypeStr = [temp objectForKey:@"code"] ;
                    break;
                }
            }
        } cancelBlock:^{
            
        }];
    }
    
    if(indexPath.row == 3){
        EditBusinessExperienceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *contentString = ((EditBusinessExperienceCell *)cell).contentTextField.text;
        
        NSArray *alreadyselectedData ;
        if (![contentString isEqualToString:@""]) {
            NSArray *temparray  = [contentString componentsSeparatedByString:@"/"];
            YLAwesomeData *data1;
            for (NSDictionary *temp in self.clientNumbersMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:temparray[0]]) {
                    
                    data1 = [[YLAwesomeData alloc]initWithId:[[temp objectForKey:@"code"] integerValue] name:temparray[0]];
                    break;
                }
            }
            YLAwesomeData *data2;
            if ([temparray[1] isEqualToString:@"天"]) {
                data2 = [[YLAwesomeData alloc]initWithId:1 name:temparray[1]];
            }else{
                data2 = [[YLAwesomeData alloc]initWithId:2 name:temparray[1]];
            }

            alreadyselectedData = [NSArray arrayWithObjects:data1,data2,nil];
            
        }
//        NSLog(@"alreadyselectedData----->%@",alreadyselectedData);
//        NSLog(@"alreadyselectedData---0--->%@",alreadyselectedData[0]);
//        NSLog(@"alreadyselectedData---1-->%@",alreadyselectedData[1]);
        NSDictionary *data = [self clientNumberDic];
        
        YLDataConfiguration *config = [[YLDataConfiguration alloc]initWithData:data selectedData:alreadyselectedData];
        YLAwesomeSheetController *sheet = [[YLAwesomeSheetController alloc]initWithTitle:@"" config:config callBack:^(NSArray *selectedData) {
            [((EditBusinessExperienceCell *)cell).contentTextField setText:[selectedData componentsJoinedByString:@"/"]];
//            NSLog(@"selectedData----->%@",selectedData);
//            NSLog(@"selectedData----->%ld",((YLAwesomeData *)selectedData[0]).objId);

            clientNumStr = [NSString stringWithFormat:@"%ld/%ld",((YLAwesomeData *)selectedData[0]).objId,(long)((YLAwesomeData *)selectedData[1]).objId];
//            NSLog(@"clientNumStr----->%@",clientNumStr);
        }];
        [sheet showInController:self];
    }
    if(indexPath.row == 4){
        NSMutableArray *clientFlowList = [NSMutableArray new];
        for (NSDictionary *temp in self.clientFlowMutableArray) {
            [clientFlowList addObject:[temp objectForKey:@"name"]];
        }
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:clientFlowList tag:2000003 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
            for (NSDictionary *temp in self.clientFlowMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    clientFlow = [temp objectForKey:@"code"] ;
//                    NSLog(@"clientFlow----->%@",clientFlow);
                    break;
                }
            }
        } cancelBlock:^{
        }];
    }
}

- (void)initSubViews{
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.onOffSwitchbgView];
    [self.onOffSwitchbgView addSubview:self.switchDesLabel];
    [self.onOffSwitchbgView addSubview:self.onOffSwitch];
    [self.view addSubview:self.baseTableView];
}

-(UIView *)onOffSwitchbgView{
    if (_onOffSwitchbgView == nil) {
        _onOffSwitchbgView = [UIView new];
        _onOffSwitchbgView.backgroundColor = [UIColor whiteColor];
        _onOffSwitchbgView.frame = CGRectMake(0, 10*AUTO_SIZE_SCALE_X, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
        
    }
    return _onOffSwitchbgView;
}

- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [UIView new];
        _headerView.backgroundColor = BGColorGray;
        _headerView.frame = CGRectMake(0, kNavHeight, kScreenWidth, 70*AUTO_SIZE_SCALE_X);
        
    }
    return _headerView;
}


-(UISwitch *)onOffSwitch{
    if(_onOffSwitch == nil){
        _onOffSwitch = [[UISwitch alloc]init];
        [_onOffSwitch setTintColor:UIColorFromRGB(0xE4E4E4)];
        [_onOffSwitch setOnTintColor:RedUIColorC1];
//        [_onOffSwitch setThumbTintColor:[UIColor whiteColor]];
        _onOffSwitch.layer.cornerRadius = 15.5f;
        _onOffSwitch.layer.masksToBounds = YES;
        [_onOffSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _onOffSwitch.frame = CGRectMake(309*AUTO_SIZE_SCALE_X, 9.5*AUTO_SIZE_SCALE_X, 51, 31);
    }
    return _onOffSwitch;
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil ) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:
                          CGRectMake(0, 70*AUTO_SIZE_SCALE_X+kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-70*AUTO_SIZE_SCALE_X)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight  = (50)*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = YES;
    }
    return _baseTableView;
}

-(NSMutableArray *)baseMutableArray{
    if (_baseMutableArray == nil) {
        _baseMutableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _baseMutableArray;
}

-(NSMutableArray *)tradeMutableArray{
    if (_tradeMutableArray == nil) {
        _tradeMutableArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *industryArray =  [[DistrictManager shareManger] industryArray];
        for(int i = 0; i<industryArray.count;i++){
            [_tradeMutableArray addObject:@{
                                            @"code":[[industryArray objectAtIndex:i] objectForKey:@"value"],
                                            @"name":[[industryArray objectAtIndex:i] objectForKey:@"text"]
                                            }];
        }
    }
    return _tradeMutableArray;
}

-(NSMutableArray *)clientTypeMutableArray{
    if (_clientTypeMutableArray == nil) {
        _clientTypeMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_clientTypeMutableArray addObject:@{
                                                @"code":@"1",
                                                @"name":@"全部类型"
                                                }];
        [_clientTypeMutableArray addObject:@{
                                                @"code":@"2",
                                                @"name":@"普通消费者"
                                                }];
        [_clientTypeMutableArray addObject:@{
                                                @"code":@"3",
                                                @"name":@"企业客户"
                                                }];

    }
    return _clientTypeMutableArray;
}

-(NSMutableArray *)clientNumbersMutableArray{
    if (_clientNumbersMutableArray == nil) {
        _clientNumbersMutableArray = [NSMutableArray arrayWithCapacity:0];
        
        [_clientNumbersMutableArray addObject:@{
                                             @"code":@"1",
                                             @"name":@"10人以下"
                                             }];
        [_clientNumbersMutableArray addObject:@{
                                             @"code":@"2",
                                             @"name":@"10-50人"
                                             }];
        [_clientNumbersMutableArray addObject:@{
                                             @"code":@"3",
                                             @"name":@"50-100人"
                                             }];
        [_clientNumbersMutableArray addObject:@{
                                             @"code":@"4",
                                             @"name":@"100-500人"
                                             }];
        [_clientNumbersMutableArray addObject:@{
                                                @"code":@"5",
                                                @"name":@"500人以上"
                                                }];
        
       
    }
    return _clientNumbersMutableArray;
}

-(UILabel *)switchDesLabel{
    if(_switchDesLabel == nil){
        _switchDesLabel = [CommentMethod initLabelWithText:@"是否有做生意的经验" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
        _switchDesLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth*2/3, 50*AUTO_SIZE_SCALE_X);
    }
    return _switchDesLabel;
}

- (NSDictionary *)clientNumberDic
{
    NSMutableArray *firstColumn = [NSMutableArray array];
    YLAwesomeData *data1 = [[YLAwesomeData alloc]initWithId:1 name:[NSString stringWithFormat:@"10人以下"]];
    YLAwesomeData *data2 = [[YLAwesomeData alloc]initWithId:2 name:[NSString stringWithFormat:@"10-50人"]];
    YLAwesomeData *data3 = [[YLAwesomeData alloc]initWithId:3 name:[NSString stringWithFormat:@"50-100人"]];
    YLAwesomeData *data4 = [[YLAwesomeData alloc]initWithId:4 name:[NSString stringWithFormat:@"100-500人"]];
    YLAwesomeData *data5 = [[YLAwesomeData alloc]initWithId:5 name:[NSString stringWithFormat:@"500人以上"]];
    [firstColumn addObject:data1];
    [firstColumn addObject:data2];
    [firstColumn addObject:data3];
    [firstColumn addObject:data4];
    [firstColumn addObject:data5];
    NSMutableArray * secondyColumn = [NSMutableArray array];
    YLAwesomeData *data1AwesomeData = [[YLAwesomeData alloc]initWithId:1 name:[NSString stringWithFormat:@"天"]];
    YLAwesomeData *data2AwesomeData = [[YLAwesomeData alloc]initWithId:2 name:[NSString stringWithFormat:@"月"]];
    [secondyColumn addObject:data1AwesomeData];
    [secondyColumn addObject:data2AwesomeData];
    NSDictionary *clientNumberDic = @{@0:firstColumn,@1:secondyColumn};
    return clientNumberDic;
}


- (NSDictionary *)testDic
{
    NSDateComponents *dateComponents = [self currentDateComponents];
    NSInteger year = dateComponents.year;
    
    NSMutableArray *firstyears = [NSMutableArray array];
    for(NSInteger i = year; i >= 1989; i--){
        YLAwesomeData *data = nil;
        if (i == 1989) {
            data = [[YLAwesomeData alloc]initWithId:i name:[NSString stringWithFormat:@"1990年以前"]];
        }else{
            data = [[YLAwesomeData alloc]initWithId:i name:[NSString stringWithFormat:@"%li",i]];
        }
        
        [firstyears addObject:data];
    }
    
    NSMutableArray * secondyears = [NSMutableArray array];
    for(NSInteger i = year; i >= 1990; i--){
        
        YLAwesomeData *data = nil;
        if(i == year){
            data = [[YLAwesomeData alloc]initWithId:i name:[NSString stringWithFormat:@"至今"]];
        }else{
            data = [[YLAwesomeData alloc]initWithId:i name:[NSString stringWithFormat:@"%li",i]];
        }
        
        [secondyears addObject:data];
    }
    NSDictionary *data = @{@0:firstyears,
                           @1:secondyears
                           };
    return data;
}

- (NSDateComponents *)currentDateComponents
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:now];
    return dateComponents;
}

-(NSMutableArray *)clientFlowMutableArray{
    if (_clientFlowMutableArray == nil) {
        _clientFlowMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_clientFlowMutableArray addObject:@{
                                                @"code":@"1",
                                                @"name":@"50人以下"
                                                }];
        [_clientFlowMutableArray addObject:@{
                                                @"code":@"2",
                                                @"name":@"50-200人"
                                                }];
        [_clientFlowMutableArray addObject:@{
                                                @"code":@"3",
                                                @"name":@"200-500人"
                                                }];
        [_clientFlowMutableArray addObject:@{
                                                @"code":@"4",
                                                @"name":@"500人以上"
                                                }];
       
    }
    return _clientFlowMutableArray;
}
@end
