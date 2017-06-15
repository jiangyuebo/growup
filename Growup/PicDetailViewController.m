//
//  PicDetailViewController.m
//  Growup
//
//  Created by Jerry on 2017/5/24.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "PicDetailViewController.h"
#import "globalHeader.h"
#import "JerryTools.h"

@interface PicDetailViewController ()<UIScrollViewDelegate>

@property (strong,nonatomic) UIImageView *detailPicView;

@end

@implementation PicDetailViewController

@synthesize resourcePath;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    //获取缓存KEY
    NSString *cacheKey = [resourcePath lastPathComponent];
    //查询缓存数据
    NSMutableDictionary *globalCache = [JerryTools getGlobalPicCache];
    
    if ([globalCache objectForKey:cacheKey]) {
        //有缓存图片
        [self.indicator stopAnimating];
        NSData *imageData = [globalCache objectForKey:cacheKey];
        UIImage *detailImage = [UIImage imageWithData:imageData];
        
        [self setDetailImageViewByImage:detailImage];
        
        [self.imageScrollView addSubview:self.detailPicView];
    }else{
        //无缓存图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL *picUrl = [NSURL URLWithString:resourcePath];
            NSData *imageData = [NSData dataWithContentsOfURL:picUrl];
            //获取图片大小
            NSUInteger length = [imageData length]/1000;
            NSLog(@"image length : %ld",length);
            //存入缓存
            [globalCache setObject:imageData forKey:cacheKey];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //停止并隐藏小菊花
                [self.indicator stopAnimating];
                
                UIImage *detailImage = [UIImage imageWithData:imageData];
                [self setDetailImageViewByImage:detailImage];
                [self.imageScrollView addSubview:self.detailPicView];
            });
        });
    }
}

#pragma mark 转化图片宽高适配屏幕
- (void)setDetailImageViewByImage:(UIImage *) image{
    //转化图片宽高适配屏幕
    CGFloat newheight = (image.size.height/image.size.width) * SCREENWIDTH;
    self.detailPicView = [[UIImageView alloc] initWithImage:image];
    self.detailPicView.userInteractionEnabled = YES;
    self.detailPicView.frame = CGRectMake(0, 20, SCREENWIDTH, newheight);
    
    self.imageScrollView.contentSize = CGSizeMake(SCREENWIDTH, newheight);
}

- (void)initView{
    self.imageScrollView.backgroundColor = [UIColor blackColor];
    self.imageScrollView.userInteractionEnabled = YES;
    
    self.imageScrollView.maximumZoomScale = 2.0;
    self.imageScrollView.minimumZoomScale = 1.0;
    
    self.imageScrollView.delegate = self;
    
    //为detailPicView添加点击事件，用于返回
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewToBack:)];
    self.imageScrollView.userInteractionEnabled = YES;
    [self.imageScrollView addGestureRecognizer:singleTap];
}

- (void)clickImageViewToBack:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.detailPicView;
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
