//
//  CDZTableViewCell.m
//  CDZCollectionInTableViewDemo
//
//  Created by Nemocdz on 2017/1/21.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZTableViewCell.h"
#import "CDZCollectionViewCell.h"
#import "CDZCollectionViewItem.h"
#import "FileUploadHelper.h"


@interface CDZTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,CDZCollectionCellDelegate,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>{
    
    NSInteger selectRow;
    
    Boolean flag;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<CDZCollectionViewItem *>*itemsArray;
@property (strong, nonatomic) NSMutableArray<NSString *>*picArrays;
@end
@implementation CDZTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.picArrays = [NSMutableArray arrayWithCapacity:6];
    CDZCollectionViewItem *firstitem = [CDZCollectionViewItem new];
    firstitem.delBtnHidden = YES;
    _itemsArray = [NSMutableArray arrayWithObject:firstitem];
    
   // self.collectionViewFlowLayout.estimatedItemSize = CGSizeMake(125, 100);
   // self.collectionViewFlowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.with.bottom.with.left.with.right.mas_equalTo(self.contentView);
//        make.height.mas_equalTo(@100);
//    }];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, 100);
   
}


- (void)didDelete:(UICollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.itemsArray removeObjectAtIndex:indexPath.row];
    [self.picArrays removeObjectAtIndex:indexPath.row];
//    NSLog(@"%ld",indexPath.row);
    if (self.itemsArray.count == 5 && !flag) {
//        for (NSUInteger i = indexPath.row; i < self.itemsArray.count - 1; i ++) {
//        [self.itemsArray exchangeObjectAtIndex:i+1 withObjectAtIndex:i];
//        }
        flag = TRUE;
        CDZCollectionViewItem *itemtemp = [CDZCollectionViewItem new];
        itemtemp.delBtnHidden = YES;
//        [self.itemsArray insertObject:itemtemp atIndex:5];
        [self.itemsArray addObject:itemtemp];
    }

    [self reloadCell];
}

- (void)reloadCell{
    [self.collectionView reloadData];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, self.collectionView.collectionViewLayout.collectionViewContentSize.height);
    [self.delegate didChangeCell:self pushHeight:self.collectionView.collectionViewLayout.collectionViewContentSize.height returnPictureArray:self.picArrays];
    
//    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(self.collectionView.collectionViewLayout.collectionViewContentSize.height));
//    }];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //载入数据，如图片等
    selectRow = (NSInteger )indexPath.row;
    [self photoMethod];
//    [self.delegate didSelectPhtot];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CDZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.item = self.itemsArray[indexPath.row];

    return cell;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout.alloc init];
        layout.itemSize = CGSizeMake(125, 100);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"CDZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)setPicsArray:(NSArray *)picArray{
//    NSLog(@"picarray----->%@",picArray);
    if (picArray != nil) {
        if (picArray.count == 6) {
            flag = FALSE;
            [self.itemsArray removeAllObjects];
        }
        
        if (picArray.count > 0) {
            for (int i = 0; i < picArray.count; i++) {
                CDZCollectionViewItem *item = [CDZCollectionViewItem new];
                item.imageStr = picArray[i];
                if (picArray.count == 6) {
                    [self.itemsArray insertObject:item atIndex:i];
                }else{
                    [self.itemsArray insertObject:item atIndex:self.itemsArray.count - 1];
                }
                [self.picArrays addObject:item.imageStr];
            }
        }
        [self reloadCell];
    }
}

- (void)photoMethod{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 8.0f)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *addPhoneAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //照片来源为相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                [imgPicker setDelegate:self];
                [imgPicker setAllowsEditing:NO];
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imgPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                //            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
                imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
                //                [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
                //            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                [self.myselfController presentViewController:imgPicker animated:YES completion:nil];
            }
            
        }];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //照片来源为相册
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            //        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//这句话看个人需求，我这里需要改变状态栏颜色
            //            imgPicker.navigationBar.translucent = NO;//这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
            //            [imgPicker.navigationBar setBarTintColor:RedUIColorC1];
            
            //        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
            [self.myselfController presentViewController:imgPicker animated:YES completion:nil];
            
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [addPhoneAction setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [photoAction setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [cancelAction setValue:FontUIColorBlack forKey:@"titleTextColor"];
        [actionSheet addAction:addPhoneAction];
        [actionSheet addAction:photoAction];
        [actionSheet addAction:cancelAction];
        [self.myselfController presentViewController:actionSheet animated:YES completion:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消提现" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [actionSheet showInView:self];
#pragma clang diagnostic pop
    }
}

#pragma mark - 图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        UIImage *img;
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            img = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        img = [img fixOrientation];
        NSString *fileName = [imageRep filename];
        
        if (fileName == nil)
        {
            // 要上传保存在服务器中的名称
            // 使用时间来作为文件名 2014-04-30 14:20:57.png
            // 让不同的用户信息,保存在不同目录中
            //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //            // 设置日期格式
            //            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            //            NSString *Name = [formatter stringFromDate:[NSDate date]];
            //
            //            fileName = [NSString stringWithFormat:@"%@%@", Name,@".jpg"];
            fileName = @"tempcapt.jpg";
        }
        //        NSLog(@"fileName--------%@",fileName);
        NSString *localFile = [FileUploadHelper PreUploadImagePath:img AndFileName:fileName];
        if([localFile isEqualToString:@""])
        {
            [self.myselfController showHint:@"图片获取失败"];
            return;
        }
        //        NSLog(@"localFile--------%@",localFile);
        //        NSString *pathext = [NSString stringWithFormat:@".%@",[localFile pathExtension]];
        //        pathext = [pathext lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        NSData *imageData = [NSData dataWithContentsOfFile:localFile];
        
//        NSLog(@"localFile = %@",localFile);
        
        NSDictionary *dic = @{};
        
        [[RequestManager shareRequestManager] SubmitImage:dic  sendData:imageData  WithFileName:fileName WithHeader:dic viewController:self.myselfController  successData:^(NSDictionary *result){
            CDZCollectionViewItem *item; item = [CDZCollectionViewItem new];
            item.imageStr = [[result objectForKey:@"data"] objectForKey:@"url"];
            
            if (selectRow == self.itemsArray.count - 1) {
                if (self.itemsArray.count == 6) {
                    flag = FALSE;
                    for (NSUInteger i = self.itemsArray.count-1; i > 0; i--) {
                        [self.itemsArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                    }
                    [self.itemsArray  removeObjectAtIndex:0];
                    [self.itemsArray insertObject:item atIndex:5];
                }else{
                    [self.itemsArray insertObject:item atIndex:self.itemsArray.count - 1];
                }
                [self.picArrays addObject:item.imageStr];
            }else{
                self.itemsArray[selectRow] = item;
            }
            
        }failuer:^(NSError *error){
            [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:self.myselfController ];
            [self.myselfController  hideHud];
        }];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    [picker dismissViewControllerAnimated:YES completion:^(void)
     {
         [self reloadCell];
         //         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
