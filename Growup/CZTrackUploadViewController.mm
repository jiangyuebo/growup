//
//  CZTrackUploadViewController.m
//  Growup
//
//  Created by Jerry on 2017/3/22.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZTrackUploadViewController.h"
#import "globalHeader.h"
#import "TrackUploadModel.h"
#import "JerryTools.h"
#import "JerryViewTools.h"
#import "COSClient.h"
#import "COSTask.h"
#import "UserInfoModel.h"
#import "KidInfoModel.h"
#import "QCloudUtils.h"

#import "Auth.h"

@interface CZTrackUploadViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *uploadText;

@property (strong, nonatomic) IBOutlet UILabel *locationText;

@property (strong, nonatomic) IBOutlet UILabel *authorityText;

@property (strong,nonatomic) TrackUploadModel *viewModel;

@property (strong, nonatomic) IBOutlet UIView *pageView;

@property (nonatomic) BOOL isEmpty;

@property (strong, nonatomic) IBOutlet UICollectionView *picCollectionView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (strong,nonatomic) NSMutableArray *selectedPicsArray;

@property (strong,nonatomic) NSString *selectedPicPath;

@end

@implementation CZTrackUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
}

- (void)initView{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.uploadText.contentOffset = CGPointMake(0, -64);
    
    [self setPageViewClickable];
    
    //hint
    self.uploadText.text = @"参加活动的心情激动不，记录下来吧~";
    self.uploadText.textColor = [UIColor lightGrayColor];
    self.isEmpty = YES;
    
    self.uploadText.delegate = self;
    
    //添加发送按钮
    UIBarButtonItem *sendRecord = [[UIBarButtonItem alloc]
                                initWithTitle:@"发送"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(sendRecord)];
    
    self.navigationItem.rightBarButtonItem = sendRecord;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (_isEmpty) {
        self.uploadText.text = @"";
        self.uploadText.textColor = [UIColor blackColor];
        _isEmpty = NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.uploadText.text.length == 0) {
        self.uploadText.text = @"参加活动的心情激动不，记录下来吧~";
        self.uploadText.textColor = [UIColor lightGrayColor];
        self.isEmpty = YES;
    }
}

- (void)resetCollectionViewHeight{
    //计算行数
    if (self.selectedPicsArray.count < 4) {
        self.collectionViewHeight.constant = 70;
    }else if(self.selectedPicsArray.count == 10){
        self.collectionViewHeight.constant = 80 * 3;
    }else{
        NSNumber *countNum = [NSNumber numberWithInteger:self.selectedPicsArray.count];
        float countFloat = [countNum floatValue];
        float temp = countFloat / 3.0;
        int rowNum = ceil(temp);
        self.collectionViewHeight.constant = 80 * rowNum;
    }
}

- (void)getSign{
    
}

- (void)sendRecord{
    
    //test pic upload
    [self uploadImage];
    
    //检查内容是否为空
//    NSString *contentStr = self.uploadText.text;
//    
//    if ([JerryTools stringIsNull:contentStr]) {
//        
//    }else{
//        NSMutableDictionary *recordMessage = [NSMutableDictionary dictionary];
//        [recordMessage setObject:GROWUP_RECORD_FREEDOM forKey:@"recordSourceTypeKey"];
//        [recordMessage setObject:GROWUP_INITIATIVE forKey:@"recordTypeKey"];
//        [recordMessage setObject:self.uploadText.text forKey:@"recordContent"];
//        [recordMessage setObject:GROWUP_RECORD_PUBLIC_ALL forKey:@"publicTypeKey"];
//        [recordMessage setObject:GROWUP_RECORD_PUBLIC_TYPE_PUBLIC forKey:@"recordPublishTypeKey"];
//        
//        //详细，照片
//        [self.viewModel sendRecord:recordMessage andCallback:^(NSDictionary *resultDic) {
//            NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
//            if (errorMessage) {
//                //error
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [JerryViewTools showCZToastInViewController:self andText:errorMessage];
//                });
//            }else{
//                NSString *result = [resultDic objectForKey:RESULT_KEY_DATA];
//                if ([result isEqualToString:@"success"]) {
//                    //发送成功
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[self navigationController] popViewControllerAnimated:YES];
//                    });
//                }
//            }
//        }];
//    }
}

- (void)setPageViewClickable{
    self.pageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UploadclickPageView)];
    [self.pageView addGestureRecognizer:singleTap];
}

- (void)UploadclickPageView{
    NSLog(@"clickPageView");
    [self.uploadText resignFirstResponder];
}

- (void)initData{
    
    self.viewModel = [[TrackUploadModel alloc] init];

    self.selectedPicsArray = [[NSMutableArray alloc] init];
    
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    
    //test data
    [self.selectedPicsArray addObject:[UIImage imageNamed:@"pic_upload_1"]];
    
    [self resetCollectionViewHeight];
}

- (void)uploadImage{
    
//    UserInfoModel *userInfoModel = [JerryTools getUserInfoModel];
    
//    NSString *bucket = [NSString stringWithFormat:@"%@/rec",userInfoModel.userID];
    
    NSString *picPath = self.selectedPicPath;
    
    COSObjectPutTask *task = [[COSObjectPutTask alloc] init];
    
    task.filePath = picPath;
    task.fileName = @"test";
    task.bucket = @"cbu";
    task.attrs = @"customAttribute";
    task.directory = @"/test";
    task.insertOnly = YES;
    task.sign = SIGH;
    
    COSClient *cosClient = [[COSClient alloc] initWithAppId:@"1253116201" withRegion:@"sh"];
    cosClient.region = @"sh";
//    [cosClient openHTTPSrequset:YES];
    
    cosClient.completionHandler = ^(COSTaskRsp *resp, NSDictionary *context) {
        if (resp.retCode == 0) {
            //sucess
            
        }else{
            NSLog(@"上传失败");
            
        }
    };
    
    [cosClient putObject:task];
}

- (void)addImageToArray:(UIImage *)selectedImage{
    //移除最后一位
    [self.selectedPicsArray removeLastObject];
    //添加新的
    [self.selectedPicsArray addObject:selectedImage];
    //添加占位
    UIImage *offsetImage = [UIImage imageNamed:@"pic_upload_1"];
    [self.selectedPicsArray addObject:offsetImage];
}

- (void)selectImage{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark 获取照片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 设置图片
    UIImage *orginalImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(orginalImage, 1.f);
    
    NSURL *url  = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    NSString *photoPath = [self photoSavePathForURL:url];
    [imageData writeToFile:photoPath atomically:YES];
    
    self.selectedPicPath = photoPath;
    
    //添加到数组中
    [self addImageToArray:orginalImage];
    
    [self resetCollectionViewHeight];
    [self.picCollectionView reloadData];
    
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)photoSavePathForURL:(NSURL *)url
{
    NSString *photoSavePath = nil;
    NSString *urlString = [url absoluteString];
    NSString *uuid = nil;
    if (urlString) {
        uuid = [QCloudUtils findUUID:urlString];
    } else {
        uuid = [QCloudUtils uuid];
    }
    
    NSString *resourceCacheDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/UploadPhoto/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:resourceCacheDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:resourceCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    photoSavePath = [resourceCacheDir stringByAppendingPathComponent:uuid];
    
    return photoSavePath;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark collection view 
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    
    if (indexPath.row == (self.selectedPicsArray.count - 1)) {
        //最后一个
        static NSString *collectionCellPlusId = @"plusButtonId";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellPlusId forIndexPath:indexPath];
        
        UIButton *selectPicButton = [cell viewWithTag:1];
        [selectPicButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    }else{
        static NSString *collectionCellId = @"collectionCellId";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellId forIndexPath:indexPath];
        
        UIImageView *imageView = [cell viewWithTag:1];
        [imageView setImage:[self.selectedPicsArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectedPicsArray.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
