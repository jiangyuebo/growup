//
//  CZMultiSelectView.m
//  Growup
//
//  Created by Jerry on 2017/6/8.
//  Copyright © 2017年 orange. All rights reserved.
//

#import "CZMultiSelectView.h"
#import "globalHeader.h"

@interface CZMultiSelectView()

//列
@property (nonatomic) NSUInteger col;
//行
@property (nonatomic) NSUInteger margin;

@property (strong,nonatomic) NSMutableDictionary *itemsDic;

@property (strong,nonatomic) NSMutableArray *allButtonsArray;

@property (strong,nonatomic) NSArray *itemsDicKeys;

@property (strong,nonatomic) NSMutableArray *itemsDicContents;

@end

@implementation CZMultiSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化控件
        self.col = 2;
        self.margin = 10;
        
        self.selectedItems = [[NSMutableArray alloc] init];
        
        self.allButtonsArray = [[NSMutableArray alloc] init];
        
        self.itemsDicContents = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void)setSelectItemDic:(NSMutableDictionary *) itemsDic{
    self.itemsDic = itemsDic;
    
    self.itemsDicKeys = [self.itemsDic allKeys];
    
//    for (int i = 0; i < [self.itemsDicKeys count]; i++) {
//        NSString *content = [self.itemsDic objectForKey:self.itemsDicKeys[i]];
//        [self.itemsDicContents addObject:content];
//    }
    
    for (int i = 0; i < [self.itemsDicKeys count]; i++) {
        NSLog(@" i = %d",i);
        int page = i / self.col;
        int index = i % self.col;
        
        UIButton *btnItem = [[UIButton alloc] initWithFrame:CGRectMake(self.margin + index * (SCREENWIDTH - (self.col + 1) * self.margin) / self.col + self.margin * index,40 * page + 40,(SCREENWIDTH - (self.col + 1) * self.margin) / self.col,30)];
        
        btnItem.layer.cornerRadius = 5;
        btnItem.layer.masksToBounds = YES;
        btnItem.layer.shadowOffset =  CGSizeMake(1, 1);
        btnItem.layer.shadowOpacity = 0.8;
        btnItem.layer.shadowColor =  [UIColor blackColor].CGColor;
        btnItem.backgroundColor = [UIColor lightGrayColor];
        btnItem.tag = i;
        [btnItem setTitle:self.itemsDicKeys[i] forState:UIControlStateNormal];
        [btnItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btnItem addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.allButtonsArray addObject:btnItem];
        [self addSubview:btnItem];
    }
}

- (void)selectBtn:(UIButton *) button{
    NSString *selectedItem = [self.itemsDic objectForKey:[self.itemsDicKeys objectAtIndex:button.tag]];
    
    if (button.selected) {
        //取消选中
        button.selected = NO;
        button.backgroundColor = [UIColor lightGrayColor];
        
        [self.selectedItems removeObject:selectedItem];
        
        
    }else{
        //选中
        button.selected = YES;
        button.backgroundColor = [UIColor orangeColor];
        
        [self.selectedItems addObject:selectedItem];
    }
    
    NSLog(@"self.selectedItems = [%@]",self.selectedItems);
}

#pragma mark 设置默认选择项
- (void)setDefaultSelectedItems:(NSArray *) selectedItems{
    for (int i = 0; i < [selectedItems count]; i++) {
        NSString *selectedItem = selectedItems[i];
        
        for (int i = 0; i  < [self.itemsDicKeys count]; i++) {
            NSString *key = self.itemsDicKeys[i];
            NSString *content = [self.itemsDic objectForKey:key];
            
            if ([selectedItem isEqualToString:content]) {
                NSUInteger itemIndex = [self.itemsDicKeys indexOfObject:key];
                
                //获得按钮
                UIButton *selectedButton = [self.allButtonsArray objectAtIndex:itemIndex];
                selectedButton.selected = YES;
                selectedButton.backgroundColor = [UIColor orangeColor];
                [self.selectedItems addObject:selectedItem];
                
            }
        }
        
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
