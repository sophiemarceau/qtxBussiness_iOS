//
//  EditBusinessIntentViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "EditBusinessIntentViewController.h"
#import "BaseTableView.h"
#import "EditBusinessExperienceCell.h"
#import "EditBusinessModel.h"
#import "EditBusinessExperienceCell+EditBusinessModel.h"
#import "MOFSPickerManager.h"
#import "DistrictManager.h"
#import "UITextView+ZWPlaceHolder.h"
#import <objc/runtime.h>
@interface EditBusinessIntentViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *tradeStr,*moneyStr,*cooperationTypeStr,*intention_note;
}
@property (nonatomic,strong)BaseTableView *baseTableView;
@property (nonatomic,strong)NSMutableArray *baseMutableArray;
@property (nonatomic,strong)NSMutableArray *tradeMutableArray;
@property (nonatomic,strong)NSMutableArray *moneyMutableArray;
@property (nonatomic,strong)NSMutableArray *cooperationTypeMutableArray;
@property (nonatomic,strong)UILabel *remarksLabel;
@property (nonatomic,strong)UIView *remarksbgView;
@property (nonatomic,strong)UITextView *remarksTextView;
@end

@implementation EditBusinessIntentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑生意意向";
    [self initNavgation];
    [self initSubViews];
    self.automaticallyAdjustsScrollViewInsets=NO;//scrollview预留空位
    [self loadData];
}
-(void)loadData{
    [self.baseMutableArray removeAllObjects];
    
    NSDictionary *dic = @{@"resume_id":self.resumeId};
    [[RequestManager shareRequestManager] getBusinessResumeIntention:dic viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            EditBusinessModel *editBusinessModel1  = [EditBusinessModel new];
            editBusinessModel1.functionnameStr = @"意向行业";
            editBusinessModel1.placenameStr = @"请选择您意向的主要行业";
            
            EditBusinessModel *editBusinessModel2  = [EditBusinessModel new];
            editBusinessModel2.functionnameStr = @"投入金额";
            editBusinessModel2.placenameStr = @"请选择投入金额";
            
            EditBusinessModel *editBusinessModel3  = [EditBusinessModel new];
            editBusinessModel3.functionnameStr = @"希望合作模式（选填）";
            editBusinessModel3.placenameStr = @"请选择合作模式";
            
            NSDictionary *dtoDictionary = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil){
                intention_note = [dtoDictionary objectForKey:@"intention_note"];
                for (NSDictionary *temp in self.tradeMutableArray) {
                    if ( [[temp objectForKey:@"code"] isEqualToString:[dtoDictionary objectForKey:@"intention_industry"]]) {
                        editBusinessModel1.contentStr = [temp objectForKey:@"name"] ;
                        tradeStr = [temp objectForKey:@"code"] ;
                    }
                }
                NSString *moneystr = [NSString stringWithFormat:@"%@",[dtoDictionary objectForKey:@"intention_amount"]];
                
                for (NSDictionary *temp in self.moneyMutableArray) {
                    if ( [[temp objectForKey:@"code"] isEqualToString:moneystr]) {
                        editBusinessModel2.contentStr = [temp objectForKey:@"name"] ;
                        moneyStr = [temp objectForKey:@"code"] ;
                    }
                }
                
                NSString *coopertypestr = [NSString stringWithFormat:@"%@",[dtoDictionary objectForKey:@"intention_type"]];
                
                if (![coopertypestr isEqualToString:@"0"]) {
                    for (NSDictionary *temp in self.cooperationTypeMutableArray) {
                        if ( [[temp objectForKey:@"code"] isEqualToString:coopertypestr]) {
                            editBusinessModel3.contentStr = [temp objectForKey:@"name"] ;
                            cooperationTypeStr = [temp objectForKey:@"code"] ;
                        }
                    }
                }
                self.remarksTextView.text = intention_note;
                [self.remarksTextView updatePlaceHolder];
                
            }
            [_baseMutableArray addObject:editBusinessModel1];
            [_baseMutableArray addObject:editBusinessModel2];
            [_baseMutableArray addObject:editBusinessModel3];
            [self.baseTableView reloadData];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [self.view endEditing:YES];
    intention_note = self.remarksTextView.text;
    if (tradeStr.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您想要投资的行业" viewController:self];
        return;
    }
    if (moneyStr.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您想要投入的金额" viewController:self];
        return;
    }

    if (intention_note.length > 150) {
        [[RequestManager shareRequestManager] tipAlert:@"备注内容不得超过150字" viewController:self];
        return;
    }

    NSDictionary *dic = @{
                          @"resume_id":self.resumeId,
                          @"_intention_type":cooperationTypeStr,
                          @"intention_amount":moneyStr,
                          @"intention_industry":tradeStr,
                          @"_intention_note":intention_note,
                          };
    [[RequestManager shareRequestManager] editBusinessResumeIntention:dic viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            int returnFLag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            if (returnFLag == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ResumeIntention object:nil userInfo:nil];
                [[RequestManager shareRequestManager] tipAlert:@"保存成功" viewController:self];
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
}

-(void)returnListPage{

    [self.navigationController popViewControllerAnimated:YES];
   
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
    cell.backgroundColor = [UIColor blueColor];
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
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:tradList tag:4001 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
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
        NSMutableArray *clientTypeList = [NSMutableArray new];
        for (NSDictionary *temp in self.moneyMutableArray) {
            [clientTypeList addObject:[temp objectForKey:@"name"]];
        }
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:clientTypeList tag:4002 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
            for (NSDictionary *temp in self.moneyMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    moneyStr = [temp objectForKey:@"code"] ;
                    break;
                }
            }
        } cancelBlock:^{
            
        }];
    }
    if(indexPath.row == 2){
        NSMutableArray *clientTypeList = [NSMutableArray new];
        for (NSDictionary *temp in self.cooperationTypeMutableArray) {
            [clientTypeList addObject:[temp objectForKey:@"name"]];
        }
        [[MOFSPickerManager shareManger] showPickerViewWithDataArray:clientTypeList tag:4003 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
            BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
            for (NSDictionary *temp in self.cooperationTypeMutableArray) {
                if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                    cooperationTypeStr = [temp objectForKey:@"code"] ;
                    break;
                }
            }
        } cancelBlock:^{
            
        }];
    }
}

- (void)initSubViews{
    self.view.backgroundColor = BGColorGray;
    [self.view addSubview:self.baseTableView];
    [self.view addSubview:self.remarksLabel];
    [self.view addSubview:self.remarksbgView];
}



-(BaseTableView *)baseTableView{
    if (_baseTableView == nil ) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:
                          CGRectMake(0, kNavHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth, 150*AUTO_SIZE_SCALE_X)];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.estimatedRowHeight  = (50)*AUTO_SIZE_SCALE_X;
        _baseTableView.bounces = NO;
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

-(NSMutableArray *)moneyMutableArray{
    if (_moneyMutableArray == nil) {
        _moneyMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_moneyMutableArray addObject:@{
                                             @"code":@"1",
                                             @"name":@"1万以内"
                                             }];
        [_moneyMutableArray addObject:@{
                                            @"code":@"2",
                                            @"name":@"1-5万"
                                        }];
        [_moneyMutableArray addObject:@{
                                             @"code":@"3",
                                             @"name":@"5-20万"
                                             }];
        [_moneyMutableArray addObject:@{
                                             @"code":@"4",
                                             @"name":@"20-50万"
                                             }];
        [_moneyMutableArray addObject:@{
                                             @"code":@"5",
                                             @"name":@"50万以上"
                                             }];
        
    }
    return _moneyMutableArray;
}

-(NSMutableArray *)cooperationTypeMutableArray{
    if (_cooperationTypeMutableArray == nil) {
        _cooperationTypeMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_cooperationTypeMutableArray addObject:@{
                                                @"code":@"1",
                                                @"name":@"商品经销"
                                                }];
        [_cooperationTypeMutableArray addObject:@{
                                                @"code":@"2",
                                                @"name":@"品牌代理"
                                                }];
        [_cooperationTypeMutableArray addObject:@{
                                                @"code":@"3",
                                                @"name":@"店铺加盟"
                                                }];
 
    }
    return _cooperationTypeMutableArray;
}


-(UILabel *)remarksLabel{
    if (_remarksLabel == nil) {
        _remarksLabel = [CommentMethod initLabelWithText:@"备注（选填）" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
        _remarksLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, kNavHeight+150*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X, kScreenWidth - 30*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
    }
    return _remarksLabel;
}

- (UIView *)remarksbgView{
    if (_remarksbgView == nil) {
        _remarksbgView = [UIView new];
        _remarksbgView.backgroundColor = [UIColor whiteColor];
        _remarksbgView.frame = CGRectMake(0, kNavHeight+150*AUTO_SIZE_SCALE_X+10*AUTO_SIZE_SCALE_X+44*AUTO_SIZE_SCALE_X, kScreenWidth , 150*AUTO_SIZE_SCALE_X);
        [_remarksbgView addSubview:self.remarksTextView];
    }
    return _remarksbgView;
}


-(UITextView *)remarksTextView{
    if (_remarksTextView == nil) {
        _remarksTextView = [[UITextView alloc] initWithFrame:CGRectMake(15*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, self.remarksbgView.frame.size.height-30*AUTO_SIZE_SCALE_X)];
        _remarksTextView.layer.borderWidth = 0;
        _remarksTextView.font = [UIFont systemFontOfSize:14];
        _remarksTextView.layer.borderColor = [UIColor clearColor].CGColor;
        _remarksTextView.zw_placeHolder = @"50字以内，例：我在北京市朝阳区建外大街19号有家经营酒类的临街店铺，每天客流量大约在150人左右，每日流水至少15000元";
        _remarksTextView.zw_placeHolderColor = FontUIColor999999Gray;
        _remarksTextView.textColor = FontUIColorBlack;
        _remarksTextView.tintColor = RedUIColorC1;
        
    }
    return _remarksTextView;
}
@end
