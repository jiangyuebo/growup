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
#import "CZCellDeleteButton.h"
//SHA1
#import <CommonCrypto/CommonDigest.h>

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
@property (strong,nonatomic) NSMutableArray *selectedPicPathArray;
@property (strong,nonatomic) NSMutableArray *selectedPicUrlArray;

@property (nonatomic) NSUInteger uploadIndex;
@property (nonatomic) NSUInteger finishCount;

@property (strong,nonatomic) UIBarButtonItem *sendRecord;

@property (strong,nonatomic) UIView *uploadingMaskView;

//发布权限选择
@property (strong, nonatomic) IBOutlet UIView *authSelectView;
@property (strong,nonatomic) NSString *publicTypeKey;

@end

@implementation CZTrackUploadViewController

- (IBAction)authTotalOpen:(UIButton *)sender {
    //完全公开
    self.authorityText.text = @"完全公开";
    self.publicTypeKey = GROWUP_RECORD_PUBLIC_ALL;
    self.authSelectView.hidden = YES;
}

- (IBAction)friendsOpen:(UIButton *)sender {
    //好友公开
    self.authorityText.text = @"好友公开";
    self.publicTypeKey = GROWUP_RECORD_PUBLIC_FRIEND;
    self.authSelectView.hidden = YES;
}

- (IBAction)authSelf:(UIButton *)sender {
    //隐私
    self.authorityText.text = @"隐私";
    self.publicTypeKey = GROWUP_RECORD_PUBLIC_PRIVITE;
    self.authSelectView.hidden = YES;
}

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
    self.sendRecord = [[UIBarButtonItem alloc]
                                initWithTitle:@"发送"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(sendOrangeRecord)];
    
    self.navigationItem.rightBarButtonItem = self.sendRecord;
    
    //设置权限选择功能
    self.authorityText.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authSelected)];
    [self.authorityText addGestureRecognizer:singleTap];
}

- (void)authSelected{
    if (self.authSelectView.hidden) {
        self.authSelectView.hidden = NO;
    }else{
        self.authSelectView.hidden = YES;
    }
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

- (void)sendOrangeRecord{
    
    [self UploadclickPageView];
    
    NSString *contentStr = self.uploadText.text;
    if ([contentStr isEqualToString:@"参加活动的心情激动不，记录下来吧~"]) {
        self.uploadText.text = @"";
    }
    
    //删除占位图片
    [self.selectedPicsArray removeLastObject];
    
    //非空判断
    if ([self.uploadText.text isEqualToString:@""] && ([self.selectedPicsArray count] == 0)) {
        //无内容
        [JerryViewTools showCZToastInViewController:self andText:@"没有什么可提交吧？"];
        return;
    }
    
    if ([self.selectedPicsArray count] > 0) {
        //有选择图片
        [self showUploadingMask];
        [self uploadImage];
        
    }else{
        //无图片
        //检查内容是否为空
        
        if ([JerryTools stringIsNull:contentStr]) {
            [JerryViewTools showCZToastInViewController:self andText:@"写点儿什么再提交吧？"];
            return;
        }else{
            [self postRecordData];
        }
    }
}

- (void)postRecordData{
    
    NSMutableDictionary *recordMessage = [NSMutableDictionary dictionary];
    [recordMessage setObject:GROWUP_RECORD_FREEDOM forKey:@"recordSourceTypeKey"];
    [recordMessage setObject:GROWUP_INITIATIVE forKey:@"recordTypeKey"];
    [recordMessage setObject:self.uploadText.text forKey:@"recordContent"];
    [recordMessage setObject:self.publicTypeKey forKey:@"publicTypeKey"];
    [recordMessage setObject:GROWUP_RECORD_PUBLIC_TYPE_PUBLIC forKey:@"recordPublishTypeKey"];
    
    NSMutableArray *picDetailArray = [[NSMutableArray alloc] init];
    //图片详细 RESOURCE_TYPE_KEY_PIC
    for (int i = 0; i < [self.selectedPicUrlArray count]; i++) {
        NSMutableDictionary *picDetailDic = [NSMutableDictionary dictionary];
        [picDetailDic setObject:RESOURCE_TYPE_KEY_PIC forKey:@"contentResourceTypeKey"];
        [picDetailDic setObject:self.selectedPicUrlArray[i] forKey:@"contentResourceTypeUrl"];
        
        [picDetailArray addObject:picDetailDic];
    }
    if ([picDetailArray count] > 0) {
        [recordMessage setObject:picDetailArray forKey:@"recordDetails"];
    }
    
    NSLog(@"recordMessage = %@",recordMessage);
    
    //详细，照片
    [self.viewModel sendRecord:recordMessage andCallback:^(NSDictionary *resultDic) {
        NSString *errorMessage = [resultDic objectForKey:RESULT_KEY_ERROR_MESSAGE];
        if (errorMessage) {
            //error
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:errorMessage];
            });
        }else{
            NSString *result = [resultDic objectForKey:RESULT_KEY_DATA];
            if ([result isEqualToString:@"success"]) {
                //发送成功
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (self.uploadingMaskView) {
                        [self.uploadingMaskView removeFromSuperview];
                    }
                    
                    [[self navigationController] popViewControllerAnimated:YES];
                });
            }
        }
    }];
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
    
    self.publicTypeKey = GROWUP_RECORD_PUBLIC_ALL;
    
    self.viewModel = [[TrackUploadModel alloc] init];

    self.selectedPicsArray = [[NSMutableArray alloc] init];
    self.selectedPicPathArray = [[NSMutableArray alloc] init];
    self.selectedPicUrlArray = [[NSMutableArray alloc] init];
    
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    
    //上传队列序号
    self.uploadIndex = 0;
    self.finishCount = 0;
    
    //test data
    [self.selectedPicsArray addObject:[UIImage imageNamed:@"pic_upload_1"]];
    
    [self resetCollectionViewHeight];
}

- (void)uploadImage{
    
    //判断是否还有图要传
    if (self.uploadIndex <= ([self.selectedPicsArray count] - 1)) {
        
        if (self.uploadingMaskView) {
             NSString *finishCountLabel = [NSString stringWithFormat:@"已完成 %ld/%ld",self.finishCount,[self.selectedPicsArray count]];
            
            //设置MASK显示
            UILabel *processLabel = [self.uploadingMaskView viewWithTag:11];
            processLabel.text = finishCountLabel;
        }
        
        [self updateImageToCload:self.uploadIndex];
    }
}

#pragma mark 上传图片到云端
- (void)updateImageToCload:(NSUInteger) index{
    //    UserInfoModel *userInfoModel = [JerryTools getUserInfoModel];
    //    NSString *bucket = [NSString stringWithFormat:@"%@/rec",userInfoModel.userID];
    
    NSString *picPath = self.selectedPicPathArray[index];
    NSString *picName = [self getPicUploadName:picPath];
    //计算hash得名字
    NSString *sha1String = [self sha1:picName];
    
    
    
    COSObjectPutTask *task = [[COSObjectPutTask alloc] init];
    
    task.filePath = picPath;
    task.fileName = sha1String;
    task.bucket = @"cbu";
    task.attrs = @"customAttribute";
    task.directory = @"/rec";
    task.insertOnly = YES;
    task.sign = SIGH;
    
    COSClient *cosClient = [[COSClient alloc] initWithAppId:@"1253116201" withRegion:@"sh"];
    cosClient.region = @"sh";
    //    [cosClient openHTTPSrequset:YES];
    
    cosClient.completionHandler = ^(COSTaskRsp *resp, NSDictionary *context) {
        if (resp.retCode == 0) {
            //sucess
            self.finishCount ++;
            self.uploadIndex ++;
            
            COSObjectUploadTaskRsp *rsp = (COSObjectUploadTaskRsp *)resp;
            NSString *urlString = rsp.sourceURL;
            
            [self.selectedPicUrlArray addObject:urlString];
            
            if (self.finishCount == [self.selectedPicsArray count]) {
                //全部完成
//                [self setBtnNoUploadingMode];
                [self postRecordData];
                
            }else{
                //还未完成，继续
                [self uploadImage];
            }
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [JerryViewTools showCZToastInViewController:self andText:@"本次发布失败了..."];
            });
        }
    };
    
    //监控进度
    cosClient.progressHandler = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        //progress
        if (self.uploadingMaskView) {
            UIProgressView *progress = [self.uploadingMaskView viewWithTag:10];
            CGFloat percent = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
            
            [progress setProgress:percent];
        }
    };
    
    [cosClient putObject:task];
}

- (void)setBtnsUploadingMode{
    //隐藏返回和发送按钮
    [self.navigationItem setHidesBackButton:YES];
    self.sendRecord.enabled = NO;
}

- (void)setBtnNoUploadingMode{
    //显示返回和发送按钮
    [self.navigationItem setHidesBackButton:NO];
    self.sendRecord.enabled = YES;
}

- (NSString *)getPicUploadName:(NSString *) picPath{
    NSString *picName = [picPath lastPathComponent];
    return picName;
}

- (void)addImageToArray:(UIImage *)selectedImage{
    //移除最后一位占位
    [self.selectedPicsArray removeLastObject];
    //添加新的
    [self.selectedPicsArray addObject:selectedImage];
    //添加占位
    UIImage *offsetImage = [UIImage imageNamed:@"pic_upload_1"];
    [self.selectedPicsArray addObject:offsetImage];
}

- (void)addPathToArray:(NSString *) selectedPath{
    //添加新的
    [self.selectedPicPathArray addObject:selectedPath];
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
    NSData *imageData = UIImageJPEGRepresentation(orginalImage, 0.5f);
    
    NSUInteger length = [imageData length]/1000;
    NSLog(@"准备上传图片 image length : %ld",length);
    
    NSURL *url  = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    NSString *photoPath = [self photoSavePathForURL:url];
    [imageData writeToFile:photoPath atomically:YES];
    
    //添加到数组中
    [self addImageToArray:orginalImage];
    //路径添加到数组
    [self addPathToArray:photoPath];
    
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

- (void)deletePicInCollection:(CZCellDeleteButton *) sender{
    NSLog(@"delete indexPath.row = %ld",sender.row);
    [self.selectedPicsArray removeObjectAtIndex:sender.row];
    [self.selectedPicPathArray removeObjectAtIndex:sender.row];
    
    [self resetCollectionViewHeight];
    [self.picCollectionView reloadData];
}

- (void)showUploadingMask{
    
    self.uploadingMaskView = [JerryViewTools getViewByXibName:@"UploadingMaskView"];
    self.uploadingMaskView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view addSubview:self.uploadingMaskView];
    
    [self setBtnsUploadingMode];
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
        NSLog(@"indexPath.row = %ld",indexPath.row);
        
        CZCellDeleteButton *deleteButton = [cell viewWithTag:2];
        deleteButton.row = indexPath.row;
        [deleteButton addTarget:self action:@selector(deletePicInCollection:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectedPicsArray.count;
}

- (NSString *)sha1:(NSString *)inputString{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(unsigned int)data.length,digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",digest[i]];
    }
    return [outputString lowercaseString];
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
