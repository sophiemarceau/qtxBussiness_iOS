//
//  AddBusinessPlaceViewController.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/29.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "AddBusinessPlaceViewController.h"
#import "CDZTableViewCell.h"
#import "CDZCollectionViewCell.h"
#import "CDZCollectionViewItem.h"
#import "BaseTableView.h"
#import "EditBusinessExperienceCell.h"
#import "EditBusinessExperienceCell+EditBusinessModel.h"
#import "UploadPictureDesCell.h"
#import "DistrictManager.h"
#import "UITextView+ZWPlaceHolder.h"
#import "MOFSPickerManager.h"
#import "SaveDeleteView.h"
@interface AddBusinessPlaceViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,CDZTableViewCellDelegate>{
    CGFloat  tableviewHeight;
    NSString  *placeName;
    NSString  *districtindex;
    NSString  *placeAddress;
    NSString  *placeKind;
    NSString  *palceProportion;
    NSString  *tradeStr;
    NSString  *PlaceStaffNum;
    NSString  *PlaceCrowd;
    NSString  *PlacePics;
    NSArray   *PlacePicsArray;
    NSString  *PlaceNote;
    NSString  *place_industry_str,*place_kind_str;

}
@property (nonatomic,strong)BaseTableView *baseTableView;
@property (nonatomic,strong)BaseTableView *HeaderTableView;
@property (nonatomic,strong)UIView *FooterTableView;
@property (nonatomic,strong)UILabel *remarksLabel;
@property (nonatomic,strong)UIView *remarksbgView;
@property (nonatomic,strong)UITextView *remarksTextView;
@property (nonatomic,strong)NSMutableArray *baseMutableArray;
@property (nonatomic,strong)NSMutableArray *tradeMutableArray;
@property (nonatomic,strong)NSMutableArray *placeMutableArray;
@property (nonatomic,strong)NSMutableArray *placeSizeMutableArray;
@property (nonatomic,strong)NSMutableArray *employeeNumbersMutableArray;
@property (nonatomic,strong)NSMutableArray *peopleTypeMutableArray;


@property (nonatomic,strong)SaveDeleteView *saveOrDeleteView;
@end

@implementation AddBusinessPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableviewHeight = 100;
    placeName=districtindex=placeAddress=placeKind=palceProportion=tradeStr=PlaceStaffNum=PlaceCrowd=PlacePics=PlaceNote =@"";
    [self initNavgation];
    if ([self.title isEqualToString:@"编辑经营场所"]) {
        [self loadData];
    }else{
        [self initSubViews];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)loadData{
    [self.baseMutableArray removeAllObjects];
    NSDictionary *dic = @{@"place_id" :self.placeId};
//    NSLog(@"dic----->%@",dic);
    [[RequestManager shareRequestManager] getBusinessResumePlace:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"result--getBusinessResumePlace--->%@",result);
        if (IsSucess(result) == 1) {
            [self initSubViews];
            NSDictionary *dtoDictionary = [[result objectForKey:@"data"] objectForKey:@"dto"];
            if(![dtoDictionary isEqual:[NSNull null]] && dtoDictionary !=nil){
                EditBusinessModel *editBusinessModel1  = [EditBusinessModel new];
                editBusinessModel1.functionnameStr = @"场所名称";
                editBusinessModel1.placenameStr = @"请填写场所名称";
                editBusinessModel1.isEditTextField = YES;
                EditBusinessModel *editBusinessModel2  = [EditBusinessModel new];
                editBusinessModel2.functionnameStr = @"所在地区";
                editBusinessModel2.placenameStr = @"请选择场所所在地区";
                
                EditBusinessModel *editBusinessModel3  = [EditBusinessModel new];
                editBusinessModel3.functionnameStr = @"详细地址";
                editBusinessModel3.placenameStr = @"请填写场所详细地址";
                editBusinessModel3.isEditTextField = YES;
                EditBusinessModel *editBusinessModel4  = [EditBusinessModel new];
                editBusinessModel4.functionnameStr = @"场所类型";
                editBusinessModel4.placenameStr = @"请选择场所类型";
                
                EditBusinessModel *editBusinessModel5  = [EditBusinessModel new];
                editBusinessModel5.functionnameStr = @"场所面积";
                editBusinessModel5.placenameStr = @"请选择场所面积";
                
                EditBusinessModel *editBusinessModel6  = [EditBusinessModel new];
                editBusinessModel6.functionnameStr = @"当前从事行业";
                editBusinessModel6.placenameStr = @"请选择该场所当前从事行业";
                
                EditBusinessModel *editBusinessModel7  = [EditBusinessModel new];
                editBusinessModel7.functionnameStr = @"员工人数（选填）";
                editBusinessModel7.placenameStr = @"请选择员工人数";
                
                EditBusinessModel *editBusinessModel8 = [EditBusinessModel new];
                editBusinessModel8.functionnameStr = @"面向人群（选填）";
                editBusinessModel8.placenameStr = @"请选择面向人群";
                
                EditBusinessModel *editBusinessModel9 = [EditBusinessModel new];
                editBusinessModel9.functionnameStr = @"店铺照片(选填，最多上传6张）";
                editBusinessModel9.placenameStr = @"查看示例";

                editBusinessModel1.contentStr = dtoDictionary[@"place_name"];
                placeName = dtoDictionary[@"place_name"];
                
                districtindex = [NSString stringWithFormat:@"%@",dtoDictionary[@"place_area"]];
                editBusinessModel2.contentStr = dtoDictionary[@"place_area_str"];
                
                placeAddress = dtoDictionary[@"place_address"];
                editBusinessModel3.contentStr = dtoDictionary[@"place_address"];
                
                
                for (NSDictionary *temp in self.placeMutableArray) {
                    if ( [[temp objectForKey:@"code"] isEqualToString:[NSString stringWithFormat:@"%@",dtoDictionary[@"place_kind"]]]) {
                        placeKind = [temp objectForKey:@"code"] ;
                        editBusinessModel4.contentStr = [temp objectForKey:@"name"] ;
                        place_kind_str = [temp objectForKey:@"name"];
                        
                        break;
                    }
                }
                for (NSDictionary *temp in self.placeSizeMutableArray) {
                    if ( [[temp objectForKey:@"code"] isEqualToString:[NSString stringWithFormat:@"%@",dtoDictionary[@"place_proportion"]]]) {
                        palceProportion = [temp objectForKey:@"code"] ;
                        editBusinessModel5.contentStr = [temp objectForKey:@"name"] ;
                        break;
                    }
                }
                
                for (NSDictionary *temp in self.tradeMutableArray) {
                    if ( [[temp objectForKey:@"code"] isEqualToString:[NSString stringWithFormat:@"%@",dtoDictionary[@"place_industry"]]]) {
                        tradeStr = [temp objectForKey:@"code"] ;
                        editBusinessModel6.contentStr = [temp objectForKey:@"name"] ;
                        place_industry_str = [temp objectForKey:@"name"] ;
                        break;
                    }
                }
                
                for (NSDictionary *temp in self.employeeNumbersMutableArray) {
                    if ( [[temp objectForKey:@"code"] isEqualToString:[NSString stringWithFormat:@"%@",dtoDictionary[@"place_staff_num"]]]) {
                        PlaceStaffNum = [temp objectForKey:@"code"] ;
                        editBusinessModel7.contentStr = [temp objectForKey:@"name"] ;
                        break;
                    }
                }
                
                for (NSDictionary *temp in self.peopleTypeMutableArray) {
                    if ( [[temp objectForKey:@"code"] isEqualToString:[NSString stringWithFormat:@"%@",dtoDictionary[@"place_crowd"]]]) {
                        PlaceStaffNum = [temp objectForKey:@"code"] ;
                        editBusinessModel8.contentStr = [temp objectForKey:@"name"] ;
                        break;
                    }
                }
                
                PlacePics = dtoDictionary[@"place_pics"];
                if (PlacePics.length>0) {
                        PlacePicsArray = [PlacePics componentsSeparatedByString:@","];
                }
                

                PlaceNote = dtoDictionary[@"place_note"];
                self.remarksTextView.text = PlaceNote;
                [self.remarksTextView updatePlaceHolder];

                [_baseMutableArray addObject:editBusinessModel1];
                [_baseMutableArray addObject:editBusinessModel2];
                [_baseMutableArray addObject:editBusinessModel3];
                [_baseMutableArray addObject:editBusinessModel4];
                [_baseMutableArray addObject:editBusinessModel5];
                [_baseMutableArray addObject:editBusinessModel6];
                [_baseMutableArray addObject:editBusinessModel7];
                [_baseMutableArray addObject:editBusinessModel8];
                [_baseMutableArray addObject:editBusinessModel9];
                [self.HeaderTableView reloadData];
                [self.baseTableView reloadData];
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
    if ([self.title isEqualToString:@"编辑经营场所"]) {
        return;
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;//遵守
    UIBarButtonItem *rightnegSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightnegSpaceItem.width = 5;
    UIBarButtonItem *rightBackItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
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
    PlaceNote =self.remarksTextView.text;
    if (placeName.length > 15 ) {
        [[RequestManager shareRequestManager] tipAlert:@"场所名称15字以内" viewController:self];
        return;
    }
    if (placeAddress.length > 30 ) {
        [[RequestManager shareRequestManager] tipAlert:@"详细地址不能超过30个字" viewController:self];
        return;
    }
    if (placeName.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写场所名称" viewController:self];
        return;
    }
    if (districtindex.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择场所所在地区" viewController:self];
        return;
    }
    if (placeAddress.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请填写场所详细地址" viewController:self];
        return;
    }
    if (placeKind.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择场所类型" viewController:self];
        return;
    }
    if (palceProportion.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择场所面积" viewController:self];
        return;
    }

    if (tradeStr.length == 0 ) {
        [[RequestManager shareRequestManager] tipAlert:@"请选择该场所当前主营行业" viewController:self];
        return;
    }
//    NSLog(@"dic----->%@",self.resumeId);
//    NSLog(@"dic----->%@",placeName);
//    NSLog(@"dic----->%@",districtindex);
//    NSLog(@"dic----->%@",placeAddress);
//    NSLog(@"dic----->%@",placeKind);
//    NSLog(@"dic----->%@",palceProportion);
//    NSLog(@"dic----->%@",tradeStr);
//    NSLog(@"dic----->%@",PlaceStaffNum);
//    NSLog(@"dic----->%@",PlaceCrowd);
//    NSLog(@"dic----->%@",PlacePics);
//    NSLog(@"dic----->%@",PlaceNote);
    NSDictionary *dic = @{
                          @"resume_id":self.resumeId,
                          @"place_name":placeName,
                          @"place_area":districtindex,
                          @"place_address":placeAddress,
                          @"place_kind":placeKind,
                          @"place_proportion":palceProportion,
                          @"place_industry":tradeStr,
                          @"_place_staff_num":PlaceStaffNum,
                          @"_place_crowd":PlaceCrowd,
                          @"_place_pics":PlacePics,
                          @"_place_note": PlaceNote
                          };
//    NSLog(@"dic--addBusinessResumePlace--->%@",dic);
    [[RequestManager shareRequestManager] addBusinessResumePlace:dic viewController:self successData:^(NSDictionary *result) {
//        NSLog(@"addResumeExperience----->%@",result);
        if (IsSucess(result) == 1) {
            int placeId = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
            
//            NSLog(@"placeid------>%d",placeId);
            NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                              dic];
            NSDictionary *dic123 = @{
                                 @"place_id":[[result objectForKey:@"data"] objectForKey:@"result"],
                                 @"place_kind_str":place_kind_str,
                                 @"place_industry_str":place_industry_str
                                 };
            
            if (dic123 != nil) {
                [beforeDic addEntriesFromDictionary:dic123];
            }
            
            [[RequestManager shareRequestManager] tipAlert:@"保存成功" viewController:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_Add_ResumePlace object:nil userInfo:beforeDic];
            [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
            
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
    self.saveOrDeleteView.saveButton.enabled = YES;
    self.saveOrDeleteView.deleteButton.enabled = YES;
}

-(void)OnClick:(UIButton *)sender
{
    self.saveOrDeleteView.saveButton.enabled = NO;
    self.saveOrDeleteView.deleteButton.enabled = NO;
    
    if (sender.tag == 1 ) {
        sender.enabled = NO;
        PlaceNote =self.remarksTextView.text;
        if (placeName.length > 15 ) {
            [[RequestManager shareRequestManager] tipAlert:@"场所名称15字以内" viewController:self];
            return;
        }
        if (placeAddress.length > 30 ) {
            [[RequestManager shareRequestManager] tipAlert:@"详细地址不能超过30个字" viewController:self];
            return;
        }
        if (placeName.length == 0 ) {
            [[RequestManager shareRequestManager] tipAlert:@"请填写场所名称" viewController:self];
            return;
        }
        if (districtindex.length == 0 ) {
            [[RequestManager shareRequestManager] tipAlert:@"请选择场所所在地区" viewController:self];
            return;
        }
        if (placeAddress.length == 0 ) {
            [[RequestManager shareRequestManager] tipAlert:@"请填写场所详细地址" viewController:self];
            return;
        }
        if (placeKind.length == 0 ) {
            [[RequestManager shareRequestManager] tipAlert:@"请选择场所类型" viewController:self];
            return;
        }
        if (palceProportion.length == 0 ) {
            [[RequestManager shareRequestManager] tipAlert:@"请选择场所面积" viewController:self];
            return;
        }
        if (tradeStr.length == 0 ) {
            [[RequestManager shareRequestManager] tipAlert:@"请选择该场所当前主营行业" viewController:self];
            return;
        }
        
        
//        NSLog(@"dic----->%@",placeName);
//        NSLog(@"dic----->%@",districtindex);
//        NSLog(@"dic----->%@",placeAddress);
//        NSLog(@"dic----->%@",placeKind);
//        NSLog(@"dic----->%@",palceProportion);
//        NSLog(@"dic----->%@",tradeStr);
//        NSLog(@"dic----->%@",PlaceStaffNum);
//        NSLog(@"dic----->%@",PlaceCrowd);
//        NSLog(@"dic----->%@",PlacePics);
//        NSLog(@"dic----->%@",PlaceNote);
        NSDictionary *dic = @{
                              @"place_id":self.placeId,
                              @"place_name":placeName,
                              @"place_area":districtindex,
                              @"place_address":placeAddress,
                              @"place_kind":placeKind,
                              @"place_proportion":palceProportion,
                              @"place_industry":tradeStr,
                              @"_place_staff_num":PlaceStaffNum,
                              @"_place_crowd":PlaceCrowd,
                              @"_place_pics":PlacePics,
                              @"_place_note": PlaceNote
                              };
//        NSLog(@"dic--updateBusinessResumePlace--->%@",dic);
        [[RequestManager shareRequestManager]updateBusinessResumePlace:dic viewController:self successData:^(NSDictionary *result) {
//             NSLog(@"result--updateBusinessResumePlace--->%@",result);
            if (IsSucess(result) == 1) {
                int returnFLag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
                if (returnFLag == 1) {
                    
                    
                    NSMutableDictionary *beforeDic = [[NSMutableDictionary alloc] initWithDictionary:
                                                      dic];
                    NSDictionary *dic1 = @{
                                          @"place_id":self.placeId,
                                          @"place_kind_str":place_kind_str,
                                          @"place_industry_str":place_industry_str
                                          };
                    
                    if (dic1 != nil) {
                        [beforeDic addEntriesFromDictionary:dic1];
                    }
                    [[RequestManager shareRequestManager] tipAlert:@"修改成功" viewController:self];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_Update_ResumePlace object:nil userInfo:beforeDic];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                }
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            self.saveOrDeleteView.saveButton.enabled = YES;
            self.saveOrDeleteView.deleteButton.enabled = YES;
        } failuer:^(NSError *error) {
            sender.enabled = YES;
        }];
    }else{
        NSDictionary *dic = @{@"place_id":self.placeId};
        [[RequestManager shareRequestManager]deleteBusinessResumePlace:dic viewController:self successData:^(NSDictionary *result) {
//            NSLog(@"result--deleteBusinessResumePlace--->%@",result);
            if (IsSucess(result) == 1) {
                int returnFLag = [[[result objectForKey:@"data"] objectForKey:@"result"] intValue];
                if (returnFLag == 1) {
                    [[RequestManager shareRequestManager] tipAlert:@"删除成功" viewController:self];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_Remove_ResumePlace object:nil userInfo:dic];
                    [self performSelector:@selector(returnListPage) withObject:self afterDelay:2.0];
                }
            }else{
                if (IsSucess(result) == -1) {
                    [[RequestManager shareRequestManager] loginCancel:result];
                }else{
                    [[RequestManager shareRequestManager] resultFail:result viewController:self];
                }
            }
            self.saveOrDeleteView.saveButton.enabled = YES;
            self.saveOrDeleteView.deleteButton.enabled = YES;
        } failuer:^(NSError *error) {
            self.saveOrDeleteView.saveButton.enabled = YES;
            self.saveOrDeleteView.deleteButton.enabled = YES;
        }];
    }
    
}


- (void)initSubViews{
    [self.view addSubview:self.baseTableView];
    if ([self.title isEqualToString:@"编辑经营场所"]) {
        [self.view addSubview:self.saveOrDeleteView];
        self.saveOrDeleteView.frame = CGRectMake(0, (150+44+20)*AUTO_SIZE_SCALE_X , kScreenWidth, 143*AUTO_SIZE_SCALE_X);
        [self.FooterTableView addSubview:self.saveOrDeleteView];
        self.FooterTableView.frame = CGRectMake(0, 0, kScreenWidth, (150+44+20)*AUTO_SIZE_SCALE_X+ self.saveOrDeleteView.frame.size.height);
       [self.baseTableView setTableFooterView:self.FooterTableView];
    }else{
        [self.baseTableView setTableFooterView:self.FooterTableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100001) {
        return 1;
    }else{
        return 9;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100001) {
        return tableviewHeight;
    }else{
        if (indexPath.row<8) {
            return  50*AUTO_SIZE_SCALE_X;
        }else{
            return 40*AUTO_SIZE_SCALE_X;
        }
    }
}

-(void)didSelectPhtot{}

- (void)didChangeCell:(UITableViewCell *)cell pushHeight:(CGFloat)height returnPictureArray:(NSArray *)picArrays{
    PlacePics = [picArrays componentsJoinedByString:@","];
//    NSLog(@"placePice-------------->%@",PlacePics);
    tableviewHeight = height;
    [self.baseTableView reloadData];
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:cell];
    [self.baseTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (tableView.tag == 100001) {
        NSString *identifer = @"CDZTableViewCell";
        //    [NSString stringWithFormat:@"CDZTableViewCell%ld",indexPath.row];//唯一标识，相当于不复用
        CDZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell  = [CDZTableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.myselfController = self;
            [cell setPicsArray:PlacePicsArray];
        }
        
        return cell;
    }else{
        if (indexPath.row<8) {
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
            if (indexPath.row ==0 ||indexPath.row ==2) {
                [((EditBusinessExperienceCell *)cell).contentTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
                ((EditBusinessExperienceCell *)cell).contentTextField.tag = indexPath.row;
            }
            return  cell;
        }else{
            static NSString *identify = @"UploadPictureDesCell";
            UploadPictureDesCell *cell = (UploadPictureDesCell *)[tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil) {
                cell = [[UploadPictureDesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                //取消cell的选中状态
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            return  cell;
        }
    }
}

- (void)textFieldWithText:(UITextField *)textField{
    if (textField.tag == 0) {
        placeName =textField.text;
    }
    if (textField.tag == 2) {
        placeAddress = textField.text;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (tableView.tag == 100002) {
        EditBusinessModel *item = self.baseMutableArray[indexPath.row];
        
        if ([item.functionnameStr isEqualToString:@"场所名称"]) {}
        
        if ([item.functionnameStr isEqualToString:@"所在地区"]) {
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
                
                EditBusinessExperienceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((EditBusinessExperienceCell *)cell).contentTextField setText:address];
                NSArray *temparray  = [zipcode componentsSeparatedByString:@"-"];
                
                districtindex =temparray[temparray.count-1];
                
            } cancelBlock:^{
                
            }];

        }
        
        if ([item.functionnameStr isEqualToString:@"场所类型"]) {
            NSMutableArray *opnnessList = [NSMutableArray new];
            for (NSDictionary *temp in self.placeMutableArray) {
                [opnnessList addObject:[temp objectForKey:@"name"]];
            }
            [[MOFSPickerManager shareManger] showPickerViewWithDataArray:opnnessList tag:40000001 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
                BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
                for (NSDictionary *temp in self.placeMutableArray) {
                    if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                        placeKind = [temp objectForKey:@"code"];
                        place_kind_str = [temp objectForKey:@"name"];

                        break;
                    }
                }
            } cancelBlock:^{}];
        }
        
        if ([item.functionnameStr isEqualToString:@"场所面积"]) {
            NSMutableArray *opnnessList = [NSMutableArray new];
            for (NSDictionary *temp in self.placeSizeMutableArray) {
                [opnnessList addObject:[temp objectForKey:@"name"]];
            }
            [[MOFSPickerManager shareManger] showPickerViewWithDataArray:opnnessList tag:40000002 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
                BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
                for (NSDictionary *temp in self.placeSizeMutableArray) {
                    if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                        palceProportion = [temp objectForKey:@"code"];
                        break;
                    }
                }
            } cancelBlock:^{}];
        }
        if ([item.functionnameStr isEqualToString:@"当前从事行业"]) {
            NSMutableArray *tradList = [NSMutableArray new];
            for (NSDictionary *temp in self.tradeMutableArray) {
                [tradList addObject:[temp objectForKey:@"name"]];
            }
            [[MOFSPickerManager shareManger] showPickerViewWithDataArray:tradList tag:40000003 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
                BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
                for (NSDictionary *temp in self.tradeMutableArray) {
                    if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                        tradeStr = [temp objectForKey:@"code"] ;
                        place_industry_str = [temp objectForKey:@"name"] ;
                        break;
                    }
                }
            } cancelBlock:^{
                
            }];
        }
        if ([item.functionnameStr isEqualToString:@"员工人数（选填）"]) {
            NSMutableArray *opnnessList = [NSMutableArray new];
            for (NSDictionary *temp in self.employeeNumbersMutableArray) {
                [opnnessList addObject:[temp objectForKey:@"name"]];
            }
            [[MOFSPickerManager shareManger] showPickerViewWithDataArray:opnnessList tag:40000004 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
                BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
                for (NSDictionary *temp in self.employeeNumbersMutableArray) {
                    if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                        PlaceStaffNum = [temp objectForKey:@"code"] ;
                        break;
                    }
                }
            } cancelBlock:^{}];
        }
        if ([item.functionnameStr isEqualToString:@"面向人群（选填）"]) {
            NSMutableArray *opnnessList = [NSMutableArray new];
            for (NSDictionary *temp in self.peopleTypeMutableArray) {
                [opnnessList addObject:[temp objectForKey:@"name"]];
            }
            [[MOFSPickerManager shareManger] showPickerViewWithDataArray:opnnessList tag:40000005 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
                BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [((EditBusinessExperienceCell *)cell).contentTextField setText:string];
                for (NSDictionary *temp in self.peopleTypeMutableArray) {
                    if ( [[temp objectForKey:@"name"] isEqualToString:string]) {
                        PlaceCrowd = [temp objectForKey:@"code"] ;
                        break;
                    }
                }
            } cancelBlock:^{}];
        }
        
        if ([item.functionnameStr isEqualToString:@"店铺照片(选填，最多上传6张）"]) {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.title = @"demo";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
//        AddBusinessPlaceViewController *vc = [[AddBusinessPlaceViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    
}

-(BaseTableView *)baseTableView{
    if (_baseTableView == nil ) {
        _baseTableView = [[BaseTableView alloc] initWithFrame:
                          CGRectMake(0, kNavHeight+10*AUTO_SIZE_SCALE_X, kScreenWidth, kScreenHeight - (kNavHeight+10*AUTO_SIZE_SCALE_X))];
        _baseTableView.dataSource = self;
        _baseTableView.backgroundColor = BGColorGray;
        _baseTableView.delegate = self;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _baseTableView.estimatedRowHeight  = (100)*AUTO_SIZE_SCALE_X;
         _baseTableView.tag = 100001;
        _baseTableView.bounces = NO;
        [_baseTableView setTableHeaderView:self.HeaderTableView];
        
//        _baseTableView.rowHeight = UITableViewAutomaticDimension;

//        [_baseTableView registerClass:[EditBusinessExperienceCell class] forCellReuseIdentifier:@"EditBusinessExperienceCell"];
//        [_baseTableView registerClass:[CDZTableViewCell class] forCellReuseIdentifier:@"CDZTableViewCell"];
//        [_baseTableView registerClass:[UploadPictureDesCell class] forCellReuseIdentifier:@"UploadPictureDesCell"];

    }
    return _baseTableView;
}


-(BaseTableView *)HeaderTableView{
    if (_HeaderTableView == nil ) {
        _HeaderTableView = [[BaseTableView alloc] initWithFrame:
                          CGRectMake(0,
                                     0,
                                     kScreenWidth,
                                    (440*AUTO_SIZE_SCALE_X))];
        _HeaderTableView.dataSource = self;
        _HeaderTableView.backgroundColor = [UIColor redColor];
        _HeaderTableView.delegate = self;
        _HeaderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _baseTableView.estimatedRowHeight  = (100)*AUTO_SIZE_SCALE_X;
        _HeaderTableView.tag = 100002;
        _HeaderTableView.bounces = NO;
        _HeaderTableView.scrollEnabled = NO;
        //        _baseTableView.rowHeight = UITableViewAutomaticDimension;
        
                [_HeaderTableView registerClass:[EditBusinessExperienceCell class] forCellReuseIdentifier:@"EditBusinessExperienceCell"];
        //        [_baseTableView registerClass:[CDZTableViewCell class] forCellReuseIdentifier:@"CDZTableViewCell"];
                [_HeaderTableView registerClass:[UploadPictureDesCell class] forCellReuseIdentifier:@"UploadPictureDesCell"];
        
    }
    return _HeaderTableView;
}

-(UIView *)FooterTableView{
    if (_FooterTableView == nil) {
        _FooterTableView = [UIView new];
        _FooterTableView.frame = CGRectMake(0, 0, kScreenWidth, (150+44+20)*AUTO_SIZE_SCALE_X);
        _FooterTableView.backgroundColor = BGColorGray;
        [_FooterTableView addSubview:self.remarksLabel];
        [_FooterTableView addSubview:self.remarksbgView];
    }
    return _FooterTableView;
}

-(NSMutableArray *)baseMutableArray{
    if (_baseMutableArray == nil) {
        _baseMutableArray = [NSMutableArray arrayWithCapacity:0];
        
        EditBusinessModel *editBusinessModel1  = [EditBusinessModel new];
        editBusinessModel1.functionnameStr = @"场所名称";
        editBusinessModel1.placenameStr = @"请填写场所名称";
        editBusinessModel1.isEditTextField = YES;
        EditBusinessModel *editBusinessModel2  = [EditBusinessModel new];
        editBusinessModel2.functionnameStr = @"所在地区";
        editBusinessModel2.placenameStr = @"请选择场所所在地区";
        
        EditBusinessModel *editBusinessModel3  = [EditBusinessModel new];
        editBusinessModel3.functionnameStr = @"详细地址";
        editBusinessModel3.placenameStr = @"请填写场所详细地址";
        editBusinessModel3.isEditTextField = YES;
        EditBusinessModel *editBusinessModel4  = [EditBusinessModel new];
        editBusinessModel4.functionnameStr = @"场所类型";
        editBusinessModel4.placenameStr = @"请选择场所类型";
        
        EditBusinessModel *editBusinessModel5  = [EditBusinessModel new];
        editBusinessModel5.functionnameStr = @"场所面积";
        editBusinessModel5.placenameStr = @"请选择场所面积";
        
        EditBusinessModel *editBusinessModel6  = [EditBusinessModel new];
        editBusinessModel6.functionnameStr = @"当前从事行业";
        editBusinessModel6.placenameStr = @"请选择该场所当前从事行业";
        
        EditBusinessModel *editBusinessModel7  = [EditBusinessModel new];
        editBusinessModel7.functionnameStr = @"员工人数（选填）";
        editBusinessModel7.placenameStr = @"请选择员工人数";
        
        EditBusinessModel *editBusinessModel8 = [EditBusinessModel new];
        editBusinessModel8.functionnameStr = @"面向人群（选填）";
        editBusinessModel8.placenameStr = @"请选择面向人群";
        
        EditBusinessModel *editBusinessModel9 = [EditBusinessModel new];
        editBusinessModel9.functionnameStr = @"店铺照片(选填，最多上传6张）";
        editBusinessModel9.placenameStr = @"查看示例";
        
        

        [_baseMutableArray addObject:editBusinessModel1];
        [_baseMutableArray addObject:editBusinessModel2];
        [_baseMutableArray addObject:editBusinessModel3];
        [_baseMutableArray addObject:editBusinessModel4];
        [_baseMutableArray addObject:editBusinessModel5];
        [_baseMutableArray addObject:editBusinessModel6];
        [_baseMutableArray addObject:editBusinessModel7];
        [_baseMutableArray addObject:editBusinessModel8];
        [_baseMutableArray addObject:editBusinessModel9];
        
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

-(NSMutableArray *)placeMutableArray{
    if (_placeMutableArray == nil) {
        _placeMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_placeMutableArray addObject:@{
                                             @"code":@"1",
                                             @"name":@"临街店铺"
                                             }];
        [_placeMutableArray addObject:@{
                                             @"code":@"2",
                                             @"name":@"写字楼"
                                             }];
        [_placeMutableArray addObject:@{
                                             @"code":@"3",
                                             @"name":@"商场店"
                                             }];
    }
    return _placeMutableArray;
}

-(NSMutableArray *)placeSizeMutableArray{
    if (_placeSizeMutableArray == nil) {
        _placeSizeMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_placeSizeMutableArray addObject:@{
                                             @"code":@"1",
                                             @"name":@"10㎡以内"
                                             }];
        [_placeSizeMutableArray addObject:@{
                                             @"code":@"2",
                                             @"name":@"10-29㎡"
                                             }];
        [_placeSizeMutableArray addObject:@{
                                             @"code":@"3",
                                             @"name":@"30-99㎡"
                                             }];
        [_placeSizeMutableArray addObject:@{
                                            @"code":@"3",
                                            @"name":@"100-199㎡"
                                            }];
        [_placeSizeMutableArray addObject:@{
                                            @"code":@"3",
                                            @"name":@"200㎡以上"
                                            }];
        
    }
    return _placeSizeMutableArray;
}

-(NSMutableArray *)employeeNumbersMutableArray{
    if (_employeeNumbersMutableArray == nil) {
        _employeeNumbersMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_employeeNumbersMutableArray addObject:@{
                                                @"code":@"1",
                                                @"name":@"5人以内"
                                                }];
        [_employeeNumbersMutableArray addObject:@{
                                                @"code":@"2",
                                                @"name":@"5-20人"
                                                }];
        [_employeeNumbersMutableArray addObject:@{
                                                @"code":@"3",
                                                @"name":@"20-50人"
                                                }];
        [_employeeNumbersMutableArray addObject:@{
                                                @"code":@"4",
                                                @"name":@"50人以上"
                                                }];
    }
    return _employeeNumbersMutableArray;
}

-(NSMutableArray *)peopleTypeMutableArray{
    if (_peopleTypeMutableArray == nil) {
        _peopleTypeMutableArray = [NSMutableArray arrayWithCapacity:0];
        [_peopleTypeMutableArray addObject:@{
                                             @"code":@"1",
                                             @"name":@"全部人群"
                                             }];
        [_peopleTypeMutableArray addObject:@{
                                             @"code":@"2",
                                             @"name":@"普通消费者"
                                             }];
        [_peopleTypeMutableArray addObject:@{
                                             @"code":@"3",
                                             @"name":@"企业用户"
                                             }];
    }
    return _peopleTypeMutableArray;
}

-(UILabel *)remarksLabel{
    if (_remarksLabel == nil) {
        _remarksLabel = [CommentMethod initLabelWithText:@"备注（选填）" textAlignment:NSTextAlignmentLeft font:14 TextColor:FontUIColorBlack];
        _remarksLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth - 30*AUTO_SIZE_SCALE_X, 44*AUTO_SIZE_SCALE_X);
    }
    return _remarksLabel;
}

- (UIView *)remarksbgView{
    if (_remarksbgView == nil) {
        _remarksbgView = [UIView new];
        _remarksbgView.backgroundColor = [UIColor whiteColor];
        _remarksbgView.frame = CGRectMake(0, 44*AUTO_SIZE_SCALE_X, kScreenWidth , 150*AUTO_SIZE_SCALE_X);
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

-(SaveDeleteView *)saveOrDeleteView{
    if (_saveOrDeleteView == nil) {
        _saveOrDeleteView = [SaveDeleteView new];
        [_saveOrDeleteView.saveButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_saveOrDeleteView.deleteButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveOrDeleteView;
}
@end
