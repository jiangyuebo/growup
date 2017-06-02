//
//  MultiSelectView.m
//  Growup
//
//  Created by Jerry on 2017/6/1.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "MultiSelectView.h"

@interface MultiSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableIndexSet *selectedIndexSet;

@property (nonatomic) BOOL isRegist;

@property (nonatomic,strong) NSArray *selectItemsArray;

@end

@implementation MultiSelectView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //init
        self.isRegist = NO;
        
        self.selectItemsArray = [NSArray arrayWithObjects:@"音乐",@"美术",@"数学",@"美术",@"数学",@"美术",@"数学", nil];
        
        self.multiSelecCollectionView.dataSource = self;
        self.multiSelecCollectionView.delegate = self;
        
        [self.multiSelecCollectionView performBatchUpdates:^{
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return self;
}

#pragma mark delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.selectItemsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *multiSelectCellId = @"multiSelectCellId";
    
    //注册单元格
    if (!self.isRegist) {
        UINib *nib = [UINib nibWithNibName:@"MultiSelectViewCell" bundle:nil];
        [self.multiSelecCollectionView registerNib:nib forCellWithReuseIdentifier:multiSelectCellId];
        
        self.isRegist = YES;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:multiSelectCellId forIndexPath:indexPath];
    
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"shouldSelectItemAtIndexPath ...");
    [self.multiSelecCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.selectedIndexSet addIndex:indexPath.item];
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"shouldDeselectItemAtIndexPath ...");
    [self.multiSelecCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.selectedIndexSet removeIndex:indexPath.item];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
