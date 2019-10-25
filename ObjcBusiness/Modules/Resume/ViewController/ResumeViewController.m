//
//  ResumeViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ResumeViewController.h"
#import "CDZBaseCell.h"
#import "PersonalViewController.h"
#import "TextWthInputFieldCell.h"
#import "TextWithMarginCell.h"
#import "TextWithLineCell.h"
#import "ResumeTableItem.h"
#import "BottomButtonView.h"
#import "MOFSPickerManager.h"
#import "ResumeFooterVIew.h"
#import "TextPlaceCell.h"
#import "EditBusinessIntentViewController.h"
#import "EditBusinessExpViewController.h"
#import "AddBusinessPlaceViewController.h"
#import "BaseTableView.h"
#import "UIImageView+WebCache.h"
#import "ResumePersonalInfoCell.h"
#import "DetailTextViewTableViewCell.h"
#import "CreateProjectHeaderView.h"
#import "TextFieldBaseCell.h"
#import "LabelTableViewCell.h"
@interface ResumeViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *dtoDictionary;
    
    
    NSString *resumeOpenLevelIndex;
    NSString* phoneindex;
    NSString* districtindex;
    NSString* businessIntentionIndex;
    NSString* businessExperienceIndex;
    NSString* businessPlaceIndex;
    NSNumber* resume_id;
    NSDictionary *businessExperienceDic;
    NSIndexPath *selectindexPath;
}
@property (nonatomic,strong)BaseTableView *HeaderTableView;
@property (nonatomic,strong)BaseTableView *Tableview;
@property (nonatomic,strong)BottomButtonView *bottonButtonView;
@property (nonatomic,strong)ResumeFooterVIew *resumeFooterView;
@property (nonatomic,strong)NSMutableArray *resumeMutableArray;
@property (nonatomic,strong)NSMutableArray *placesMutableArray;
@property (nonatomic,strong)NSMutableArray *opennessMutableArray;
@property (nonatomic,strong)NSMutableArray *placeOfBusinessMutableArray;

@end

@implementation ResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    resumeOpenLevelIndex =phoneindex=districtindex=businessIntentionIndex=businessExperienceIndex=businessPlaceIndex=@"";
    self.title = @"编辑生意简历";
    self.automaticallyAdjustsScrollViewInsets=NO;//scrollview预留空位
    [self initNavgation];
    [self initSubViews];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHeadView:) name:NOTIFICATION_ResumeHeaderView object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshIntention:) name:NOTIFICATION_ResumeIntention object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshExperience:) name:NOTIFICATION_ResumeExperience object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPlaceView:) name:NOTIFICATION_Add_ResumePlace object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePlaceView:) name:NOTIFICATION_Update_ResumePlace object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deletePlaceView:) name:NOTIFICATION_Remove_ResumePlace object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshHeadView:(NSNotification *)notification{
     [self.HeaderTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0  inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)refreshIntention:(NSNotification *)notification{
    businessIntentionIndex = @"2";
    CDZBaseCell *cell = [self.HeaderTableView cellForRowAtIndexPath:selectindexPath];
    [((TextWithMarginCell *)cell).ValueLabel setText:@""];
}

-(void)refreshExperience:(NSNotification *)notification{
    [[RequestManager shareRequestManager] getUserBusinessResume:nil viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            dtoDictionary = [[result objectForKey:@"data"] objectForKey:@"dto"];
            resume_id = dtoDictionary[@"resume_id"];
            if(![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil){
                ResumeTableItem *itemE = self.resumeMutableArray[selectindexPath.row];
                itemE.showtype = ResumSelectWithMargin;
                itemE.name = @"生意经验";
                itemE.isShowLineImageFlag = YES;
                businessExperienceIndex = [NSString stringWithFormat:@"%d",[dtoDictionary[@"resume_is_experience"] intValue]];
                if ([businessExperienceIndex isEqualToString:@"1"]) {
                    itemE.functionValue =  @"未填写";
                }
                if ([businessExperienceIndex isEqualToString:@"2"]) {
                    itemE.functionValue =  @"已填写";
                }
                if ([businessExperienceIndex isEqualToString:@"3"]) {
                    itemE.functionValue =  @"无生意经验";
                }
                businessExperienceDic =  dtoDictionary[@"businessResumeExperienceDto"];
                [self.HeaderTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:selectindexPath.row  inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
               
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

-(void)addPlaceView:(NSNotification *)notification{
    [self refreshData];
}

-(void)updatePlaceView:(NSNotification *)notification{
    [self refreshData];
}

-(void)deletePlaceView:(NSNotification *)notification{
    [self refreshData];
}

-(void)refreshData{
    [self.placesMutableArray removeAllObjects];
    [[RequestManager shareRequestManager] getUserBusinessResume:nil viewController:self successData:^(NSDictionary *result) {
        if (IsSucess(result) == 1) {
            dtoDictionary = [[result objectForKey:@"data"] objectForKey:@"dto"];
            resume_id = dtoDictionary[@"resume_id"];
            if(![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil){
                ResumeTableItem *itemF = [ResumeTableItem new];
                itemF.showtype = ResumSelectWithMargin;
                
                if ([businessPlaceIndex isEqualToString:@"1"]) {
                    itemF.name = @"店铺信息(选填)";
                    itemF.functionValue =  @"无经营场所";
                    itemF.isShowLineImageFlag = YES;
                    [self.resumeMutableArray replaceObjectAtIndex:self.resumeMutableArray.count-1 withObject:itemF];
                    [self.Tableview.tableFooterView setHidden:YES];
                    self.Tableview.tableFooterView = nil;
                    [self.Tableview.tableFooterView removeFromSuperview];

                }
                
                if ([businessPlaceIndex isEqualToString:@"2"]) {
                    itemF.name = @"店铺信息";
                    itemF.hiddenArrowImageView = YES;
                    [self.resumeMutableArray replaceObjectAtIndex:self.resumeMutableArray.count-1 withObject:itemF];
                    NSArray *array = dtoDictionary[@"businessResumePlaceDtoList"];
                    if(![array isEqual:[NSNull null]] && array !=nil)
                    {
                        if (array.count>0) {
                            for (NSDictionary *placeDictionary in array)  {
                                ResumeTableItem *itemPlaceTemp = [ResumeTableItem new];
                                itemPlaceTemp.showtype = ResumSelectPlace;
                                itemPlaceTemp.placeName = [placeDictionary objectForKey:@"place_name"];
                                itemPlaceTemp.placeArray = @[
                                                             [placeDictionary objectForKey:@"place_kind_str"],
                                                             [placeDictionary objectForKey:@"place_industry_str"]
                                                             ];
                                itemPlaceTemp.isHavePlacePic = [[NSString stringWithFormat:@"%d",[[placeDictionary objectForKey:@"is_place_pic"] intValue]] isEqualToString:@"1"]?TRUE:FALSE;
                                
                                itemPlaceTemp.addresString = [NSString stringWithFormat:@"位置：%@",[placeDictionary objectForKey:@"place_address"]];
                                
                                itemPlaceTemp.placeId = [placeDictionary objectForKey:@"place_id"];
                                [self.placesMutableArray addObject:itemPlaceTemp];
                            }
                        }else{
                            [self.Tableview setTableFooterView:self.resumeFooterView];
                            [self.Tableview.tableFooterView setHidden:NO];
                            self.Tableview.sectionFooterHeight = 60*AUTO_SIZE_SCALE_X;
                        }
                        if (array.count >= 5) {
                            [self.Tableview.tableFooterView setHidden:YES];
                            self.Tableview.tableFooterView = nil;
                            [self.Tableview.tableFooterView removeFromSuperview];
                        }else{
                            [self.Tableview setTableFooterView:self.resumeFooterView];
                            [self.Tableview.tableFooterView setHidden:NO];
                            self.Tableview.sectionFooterHeight = 60*AUTO_SIZE_SCALE_X;
                        }
                    }
                }
                [self.HeaderTableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:self.resumeMutableArray.count-1  inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.Tableview reloadData];
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

-(void)loadData{
    [self.resumeMutableArray removeAllObjects];
    [self.placesMutableArray removeAllObjects];
    
    [[RequestManager shareRequestManager] getUserBusinessResume:nil viewController:self successData:^(NSDictionary *result) {
        
        if (IsSucess(result) == 1) {
            dtoDictionary = [[result objectForKey:@"data"] objectForKey:@"dto"];
            resume_id = dtoDictionary[@"resume_id"];
            if(![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil){
                ResumeTableItem *item0 = [ResumeTableItem new];
                item0.showtype = ResumePersonalInfo;
                item0.name = [DEFAULTS objectForKey:@"userNickName"];
                item0.functionValue = [DEFAULTS objectForKey:@"userPortraitUri"];
                
                ResumeTableItem *itemA = [ResumeTableItem new];
                itemA.showtype = ResumSelectText;
                itemA.name = @"开放程度";
                itemA.isShowLineImageFlag = NO;//不隐藏
                NSString *resume_open_level = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_open_level"]];
                for (NSDictionary *temp in self.opennessMutableArray) {
                    if ( [[temp objectForKey:@"code"] isEqualToString:resume_open_level]) {
                        itemA.functionValue = [temp objectForKey:@"name"] ;
                        resumeOpenLevelIndex = [temp objectForKey:@"code"] ;
                        break;
                    }
                }
                
                ResumeTableItem *itemB = [ResumeTableItem new];
                itemB.showtype = ResumInput;
                itemB.name = @"联系方式（可选）";
                itemB.isShowLineImageFlag = NO;//不隐藏.
                itemB.functionValue =  [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_tel"]];
                
                ResumeTableItem *itemC = [ResumeTableItem new];
                itemC.showtype = ResumSelectText;
                itemC.name = @"您的位置";
                itemC.isShowLineImageFlag = YES;//隐藏
                districtindex = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_area"]];
                NSString *areaString = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_area_str"]];
                itemC.functionValue = areaString;
                if ([areaString isEqualToString:@""]) {
                    itemC.functionValue = @"请选择所在地区";
                }
                
                ResumeTableItem *itemD = [ResumeTableItem new];
                itemD.showtype = ResumSelectWithMargin;
                itemD.name = @"生意意向";
                itemD.isShowLineImageFlag = YES;//不隐藏
                businessIntentionIndex = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_is_intention"]];
                if ([businessIntentionIndex isEqualToString:@"1"]) {
                    itemD.functionValue =  @"未填写";
                }
                
                ResumeTableItem *itemE = [ResumeTableItem new];
                itemE.showtype = ResumSelectWithMargin;
                itemE.name = @"生意经验";
                itemE.isShowLineImageFlag = YES;
                businessExperienceIndex = [NSString stringWithFormat:@"%d",[dtoDictionary[@"resume_is_experience"] intValue]];
                if ([businessExperienceIndex isEqualToString:@"1"]) {
                    itemE.functionValue =  @"未填写";
                }
                if ([businessExperienceIndex isEqualToString:@"2"]) {
                    itemE.functionValue =  @"已填写";
                }
                if ([businessExperienceIndex isEqualToString:@"3"]) {
                    itemE.functionValue =  @"无生意经验";
                }
                [self.resumeMutableArray addObject:item0];
                [self.resumeMutableArray addObject:itemA];
                [self.resumeMutableArray addObject:itemB];
                [self.resumeMutableArray addObject:itemC];
                [self.resumeMutableArray addObject:itemD];
                [self.resumeMutableArray addObject:itemE];
                
                ResumeTableItem *itemF = [ResumeTableItem new];
                itemF.showtype = ResumSelectWithMargin;
                
                itemF.isShowLineImageFlag = YES;
                businessPlaceIndex = [NSString stringWithFormat:@"%@",dtoDictionary[@"resume_is_place"]];
                if ([businessPlaceIndex isEqualToString:@"0"]) {
                    itemF.name = @"店铺信息(选填)";
                    itemF.functionValue =  @"是否有经营场所";
                    [self.resumeMutableArray addObject:itemF];
                }
                if ([businessPlaceIndex isEqualToString:@"1"]) {
                    itemF.name = @"店铺信息(选填)";
                    itemF.functionValue =  @"无经营场所";
                    [self.resumeMutableArray addObject:itemF];
                   
                }
                if ([businessPlaceIndex isEqualToString:@"2"]) {
                    itemF.name = @"店铺信息";
                    itemF.hiddenArrowImageView = YES;
                    [_resumeMutableArray addObject:itemF];
                    NSArray *array = dtoDictionary[@"businessResumePlaceDtoList"];
                    if(![array isEqual:[NSNull null]] && array !=nil)
                    {
                        for (NSDictionary *placeDictionary in array)  {
                            ResumeTableItem *itemPlaceTemp = [ResumeTableItem new];
                            itemPlaceTemp.showtype = ResumSelectPlace;
                            itemPlaceTemp.placeName = [placeDictionary objectForKey:@"place_name"];
                            
                            if ([[placeDictionary objectForKey:@"place_industry_str"] isEqualToString:@""]) {
                                itemPlaceTemp.placeArray = @[
                                                             [placeDictionary objectForKey:@"place_kind_str"],
                                                             @"不限行业"
                                                             ];
                            }else{
                                itemPlaceTemp.placeArray = @[
                                                             [placeDictionary objectForKey:@"place_kind_str"],
                                                             [placeDictionary objectForKey:@"place_industry_str"]
                                                             ];
                            }
                            
                            
                            itemPlaceTemp.isHavePlacePic = [[NSString stringWithFormat:@"%d",[[placeDictionary objectForKey:@"is_place_pic"] intValue]] isEqualToString:@"1"]?TRUE:FALSE;
                            
                            itemPlaceTemp.addresString = [NSString stringWithFormat:@"位置：%@",[placeDictionary objectForKey:@"place_address"]];
                            
                            itemPlaceTemp.placeId = [placeDictionary objectForKey:@"place_id"];
                            [self.placesMutableArray addObject:itemPlaceTemp];
                        }
                        if (array.count >= 5) {
                            [self.Tableview.tableFooterView setHidden:YES];
                            self.Tableview.tableFooterView = nil;
                            [self.Tableview.tableFooterView removeFromSuperview];
                        }else{
                            [self.Tableview setTableFooterView:self.resumeFooterView];
                            [self.Tableview.tableFooterView setHidden:NO];
                            self.Tableview.sectionFooterHeight = 60*AUTO_SIZE_SCALE_X;
                        }
                    }
                }
                [self.HeaderTableView reloadData];
                [self.Tableview reloadData];
                
                businessExperienceDic =  dtoDictionary[@"businessResumeExperienceDto"];
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

-(void)gotoBrowerView
{
    
}

-(void)AddPlaceTaped:(UITapGestureRecognizer *)sender{
    AddBusinessPlaceViewController *vc = [[AddBusinessPlaceViewController alloc] init];
    vc.title = @"添加经营场所";
    vc.resumeId = resume_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)savePost:(UIButton *)button{
    //防止按钮快速点击造成多次响应的避免方法
    //    [[selfclass] cancelPreviousPerformRequestsWithTarget:selfselector:@selector(todoSomething:)object:sender];
    //
    //    [self performSelector:@selector(todoSomething:)withObject:sender afterDelay:0.2f];
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(save:)object:button];
    [self performSelector:@selector(save:) withObject:button afterDelay:0.2f];
}

- (void)save:(UIButton *)button{
    button.enabled = NO;
    if (resumeOpenLevelIndex.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择简历开放程度" viewController:self];
        button.enabled = YES;
        return;
    }
    if (districtindex.length == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择你的位置" viewController:self];
         button.enabled = YES;
        return;
    }
    if ([districtindex isEqualToString:@"999999"] ||[districtindex isEqualToString:@"000000"]) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择你的位置" viewController:self];
        button.enabled = YES;
        return;
    }
    if (businessPlaceIndex == 0) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择您是否有经营场所" viewController:self];
         button.enabled = YES;
        return;
    }
    
    NSDictionary *dic = @{
                          @"resume_id":resume_id,
                          @"resume_open_level":resumeOpenLevelIndex,
                          @"_resume_tel":phoneindex,
                          @"resume_area":districtindex,
                          @"resume_is_place":businessPlaceIndex
                          };
//    NSLog(@"dic----->%@",dic);
    [[RequestManager shareRequestManager] saveBusinessResume:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"saveBusinessResume----->%@",result);
        if (IsSucess(result) == 1) {
            int returnFLag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            if (returnFLag == 1) {
                
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
         button.enabled = YES;
    } failuer:^(NSError *error) {
         button.enabled = YES;
    }];
}


-(void)returnListPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 111111) {
//        NSLog(@"%ld",self.resumeMutableArray.count);
        return self.resumeMutableArray.count;
    }else{
        return self.placesMutableArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeTableItem *item ;
    if (tableView.tag == 111111) {
        item = self.resumeMutableArray[indexPath.row];
        Class cls = [self cellClassAtIndexPath:item];
        return [cls tableView:tableView rowHeightForObject:self.resumeMutableArray[indexPath.row]];
    }else{
        if (self.placesMutableArray.count > 0) {
            item = self.placesMutableArray[indexPath.row];
            Class cls = [self cellClassAtIndexPath:item];
            return [cls tableView:tableView rowHeightForObject:self.placesMutableArray[indexPath.row]];
        }else{
            return 0 ;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeTableItem *item ;
    if (tableView.tag == 111111) {
        item = self.resumeMutableArray[indexPath.row];
        CDZBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
        if (!cell) {
            Class cls = [self cellClassAtIndexPath:item];
            cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
        }
        cell.backgroundColor = BGColorGray;
        [cell setResumeTableItem:self.resumeMutableArray[indexPath.row]];
        ResumeTableItem *itemtemp = self.resumeMutableArray[indexPath.row];
        if ([item.name isEqualToString:@"联系方式（可选）"]) {
            [((TextWthInputFieldCell *)cell).phoneTextField setText:itemtemp.functionValue];
            [((TextWthInputFieldCell *)cell).phoneTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        }
        return cell;
    }else{
        if (self.placesMutableArray.count > 0) {
            item = self.placesMutableArray[indexPath.row];
        }
        
        CDZBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
        if (!cell) {
            Class cls = [self cellClassAtIndexPath:item];
            cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self cellClassAtIndexPath:item])];
        }
        cell.backgroundColor = BGColorGray;
        [cell setResumeTableItem:item];
        return cell;
    }
}

- (void)textFieldWithText:(UITextField *)textField{
    NSString * temp = textField.text;
    if (textField.markedTextRange ==nil){
        while(1){
            if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 11) {
                break;
            }else{
                temp = [temp substringToIndex:temp.length-1];
            }
        }
       phoneindex = textField.text=temp;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResumeTableItem *item = self.resumeMutableArray[indexPath.row];
    selectindexPath = indexPath;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (tableView.tag == 111111) {
        if (indexPath.row == 0) {
            PersonalViewController *vc = [[PersonalViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([item.name isEqualToString:@"开放程度"]) {
            NSMutableArray *opnnessList = [NSMutableArray new];
            for (NSDictionary *temp in self.opennessMutableArray) {
                [opnnessList addObject:[temp objectForKey:@"name"]];
            }
            [[MOFSPickerManager shareManger] showPickerViewWithDataArray:opnnessList tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
                CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((TextWithMarginCell *)cell).ValueLabel setText:string];
                for (NSDictionary *temp in self.opennessMutableArray) {
                    if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                        resumeOpenLevelIndex = [temp objectForKey:@"code"] ;
                        break;
                    }
                }
            } cancelBlock:^{
                
            }];
        }
        if ([item.name isEqualToString:@"您的位置"]) {
            [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *addressStr, NSString *zipcode) {
                NSString *address;
                NSArray *addresstemparray  = [addressStr componentsSeparatedByString:@"-"];
                //        NSLog(@"addresstemparray----%@",addresstemparray);
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
                
                //        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
                
                CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((TextWithMarginCell *)cell).ValueLabel setText:address];
                NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
                
                districtindex =temparray[temparray.count-1];
                
            } cancelBlock:^{
                
            }];
        }
        if ([item.name isEqualToString:@"生意意向"]) {
            EditBusinessIntentViewController * vc = [[EditBusinessIntentViewController alloc] init];
            vc.resumeId = resume_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([item.name isEqualToString:@"生意经验"]) {
            EditBusinessExpViewController *vc = [[EditBusinessExpViewController alloc] init];
            vc.resumeId = resume_id;
            vc.resumeIsExperience = businessExperienceIndex;
            vc.BusinessExperienceDic = businessExperienceDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([item.name isEqualToString:@"店铺信息(选填)"]) {
            NSMutableArray *placeList = [NSMutableArray new];
            for (NSDictionary *temp in self.placeOfBusinessMutableArray) {
                [placeList addObject:[temp objectForKey:@"name"]];
            }
            [[MOFSPickerManager shareManger] showPickerViewWithDataArray:placeList tag:0 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
                
                if ([string isEqualToString:@"无经营场所"]) {
                    businessPlaceIndex = [NSString stringWithFormat:@"%@",@"1"];
                    item.isShowLineImageFlag = YES;
                    NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
                    if (self.placesMutableArray.count > 0) {
                        for(NSInteger index = 0;index<self.placesMutableArray.count;index++){
                            if (index>indexPath.row) {
                                [indexSets addIndex:index];
                            }
                        }
                        NSMutableArray<NSIndexPath *> *deleteArray = [[NSMutableArray alloc] init];
                        for(NSInteger index = 0;index<self.resumeMutableArray.count;index++){
                            if (index>indexPath.row) {
                                [deleteArray addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                            }
                        }
                        if (deleteArray.count>0) {
                            [self.resumeMutableArray removeObjectsAtIndexes:indexSets];
                            [self.Tableview deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
                        }
                    }
                    [self.Tableview.tableFooterView setHidden:YES];
                    self.Tableview.tableFooterView = nil;
                    [self.Tableview.tableFooterView removeFromSuperview];
                    self.Tableview.sectionFooterHeight = 0;
                }else{
                    businessPlaceIndex = [NSString stringWithFormat:@"%@",@"2"];
                    item.isShowLineImageFlag = NO;
                    [self.Tableview setTableFooterView:self.resumeFooterView];
                    [self.Tableview.tableFooterView setHidden:NO];
                    self.Tableview.sectionFooterHeight = 50*AUTO_SIZE_SCALE_X;
                    //
                    //                [self.resumeMutableArray insertObject:itemE atIndex:indexPath.row+1];
                    //
                    //                [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                }
                
                //            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                CDZBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((TextWithLineCell *)cell).ValueLabel setText:string];
                for (NSDictionary *temp in self.opennessMutableArray) {
                    if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                        resumeOpenLevelIndex = [temp objectForKey:@"code"] ;
                        break;
                    }
                }
            } cancelBlock:^{
            }];
        }
    }else{
        ResumeTableItem *item123 = self.placesMutableArray[indexPath.row];
        AddBusinessPlaceViewController *vc = [[AddBusinessPlaceViewController alloc] init];
        vc.resumeId = resume_id;
        vc.placeId = item123.placeId;
        vc.title = @"编辑经营场所";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (Class)cellClassAtIndexPath:(ResumeTableItem *)nowItem{
    //    ResumeTableItem *item = self.resumeMutableArray[indexPath.row];
    switch (nowItem.showtype) {
        case ResumSelectText:{
            return [TextWithLineCell class];
        }
        case ResumInput:{
            return [TextWthInputFieldCell class];
        }
        case ResumSelectWithMargin:{
            return [TextWithMarginCell class];
        }
        case ResumSelectPlace:{
            return [TextPlaceCell class];
        }
        case ResumePersonalInfo:{
            return [ResumePersonalInfoCell class];
        }
        case TextViewInput:{
            return [DetailTextViewTableViewCell class];
        }
        case ProjectPicUpload:{
            return [CreateProjectHeaderView class];
        }
        case TextFieldText:{
            return [TextFieldBaseCell class];
        }
        case LabelText:{
            return [LabelTableViewCell class];
        }
        default:{
            break;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initNavgation{
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBrowerView)];
    rightBackItem.tintColor = UIColorFromRGB(0x1A1A1A);
    self.navigationItem.rightBarButtonItems = @[rightBackItem,rightnegSpaceItem];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*AUTO_SIZE_SCALE_X],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)initSubViews{
    [self.view addSubview:self.Tableview];
    [self.view addSubview:self.bottonButtonView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:kResumePage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kResumePage];
}

- (BOOL)shouldShowGobackButton{
    return  YES;
}

- (BOOL)shouldHideBottomBarWhenPushed{
    return  YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(BaseTableView *)Tableview{
    if (_Tableview == nil) {
        _Tableview = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight-60*AUTO_SIZE_SCALE_X) style:UITableViewStylePlain];
        self.Tableview.delegate = self;
        self.Tableview.dataSource = self;
        self.Tableview.bounces = NO;
        self.Tableview.tag = 000000;
        self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.Tableview.showsVerticalScrollIndicator = NO;
        self.Tableview.backgroundColor = BGColorGray;
        [self.Tableview registerClass:[TextPlaceCell class] forCellReuseIdentifier:NSStringFromClass([TextPlaceCell class])];
        [self.Tableview setTableHeaderView:self.HeaderTableView];
    }
    return _Tableview;
}

-(BaseTableView *)HeaderTableView{
    if (_HeaderTableView == nil) {
        _HeaderTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (50*6+30+95)*AUTO_SIZE_SCALE_X) style:UITableViewStylePlain];
        _HeaderTableView.scrollEnabled = NO;
        _HeaderTableView.delegate = self;
        _HeaderTableView.dataSource = self;
        _HeaderTableView.tag = 111111;
        _HeaderTableView.bounces = NO;
        _HeaderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _HeaderTableView.showsVerticalScrollIndicator = NO;
        _HeaderTableView.backgroundColor = BGColorGray;
        [self.HeaderTableView registerClass:[ResumePersonalInfoCell class] forCellReuseIdentifier:NSStringFromClass([ResumePersonalInfoCell class])];
        [self.HeaderTableView registerClass:[TextWithMarginCell class] forCellReuseIdentifier:NSStringFromClass([TextWithMarginCell class])];
        [self.HeaderTableView registerClass:[TextWthInputFieldCell class] forCellReuseIdentifier:NSStringFromClass([TextWthInputFieldCell class])];
    }
    return _HeaderTableView;
}

-(BottomButtonView *)bottonButtonView{
    if (_bottonButtonView == nil) {
        _bottonButtonView = [[BottomButtonView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60*AUTO_SIZE_SCALE_X, kScreenWidth, 60*AUTO_SIZE_SCALE_X) target:self action:@selector(savePost:) Title:@"保存"];
        [_bottonButtonView.bottomPostButton addTarget:self action:@selector(savePost:) forControlEvents:UIControlEventTouchUpInside];
        [_bottonButtonView.bottomPostButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    return _bottonButtonView;
}

-(ResumeFooterVIew *)resumeFooterView{
    if (_resumeFooterView == nil ) {
        _resumeFooterView = [[ResumeFooterVIew alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60*AUTO_SIZE_SCALE_X)];
        
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AddPlaceTaped:)];
        [_resumeFooterView addGestureRecognizer:tap1];
    }
    return _resumeFooterView;
}

-(NSMutableArray *)placeOfBusinessMutableArray{
    if (_placeOfBusinessMutableArray == nil) {
        _placeOfBusinessMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"1",
                                                  @"name":@"无经营场所"
                                                  }];
        [_placeOfBusinessMutableArray addObject:@{
                                                  @"code":@"2",
                                                  @"name":@"有经营场所"
                                                  }];
    }
    return _placeOfBusinessMutableArray;
}

-(NSMutableArray *)opennessMutableArray{
    if (_opennessMutableArray == nil) {
        _opennessMutableArray = [NSMutableArray arrayWithCapacity:0];
        
        [_opennessMutableArray addObject:@{
                                           @"code":@"2",
                                           @"name":@"对意向行业的项目开放"
                                           }];
        [_opennessMutableArray addObject:@{
                                           @"code":@"1",
                                           @"name":@"对所有项目开放"
                                           }];
        [_opennessMutableArray addObject:@{
                                           @"code":@"3",
                                           @"name":@"不开放"
                                           }];
    }
    return _opennessMutableArray;
}

-(NSMutableArray *)resumeMutableArray{
    if (_resumeMutableArray == nil) {
        _resumeMutableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _resumeMutableArray;
}

-(NSMutableArray *)placesMutableArray{
    if (_placesMutableArray == nil) {
        _placesMutableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _placesMutableArray;
}
@end
